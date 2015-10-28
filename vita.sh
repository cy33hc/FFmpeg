#!/bin/bash

GENERAL="\
   --enable-cross-compile \
   --extra-libs="-lgcc" \
   --arch=arm \
   --cc=arm-vita-eabi-gcc \
   --cross-prefix=arm-vita-eabi- \
   --nm=arm-vita-eabi-nm"

MODULES="\
   --disable-avdevice \
   --disable-filters \
   --disable-programs \
   --disable-avfilter \
   --disable-network \
   --disable-postproc \
   --disable-encoders \
   --disable-protocols \
   --disable-hwaccels \
   --disable-doc"

VIDEO_DECODERS="\
   --enable-decoder=h264 \
   --enable-decoder=mpc7 \
   --enable-decoder=mpc8 \
   --enable-decoder=mpeg4 \
   --enable-decoder=msmpeg4v1 \
   --enable-decoder=msmpeg4v2 \
   --enable-decoder=msmpeg4v3 \
   --enable-decoder=mpegvideo \
   --enable-decoder=mpeg1video \
   --enable-decoder=mpeg2video \
   --enable-decoder=mjpeg \
   --enable-decoder=mjpegb \
   --enable-decoder=vorbis \
   --enable-decoder=srt \
   --enable-decoder=ssa \
   --enable-decoder=subrip \
   --enable-decoder=xsub \
   --enable-decoder=vp3 \
   --enable-decoder=vp5 \
   --enable-decoder=vp6 \
   --enable-decoder=vp7 \
   --enable-decoder=vp8 \
   --enable-decoder=vp9 \
   --enable-decoder=rv10 \
   --enable-decoder=rv20 \
   --enable-decoder=rv30 \
   --enable-decoder=rv40 \
   --enable-decoder=rawvideo \
   --enable-decoder=flv \
   --enable-decoder=svq1 \
   --enable-decoder=svq3 \
   --enable-decoder=wmav1 \
   --enable-decoder=wmav2 \
   --enable-decoder=wmv1 \
   --enable-decoder=wmv2 \
   --enable-decoder=wmv3 \
   --enable-decoder=realtext \
   --enable-decoder=h263 \
   --enable-decoder=mpeg1_vdpau \
   --enable-decoder=mpeg1video \
   --enable-decoder=mpeg2_crystalhd \
   --enable-decoder=mpeg2video \
   --enable-decoder=mpeg4 \
   --enable-decoder=mpeg4_crystalhd \
   --enable-decoder=mpeg4_vdpau \
   --enable-decoder=mpeg_vdpau \
   --enable-decoder=mpeg_xvmc \
   --enable-decoder=mpegvideo \
   --enable-decoder=msmpeg4_crystalhd \
   --enable-decoder=msmpeg4v1 \
   --enable-decoder=msmpeg4v2 \
   --enable-decoder=msmpeg4v3 \
   --enable-decoder=h264_crystalhd \
   --enable-decoder=h264_vdpau \
   --enable-decoder=h264 \
   --enable-decoder=h261 \
   --enable-decoder=h263 \
   --enable-decoder=h263i \
   --enable-decoder=libopenjpeg \
   --enable-decoder=mjpeg \
   --enable-decoder=mjpegb \
   --enable-decoder=jpeg2000 \
   --enable-decoder=jpegls"

AUDIO_DECODERS="\
	--enable-decoder=ac3 \
	--enable-decoder=aac \
	--enable-decoder=aac_latm \
	--enable-decoder=atrac1 \
	--enable-decoder=atrac3 \
	--enable-decoder=atrac3p \
	--enable-decoder=mp3 \
	--enable-decoder=pcm_s16le \
	--enable-decoder=pcm_s8 \
	--enable-decoder=pcm_bluray \
	--enable-decoder=pcm_dvd \
	--enable-decoder=pcm_f32be \
	--enable-decoder=pcm_f32le \
	--enable-decoder=pcm_f64be \
	--enable-decoder=pcm_f64le \
	--enable-decoder=pcm_lxf \
	--enable-decoder=pcm_mulaw \
	--enable-decoder=pcm_s16be \
	--enable-decoder=pcm_s16be_planar \
	--enable-decoder=pcm_s16le \
	--enable-decoder=pcm_s16le_planar \
	--enable-decoder=pcm_s24be \
	--enable-decoder=pcm_s24daud \
	--enable-decoder=pcm_s24le \
	--enable-decoder=pcm_s24le_planar \
	--enable-decoder=pcm_s32be"

