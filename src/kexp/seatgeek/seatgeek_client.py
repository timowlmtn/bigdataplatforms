#!/usr/bin/env python3
import argparse
import os
import json
import requests  # Contains methods used to make HTTP requests
import subprocess
from requests.auth import HTTPBasicAuth


def get_resource(sg_client, resource, latitude, longitude, geoip):
    url = f"https://api.seatgeek.com/2/{resource}"

    if latitude and longitude:
        url += f"?lat={latitude}&lon={longitude}"
    elif geoip:
        url += f"?geoip={geoip}"

    result = requests.get(url, auth=sg_client)
    if result.status_code == 200:
        result = json.dumps(json.loads(result.text), indent=2)
    else:
        print(url)
        print(f"ERROR {result.status_code}: {result.text}")

    return result


def main():
    parser = argparse.ArgumentParser(
        prog='seatgeek_client.py',
        description='Acts a client to the Seatgeek API',
        epilog='See: https://platform.seatgeek.com/')

    parser.add_argument("--get", default="events", help="The resource endpoint to get")

    parser.add_argument("--latitude", help="An optional latitude")
    parser.add_argument("--longitude", help="An optional longitude")

    parser.add_argument("--geoip", action='store_true', help="The current IP to be geolocated")

    args = parser.parse_args()

    if os.getenv("seatgeek_client_id") is None or os.getenv("seatgeek_secret") is None:
        result = "Usage: seatgeek_client.py --<type> with  seatgeek_client_id:seatgeek_secret variables "
    else:
        ip_add = None
        if args.geoip:
            # , "TXT", "+short", "o-o.myaddr.l.google.com", "@ns1.google.com"
            dig_run = subprocess.run(["/usr/bin/dig",
                                      "-4", "TXT", "+short", "o-o.myaddr.l.google.com", "@ns1.google.com"],
                                     stdout=subprocess.PIPE)
            ip_add = dig_run.stdout.decode('utf-8').replace("\"", "").strip()

        result = get_resource(HTTPBasicAuth(os.getenv("seatgeek_client_id"), os.getenv("seatgeek_secret")),
                              resource=args.get,
                              latitude=args.latitude,
                              longitude=args.longitude,
                              geoip=ip_add)

    print(result)


if __name__ == "__main__":
    main()
