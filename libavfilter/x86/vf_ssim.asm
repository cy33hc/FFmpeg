;*****************************************************************************
;* x86-optimized functions for ssim filter
;*
;* Copyright (C) 2015 Ronald S. Bultje <rsbultje@gmail.com>
;*
;* This file is part of FFmpeg.
;*
;* FFmpeg is free software; you can redistribute it and/or
;* modify it under the terms of the GNU Lesser General Public
;* License as published by the Free Software Foundation; either
;* version 2.1 of the License, or (at your option) any later version.
;*
;* FFmpeg is distributed in the hope that it will be useful,
;* but WITHOUT ANY WARRANTY; without even the implied warranty of
;* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;* Lesser General Public License for more details.
;*
;* You should have received a copy of the GNU Lesser General Public
;* License along with FFmpeg; if not, write to the Free Software
;* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;******************************************************************************

%include "libavutil/x86/x86util.asm"

SECTION_RODATA

pw_1: times 8 dw 1
ssim_c1: times 4 dd 416 ;(.01*.01*255*255*64 + .5)
ssim_c2: times 4 dd 235963 ;(.03*.03*255*255*64*63 + .5)

SECTION .text

%if ARCH_X86_64

INIT_XMM ssse3
cglobal ssim_4x4_line, 6, 8, 16, buf, buf_stride, ref, ref_stride, sums, w, buf_stride3, ref_stride3
    lea     ref_stride3q, [ref_strideq*3]
    lea     buf_stride3q, [buf_strideq*3]
    pxor              m7, m7
    mova             m15, [pw_1]

.loop:
    movh              m0, [bufq+buf_strideq*0]  ; a1
    movh              m1, [refq+ref_strideq*0]  ; b1
    movh              m2, [bufq+buf_strideq*1]  ; a2
    movh              m3, [refq+ref_strideq*1]  ; b2
    punpcklbw         m0, m7                    ; s1 [word]
    punpcklbw         m1, m7                    ; s2 [word]
    punpcklbw         m2, m7                    ; s1 [word]
    punpcklbw         m3, m7                    ; s2 [word]
    pmaddwd           m4, m0, m0                ; a1 * a1
    pmaddwd           m5, m1, m1                ; b1 * b1
    pmaddwd           m8, m2, m2                ; a2 * a2
    pmaddwd           m9, m3, m3                ; b2 * b2
    paddd             m4, m5                    ; ss
    paddd             m8, m9                    ; ss
    pmaddwd           m6, m0, m1                ; a1 * b1 = ss12
    pmaddwd           m5, m2, m3                ; a2 * b2 = ss12
    paddw             m0, m2
    paddw             m1, m3
    paddd             m6, m5                    ; s12
    paddd             m4, m8                    ; ss

    movh              m2, [bufq+buf_strideq*2]  ; a3
    movh              m3, [refq+ref_strideq*2]  ; b3
    movh              m5, [bufq+buf_stride3q]   ; a4
    movh              m8, [refq+ref_stride3q]   ; b4
    punpcklbw         m2, m7                    ; s1 [word]
    punpcklbw         m3, m7                    ; s2 [word]
    punpcklbw         m5, m7                    ; s1 [word]
    punpcklbw         m8, m7                    ; s2 [word]
    pmaddwd           m9, m2, m2                ; a3 * a3
    pmaddwd          m10, m3, m3                ; b3 * b3
    pmaddwd          m12, m5, m5                ; a4 * a4
    pmaddwd          m13, m8, m8                ; b4 * b4
    pmaddwd          m11, m2, m3                ; a3 * b3 = ss12
    pmaddwd          m14, m5, m8                ; a4 * b4 = ss12
    paddd             m9, m10
    paddd            m12, m13
    paddw             m0, m2
    paddw             m1, m3
    paddw             m0, m5
    paddw             m1, m8
    paddd             m6, m11
    paddd             m4, m9
    paddd             m6, m14
    paddd             m4, m12

    ; m0 = [word] s1 a,a,a,a,b,b,b,b
    ; m1 = [word] s2 a,a,a,a,b,b,b,b
    ; m4 = [dword] ss a,a,b,b
    ; m6 = [dword] s12 a,a,b,b

    pmaddwd           m0, m15                   ; [dword] s1 a,a,b,b
    pmaddwd           m1, m15                   ; [dword] s2 a,a,b,b
    phaddd            m0, m4                    ; [dword] s1 a, b, ss a, b
    phaddd            m1, m6                    ; [dword] s2 a, b, s12 a, b
    punpckhdq     m2, m0, m1                    ; [dword] ss a, s12 a, ss b, s12 b
    punpckldq         m0, m1                    ; [dword] s1 a, s2 a, s1 b, s2 b
    punpckhqdq    m1, m0, m2                    ; [dword] b s1, s2, ss, s12
    punpcklqdq        m0, m2                    ; [dword] a s1, s2, ss, s12

    mova  [sumsq+     0], m0
    mova  [sumsq+mmsize], m1

    add             bufq, mmsize/2
    add             refq, mmsize/2
    add            sumsq, mmsize*2
    sub               wd, mmsize/8
    jg .loop
    RET

