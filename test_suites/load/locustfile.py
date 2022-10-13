from locust import HttpUser, task, between, LoadTestShape, events
from datetime import datetime
import json
import config
import csv


def get_json_data(json_file_path):
    with open(json_file_path) as file:
        data = json.load(file)
    return data


class TestStages(LoadTestShape):
    stages = [
        {"duration": 180, "users": 2, "spawn_rate": 2},
        {"duration": 360, "users": 4, "spawn_rate": 2},
        {"duration": 540, "users": 6, "spawn_rate": 2},
        {"duration": 720, "users": 8, "spawn_rate": 2},
        {"duration": 1980, "users": 10, "spawn_rate": 2},
        {"duration": 2160, "users": 8, "spawn_rate": 2},
        {"duration": 2340, "users": 6, "spawn_rate": 2},
        {"duration": 2520, "users": 4, "spawn_rate": 2},
        {"duration": 2700, "users": 2, "spawn_rate": 2}
    ]

    def tick(self):
        run_time = self.get_run_time()

        for stage in self.stages:
            if run_time < stage["duration"]:
                tick_data = (stage["users"], stage["spawn_rate"])
                return tick_data
        return None


class LocustTest(HttpUser):
    host = config.APP_URL
    wait_time = between(1, 5)

    def __init__(self, parent):
        super().__init__(parent)
        self.rake_database = config.rake_database
        self.single_json_path = config.single_json
        self.single_json = ""
        self.multiple_json_path = config.multiple_json
        self.multiple_json = ""

    def on_start(self):
        self.client.post(self.rake_database)  # Needs improvement. This is executed twice if placed here.
        self.single_json = get_json_data(self.single_json_path)
        self.multiple_json = get_json_data(self.multiple_json_path)

    @task(10)
    def add_single_entry(self):
        response = self.client.post(config.add_single_entry, name="Add single entry",
                                    headers={"content-type": "application/json"}, json=self.single_json)
        print(f"Add single entry: {response.status_code}")

    @task(5)
    def add_multiple_entries(self):
        response = self.client.post(config.add_multiple_entries, name="Add multiple entries",
                                    headers={"content-type": "application/json"}, json=self.multiple_json)
        print(f"Add multiple entries: {response.status_code}")

    @task(1)
    def get_tax_relief(self):
        response = self.client.get(config.get_tax_relief)
        print(f"Get tax relief list: {response.status_code}")

    filename = "results\\locust_test.csv"
    field_names = ['REQUEST_TYPE', 'ENDPOINT', 'RESPONSE_TIME', 'RESPONSE_LENGTH', 'RESPONSE', 'CONTEXT', 'EXCEPTION',
                   'TIMESTAMP']
    with open(filename, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(field_names)

    @events.request.add_listener
    def hook_request_success(self, request_type, name, response_time, response_length, response, context, exception):
        timestamp = datetime.now().strftime('%H:%M:%S %p')
        file = "results\\locust_test.csv"
        field_names = ['REQUEST_TYPE', 'ENDPOINT', 'RESPONSE_TIME', 'RESPONSE_LENGTH', 'RESPONSE', 'CONTEXT',
                       'EXCEPTION', 'TIMESTAMP']
        with open(file, 'a', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=field_names)
            writer.writerow({'REQUEST_TYPE': request_type, 'ENDPOINT': name, 'RESPONSE_TIME': response_time,
                             'RESPONSE_LENGTH': response_length, 'RESPONSE': response, 'CONTEXT': context,
                             'EXCEPTION': exception, 'TIMESTAMP': timestamp})
            f.close()
