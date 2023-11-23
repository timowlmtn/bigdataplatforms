#!/usr/bin/env python3
import argparse
import os
import json
import requests  # Contains methods used to make HTTP requests
import subprocess
from requests.auth import HTTPBasicAuth


def get_resource(sg_client, resource, geoip, args):
    url = f"https://api.seatgeek.com/2/{resource}?"

    if args.latitude and args.longitude:
        url += f"lat={args.latitude}&lon={args.longitude}"
    elif geoip:
        url += f"geoip={geoip}"
        if args.range:
            url += f"&range={args.range}"

    if args.type:
        url += f"&type={args.type}"

    if args.performers:
        url += f"&q={args.performers}"

    if args.debug:
        result = f"URL: {url}"
    else:

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

    parser.add_argument("--debug", action='store_true', help="Do not run the query, just print the URL")

    parser.add_argument("--geoip", action='store_true', help="The current IP to be geolocated")
    parser.add_argument("--range", help="A range to include if specified")

    parser.add_argument("--type", help="Type of event: concert or theatre for example")

    parser.add_argument("--performers", help="The performers of the event")

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
                              geoip=ip_add,
                              args=args)

    print(result)


if __name__ == "__main__":
    main()
