FROM debian:10 as builder

RUN apt update && apt-get -y install \
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

RUN make MXE_TARGETS="$MXE_TARGETS" qt5

RUN rm -f /mxe/pkg/*.*

RUN rm -rf /mxe/.git

RUN rm -rf /mxe/.ccache

RUN rm -rf /mxe/log/*

RUN rm -rf /usr/share/doc

RUN rm -rf /usr/share/man

FROM debian:10

COPY --from=builder / /

RUN mkdir /src

WORKDIR /src

RUN ln -s /mxe/usr/x86_64-w64-mingw32.shared/qt5/bin/qmake /usr/bin/qmake.shared

RUN ln -s /mxe/usr/x86_64-w64-mingw32.shared/qt5/bin/qmake /usr/bin/qmake.mingw64.shared

RUN ln -s /mxe/usr/x86_64-w64-mingw32.static/qt5/bin/qmake /usr/bin/qmake.static

RUN ln -s /mxe/usr/x86_64-w64-mingw32.static/qt5/bin/qmake /usr/bin/qmake.mingw64.static

ENV PATH /mxe/usr/x86_64-pc-linux-gnu/bin:/mxe/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD /bin/bash

