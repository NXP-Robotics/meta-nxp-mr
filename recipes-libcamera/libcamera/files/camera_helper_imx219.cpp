/* SPDX-License-Identifier: LGPL-2.1-or-later */
/* Copyright (C) 2021, Google Inc.
 *
 * camera_helper_imx219.c
 * Helper class that performs sensor-specific parameter computations
 * for Sony IMX 219 sensor
 * Copyright 2025 NXP
 */

#include <cmath>
#include "camera_helper.h"
#include <libcamera/base/log.h>

namespace libcamera {

LOG_DECLARE_CATEGORY(NxpCameraHelper)

namespace nxp {

class CameraHelperImx219 : public CameraHelper
{
public:
	uint32_t gainCode(double gain) const override;
	double gain(uint32_t gainCode) const override;
};


uint32_t CameraHelperImx219::gainCode(double gain) const
{
	return (uint32_t)(256 - 256 / gain);
}

double CameraHelperImx219::gain(uint32_t gainCode) const
{
	return 256.0 / (256 - gainCode);
}

REGISTER_CAMERA_HELPER("imx219", CameraHelperImx219)

} /* namespace nxp */

} /* namespace libcamera */
