"""Configuration for inputs."""
from libqtile.backend.wayland import InputConfig

wl_input_rules = {
    "type:keyboard": InputConfig(kb_options="compose:menu"),
    "type:touchpad": InputConfig(
        natural_scroll=True, middle_emulation=True, click_method="clickfinger"
    ),
}
