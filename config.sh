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

########################################################################
# Configuration options for website GENERATION                         #
########################################################################

# Header file. Its content will be glued to the top of every page.
HEADER_FILE="../input/layout/header.html"

# Footer file. Its content will be glued to the bottom of every page
FOOTER_FILE="../input/layout/footer.html"

# Content of your website in form of *.md or *.html, which can be
# organized in (nested) directories. This directory structure will be
# preserved in generated content.
CONTENT_DIR="../input/content/"

# Static files like images, CSS styles etc. which do not need any
# processing ...
STATIC_FILES_INPUT_DIR="../input/static/"

# ... will be copied here.
STATIC_FILES_OUTPUT_DIR="../output/static/"

# Output directory. Generated website in form of HTML pages will be
# stored here 
OUTPUT_DIR="../output/"

# Base path for all relative links. Set to "/" if your website will
# reside in server's root.
BASE_HREF="/"

# Command for processing *.md files. This command should take
# file with markdown syntax as it's input and output HTML file.
MARKDOWN_COMMAND="marked"

# Command for processing *.html files. Usually simple "cat" command
# is enough as HTML pages do not need further processing.
HTML_COMMAND="cat"

########################################################################
# Configuration options for website PUBLICATION                        #
########################################################################

# URL of your FTP server
FTP_URL="ftp.server.com"

# FTP user
FTP_USER="user"

# FTP password. If empty, FTP_PASS_COMMAND is used instead.
FTP_PASS=""

# FTP password command, i.e. password store command. By using this option you
# don't need to save password in plaintext here, but use command whose standard
# output will be used as password
FTP_PASS_COMMAND="pass mysite.com"

# Path on the remote FTP server where to store your website
FTP_PATH="/www"
