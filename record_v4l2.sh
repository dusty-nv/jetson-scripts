#!/bin/sh

 gst-launch v4l2src ! xvimagesink

#gst-launch-0.10 -v v4l2src always-copy=FALSE ! 'video/x-raw-yuv, width=(int)2560, height=(int)720, format=(fourcc)I420' ! \
#	nvvidconv ! nv_omx_h264enc ! qtmux ! filesink location=test.mp4 -e

#gst-launch-0.10 videotestsrc ! 'video/x-raw-yuv, width=(int)1280, height=(int)720, format=(fourcc)I420' ! \
#	nv_omx_h264enc ! qtmux ! filesink location=test.mp4 -e

#gst-launch-1.0 videotestsrc ! 'video/x-raw, format=(string)I420, width=(int)640, height=(int)480' ! omxh265enc ! filesink location=test.h265 -e

#gst-launch-1.0 videotestsrc ! 'video/x-raw, format=(string)I420, width=(int)640, height=(int)480' ! \
#	omxh264enc ! 'video/x-h264, stream-format=(string)byte-stream' ! h264parse ! qtmux ! filesink location=test.mp4 -e
