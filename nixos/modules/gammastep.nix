{ pkgs, ... }: {
  home.packages = [ pkgs.gammastep ];

  xdg.configFile."gammastep/config.ini".text = ''
    ; Global settings
    [general]
    ; Set the day and night screen temperatures
    temp-day=4000
    temp-night=1500

    ; Disable the smooth fade between temperatures when Redshift starts and stops.
    ; 0 will cause an immediate change between screen temperatures.
    ; 1 will gradually apply the new screen temperature over a couple of seconds.
    fade=1

    ; Solar elevation thresholds.
    ; By default, Redshift will use the current elevation of the sun to determine
    ; whether it is daytime, night or in transition (dawn/dusk). When the sun is
    ; above the degrees specified with elevation-high it is considered daytime and
    ; below elevation-low it is considered night.
    ;elevation-high=3
    ;elevation-low=-6

    ; Custom dawn/dusk intervals.
    ; Instead of using the solar elevation, the time intervals of dawn and dusk
    ; can be specified manually. The times must be specified as HH:MM in 24-hour
    ; format.
    ;dawn-time=6:00-7:45
    ;dusk-time=18:35-20:15

    ; Set the screen brightness. Default is 1.0.
    ;brightness=0.9
    ; It is also possible to use different settings for day and night
    ; since version 1.8.
    ;brightness-day=0.7
    ;brightness-night=0.4
    ; Set the screen gamma (for all colors, or each color channel
    ; individually)
    gamma=0.8
    ;gamma=0.8:0.7:0.8
    ; This can also be set individually for day and night since
    ; version 1.10.
    ;gamma-day=0.8:0.7:0.8
    ;gamma-night=0.6

    ; Set the location-provider: 'geoclue2', 'manual'.
    ; The location provider settings are in a different section.
    location-provider=manual

    ; Set the adjustment-method: 'randr', 'vidmode', 'drm', 'wayland'.
    ; 'randr' is the preferred X11 method, 'vidmode' is an older API
    ; that works in some cases when 'randr' does not.
    ; The adjustment method settings are in a different section.
    adjustment-method=wayland

    ; Configuration of the location-provider:
    ; type 'gammastep -l PROVIDER:help' to see the settings.
    ; ex: 'gammastep -l manual:help'
    ; Keep in mind that longitudes west of Greenwich (e.g. the Americas)
    ; are negative numbers.
    [manual]
    lat=38.6
    lon=-9.1
  '';
}