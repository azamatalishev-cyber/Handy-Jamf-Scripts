#!/bin/bash

defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Causes Finder to be restarted. Finder windows that were open will re-open automatically
killall Finder
