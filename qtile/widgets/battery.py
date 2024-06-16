"""A custom battery widget."""

from libqtile.widget.battery import Battery, BatteryState, BatteryStatus


class MyBattery(Battery):
    """A custom battery subclass."""

    def build_string(self, status: BatteryStatus) -> str:
        """Build the display string."""
        if self.layout is not None:
            if (
                status.state == BatteryState.DISCHARGING
                and status.percent < self.low_percentage
            ):
                self.layout.colour = self.low_foreground
            else:
                self.layout.colour = self.foreground

        match status.state:
            case BatteryState.DISCHARGING | BatteryState.NOT_CHARGING:
                if status.percent > 0.8:
                    char = " "
                elif status.percent > 0.6:
                    char = " "
                elif status.percent > 0.4:
                    char = " "
                elif status.percent > 0.2:
                    char = " "
                else:
                    char = " "

            case BatteryState.FULL:
                char = " "

            case BatteryState.EMPTY:
                char = " "

            case BatteryState.CHARGING:
                char = ""

            case BatteryState.UNKNOWN:
                char = "-"

        return self.format.format(char=char, percent=status.percent)  # type: ignore
