#!/bin/bash

# Going to the root dir of the repository
pushd `dirname $0` > /dev/null
ROOT_PATH=`pwd -P`/..
popd > /dev/null
cd $ROOT_PATH
ROOT_PATH=`pwd -P`

# Install Xcode command line tools if needed
. ./scripts/install_xcode_command_line_tools.sh

# Install puppet if needed
. ./scripts/install_puppet.sh

# Check that manifests/init.pp file exists
if [ ! -f manifests/init.pp ]; then
	echo "Error : file manifests/init.pp not found"
	exit
fi

# Run puppet
sudo puppet apply --modulepath=./modules --hiera_config=./hiera/config.yaml manifests/init.pp

if [ -f $ROOT_PATH/.need_to_source_env_sh ]; then
	echo "You need to source the $ROOT_PATH/env.sh file"
fi
