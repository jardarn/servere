# Based on ffmpeg installation instructions found at https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

{% set h264 = pillar.get('h264', {}) %}
{% set h264_version = h264.get('version', '20140803-2245-stable') %}
{% set h264_version_hash = h264.get('version_hash', 'sha1=c242dfe296e88d73665aa1b3ca1d5de3cc908207') %}
{% set fdk_aac = pillar.get('fdk_aac', {}) %}
{% set fdk_aac_version = fdk_aac.get('version', '9a3234055adb1e18f80571925779503c8dec5251') %}
{% set fdk_aac_version_hash = fdk_aac.get('version_hash', 'sha1=5d8c59819ba32e33996a4607370f63f57d356466') %}
{% set vpx = pillar.get('vpx', {}) %}
{% set vpx_version = vpx.get('version', '1.3.0') %}
{% set vpx_version_hash = vpx.get('version_hash', 'sha1=f2422e9d14d84a6b48c69dbd1adb2e7fa9653997') %}
{% set ffmpeg = pillar.get('ffmpeg', {}) %}
{% set ffmpeg_version = ffmpeg.get('version', '2.3.1') %}
{% set ffmpeg_version_hash = ffmpeg.get('version_hash', 'sha1=79efcf3a771f42ffed17c4886e4aae6a7a642d7a') %}

ffmpeg-deps:
    pkg.installed:
        - pkgs:
            - autoconf
            - automake
            - build-essential
            - libass-dev
            - libfreetype6-dev
            - libgpac-dev
            - libmp3lame-dev
            - libsdl1.2-dev
            - libtheora-dev
            - libtool
            - libva-dev
            - libvdpau-dev
            - libvorbis-dev
            - libx11-dev
            - libxext-dev
            - libxfixes-dev
            - pkg-config
            - texi2html
            - zlib1g-dev
            - yasm


h264-source:
    file.managed:
        - name: /usr/local/src/x264-snapshot-{{ h264_version }}.tar.bz2
        - source: http://download.videolan.org/pub/x264/snapshots/x264-snapshot-{{ h264_version }}.tar.bz2
        - source_hash: {{ h264_version_hash }}

    cmd.wait:
        - name: tar xf x264-snapshot-{{ h264_version }}.tar.bz2
        - cwd: /usr/local/src
        - watch:
            - file: h264-source


h264:
    cmd.wait:
        - name: ./configure --enable-static --disable-opencl --prefix=/usr/local --bindir=/usr/local/bin &&
                make &&
                make install &&
                make distclean
        - cwd: /usr/local/src/x264-snapshot-{{ h264_version }}
        - watch:
            - cmd: h264-source


fdk-aac-source:
    file.managed:
        - name: /usr/local/src/fdk-aac-{{ fdk_aac_version }}.tar.gz
        - source: https://github.com/mstorsjo/fdk-aac/tarball/{{ fdk_aac_version }}
        - source_hash: {{ fdk_aac_version_hash }}

    cmd.wait:
        - name: tar xf fdk-aac-{{ fdk_aac_version }}.tar.gz
        - cwd: /usr/local/src
        - watch:
            - file: fdk-aac-source


fdk-aac:
    cmd.wait:
        - name: cd mstorsjo-fdk-aac* &&
                autoreconf -fiv &&
                ./configure --prefix=/usr/local --disable-shared &&
                make &&
                make install &&
                make distclean
        - cwd: /usr/local/src
        - watch:
            - cmd: fdk-aac-source


libvpx-source:
    file.managed:
        - name: /usr/local/src/libvpx-v{{ vpx_version }}.tar.gz
        #- source: https://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
        - source: https://github.com/webmproject/libvpx/archive/v1.3.0.tar.gz
        - source_hash: {{ vpx_version_hash }}

    cmd.wait:
        - name: tar xf libvpx-v{{ vpx_version }}.tar.gz
        - cwd: /usr/local/src
        - watch:
            - file: libvpx-source


libvpx:
    file.directory:
        - name: /usr/local/src/libvpx-v{{ vpx_version }}
        - mode: 775
        - user: vagrant
        - group: vagrant
        - makedirs: True
    cmd.wait:
        - name: ./configure --prefix=/usr/local --disable-examples &&
                make &&
                make install &&
                make clean
        - cwd: /usr/local/src/libvpx-v{{ vpx_version }}
        - watch:
            - cmd: libvpx-source


ffmpeg-source:
    file.managed:
        - name: /usr/local/src/ffmpeg-{{ ffmpeg_version }}.tar.bz2
        - source: http://ffmpeg.org/releases/ffmpeg-{{ ffmpeg_version }}.tar.gz
        - source_hash: {{ ffmpeg_version_hash }}

    cmd.wait:
        - name: tar xf ffmpeg-{{ ffmpeg_version }}.tar.bz2
        - cwd: /usr/local/src
        - watch:
            - file: ffmpeg-source

ffmpeg:
    cmd.wait:
        - env:
            PKG_CONFIG_PATH: /usr/local/lib/pkgconfig
        - name: ./configure
                --prefix=/usr/local
                --extra-cflags=-I/usr/local/include
                --extra-ldflags=-L/usr/local/lib
                --bindir=/usr/local/bin
                --enable-gpl
                --enable-libass
                --enable-libfdk-aac
                --enable-libfreetype
                --enable-libmp3lame
                --enable-libtheora
                --enable-libvorbis
                --enable-libvpx
                --enable-libx264
                --enable-nonfree
                --enable-x11grab &&
                make &&
                make install &&
                make distclean
        - cwd: /usr/local/src/ffmpeg-{{ ffmpeg_version }}
        - require:
            - pkg: ffmpeg-deps
            - cmd: fdk-aac
            - cmd: h264
            - cmd: libvpx
        - watch:
            - cmd: ffmpeg-source
