import argparse
import json
import os
import requests


def main():
    # Example for SportsData.io
    api_key = os.getenv('SPORTSDATA_IO_API_KEY')

    parser = argparse.ArgumentParser(
        prog='api_sportsdata.py',
        description='Acts a client to the SportData API',
        epilog='See: https://sportsdata.io/developers/coverages/mlb#/sports-data-feeds')

    parser.add_argument("--endpoint",  default="TeamSeasonStats", help="Endpoint for the API")
    parser.add_argument("--year", default="2023", help="Year for the stats")

    args = parser.parse_args()

    url = f'https://api.sportsdata.io/v3/mlb/stats/json/{args.endpoint}/{args.year}?key={api_key}'

    response = requests.get(url)
    data = json.dumps(response.json(), indent=2, sort_keys=True)

    print(data)


if __name__ == "__main__":
    main()
