default: seatgeek-events

seatgeek-events:
	curl https://api.seatgeek.com/2/events -u "$(sg_kexp_client_id)":"$(sg_kexp_secret)"

seatgeek-events-ri:
	curl https://api.seatgeek.com/2/events?venue.state=RI -u "$(sg_kexp_client_id)":"$(sg_kexp_secret)"

seatgeek-event-id:
	curl https://api.seatgeek.com/2/events/6233694 -u "$(sg_kexp_client_id)":"$(sg_kexp_secret)"

seatgeek-venues:
	curl https://api.seatgeek.com/2/venues?venue.state -u "$(sg_kexp_client_id)":"$(sg_kexp_secret)"
