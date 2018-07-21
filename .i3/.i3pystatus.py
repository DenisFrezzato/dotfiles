from i3pystatus import Status, backlight

status = Status()

status.register("clock", format=" %a %-d %b  %X")

status.register("backlight",
    format=" {percentage:.0f}%",
    interval=1,
    backlight="intel_backlight"
)

status.register("pulseaudio",
    format_muted='',
    format=" {volume}%"
)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load")

status.register("mem", format=" {percent_used_mem}%")

status.register("cpu_usage_graph",
    format="  {usage:02}% {cpu_graph}",
    graph_width=8
)

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp", format="{temp:.0f}°C")

# LAN network
status.register("network",
    interface="enp4s0f1",
    format_up="",
    format_down=""
)

# WiFi network
status.register("network",
    interface="wlp3s0",
    format_up="  {essid}",
    format_down="",
    on_leftclick="nmcli radio wifi on",
    on_rightclick="nmcli radio wifi off",
)

# This would look like this:
# Discharging 6h:51m
status.register("battery",
    format="{remaining:%E%hh:%Mm}",
    alert=False,
)

status.register("battery",
    format="{status} {percentage:.0f}%",
    alert=True,
    alert_percentage=10,
    status={
        "DIS": " ",
        "CHR": " ",
        "FULL": "  ",
    },
)

status.register("keyboard_locks", format="{caps} {num}")

status.register("now_playing", format="{status} {artist} - {album} - {title}")

status.run()
