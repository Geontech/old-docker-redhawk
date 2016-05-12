# Docker REDHAWK Images

## Docker REDHAWK Deps Image

This Docker image is a CentOS 6 base with all of the dependencies necessary to build REDHAWK. Note that Boost 1.56 is built from source as opposed to using the default Boost 1.41 available as an RPM.

This image is used by the REDHAWK Base Image to build REDHAWK 2.0.1. It can be used for other versions of REDHAWK as well.

## Docker REDHAWK Base Image

This Docker image is built upon the REDHAWK Deps Image and builds REDHAWK 2.0.1. This image can be used to run a REDHAWK Domain Manager.

### Using the Script

To build all of the images, use the provided build.sh script:

        ./build.sh

To remove the images:

        ./build.sh clean

To build only redhawk-deps and redhawk-base:

        ./build.sh redhawk-base

This will build redhawk deps if necessary.

### Using Docker

Alternatively, each image can be built from the top level directory manually with:

        docker build --rm -t redhawk-deps docker-redhawk-deps

This will build redhawk deps only.

### Permissions

Note that it may be necessary to run the above commands as root if you are not part of the 'docker' group.

## Running

### Using the Script

#### Run as Domain

Use this script to run the REDHAWK Base Image as a Domain Manager on your computer.

	./runAsDomain

This script optionally accepts an IP address for the Domain Manager to accept distributed Devices on, which defaults to 127.0.0.1.

	./runAsDomain [IP Address]

### Using Docker

Consult the script above for an example of how to run the images.
