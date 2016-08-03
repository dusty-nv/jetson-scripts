#!/bin/bash

# note:  to remove online search (wikipedia, amazon, ect.)
#        go to 'Security & Privacy' settings -> Search tab
#        and disable Online search

gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', \
    'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', \
    'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

sudo apt-get remove --purge unity-lens-friends
sudo apt-get remove --purge unity-lens-music
sudo apt-get remove --purge unity-lens-music
sudo apt-get remove --purge unity-lens-photos
sudo apt-get remove --purge unity-lens-video

sudo apt-get remove --purge unity-scope-audacious
sudo apt-get remove --purge unity-scope-calculator
sudo apt-get remove --purge unity-scope-chromiumbookmarks
sudo apt-get remove --purge unity-scope-clementine
sudo apt-get remove --purge unity-scope-colourlovers
sudo apt-get remove --purge unity-scope-devhelp
sudo apt-get remove --purge unity-scope-firefoxbookmarks
sudo apt-get remove --purge unity-scope-gdrive
sudo apt-get remove --purge unity-scope-gmusicbrowser
sudo apt-get remove --purge unity-scope-gourmet
sudo apt-get remove --purge unity-scope-guayadeque
sudo apt-get remove --purge unity-scope-manpages
sudo apt-get remove --purge unity-scope-musicstores
sudo apt-get remove --purge unity-scope-musique
sudo apt-get remove --purge unity-scope-openclipart
sudo apt-get remove --purge unity-scope-exdoc
sudo apt-get remove --purge unity-scope-tomboy
sudo apt-get remove --purge unity-scope-video-remote
sudo apt-get remove --purge unity-scope-virtualbox
sudo apt-get remove --purge unity-scope-yelp
sudo apt-get remove --purge unity-scope-zotero

