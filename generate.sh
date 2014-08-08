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
# GENERATE SCRIPT                                                      #
########################################################################

# This script is used to generate entire website. It does
# following steps:
#
# (1) Clear output directory
# (2) Copy static files (images, css styles etc.)
# (3) Recursively generate HTML files from all files in content directory
#
# The process of generating HTML from an input file is following:
# - create empty output HTML file
# - append layout header
# - append contents of input file (if it's plain HTML) or first
#   transform it with Markdown command to HTML and then append it (if it's Markdown file)
# - append layout footer
# - replace #title# tag with page title
# - replace #lastchange# with modification date of the file
# - replace #basehref# with base href

# make sure this script is invoked from it's directory
if [[ $0 != "./generate.sh" ]]; then
	echo "ERROR: Run this script from it's directory!"
	exit
fi

# load configuration
source config.sh
# load common functions
source common.sh

# get commandline argument
CMDLINE_ARG=$1

echo_highlight "----- Simple BASH CMS -----"

# (1) clear output directory
echo_message "Clearing output directory ${OUTPUT_DIR}"
rm -rf "${OUTPUT_DIR}"*

# (2) copy static files
echo_message "Copying static files to ${STATIC_FILES_OUTPUT_DIR}"
mkdir "${STATIC_FILES_OUTPUT_DIR}"
cp -pr ${STATIC_FILES_FILES_DIR}* ${STATIC_FILES_OUTPUT_DIR} 

# Find title within the file passed as an argument. This function tries to
# search for title in this order: 
#   -> in line beginning with "title:". Example: "title: Home page"
#   -> in <h1> tag. Example: "<h1>Home page</h1>"
#   -> in Markdown tag for H1 header (#). Example: "# Home page #"
find_title() {
        FILE=$1
        # search for title
        # in title:
        TITLE=$(grep -m 1 '^title:' "$FILE" | sed -e 's/title: \{0,1\}//')
        if [ -z "$TITLE" ]; then 
            # in HTML <h1> tag
            TITLE=$(grep -m 1 '<h1>' "$FILE" | sed -e 's/<h1>\([^<]*\)<\/h1>/\1/')
        fi
        if [ -z "$TITLE" ]; then
            # in Markdown # tag
            TITLE=$(grep -m 1 '^# ' "$FILE" | sed -e 's/^# *//' -e 's/ *#$//')
        fi
        # fix ampersand sign so sed won't interpret it
        TITLE=$(echo "$TITLE" | sed 's/&/\\\&/')

        # trim title
        TITLE=$(echo "$TITLE" | sed -e 's/^ *//' -e 's/ *$//')

        echo "$TITLE"
}

# Recursively transform files in directory given as argument and copy them to
# output dir, preserving directory structure
transform() {
    
    TARGET_DIR=${1/$CONTENT_DIR/$OUTPUT_DIR}

    # create directory if not exists
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir "$TARGET_DIR"
    fi

    # Transform files in current directory
    for i in "${1}"*.{md,html}; do
        # check if we have regular file
        [ -e "$i" ] || continue 
        
        # transform
        TARGET_FILE=${i/$1/$TARGET_DIR}
        TARGET_FILE=${TARGET_FILE/%md/html}
        
        # add header
        cat "${HEADER_FILE}" >> "${TARGET_FILE}"

        # transform and add content
        PATTERN="\.md"
        if [[ $i =~ $PATTERN ]]; then
            echo -e "${COLOR_GRAY}MARKDOWN:${COLOR_RESET} $i -> $TARGET_FILE"
            $MARKDOWN_COMMAND "${i}" >> "${TARGET_FILE}"
        else
            echo -e "${COLOR_GRAY}HTML:${COLOR_RESET} $i -> $TARGET_FILE"
            $HTML_COMMAND "${i}" >> "${TARGET_FILE}"
        fi
        
        # add footer
        cat "${FOOTER_FILE}" >> ${TARGET_FILE}

        # add title
        TITLE=$(find_title $i) 
        if [ -z "$TITLE" ]; then
            # title NOT FOUND!
            TITLE="UNKNOWN TITLE"
            echo -e "\e[1;31m Failed to find title in $i \e[0m" 1>&2
        fi
        sed -i "0,/#title#/{s/#title#/$TITLE/}" "$TARGET_FILE"
        
        # add modification date
        LASTCHANGE=$(stat -c "%Y" "$i")
        LASTCHANGE=$(date -d @$LASTCHANGE "+%c")
        sed -i "s/#lastchange#/$LASTCHANGE/" "$TARGET_FILE"

        # add base href
        if [[ "$CMDLINE_ARG" == "local" ]]; then
            BASE_HREF="file://$(pwd)/output/"
        fi
        #echo "$1 so base hfer is $BASE_HREF"
        sed -i "0,/#basehref#/{s;#basehref#;$BASE_HREF;}" "$TARGET_FILE"

    done

    # do the same for all subdirectories
    for i in "${1}"*; do
        #check if we have directory
        [ -d "$i" ] || continue 
        #do not process . and ..
        [[ "$i" != "." && "$i" != ".." ]] || continue
        transform "$i/"
    done

}

# (3) transform 
echo_message "Generating HTML pages..."
transform "$CONTENT_DIR" 
echo_message "Done!"
