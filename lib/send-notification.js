#!/usr/bin/env osascript -l JavaScript
//! Sends a system notification.
//! First console arg is the body, second is the title, third is the subtitle.

function run(argv) {
        var app = Application.currentApplication();

        app.includeStandardAdditions = true;

        app.displayNotification(argv[0], {
                withTitle: argv[1],
                subtitle: argv[2],
        });
};
