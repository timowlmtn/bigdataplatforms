default: get-team-season-stats

mkdirs:
	mkdir -p ../../data/raw/mlb/2021/
	mkdir -p ../../data/raw/mlb/2022/
	mkdir -p ../../data/raw/mlb/2023/


get-team-season-stats: mkdirs
	python python/api_sportsdata.py --year 2021 --endpoint TeamSeasonStats \
		| tee ../../data/raw/mlb/2021/TeamSeasonStats.json
	python python/api_sportsdata.py --year 2022 --endpoint TeamSeasonStats \
		| tee ../../data/raw/mlb/2022/TeamSeasonStats.json
	python python/api_sportsdata.py --year 2023 --endpoint TeamSeasonStats \
 		| tee ../../data/raw/mlb/2023/TeamSeasonStats.json

