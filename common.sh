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
# Common functions for scripts
# Author: Ondrej Kulaty (rubick)
#

# Color definitions
COLOR_BLUE="\e[1;34m"
COLOR_GRAY="\e[1;30m"
COLOR_RED="\e[1;31m"
COLOR_GREEN="\e[1;32m" 
COLOR_YELLOW="\e[1;93m"
COLOR_RESET="\e[0m"

# generic message prepended with program name
echo_message() {
    echo -e "${COLOR_BLUE}$(basename ${0})${COLOR_RESET}: $@"
}

# Same as message but prints to stderr and in red
echo_err() {
	echo_message "${COLOR_RED}ERROR: $@${COLOR_RESET}" 1>&2
}

echo_warn() {
	echo_message "${COLOR_YELLOW}WARNING: $@${COLOR_RESET}" 1>&2
}

# echo higlighted text, suitable for questions for user
echo_highlight() {
	echo -e "${COLOR_GREEN}$@${COLOR_RESET}"
}
