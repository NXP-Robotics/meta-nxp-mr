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
