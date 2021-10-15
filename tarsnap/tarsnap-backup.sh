#!/bin/sh
tarsnap -c                                                   \
	-f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)"          \
        --configfile "$XDG_CONFIG_HOME"/tarsnap/tarsnap.conf \
        /home/riley/notes /home/riley/library /home/riley/private
