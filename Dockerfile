FROM debian:10

RUN apt update

RUN apt-get -y install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils \
    g++-multilib \
    libc6-dev-i386 
#   cmake \
#    libboost-filesystem-dev
    
WORKDIR /

RUN git clone https://github.com/mxe/mxe.git

WORKDIR /mxe

ENV MXE_TARGETS "x86_64-w64-mingw32.shared x86_64-w64-mingw32.static"

ENV MXE_PLUGIN_DIRS plugins/gcc9

RUN make download-gcc

RUN make MXE_PLUGIN_DIRS="$MXE_PLUGIN_DIRS" MXE_TARGETS="x86_64-w64-mingw32.shared" cc

RUN make MXE_PLUGIN_DIRS="$MXE_PLUGIN_DIRS" MXE_TARGETS="x86_64-w64-mingw32.static" cc

RUN make MXE_TARGETS="$MXE_TARGETS" openssl

RUN make MXE_TARGETS="$MXE_TARGETS" icu4c

RUN make MXE_TARGETS="$MXE_TARGETS" dbus
RUN make MXE_TARGETS="$MXE_TARGETS" libpng
RUN make MXE_TARGETS="$MXE_TARGETS" freetype
RUN make MXE_TARGETS="$MXE_TARGETS" libiconv
RUN make MXE_TARGETS="$MXE_TARGETS" gettext
RUN make MXE_TARGETS="$MXE_TARGETS" fontconfig
RUN make MXE_TARGETS="$MXE_TARGETS" freetds
RUN make MXE_TARGETS="$MXE_TARGETS" libffi
RUN make MXE_TARGETS="$MXE_TARGETS" pcre
RUN make MXE_TARGETS="$MXE_TARGETS" glib
RUN make MXE_TARGETS="$MXE_TARGETS" lzo
RUN make MXE_TARGETS="$MXE_TARGETS" pixman
RUN make MXE_TARGETS="$MXE_TARGETS" cairo
RUN make MXE_TARGETS="$MXE_TARGETS" harfbuzz
RUN make MXE_TARGETS="$MXE_TARGETS" jpeg
RUN make MXE_TARGETS="$MXE_TARGETS" mesa
RUN make MXE_TARGETS="$MXE_TARGETS" libmysqlclient
RUN make MXE_TARGETS="$MXE_TARGETS" pcre2
RUN make MXE_TARGETS="$MXE_TARGETS" postgresql
RUN make MXE_TARGETS="$MXE_TARGETS" sqlite
RUN make MXE_TARGETS="$MXE_TARGETS" jasper
RUN make MXE_TARGETS="$MXE_TARGETS" libwebp
RUN make MXE_TARGETS="$MXE_TARGETS" xz
RUN make MXE_TARGETS="$MXE_TARGETS" tiff
RUN make MXE_TARGETS="$MXE_TARGETS" libmng
RUN make MXE_TARGETS="$MXE_TARGETS" qt5

#WORKDIR /opt

#RUN git clone https://github.com/gsauthof/pe-util.git

#WORKDIR /opt/pe-util

#RUN git submodule update --init

#RUN mkdir build && \
#    cd build && \
#    cmake .. -DBOOST_NO_CXX11_SCOPED_ENUMS=1 -DCMAKE_BUILD_TYPE=Release && \
#    make && \
#    make install

#RUN mkdir /src

WORKDIR /src

RUN ln -s /mxe/usr/x86_64-w64-mingw32.static/qt5/bin/qmake /usr/bin/qmake.mingw64.static

RUN ln -s /mxe/usr/x86_64-w64-mingw32.shared/qt5/bin/qmake /usr/bin/qmake.mingw64.shared

RUN ln -s /mxe/usr/x86_64-pc-linux-gnu/bin/peldd /usr/bin/peldd

ENV PATH /mxe/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN rm -f /mxe/pkg/*.*

RUN rm -rf /mxe/.git

RUN rm -rf /mxe/.ccache

RUN rm -rf /mxe/log/*

CMD /bin/bash

