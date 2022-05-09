import csv
import json
import argparse

def make_json(csv_path, json_path):
    """
    Function to take the Tab separated Data Dictionary and turn into a JSON Data Dictionary

    :param csv_path:
    :param json_path:
    :return:
    """

    # create a dictionary
    data = {}

    # Open a csv reader called DictReader
    with open(csv_path, encoding='utf-8') as csvf:
        csv_reader = csv.reader(csvf, delimiter="|")

        # Convert each row into a dictionary
        # and add it to data

        header = next(csv_reader)

        print(header)
        current_header = None

        for row in csv_reader:
            print(row)

            if len(row) == 1:
                current_header = row[0]
                data[current_header] = []
            elif len(row) == len(header):
                row_dict = {}
                for i in range(0, len(row)-1):
                    row_dict[header[i]] = row[i]
                data[current_header].append(row_dict)

            else:
                exit(f"Bad row {row} {len(row)} {len(header)}")

    # Open a json writer, and use the json.dumps()
    # function to dump data
    with open(json_path, 'w', encoding='utf-8') as jsonf:
        jsonf.write(json.dumps(data, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Input the parameters")
    parser.add_argument("--in_csv", help="Input CSV", default=None)
    parser.add_argument("--out_json", help="Output CSV", default=None)

    args = parser.parse_args()

    make_json(args.in_csv, args.out_json)