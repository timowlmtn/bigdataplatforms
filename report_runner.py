import argparse
import datetime
import string
import os
import sys


# TODO put this into a separate database connection module
# import _mssql

def apply_template( withSql, mainSql, attributes, metrics, filters, joinSql, debug ):
    with open(mainSql) as sqlFile:
        read_data = sqlFile.read()

    sqlTemplate = string.Template( read_data );

    with open(joinSql) as sqlFile:
        read_data = sqlFile.read()

    joinSql = read_data;

    withSqlData = ""
    if ( withSql ):
        with open(withSql) as sqlWithFile:
            withSqlData = sqlWithFile.read()

    sql = sqlTemplate.substitute( withExpression = withSqlData, attributes = attributes, metrics = metrics, filters = filters, joinSql = joinSql );

    if ( debug ) is 'T':
        print( sql )

    return sql;

def main(argv):

    parser = argparse.ArgumentParser(description='Export database from a SQL database using SQL templates.')
    parser.add_argument('--server',
                        default='localhost',
                        help='Server to connect to')
    parser.add_argument('--database',
                        default='TEST',
                        help='Database to connect to')
    parser.add_argument('--instance',
                        default='',
                        help='Database Instance')
    parser.add_argument('--attributes', default='COLUMN_1, COLUMN_2', help='Column Group by Attributes');
    parser.add_argument('--metrics', default='SUM( AMOUNT ) SUM_AMOUNT', help='Column Metrics');
    parser.add_argument('--filters', default='1 = 1', help='Filters');

    parser.add_argument('--mainSql', default='sql/mainTemplate.sql',
                        help='A SQL template containing the main portion of the SQL to run');
    parser.add_argument('--withSql');
    parser.add_argument('--joinSql', default="tables/joinAandB.sql")
    parser.add_argument('--delimiter', default=',');

    parser.add_argument('--debug', default='F');
    now = datetime.datetime.now();

    parser.add_argument('--outFile', default='out/file' + now.strftime("%Y%m%d_%H%M"));

    args = parser.parse_args()

    sql = apply_template(args.withSql, args.mainSql, args.attributes, args.metrics, args.filters, args.joinSql, args.debug);

    print("{ \"outFile\" : \"" + args.outFile + "\" } ");

if __name__ == "__main__":
    main(sys.argv)