%endif

INIT_XMM sse4
cglobal ssim_end_line, 3, 3, 6, sum0, sum1, w
    pxor              m0, m0
.loop:
    mova              m1, [sum0q+mmsize*0]
    mova              m2, [sum0q+mmsize*1]
    mova              m3, [sum0q+mmsize*2]
    mova              m4, [sum0q+mmsize*3]
    paddd             m1, [sum1q+mmsize*0]
    paddd             m2, [sum1q+mmsize*1]
    paddd             m3, [sum1q+mmsize*2]
    paddd             m4, [sum1q+mmsize*3]
    paddd             m1, m2
    paddd             m2, m3
    paddd             m3, m4
    paddd             m4, [sum0q+mmsize*4]
    paddd             m4, [sum1q+mmsize*4]
    TRANSPOSE4x4D      1, 2, 3, 4, 5

    ; m1 = fs1, m2 = fs2, m3 = fss, m4 = fs12
    pslld             m3, 6
    pslld             m4, 6
    pmulld            m5, m1, m2                ; fs1 * fs2
    pmulld            m1, m1                    ; fs1 * fs1
    pmulld            m2, m2                    ; fs2 * fs2
    psubd             m3, m1
    psubd             m4, m5                    ; covariance
    psubd             m3, m2                    ; variance

    ; m1 = fs1 * fs1, m2 = fs2 * fs2, m3 = variance, m4 = covariance, m5 = fs1 * fs2
    paddd             m4, m4                    ; 2 * covariance
    paddd             m5, m5                    ; 2 * fs1 * fs2
    paddd             m1, m2                    ; fs1 * fs1 + fs2 * fs2
    paddd             m3, [ssim_c2]             ; variance + ssim_c2
    paddd             m4, [ssim_c2]             ; 2 * covariance + ssim_c2
    paddd             m5, [ssim_c1]             ; 2 * fs1 * fs2 + ssim_c1
    paddd             m1, [ssim_c1]             ; fs1 * fs1 + fs2 * fs2 + ssim_c1

    ; convert to float
    cvtdq2ps          m3, m3
    cvtdq2ps          m4, m4
    cvtdq2ps          m5, m5
    cvtdq2ps          m1, m1
    mulps             m4, m5
    mulps             m3, m1
    divps             m4, m3                    ; ssim_endl
    addps             m0, m4                    ; ssim
    add            sum0q, mmsize*4
    add            sum1q, mmsize*4
    sub               wd, 4
    jg .loop

    ; subps the ones we added too much
    test              wd, wd
    jz .end
    add               wd, 4
    test              wd, 2
    jz .skip2
    psrldq            m4, 8
.skip2:
    test              wd, 1
    jz .skip1
    psrldq            m4, 4
.skip1:
    subps             m0, m4

.end:
    movhlps           m4, m0
    addps             m0, m4
    movss             m4, m0
    shufps            m0, m0, 1
    addss             m0, m4
%if ARCH_X86_32
    movss            r0m, m0
    fld             r0mp
%endif
    RET