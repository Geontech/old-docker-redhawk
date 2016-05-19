# This file is protected by Copyright. Please refer to the COPYRIGHT file
# distributed with this source distribution.
#
# This file is part of Docker REDHAWK.
#
# Docker REDHAWK is free software: you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# Docker REDHAWK is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.
#
FROM centos:6
MAINTAINER Thomas Goodwin <btgoodwin@geontech.com>
LABEL version="1.0" description="CentOS 6 with REDHAWK dependencies"

# Load other dependencies
RUN yum update -y && \
    yum install -y \
        autoconf \
        automake \
        expat-devel \
        libtool \
        libuuid-devel \
        log4cxx-devel \
        numpy \
        python-devel \
        redhat-lsb \
        wget && \
    yum groupinstall -y 'Development Tools'

# Compiling related variables
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib64
ENV PYTHONPATH      /usr/local/lib64/python2.6/site-packages:/usr/local/lib/python2.6/site-packages
ENV PATH            $PATH
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
ENV LDFLAGS         -L/usr/local/lib
ENV CPPFLAGS        -I/usr/local/include

# Start working in /tmp
WORKDIR /tmp

# Compile and install better boost
RUN wget http://sourceforge.net/projects/boost/files/boost/1.56.0/boost_1_56_0.tar.gz && \
    tar xf boost_1_56_0.tar.gz && \
    cd boost_1_56_0 && \
    ./bootstrap.sh && \
    ./bjam install -q -s NO_BZIP2=1 && \
    cd /tmp && \
    rm -rf boost_1_56_0*

# xerces-c
RUN wget http://apache.cs.utah.edu//xerces/c/3/sources/xerces-c-3.1.3.tar.gz && \
    tar xf xerces-c-3.1.3.tar.gz && \
    cd xerces-c-3.1.3 && \
    ./configure \
        --enable-transcoder-icu \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} && \
    cd src && \
    make install && \
    cd /tmp && \
    rm -rf xerces-c*

# xsd
RUN wget http://www.codesynthesis.com/download/xsd/3.3/xsd-3.3.0-2+dep.tar.bz2 && \
    bzip2 -d xsd-3.3.0-2+dep.tar.bz2 && \
    tar xf xsd-3.3.0-2+dep.tar && \
    cd xsd-3.3.0-2+dep && \
    make install \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} && \
    cd /tmp && \
    rm -rf xsd-3.3.0*

# apr
RUN wget http://apache.osuosl.org/apr/apr-1.5.2.tar.gz && \
    tar xf apr-1.5.2.tar.gz && \
    cd apr-1.5.2 && \
    ./configure  \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf apr*

# apr-util
RUN wget http://apache.osuosl.org/apr/apr-util-1.5.4.tar.gz && \
    tar xf apr-util-1.5.4.tar.gz && \
    cd apr-util-1.5.4 && \
    ./configure --with-apr=/usr/local/apr \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf apr-util

# apache-log4cxx
RUN wget http://apache.mesi.com.ar/logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.tar.gz && \
    tar xf apache-log4cxx-0.10.0.tar.gz && \
    cd apache-log4cxx-0.10.0 && \
    sed -i "s/\#include <log4cxx\/logstring.h>/\#include <string.h>\n&/" src/main/cpp/inputstreamreader.cpp && \
    sed -i "s/\#include <log4cxx\/logstring.h>/\#include <string.h>\n&/" src/main/cpp/socketoutputstream.cpp && \
    sed -i "s/\#include <log4cxx\/logger.h>/\#include <string.h>\n\#include <stdio.h>\n&/" src/examples/cpp/console.cpp && \
    ./configure \
        --with-apr=/usr/local/apr  \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} && \
    make install && \
    cd /tmp && \
    rm -rf apache-log4cxx*

# Also, setup /etc/profile to take the OMNISERVICEIP environment variable and apply it
# on login every time.
COPY omniORB.cfg /etc/omniORB.cfg.base
COPY omniORB.cfg /etc/omniORB.cfg

# OmniORB
RUN wget http://downloads.sourceforge.net/omniorb/omniORB-4.1.6.tar.bz2 && \
    bzip2 -d omniORB-4.1.6.tar.bz2 && \
    tar xf omniORB-4.1.6.tar && \
    cd omniORB-4.1.6 && \
    ./configure \
        --with-omniORB-config=/etc/omniORB.cfg \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} \
        && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf omniORB*

# Install and configure the correct init.d script
COPY omniNames /etc/init.d/omniNames
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/sysconfig/omniNames && \
    useradd --no-create-home omniORB && \
    mkdir -p /var/log/omniORB && \
    chown -R omniORB.omniORB /var/log/omniORB

# OmniEvents
RUN git clone -b develop git://github.com/redhawksdr/omniEvents && \
    cd omniEvents && \
    ./configure \
        --with-omniORB-config=/etc/omniORB.cfg \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} \
        && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf omniEvents*

# Install and configure the correct init.d script
COPY omniEvents /etc/init.d/omniEvents    
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/default/omniorb-eventservice && \
    mkdir -p /var/lib/omniEvents

# OmniORBPy
RUN wget http://downloads.sourceforge.net/omniorb/omniORBpy-3.6.tar.bz2 && \
    bzip2 -d omniORBpy-3.6.tar.bz2 && \
    tar xf omniORBpy-3.6.tar && \
    cd omniORBpy-3.6 && \
    ./configure \
        --with-omniORB-config=/etc/omniORB.cfg \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} \
        && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf omniORBpy

# Delete the build area
WORKDIR /
RUN rm -rf /tmp

# Expose omni's ports
EXPOSE 2809 11169

# Prepare the /etc/profile to use the OMNISERVICEIP environment variable
RUN echo "sed -i s/OMNISERVICEIP/\$OMNISERVICEIP/g /etc/omniORB.cfg" | tee -a /root/.bashrc | tee -a /root/.bash_profile

# Add the startOmni script
COPY startOmni.sh /startOmni.sh

# Expose the environment variables to following containers
ONBUILD ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}
ONBUILD ENV PYTHONPATH      ${PYTHONPATH}
ONBUILD ENV PATH            ${PATH}
ONBUILD ENV PKG_CONFIG_PATH ${PKG_CONFIG_PATH}
ONBUILD ENV LDFLAGS         ${LDFLAGS}
ONBUILD ENV CPPFLAGS        ${CPPFLAGS}

CMD ["bash", "-l"]
