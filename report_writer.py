import argparse
import datetime
import string
import os
import sys
import json

# TODO put this into a separate database connection module
# import _mssql


def main(argv):
    import argparse, sys

    parser = argparse.ArgumentParser(description='Export database from a SQL database using SQL templates.')

    debug = 'F';
    parser.add_argument('--server',
                        default='localhost',
                        help='Server to connect to')
    parser.add_argument('--database',
                        default='TEST',
                        help='Database to connect to')
    parser.add_argument('--instance',
                        default='',
                        help='Database Instance')
    parser.add_argument('--debug', default='F');
    parser.add_argument('--sqlFile', nargs='?')

    now = datetime.datetime.now();

    parser.add_argument('--outFile', default='out/file' + now.strftime("%Y%m%d_%H%M"));

    args = parser.parse_args()


    if args.sqlFile:
        sqlJson = open(args.sqlFile).read()
    elif not sys.stdin.isatty():
        sqlJson = sys.stdin.read()
    else:
        parser.print_help()

    if ( debug is 'T' ):
        print ( sqlJson )

    print("{ \"outFile\" : \"" + args.outFile + "\" } ");

if __name__ == "__main__":
    main(sys.argv)

