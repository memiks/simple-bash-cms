#!/bin/bash

# Simple BASH CMS
# Copyright (c) 2014 Ondrej Kulaty 
#
# This program is free software; you can redistribute it and/or
# odify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not see <http://www.gnu.org/licenses/>.
# This script is used to generate HTML files of the website
# Simply invoke it with no parameters and it will do this:

########################################################################
# PUBLISH SCRIPT                                                       #
########################################################################

# This script manages uploading (or mirroring) contents of local output
# directory to remote FTP server. Thanks to lftp it uploads only differences
# between local and remote directories. Invoke it with no parameters, edit
# config.sh to change FTP settings

# make sure this script is invoked from it's directory
if [[ $0 != "./publish.sh" ]]; then
	echo "ERROR: Run this script from it's directory!"
	exit
fi

# load configuration
source config.sh
# load common functions
source common.sh

# regenerate whole website (not necessary, can be commented out)
./generate.sh

# if FTP_PASS is empty, use FTP_PASS_COMMAND
if [ -z "${FTP_PASS}" ]; then
	FTP_PASS=`${FTP_PASS_COMMAND}`
	if [ $? -ne 0 ]; then
		echo_err "Password command exit status non-zero"
		exit
	fi
fi

# add commands to temporary script file
echo "set ftp:ssl-allow no" > .lftpscript
echo "open ftp://${FTP_USER}:${FTP_PASS}@${FTP_URL}" >> .lftpscript
echo "mirror -eR ${LOCAL_PATH} ${FTP_PATH}" >> .lftpscript
echo "exit" >> .lftpscript

# execute script
lftp -f .lftpscript
rm .lftpscript
