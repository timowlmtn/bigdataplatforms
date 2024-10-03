import requests
import os
from datetime import datetime, timedelta

# Your Eventbrite API Token
EVENTBRITE_TOKEN = os.getenv('EVENTBRIGHT_PUBLIC_TOKEN')

# Base URL for the Eventbrite API
EVENTBRITE_API_URL = "https://www.eventbriteapi.com/v3/events/search/"


# Function to get events by zip code
def get_events_by_zip(zip_code, start_date, end_date, page_size=50):
    headers = {
        "Authorization": f"Bearer {EVENTBRITE_TOKEN}"
    }

    # Parameters to filter events
    params = {
        'location.address': zip_code,
        'location.within': '10mi',  # Radius of 10 miles from the zip code
        'start_date.range_start': start_date.isoformat() + "Z",
        'start_date.range_end': end_date.isoformat() + "Z",
        'page': 1,
        'page_size': page_size,  # Number of events per page
        'sort_by': 'date'
    }

    response = requests.get(EVENTBRITE_API_URL, headers=headers, params=params)

    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code}, {response.text}")
        return None


# Main function to download events for the next 3 months
def download_events_by_zip(zip_code):
    today = datetime.now()
    three_months_later = today + timedelta(days=90)

    events_data = get_events_by_zip(zip_code, today, three_months_later)

    if events_data:
        events = events_data['events']

        print(f"Found {len(events)} events in the next 3 months for zip code {zip_code}")
        for event in events:
            print(f"Event: {event['name']['text']}, Start: {event['start']['local']}, URL: {event['url']}")
    else:
        print("No events found or there was an error.")


# Example usage
zip_code = '80202'  # Example: Denver, CO
download_events_by_zip(zip_code)
