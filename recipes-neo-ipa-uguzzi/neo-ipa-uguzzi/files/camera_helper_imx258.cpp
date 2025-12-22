/* SPDX-License-Identifier: LGPL-2.1-or-later */
/* Copyright (C) 2021, Google Inc.
 * camera_helper_imx258.c
 * Helper class that performs sensor-specific parameter computations
 * for Sony IMX 258 sensor
 * Copyright 2025 NXP
 */

 #include <cmath>
 #include <linux/v4l2-controls.h>
 #include <libcamera/base/log.h>
 #include "camera_helper.h"
 
 namespace libcamera {
 
 LOG_DECLARE_CATEGORY(NxpCameraHelper)
 
 namespace nxp {
 
 #define SENSOR_FIX_FRACBITS        10

 class CameraHelperimx258 : public CameraHelper
 {
 public:

     uint32_t gainCode(double gain) const override;
     double gain(uint32_t gainCode) const override;
 };

/*
 * gain multiplier( 1x-16x )converted to actual 
 * gain value code (0 - 480) to be applied on sensor driver
 * via controlListSetAGC() from camera_helper.cpp 
 */
uint32_t CameraHelperimx258::gainCode(double gain) const
 {
    LOG(NxpCameraHelper, Debug) << "input gain= " << gain; 

    //driver expects value in 10bits , which is then encoded to 0-480
 	uint32_t gain_10bit =0;  

    gain_10bit = static_cast<uint32_t>(gain * (1 << SENSOR_FIX_FRACBITS));
    LOG(NxpCameraHelper, Debug) << "gain_10bit= " << gain_10bit; 

    if (gain_10bit < (1 << SENSOR_FIX_FRACBITS )) {
        gain_10bit = 1 << SENSOR_FIX_FRACBITS;
    }
    gain_10bit = (gain_10bit - (1<< SENSOR_FIX_FRACBITS)) * 512 / gain_10bit;
    LOG(NxpCameraHelper, Debug) << "output gain_10bit= " << gain_10bit; 

    return gain_10bit;
 }

 /*
  * called from sensorControlsToMetaData directly from  
  * sensor driver via get(V4L2_CID_ANALOGUE_GAIN) (0 -480)
  * Manully calculated analog gain multiplier for each analog gain value code
  */
double CameraHelperimx258::gain(uint32_t gainCode) const 
 {
    LOG(NxpCameraHelper, Debug) << "gain() input gainCode= " << gainCode; 
 
   double gain;
     if (gainCode >= 477) 
         gain = 15.98;
     else if (gainCode >= 475) 
         gain = 15.0;
     else if (gainCode >= 472) 
         gain = 14.0;
     else if (gainCode >= 469)
         gain = 13.0;
     else if (gainCode >= 464)
         gain = 12.0;
     else if (gainCode >= 460)
         gain = 11.0;
     else if (gainCode >= 455)
         gain = 10.0;
     else if (gainCode >= 448)
         gain = 9.0;
     else if (gainCode >= 438)
         gain = 8.0;
     else if (gainCode >= 426)
         gain = 7.0;
     else if (gainCode >= 409)
         gain = 6.0;
     else if (gainCode >= 384)
         gain = 5.0;
     else if (gainCode >= 341)
         gain = 4.0;
     else if (gainCode >= 256)
         gain = 3.0;
     else if (gainCode >= 150)
         gain = 2.0;
     else
         gain = 1.0;
     
    return (gain);
 }


 REGISTER_CAMERA_HELPER("imx258", CameraHelperimx258)
 
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
        5352/256800000 = 2.08411214953271e-5 = 0.000020841121
        lines is value set to v4l2 sensor V4L2_CID_EXPOSURE 
        min exposure 4  , max exposure 65515 for v4l2 driver value , 
        but imx258.c driver also modifies exposure range based on vblank
        imx258->exposure->minimum = 4 imx258_adjust_exposure_range

        
        imx258.c driver modifies exposure range based on vblank 
		imx258->cur_mode->height = 1080
        imx258->vblank->val = 512
        exposure_max = imx258->cur_mode->height + imx258->vblank->
        val - IMX258_EXPOSURE_OFFSET '10';
        exposure_max = 1582 imx258_adjust_exposure_range imx258.c
        exposure_def = 1582 imx258_adjust_exposure_range imx258.c
        
        using modified range

		1582 = exposure / lineduration();
		expsoure = 1582 * lineduration();
		exposure = 1582* 0.000020841121
		exposure = 0.03297065 in seconds -> 32970.65 ms set in AE limits MAX 
        in MMS tool

        min exposure  0.0000833644 , 83.3644 ms in AE Limits MMS
        max exposure  0.03297065   , 32970.65 ms set in AE limits MAX in MMS
        tool for 1920x1080


         imx258_adjust_exposure_range 
         height =2160   3480x2160 mode
         exposure_max=3142 
         imx258->vblank->val = 992 
         max exposure  0.065482802   , 65482.80 ms set in AE limits MAX in MMS
         tool for 3480x2160
*/

