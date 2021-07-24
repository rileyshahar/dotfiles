import subprocess
from kittens.tui.handler import result_handler


def main(args) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    # putting the id in the format looks good, but you also need to do it like this so
    # we can get the id back afterwards
    tabs = "\n".join(map(lambda tab: f"{tab.id}:{tab.title}", boss.all_tabs))
    chosen = subprocess.check_output(
        f"echo '{tabs}' | rofi -dmenu", shell=True, text=True
    )
    chosen_id = int(str.split(chosen, ":")[0])
    for tab in boss.all_tabs:
        if tab.id == chosen_id:
            boss.set_active_tab(tab)
            break
