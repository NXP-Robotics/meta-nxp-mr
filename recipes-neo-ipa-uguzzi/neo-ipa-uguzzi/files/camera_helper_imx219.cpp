/* SPDX-License-Identifier: LGPL-2.1-or-later */
/* Copyright (C) 2021, Google Inc.
 * camera_helper_imx219.c
 * Helper class that performs sensor-specific parameter computations
 * for Sony IMX 219 sensor
 * Copyright 2025 NXP
 */

 #include <cmath>

 #include <linux/v4l2-controls.h>
 
 #include <libcamera/base/log.h>

 #include "camera_helper.h"
 
 namespace libcamera {
 
 LOG_DECLARE_CATEGORY(NxpCameraHelper)
 
 namespace nxp {

 class CameraHelperimx219 : public CameraHelper
 {
 public:

     uint32_t gainCode(double gain) const override;
     double gain(uint32_t gainCode) const override;
 };
 

 /*
  * gain multiplier( 1x-10.66x )converted to actual gain value code (0 - 232)
  * to be applied on sensor driver
  * via controlListSetAGC() from camera_helper.cpp
  */
 uint32_t CameraHelperimx219::gainCode(double gain) const
 {

    LOG(NxpCameraHelper, Debug) << "gainCode() input gain= " << gain; 
    uint32_t code;
    code = 256 - (256/gain);

    LOG(NxpCameraHelper, Debug) << "gainCode() output gainCode= " << code;
    return code;
 }

  /*
  * called from sensorControlsToMetaData directly from  
  * sensor driver via get(V4L2_CID_ANALOGUE_GAIN) (0 -232)
  */
 double CameraHelperimx219::gain(uint32_t gainCode) const
 {
    LOG(NxpCameraHelper, Debug) << "gain() input gainCode= " << gainCode; 
    double gain;
    gain = 256.0 / (256 - gainCode);
    LOG(NxpCameraHelper, Debug) << "gain()=" << gain;
    return gain;
 }
 
 REGISTER_CAMERA_HELPER("imx219", CameraHelperimx219)
 
 } /* namespace nxp */
 
 } /* namespace libcamera */

 /*
        exposure set via controlListSetAGC() in camera_helper.cpp
        exposure get via sensorControlsToMetaData() in camera_helper.cpp

        const ControlValue &exposureCtrl = sensorCtrls->get(V4L2_CID_EXPOSURE); 
        int32_t exposureLines = exposureCtrl.get<int32_t>();
		exposuresArray[0] = static_cast<float>(exposureLines * lineDuration());  
        //value that gets set between the range of exposures in MMS Tool 

        lineduration = (mode_.minLineLength) / mode_.pixelRate = 3448/182400000 
        = 1.890350877192982e-5 = 0.00001890350
        lines is value set to v4l2 sensor V4L2_CID_EXPOSURE 
        min exposure 4  , max exposure 65515 for v4l2 driver value    , 
        but imx219.c driver also modifies exposure range based on vblank
        imx219->exposure->minimum = 4 

        
        imx219.c driver modifies exposure range based on vblank 
		format->height = 2464  //3280x2464 resolution
        ctrl->val = 1062   vblank->val 
        exposure_max = format->height + ctrl->val - 4;
        exposure_max = 3522 
        exposure_def = 1600 

		3522 = exposure / lineduration();
		expsoure = 3522 * lineduration();
		exposure = 3522* 0.00001890350
		exposure = 0.066578127 in seconds -> 66578.127 ms set in AE limits 
        MAX in MMS tool

        min exposure  0.000075614 , 75.614 ms in AE Limits MMS
        max exposure  0.03297065  , 66578.127 ms set in AE limits 
        MAX in MMS tool


        format->height = 1080  //1920x1080 cropped resolution
        ctrl->val = 683        vblank->val 
        exposure_max = format->height + ctrl->val - 4;
        exposure_max = 1759 
        exposure_def = 1600 
	
        1759 = exposure / lineduration();
		expsoure = 1759 * lineduration();
		exposure = 1759* 0.00001890350
		exposure = 0.0332512565 in seconds -> 33251.2565 ms set in AE limits 
        MAX in MMS tool

        min exposure  0.000075614 , 75.614 ms in AE Limits MMS
        max exposure  0.03297065  , 33251.2565 ms set in AE limits
        MAX in MMS tool

*/

