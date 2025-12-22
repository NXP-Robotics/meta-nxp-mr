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


/*
        exposure set via controlListSetAGC() in camera_helper.cpp
        exposure get via sensorControlsToMetaData() in camera_helper.cpp

        const ControlValue &exposureCtrl = sensorCtrls->get(V4L2_CID_EXPOSURE); 
        int32_t exposureLines = exposureCtrl.get<int32_t>();
		exposuresArray[0] = static_cast<float>(exposureLines * lineDuration());  
		//value that gets set between the range of exposures in MMS Tool 

        lineduration = (mode_.minLineLength) / mode_.pixelRate = 
		24000/840000000 = 2.8571428e-5 = 0.000028571428
        lines is value set to v4l2 sensor V4L2_CID_EXPOSURE 
        min exposure 4  , max exposure 65478 for v4l2 driver value, 
        but imx477.c driver also modifies exposure range based on vblank
        
        
        imx477.c driver modifies exposure range based on vblank 
		sensor->format.height=2160 
        sensor->vblank->val =173
        exposure_max = sensor->format.height + sensor->vblank->val 
		- IMX477_EXPOSURE_OFFSSET;
        exposure_max = 2311 imx477_adjust_exposure_range imx477.c
        exposure_def = 1600 
        using modified range

                
		2311 = exposure / lineduration();
		exposure = 2311 * 0.000028571428
		exposure = 0.066028570108 in seconds -> 660285.70 ms set in 
		AE limits MAX in MMS tool

        min exposure  0.00011428 , 114.28 ms in AE Limits MMS
        max exposure  0.06602857 , 660285.70 ms set in AE limits MAX in MMS
		tool

*/
