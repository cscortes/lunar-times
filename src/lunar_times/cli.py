import argparse
import datetime
import requests
import pytz
from typing import Dict, Any, Tuple
from geopy.geocoders import Nominatim
from timezonefinder import TimezoneFinder

# API endpoint URL
url = "https://aa.usno.navy.mil/api/rstt/oneday"


# Search for coordinates using GeoPy
def find_latlong(city: str, state: str) -> Tuple[float, float]:
    """
    Find the latitude and longitude coordinates for a given city and state.

    Args:
        city (str): City name.
        state (str): State name or abbreviation.

    Returns:
        tuple: (latitude, longitude) coordinates.

    Raises:
        ValueError: If the city and state cannot be found.
    """
    geolocator = Nominatim(user_agent="lunar_times_app")
    location = geolocator.geocode(f"{city}, {state}")
    if location is None:
        raise ValueError(f"Could not find coordinates for {city}, {state}")

    # Safe attribute access for type checker compatibility
    latitude = getattr(location, "latitude", None)
    longitude = getattr(location, "longitude", None)
    if latitude is None or longitude is None:
        raise ValueError(f"Invalid location data for {city}, {state}")
    return latitude, longitude


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    """
    Parse command-line arguments.

    Args:
        argv: Arguments to parse, excluding the program name. When omitted,
            argparse reads sys.argv.

    Returns:
        Parsed arguments. The debug flag is true when -d or --debug is set.
    """
    parser = argparse.ArgumentParser(
        prog="lunar-times",
        description=(
            "Calculate moonrise and moonset times for a city and state."
        ),
        epilog=(
            "examples:\n"
            "  lunar-times\n"
            "  lunar-times --debug\n"
            "  lunar-times -h"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "-d",
        "--debug",
        action="store_true",
        help="skip the prompts and use El Paso, TX",
    )
    return parser.parse_args(argv)


# Get city and state from the user
def get_citystate(debug: bool = False) -> Tuple[str, str]:
    """
    Get city and state from user input.

    Args:
        debug: When true, skip the prompts and use El Paso, TX.

    Returns:
        tuple: (city, state)
    """
    if debug:
        city = "El Paso"
        state = "tx"
    else:
        city = input("Enter the city: ")
        state = input("Enter the state: ")

    city = city.title().strip()
    state = state.upper().strip()
    return city, state


def get_timezone(latitude: float, longitude: float) -> Tuple[str, float]:
    """
    Find the timezone and offset for a given latitude and longitude.

    Args:
        latitude (float): Latitude of the location.
        longitude (float): Longitude of the location.

    Returns:
        tuple: (tz_label, offset) where tz_label is the timezone string
          (e.g. "America/New_York"), and offset is the number of hours
          offset from UTC.

    Raises:
        pytz.UnknownTimeZoneError: If the timezone cannot be found.
    """
    tz_finder = TimezoneFinder()
    tz_label = tz_finder.timezone_at(lng=longitude, lat=latitude)
    if tz_label is None:
        raise ValueError(f"No timezone found for {latitude}, {longitude}")
    tz = pytz.timezone(tz_label)
    offset = tz.utcoffset(datetime.datetime.now()).total_seconds() / 3600
    return tz_label, offset


def find_moon_data(data: Dict[str, Any]) -> Tuple[str, str]:
    """
    Find the moonrise and moonset times from the given moon data.

    Args:
        data (dict): The moon data returned from the API.

    Returns:
        tuple: (moonrise, moonset) where moonrise and moonset are the
          respective times of the moonrise and moonset, or "N/A" if the
          information is not available.
    """
    moonrise = "N/A"
    moonset = "N/A"
    for item in data["properties"]["data"]["moondata"]:
        if item["phen"] == "Rise":
            time_str = item["time"]
            moonrise = datetime.datetime.strptime(time_str, "%H:%M").strftime(
                "%I:%M %p"
            )
        elif item["phen"] == "Set":
            time_str = item["time"]
            moonset = datetime.datetime.strptime(time_str, "%H:%M").strftime(
                "%I:%M %p"
            )
    return moonrise, moonset


def print_moon_data(
    today: str,
    tz_label: str,
    offset: float,
    moonrise: str,
    moonset: str,
    debug: bool = False,
) -> None:
    """
    Print the moonrise and moonset times for a specific date and location.

    Args:
        today (str): The current date in 'YYYY-MM-DD' format.
        tz_label (str): The timezone label (e.g. "America/New_York").
        offset (float): The timezone offset from UTC in hours.
        moonrise (str): The moonrise time in 'hh:mm AM/PM' format or "N/A".
        moonset (str): The moonset time in 'hh:mm AM/PM' format or "N/A".
        debug: When true, note that the location defaulted to El Paso, TX.
    """
    if debug:
        print("Running in debug mode. Defaulting to city (El Paso, TX)")
    offset_sign = "+" if offset >= 0 else "-"
    print(
        f"# Moon rise/set times in (Timezone: {tz_label} "
        f"{offset_sign}{abs(offset)}) on {today}: "
    )
    print(f"- RISE: {moonrise}")
    print(f"- SET: {moonset}")


def main(argv: list[str] | None = None) -> None:
    """
    Main entry point for the program.

    This function retrieves the city and state from the user, finds the
    latitude and longitude coordinates, and gets the timezone and offset.
    It then sends a request to the USNO API to retrieve the moon data and
    prints the moonrise and moonset times for the given date and location.

    Args:
        argv: Arguments to parse, excluding the program name. When omitted,
            argparse reads sys.argv. -h and --help print usage and exit.
            -d and --debug use El Paso, TX instead of prompting.

    Raises:
        ConnectionError: If the request to the API fails.
    """
    args = parse_args(argv)
    city, state = get_citystate(debug=args.debug)
    latitude, longitude = find_latlong(city, state)
    today = datetime.date.today().strftime("%Y-%m-%d")
    tz_label, offset = get_timezone(latitude, longitude)

    # Define parameters
    params = {
        "date": today,
        "coords": f"{latitude: .2f}, {longitude: .2f}",
        "tz": str(offset),
        "dst": "false",
    }

    # Send the request and get the response
    response = requests.get(url, params=params)
    # Check for errors
    if response.status_code != 200:
        raise ConnectionError(
            f"Failed to retrieve moon data. "
            f"Status code: {response.status_code}"
        )

    # Parse the JSON data
    data = response.json()
    moonrise, moonset = find_moon_data(data)

    print_moon_data(
        today, tz_label, offset, moonrise, moonset, debug=args.debug
    )


if __name__ == "__main__":
    main()
