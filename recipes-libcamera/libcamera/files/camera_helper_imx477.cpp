/* SPDX-License-Identifier: LGPL-2.1-or-later */
/* Copyright (C) 2021, Google Inc.
 * camera_helper_imx477.c
 * Helper class that performs sensor-specific parameter computations
 * for Sony IMX477 sensor
 * Copyright 2025 NXP
 */

#include <cmath>
#include <linux/v4l2-controls.h>
#include <libcamera/base/log.h>
#include "camera_helper.h"

namespace libcamera {

LOG_DECLARE_CATEGORY(NxpCameraHelper)

namespace nxp {

class CameraHelperimx477 : public CameraHelper
{
public:

	uint32_t gainCode(double gain) const override;
	double gain(uint32_t gainCode) const override;
};

#define IMX477_ANA_GAIN_MAX  976

uint32_t CameraHelperimx477::gainCode(double gain) const
{
	uint32_t code;

	LOG(NxpCameraHelper, Debug) << " -> Gain " << gain;
	if (gain < 1.0)
		gain = 1.0;

	code = (static_cast<int>(1024 - (1024/gain)));
	LOG(NxpCameraHelper, Debug) << "-> Gain Code" << code;

	return code;
}

double CameraHelperimx477::gain(uint32_t gainCode) const
{
	double gain;

	LOG(NxpCameraHelper, Debug) << "-> Gain Code" << gainCode;

	if (gainCode > (IMX477_ANA_GAIN_MAX) )
		gainCode = IMX477_ANA_GAIN_MAX;
	gain = 1024.0 / (1024 - gainCode);
	LOG(NxpCameraHelper, Debug) << "<- Gain " << gain;
	return gain;
}

REGISTER_CAMERA_HELPER("imx477", CameraHelperimx477)

} /* namespace nxp */

} /* namespace libcamera */
