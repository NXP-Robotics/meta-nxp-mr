/*
 * UIO DMA Driver with Cache Management for ARM Architectures
 *
 * Copyright (C) 2021 Amazon, Inc or one of its affiliates
 * Copyright (C) 2021-2025 Kinara, Inc.
 * Copyright 2025-2026 NXP
 *
 * SPDX-License-Identifier: GPL-2.0-only
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * This driver provides DMA buffer management with non-coherent DMA mapping
 * for UIO (Userspace I/O) devices on PCI bus.
 *
 * Note: This driver does not declare any device IDs and must be manually bound:
 *   echo "1e58 0002" > /sys/bus/pci/drivers/uiodma/new_id
 */

#include <linux/version.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/sysfs.h>
#include <linux/dma-direct.h>
#include <linux/eventfd.h>

#define DEFAULT_UIODMA_SIZE (4 * SZ_1M)

struct uiodma {
  void *hostptr;
  dma_addr_t dmaaddr;
  phys_addr_t phyaddr;
  struct eventfd_ctx *efd_ctx;
};

static ssize_t uiodma_dmaaddr_show(struct device *dev,
                                   struct device_attribute *attr, char *buf) {
  struct pci_dev *pdev = to_pci_dev(dev);
  struct uiodma *uiodma = pci_get_drvdata(pdev);
  return scnprintf(buf, PAGE_SIZE, "%llx\n", uiodma->dmaaddr);
}

DEVICE_ATTR_RO(uiodma_dmaaddr);

static int uiodma_mmap(struct file *file, struct kobject *kobj,
                       const struct bin_attribute *attr, struct vm_area_struct *vma) {
  struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
  struct uiodma *uiodma = pci_get_drvdata(pdev);
  phys_addr_t offset = (virt_to_phys(uiodma->hostptr)) >> PAGE_SHIFT;
  vma->vm_pgoff = (virt_to_phys(uiodma->hostptr)) >> PAGE_SHIFT;
  size_t size = vma->vm_end - vma->vm_start;
  phys_addr_t phy_of_host_ptr = virt_to_phys(uiodma->hostptr);
  phys_addr_t phy_of_dma = dma_to_phys(&pdev->dev, uiodma->dmaaddr);
  // dev_info(&pdev->dev,"host_addr=%llx, dma_addr=%llx, vm->vm_pgoff=%llx phy_of_host_ptr=%llx phys_of_dma=%llx",uiodma->hostptr,uiodma->dmaaddr,vma->vm_pgoff,phy_of_host_ptr,phy_of_dma);
  int ret = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, size, vma->vm_page_prot);
  // dev_info(&pdev->dev, "remap_pfn_range=%d offset=%llx size=%llx\n", ret, offset, size);
  return ret;
}

static const struct attribute *uiodma_attrs[] = {
  &dev_attr_uiodma_dmaaddr.attr,
  NULL,
};

ssize_t uiodma_read(struct file *file, struct kobject *kobj, const struct bin_attribute *attr,
                    char *buf, loff_t offset, size_t size) {
  struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
  struct uiodma *uiodma = pci_get_drvdata(pdev);
  // setting cache management flag
  int cache_management = 1;
  memcpy(buf, (char *)&cache_management, sizeof(cache_management));
  return size;
}

ssize_t uiodma_write(struct file *file, struct kobject *kobj, const struct bin_attribute *attr,
                     char *buf, loff_t offset, size_t size) {
  struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
  struct uiodma *uiodma = pci_get_drvdata(pdev);
  int eventfd_fd = *((int *)buf);
  uiodma->efd_ctx = eventfd_ctx_fdget(eventfd_fd);
  return size;
}

static const struct bin_attribute uiodma_bin_attr = {
  .attr = {
    .name = "uiodma",
    .mode = 0600,
  },
  .size = DEFAULT_UIODMA_SIZE,
  .mmap = uiodma_mmap,
  .read = uiodma_read,
  .write = uiodma_write};

// TODO: sriduth - make it proper, some logs etc..
static irqreturn_t uiodma_btm_irq_handler(int irq, void *pdata) {
  struct uiodma *uiodma = (struct uiodma *)pdata;
  if (uiodma->efd_ctx) {
#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 8, 0)
    eventfd_signal(uiodma->efd_ctx);
#else
    eventfd_signal(uiodma->efd_ctx, 1);
#endif
    return IRQ_HANDLED;
  }
  return IRQ_NONE;
}

// TODO: sriduth - make it proper, some logs etc..
static irqreturn_t uiodma_top_irq_handler(int irq, void *pdata) {
  return IRQ_WAKE_THREAD;
}

