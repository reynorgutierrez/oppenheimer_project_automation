# Oppenheimer Project Test Automation
This is the test automation for the Oppenheimer Project using robot framework.

## Environment Setup
1. Prepare application to test
2. Application URL `APP_URL` in variables.py is set to correct URL

## Pre-requisites
* Install google chrome
* Python 3.10
* Dependencies installed `pip install -r requirements.txt`
* Chrome web driver added to path environment variable.

## How to run the functional tests

#### Running a single test
`python -m robot -d results .\test_suites\functional\<test_name>.robot`
#### Running the whole test suites
`python -m robot -d results .\test_suites\functional\`
#### Running the test by tags
`python -m robot -d results -i <tag_name> .\test_suites\functional\`

## How to run the load test
1. Run the command `locust --locustfile .\test_suites\load\locustfile.py`
2. Launch a browser then go to http://localhost:8089
3. Click [Start swarming]