DEMUXERS="\
	--enable-demuxer=h264 \
	--enable-demuxer=m4v \
	--enable-demuxer=mpegvideo \
	--enable-demuxer=mpegps \
	--enable-demuxer=mp3 \
	--enable-demuxer=avi \
	--enable-demuxer=aac \
	--enable-demuxer=ac3 \
	--enable-demuxer=flac \
	--enable-demuxer=matroska \
	--enable-demuxer=mpeg \
	--enable-demuxer=pmp \
	--enable-demuxer=oma \
	--enable-demuxer=pcm_s16le \
	--enable-demuxer=pcm_s8 \
	--enable-demuxer=wav \
	--enable-demuxer=mpc \
	--enable-demuxer=mpc8 \
	--enable-demuxer=mpegps \
	--enable-demuxer=mpegts \
	--enable-demuxer=mpegtsraw \
	--enable-demuxer=mpegvideo \
	--enable-demuxer=mpjpeg \
	--enable-demuxer=h261 \
	--enable-demuxer=h263 \
	--enable-demuxer=h264 \
	--enable-demuxer=hevc \
	--enable-demuxer=dts \
	--enable-demuxer=flac \
	--enable-demuxer=flic \
	--enable-demuxer=flv  \
	--enable-demuxer=rawvideo \
	--enable-demuxer=realtext \
	--enable-demuxer=cine \
	--enable-demuxer=ogg \
	--enable-demuxer=rtp  \
	--enable-demuxer=rtsp \
	--enable-demuxer=dirac \
	--enable-demuxer=asf \
	--enable-demuxer=asf_o \
	--enable-demuxer=aiff \
	--enable-demuxer=avi      \
	--enable-demuxer=avisynth \
	--enable-demuxer=bink \
	--enable-demuxer=truehd \
	--enable-demuxer=smjpeg \
	--enable-demuxer=sol \
	--enable-demuxer=pcm_alaw  \
	--enable-demuxer=pcm_f32be \
	--enable-demuxer=pcm_f32le \
	--enable-demuxer=pcm_f64be \
	--enable-demuxer=pcm_f64le \
	--enable-demuxer=pcm_mulaw \
	--enable-demuxer=pcm_s16be \
	--enable-demuxer=pcm_s16le \
	--enable-demuxer=pcm_s24be \
	--enable-demuxer=pcm_s24le \
	--enable-demuxer=pcm_s32be \
	--enable-demuxer=pcm_s32le \
	--enable-demuxer=pcm_s8    \
	--enable-demuxer=pcm_u16be \
	--enable-demuxer=pcm_u16le \
	--enable-demuxer=pcm_u24be \
	--enable-demuxer=pcm_u24le \
	--enable-demuxer=pcm_u32be \
	--enable-demuxer=pcm_u32le \
	--enable-demuxer=pcm_u8    \
	--enable-demuxer=m4v      \
	--enable-demuxer=matroska \
	--enable-demuxer=mgsts    \
	--enable-demuxer=microdvd \
	--enable-demuxer=mjpeg \
	--enable-demuxer=mov"

VIDEO_ENCODERS="\
	  --enable-encoder=huffyuv \
	  --enable-encoder=ffv1 \
	  --enable-encoder=mjpeg"

AUDIO_ENCODERS="\
	  --enable-encoder=pcm_s16le"

MUXERS="\
  	  --enable-muxer=avi"


PARSERS="\
	--enable-parser=h264 \
	--enable-parser=mpeg4video \
	--enable-parser=mpegaudio \
	--enable-parser=mpegvideo \
	--enable-parser=ac3 \
	--enable-parser=aac \
	--enable-parser=aac_latm \
	--enable-parser=rv30 \
	--enable-parser=rv40 \
	--enable-parser=vorbis \
	--enable-parser=flac \
	--enable-parser=vp3 \
	--enable-parser=vp8 \
	--enable-parser=vp9 \
	--enable-parser=dvd_nav \
	--enable-parser=dvdsub \
	--enable-parser=h261 \
	--enable-parser=h263 \
	--enable-parser=h264 \
	--enable-parser=hevc \
	--enable-parser=mjpeg"

PROTOCOLS="\
  	  --enable-protocol=cache \
	  --enable-protocol=file \
	  --enable-protocol=ftp \
	  --enable-protocol=http \
	  --enable-protocol=https \
	  --enable-protocol=unix"

function build_vita
{
./configure --target-os=linux \
	--prefix=$VITASDK/arm-vita-eabi \
	${GENERAL} \
	--extra-cflags="-Wl,-q -Wall -O3 " \
	--disable-shared \
	--enable-static \
	--enable-zlib \
	--disable-everything \
	${MODULES} \
	${VIDEO_DECODERS} \
	${AUDIO_DECODERS} \
	${VIDEO_ENCODERS} \
	${AUDIO_ENCODERS} \
	${DEMUXERS} \
	${MUXERS} \
	${PARSERS} \
	${PROTOCOLS}
}

build_vita
echo vita builds finished
