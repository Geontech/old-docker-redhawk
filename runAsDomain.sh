#!/bin/bash
#
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

function checkImage() {
	if [[ "$(docker images -q "$1")" = "" ]]; then
		return 0
	else
		return 1
	fi
}

# Make sure the correct images are built already
checkImage "redhawk-deps"

if [ $? == 0 ]; then
	echo "Image 'redhawk-deps' is not available. Run build.sh"
	exit 1
fi

checkImage "redhawk-base"

if [ $? == 0 ]; then
	echo "Image 'redhawk-base' is not available. Run build.sh"
	exit 1
fi

# Check if an IP address was provided
ipToUse="127.0.0.1"

if [ "$1" != "" ]; then
	ipToUse="$1"
fi

# Run the docker container as a domain
docker run --net=host -e OMNISERVICEIP=$ipToUse --name rhdomain -i -t redhawk-base
