import csv
import json

from robot.api.deco import keyword


@keyword('Convert CSV data to JSON')
def csv_to_json(csv_path):
    json_array = []

    with open(str(csv_path), encoding='utf-8') as csv_file:
        # load csv file data using csv library's dictionary reader
        csv_reader = csv.DictReader(csv_file)

        # convert each csv row into python dict
        for row in csv_reader:
            # add this python dict to json array
            json_array.append(row)

    return json_array


@keyword('Get data from JSON file')
def get_data_from_json_file(json_file):
    with open(json_file) as json_file:
        data = json.load(json_file)
    return data