static int uiodma_probe(struct pci_dev *pdev, const struct pci_device_id *id) {
  struct uiodma *uiodma;
  int ret;
  int i;
  for (i = 0; i < 3; i++) {
    int bar_idx = i * 2;

    struct resource *res = &pdev->resource[bar_idx];

    // if the resource is not part of the parent bus, it
    // needs to be assigned a bus address
    if (!res->parent) {
      ret = pci_assign_resource(pdev, bar_idx);
      if (ret) {
        dev_err(&pdev->dev, "Could not assign address to BAR %d\n", bar_idx);
        return ret;
      }
    }
  }
  dev_info(&pdev->dev, "uiodma driver with non coherent dma mapping\n");
  ret = pci_enable_device(pdev);
  if (ret) {
    dev_err(&pdev->dev, "Could not enable the PCI device: %d\n",
            ret);
    return ret;
  }

  pci_set_master(pdev);

  ret = pci_alloc_irq_vectors(pdev, 1, 32, PCI_IRQ_MSI);
  if (ret < 0) {
    dev_err(&pdev->dev, "could not alloc irq vectors %d\n", ret);
  }

  uiodma = kzalloc(sizeof(*uiodma), GFP_KERNEL);
  if (!uiodma) {
    pci_clear_master(pdev);
    pci_free_irq_vectors(pdev);
    pci_disable_device(pdev);
    return -ENOMEM;
  }

  ret = request_threaded_irq(pdev->irq,
                             uiodma_top_irq_handler,
                             uiodma_btm_irq_handler,
                             IRQF_SHARED, "uiodma_efd_irq", uiodma);

  if (ret) {
    dev_err(&pdev->dev, "could not alloc irq=%d\n", ret);
  }

  uiodma->hostptr = kzalloc(DEFAULT_UIODMA_SIZE, GFP_KERNEL);
  if (!uiodma->hostptr) {
    dev_err(&pdev->dev, "Couldn't allocate the DMA memory\n");
    kfree(uiodma);
    pci_clear_master(pdev);
    pci_free_irq_vectors(pdev);
    pci_disable_device(pdev);
    return -ENOMEM;
  }
  if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
    dev_info(&pdev->dev, "64 bit dma not supported ");
    if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
      dev_info(&pdev->dev, "32  bit dma not supported");
    }
  }

  uiodma->dmaaddr = dma_map_single(&pdev->dev, uiodma->hostptr, DEFAULT_UIODMA_SIZE, DMA_BIDIRECTIONAL);
  ret = dma_mapping_error(&pdev->dev, uiodma->dmaaddr);
  if (ret) {
    dev_err(&pdev->dev, "Couldn't map the DMA memory error=%d\n", ret);
    kfree(uiodma->hostptr);
    kfree(uiodma);
    pci_clear_master(pdev);
    pci_free_irq_vectors(pdev);
    pci_disable_device(pdev);
    return -ENOMEM;
  }

  if (!uiodma->dmaaddr) {
    dev_err(&pdev->dev, "Couldn't allocate the DMA memory\n");
    kfree(uiodma->hostptr);
    kfree(uiodma);
    pci_clear_master(pdev);
    pci_free_irq_vectors(pdev);
    pci_disable_device(pdev);
    return -ENOMEM;
  }
  uiodma->phyaddr = virt_to_phys(uiodma->hostptr);

  if (ret = sysfs_create_files(&pdev->dev.kobj, uiodma_attrs))
    dev_err(&pdev->dev, "Couldn't create the sysfs file; ret=%d\n", ret);

  if (ret = sysfs_create_bin_file(&pdev->dev.kobj, &uiodma_bin_attr))
    dev_err(&pdev->dev, "Couldn't create the uiodma file ret=%d\n", ret);

  pci_set_drvdata(pdev, uiodma);

  return 0;
}

static void uiodma_remove(struct pci_dev *pdev) {
  struct uiodma *uiodma = pci_get_drvdata(pdev);

  sysfs_remove_files(&pdev->dev.kobj, uiodma_attrs);

  sysfs_remove_bin_file(&pdev->dev.kobj, &uiodma_bin_attr);
  dma_unmap_single(&pdev->dev, uiodma->dmaaddr, DEFAULT_UIODMA_SIZE, DMA_BIDIRECTIONAL);
  kfree(uiodma->hostptr);
  kfree(uiodma);
  pci_clear_master(pdev);
  pci_free_irq_vectors(pdev);
  pci_set_drvdata(pdev, NULL);
  pci_disable_device(pdev);
}

static struct pci_driver uiodma_driver = {
  .name = "uiodma",
  .id_table = NULL,
  .probe = uiodma_probe,
  .remove = uiodma_remove,
};

module_pci_driver(uiodma_driver);
MODULE_LICENSE("GPL v2");