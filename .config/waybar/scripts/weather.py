#!/usr/bin/python3

from pyquery import PyQuery  # install using `pip install pyquery`
import json
import requests
import sys


################################### CONFIGURATION ###################################

# set your location_id
# to get your location_id, go to https://weather.com & search for your location.
# once you choose your location, you can see the location_id in the URL(64 chars long hex string)
# like this: https://weather.com/en-IN/weather/today/l/c3e96d6cc4965fc54f88296b54449571c4107c73b9638c16aafc83575b4ddf2e
# once you get the location_id, you can replace the below location_id with your own location_id
location_id = "d1fadc30a5ffab62024fe30c615ce8beb58aa5e72af731a0f2181ae43085285a"  # TODO

# celcius or fahrenheit
unit = "metric"  # metric or imperial

# forcase type
forecast_type = "Daily" # Hourly or Daily

########################################## MAIN ##################################

# weather icons
weather_icons = {
    "sunnyDay": "滛",
    "clearNight": "望",
    "cloudyFoggyDay": "",
    "cloudyFoggyNight": "",
    "rainyDay": "",
    "rainyNight": "",
    "snowyIcyDay": "",
    "snowyIcyNight": "",
    "severe": "",
    "default": "",
}

# get html page using a browser-like User-Agent to avoid blocking
_l = "en-IN" if unit == "metric" else "en-US"
url = f"https://weather.com/{_l}/weather/today/l/{location_id}"

headers = {
    "User-Agent": (
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko)"
        " Chrome/114.0.0.0 Safari/537.36"
    )
}
try:
    resp = requests.get(url, headers=headers, timeout=10)
    resp.raise_for_status()
    html_data = PyQuery(resp.text)
except Exception:
    # fail gracefully with placeholders so Waybar doesn't crash
    html_data = PyQuery("")
    print(json.dumps({
        "text": "   --",
        "alt": "Unable to fetch weather",
        "tooltip": "Could not load weather data",
        "class": "default",
    }))
    sys.exit(0)

def safe_text(q, selector, idx=0, default="--"):
    el = q(selector)
    if not el:
        return default
    try:
        txt = el.eq(idx).text()
        return txt if txt else default
    except Exception:
        return default

# current temperature
temp = safe_text(html_data, "span[data-testid='TemperatureValue']", 0)

# current status phrase
status = safe_text(html_data, "div[data-testid='wxPhrase']", 0, default="")
status = f"{status[:16]}.." if len(status) > 17 else status

# status code
# status_code_class might be missing; get attribute safely
status_code_class = html_data("#regionHeader").attr("class")
# try to extract a meaningful status code from the class attribute
# fall back to "default" if the expected tokens are missing
status_code = "default"
try:
    if status_code_class:
        parts = str(status_code_class).split()
        if len(parts) >= 3:
            subparts = parts[2].split("-")
            # prefer the 3rd segment if present, otherwise use the last segment
            status_code = subparts[2] if len(subparts) >= 3 else subparts[-1]
        else:
            status_code = parts[-1] if parts else "default"
except Exception:
    status_code = "default"

# status icon: try mapping by exact code, otherwise guess from status phrase
if status_code in weather_icons:
    icon = weather_icons[status_code]
else:
    s = status.lower() if status else ""
    if "clear" in s or "sun" in s or "fair" in s:
        icon = weather_icons.get("sunnyDay", weather_icons["default"])
    elif "cloud" in s or "overcast" in s or "fog" in s:
        icon = weather_icons.get("cloudyFoggyDay", weather_icons["default"])
    elif "rain" in s or "shower" in s or "drizzle" in s:
        icon = weather_icons.get("rainyDay", weather_icons["default"])
    elif "snow" in s or "sleet" in s or "ice" in s:
        icon = weather_icons.get("snowyIcyDay", weather_icons["default"])
    else:
        icon = weather_icons["default"]

# temperature feels like
temp_feel = safe_text(
    html_data,
    "div[data-testid='FeelsLikeSection'] > span > span[data-testid='TemperatureValue']",
    0,
    default="--",
)
temp_feel_text = f"Feels like {temp_feel}{'c' if unit == 'metric' else 'f'}"

# min-max temperature
temp_min = safe_text(
    html_data, "div[data-testid='wxData'] > span[data-testid='TemperatureValue']", 1
)
temp_max = safe_text(
    html_data, "div[data-testid='wxData'] > span[data-testid='TemperatureValue']", 0
)
temp_min_max = f"  {temp_min}\t\t  {temp_max}"

# wind speed
wind_speed = safe_text(html_data, "span[data-testid='Wind']", 0)
wind_text = f"煮  {wind_speed}"

# humidity
humidity = safe_text(html_data, "span[data-testid='PercentageValue']", 0)
humidity_text = f"  {humidity}"

# visibility
visbility = safe_text(html_data, "span[data-testid='VisibilityValue']", 0)
visbility_text = f"  {visbility}"

# air quality index
air_quality_index = safe_text(html_data, "text[data-testid='DonutChartValue']", 0, default="N/A")

# rain prediction
r_prediction_text = safe_text(
    html_data(f"section[aria-label='{forecast_type} Forecast']"),
    "div[data-testid='SegmentPrecipPercentage'] > span",
    0,
    default="",
)
r_prediction = str(r_prediction_text).replace("Chance of Rain", "")
r_prediction = f"    ({forecast_type}) {r_prediction}" if len(r_prediction) > 0 else r_prediction

# temperature prediction
t_prediction_text = safe_text(
    html_data(f"section[aria-label='{forecast_type} Forecast']"),
    "div[data-testid='SegmentHighTemp'] > span",
    0,
    default="",
)
t_prediction = str(t_prediction_text).replace(" /", "/")
t_prediction = f"  滛 ({forecast_type}) {t_prediction}" if len(t_prediction) > 0 else t_prediction

#pretty print all data
# print(f"temp: {temp}\nstatus: {status}\nstatus_code: {status_code}\nicon: {icon}\
#     \ntemp_feel_text: {temp_feel_text}\ntemp_min_max: {temp_min_max}\nwind_text: {wind_text}\
#     \nhumidity_text: {humidity_text}\nvisbility_text: {visbility_text}\nair_quality_index: {air_quality_index}\
#     \nprediction: \n{r_prediction}\n{t_prediction}")

# tooltip text
tooltip_text = str.format(
    "\t\t{}\t\t\n{}\n{}\n{}\n\n{}\n{}\n{}\n\n{}\n{}",
    f'<span size="xx-large">{temp}</span>',
    f"<big>{icon}</big>",
    f"<big>{status}</big>",
    f"<small>{temp_feel_text}</small>",
    f"<big>{temp_min_max}</big>",
    f"{wind_text}\t{humidity_text}",
    f"{visbility_text}\tAQI {air_quality_index}",
    f"<i>{r_prediction}</i>",
    f"<i>{t_prediction}</i>"
)

# print waybar module data
out_data = {
    "text": f"{icon} {temp}",
    "alt": status,
    "tooltip": tooltip_text,
    "class": status_code,
}
print(json.dumps(out_data))
