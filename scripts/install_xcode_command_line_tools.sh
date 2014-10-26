#!/bin/bash

if !(xcode-select -p >/dev/null 2>/dev/null); then
	echo "You need to install Xcode command line tools, re-run this script when it's done"
	xcode-select --install 2>/dev/null
	exit
fi
