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
FROM redhawk-deps
MAINTAINER Thomas Goodwin <btgoodwin@geontech.com>
LABEL version="1.0" description="CentOS 6 with REDHAWK 2 compiled from source against Boost 1.56"

# Load other dependencies
RUN yum update -y && \
    yum install -y \
        libtool \
        log4cxx-devel \
        numpy \
        PyQt4 \
        python-jinja2-26

# Setup EPEL and update packages
WORKDIR /tmp
RUN wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum install -y --nogpgcheck epel-release-6-8.noarch.rpm && \
    rm -f epel-release-*

# REDHAWK Directories
ENV SDRROOT     /usr/local/redhawk/sdr
ENV OSSIEHOME   /usr/local/redhawk/core

# Extend Compiling related variables
ENV LD_LIBRARY_PATH ${OSSIEHOME}/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH      ${OSSIEHOME}/lib64/python:${OSSIEHOME}/lib/python:${PYTHONPATH}
ENV PATH            ${OSSIEHOME}/bin:$PATH

# Framework CORE
RUN git clone git://github.com/redhawksdr/framework-core.git && \
    cd framework-core && \
    git checkout tags/2.0.0 && \
    cd src && \
    touch AUTHORS ChangeLog NEWS README && \
    ./reconf && \
    ./configure \
        --with-ossie=${OSSIEHOME} \
        --with-sdr=${SDRROOT} \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} \
        --disable-java \
        --with-boost=/usr/local \
        --with-boost-libdir=/usr/local/lib && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf framework-core

# Framework BULKIO
RUN git clone git://github.com/RedhawkSDR/framework-bulkioInterfaces.git && \
    cd framework-bulkioInterfaces && \
    git checkout tags/2.0.0 && \
    mkdir src && touch src/AUTHORS src/ChangeLog src/NEWS src/README && \
    ./reconf && \
    ./configure \
        --with-ossie=${OSSIEHOME} \
        --with-sdr=${SDRROOT} \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} \
        --disable-java \
        --with-boost=/usr/local \
        --with-boost-libdir=/usr/local/lib && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf framework-bulkioInterfaces

# Framework FEI
RUN git clone git://github.com/RedhawkSDR/frontendInterfaces.git && \
    cd frontendInterfaces && \
    git checkout tags/2.3.0 && \
    mkdir src && touch src/AUTHORS src/ChangeLog src/NEWS src/README && \
    ./reconf && \
    ./configure \
        --with-ossie=${OSSIEHOME} \
        LDFLAGS=${LDFLAGS} \
        CPPFLAGS=${CPPFLAGS} \
        PYTHONPATH=${PYTHONPATH} \
        --disable-java \
        --with-boost=/usr/local \
        --with-boost-libdir=/usr/local/lib && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf frontendInterfaces

# Framework CodeGen
RUN git clone git://github.com/RedhawkSDR/framework-codegen.git && \
    cd framework-codegen && \
    git checkout tags/2.0.0 && \
    python setup.py install && \
    cd /tmp && \
    rm -rf framework-codegen

# Add the startDomain script
COPY startDomain.sh /startDomain.sh

# Expose the environment variables to following containers
ONBUILD ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}
ONBUILD ENV PYTHONPATH      ${PYTHONPATH}
ONBUILD ENV PATH            ${PATH}
ONBUILD ENV PKG_CONFIG_PATH ${PKG_CONFIG_PATH}
ONBUILD ENV LDFLAGS         ${LDFLAGS}
ONBUILD ENV CPPFLAGS        ${CPPFLAGS}
ONBUILD ENV SDRROOT         ${SDRROOT}
ONBUILD ENV OSSIEHOME       ${OSSIEHOME}

CMD ["/bin/bash", "-l", "/startDomain.sh"]
