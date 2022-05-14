# Overview

The files in this folder populate a Public Tableau Dashboard with the shows
and playlists of the KEXP Radio station.

It relies on an AWS Pipeline that downloads the data into an
S3 bucket that we then load into Snowflake

## AWS Steps

The AWS Pipeline utilizes the Cloud Formation code in aws_layers to create
a step function that extracts data from the KEXP API and stores it in S3 for loading.

It runs as a scheduled job in Step Functions.

## Makefile Steps

The Default Makefile Target executes the following Steps

1. Run SQL to COPY the data from S3 into Snowflake
2. Run SQL to COPY the joined data into S3
3. Run scripts to synchornize the data from S3 to the local file system
4. Run Concatenate and Compress the Script for Uploading to Tableau

## Manual Steps

We manually load the following Tableau Dashboard and replace the existing 
data source with the output of the playlist.

https://public.tableau.com/app/profile/timothy.burns/viz/KEXPDJFavorites/DJFavorites_1#1

