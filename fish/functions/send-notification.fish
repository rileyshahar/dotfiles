function system-notification -a body title subtitle -d "Send a system notification"
    set -q subtitle[0]; or set subtitle ""
    send-notification.js $body $title $subtitle
end
