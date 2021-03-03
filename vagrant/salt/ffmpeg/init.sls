# Based on ffmpeg installation instructions found at https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

{% set h264 = pillar.get('h264', {}) %}
{% set h264_version = h264.get('version', '20140803-2245-stable') %}
{% set h264_version_hash = h264.get('version_hash', 'sha1=c242dfe296e88d73665aa1b3ca1d5de3cc908207') %}
{% set fdk_aac = pillar.get('fdk_aac', {}) %}
{% set fdk_aac_version = fdk_aac.get('version', 'v2.0.1') %}
{% set fdk_aac_version_shortcode = '2.0.1' %}
{% set fdk_aac_version_hash = fdk_aac.get('version_hash', 'sha1=3684ed4081d006bb476215ccb632b0f241892edf') %}
{% set vpx = pillar.get('vpx', {}) %}
{% set vpx_version = vpx.get('version', '1.9.0') %}
{% set vpx_version_hash = vpx.get('version_hash', 'sha1=2ab8203ad8922bdf3256e4a197d1348fa8db9a62') %}
{% set ffmpeg = pillar.get('ffmpeg', {}) %}
{% set ffmpeg_version = ffmpeg.get('version', '4.3.1') %}
{% set ffmpeg_version_hash = ffmpeg.get('version_hash', 'sha1=615e8c571dd7959e57fcc579533ec30806189693') %}

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

    cmd.run:
        - name: tar xf x264-snapshot-{{ h264_version }}.tar.bz2
        - cwd: /usr/local/src
        - unless: which x264

h264-make-distclean:
    cmd.wait:
        - name: make distclean
        - cwd: /usr/local/src/x264-snapshot-{{ h264_version }}
        - watch:
            - cmd: h264-source

h264-configure:
    cmd.wait:
        - name: ./configure --enable-static --enable-pic --disable-opencl --prefix=/usr/local --bindir=/usr/local/bin --extra-cflags="-fno-pie"
        - cwd: /usr/local/src/x264-snapshot-{{ h264_version }}
        - watch:
            - cmd: h264-make-distclean

h264-make:
    cmd.wait:
        - name: make
        - cwd: /usr/local/src/x264-snapshot-{{ h264_version }}
        - require: [ h264-make-distclean ]
        - watch:
            - cmd: h264-configure

h264-make-install:
    cmd.wait:
        - name: make install
        - cwd: /usr/local/src/x264-snapshot-{{ h264_version }}
        - require: [ h264-make ]
        - watch:
            - cmd: h264-make

fdk-aac-folder:
    archive.extracted:
        - name: /usr/local/src
        - source: https://github.com/mstorsjo/fdk-aac/archive/{{ fdk_aac_version }}.tar.gz
        - source_hash: {{ fdk_aac_version_hash }}
        - archive_format: tar
        - mode: 775
        - user: vagrant
        - group: vagrant
        - makedirs: True

fdk-aac-autoreconf:
    cmd.run:
        - name: autoreconf -fiv
        - cwd: /usr/local/src/fdk-aac-{{ fdk_aac_version_shortcode }}
        - unless:
            - ls /usr/local/lib/libfdk-aac.a

fdk-aac-configure:
    cmd.wait:
        - name: ./configure --prefix=/usr/local --disable-shared
        - cwd: /usr/local/src/fdk-aac-{{ fdk_aac_version_shortcode }}
        - watch:
            - cmd: fdk-aac-autoreconf

fdk-aac-make:
    cmd.wait:
        - name: make &&
                make install &&
                make distclean
        - cwd: /usr/local/src/fdk-aac-{{ fdk_aac_version_shortcode }}
        - watch:
            - cmd: fdk-aac-configure

libvpx-source:
    archive.extracted:
        - name: /usr/local/src
        - source: https://github.com/webmproject/libvpx/archive/v{{ vpx_version }}.tar.gz
        - source_hash: {{ vpx_version_hash }}
        - archive_format: tar
        - mode: 775
        - user: vagrant
        - group: vagrant
        - recurse:
            - user
            - group
            - mode
        - makedirs: True

libvpx:
    file.directory:
        - name: /usr/local/src/libvpx-{{ vpx_version }}
        - mode: 775
        - user: vagrant
        - group: vagrant
        - recurse:
            - user
            - group
            - mode
        - makedirs: True
    cmd.run:
        - name: ./configure --prefix=/usr/local --disable-examples &&
                make &&
                make install &&
                make clean
        - cwd: /usr/local/src/libvpx-{{ vpx_version }}
        - unless: ls /usr/local/lib/libvpx.a
        - require: [ libvpx-source ] 

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

ffmpeg-distclean:
    cmd.run:
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
                --enable-nonfree && 
                make distclean
        - cwd: /usr/local/src/ffmpeg-{{ ffmpeg_version }}
        - unless: which ffmpeg

ffmpeg-configure:
    cmd.wait:
        - env:
            PKG_CONFIG_PATH: /usr/local/lib/pkgconfig
        - cwd: /usr/local/src/ffmpeg-{{ ffmpeg_version }}
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
        - watch: 
            - ffmpeg-distclean

ffmpeg-make:
    cmd.wait:
        - name: make
        - cwd: /usr/local/src/ffmpeg-{{ ffmpeg_version }}
        - watch:
            - ffmpeg-configure
        
ffmpeg-make-install:
    cmd.wait:
        - name: make install
        - cwd: /usr/local/src/ffmpeg-{{ ffmpeg_version }}
        - watch: 
            - ffmpeg-make