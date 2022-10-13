*** Settings ***
Documentation   This tests the functions associated with the roles of the bookkeeper
Library     RequestsLibrary
Library     JSONLibrary
Library     OperatingSystem
Library     ./../../libraries/id_mask_validator.py
Resource    ./../../resources/common.robot
Test Setup  common.Rake database

*** Variables ***
${get_response_schema}      ${EXECDIR}\\test_data\\json_schema.json
${multiple_entries_json}    ${EXECDIR}\\test_data\\multiple_entries.json


*** Test Cases ***
Get list of taxpayers via API
    [Documentation]     Retrieves a list of taxpayers consists of natid, tax relief amount and name
    [Tags]      Acceptance
    ${relief_list}=    common.Add multiple data to system   ${multiple_entries_json}
    ${response}=    GET     ${get_tax_relief_url}
    Status Should Be    200
    ${response_json}   Evaluate    json.loads('''${response.text}''')    json
    Validate Json By Schema File   ${response_json}    ${get_response_schema}
    Verify contents of tax relief list  ${response_json}    ${relief_list}


*** Keywords ***
Verify contents of tax relief list
    [Arguments]     ${json_data}    ${expected_relief_list}
    ${masked_nat_id}=   id_mask_validator.Validate nat ID masking     ${json_data}
    Should Be True   ${masked_nat_id}
    Log To Console    ${json_data}
    Log To Console    ${expected_relief_list}
    Lists Should Be Equal    ${json_data}    ${expected_relief_list}







