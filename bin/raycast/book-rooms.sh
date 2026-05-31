#!/opt/homebrew/bin/fish

# @raycast.schemaVersion 1
# @raycast.title Book Rooms
# @raycast.mode silent
# @raycast.packageName Custom
# @raycast.argument1 { "type": "dropdown", "placeholder": "Room", "data": [{"title": "Lippincott 247", "value": "https://libcal.library.upenn.edu/space/17625"}, {"title": "Lippincott 251", "value": "https://libcal.library.upenn.edu/reserve/seminar-group/vitale"}, {"title": "Lippincott 242", "value": "https://libcal.library.upenn.edu/space/16998"}, {"title": "Albrecht 452.1", "value": "https://libcal.library.upenn.edu/space/24031"}] }

open $argv[1]
