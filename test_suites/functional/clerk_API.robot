*** Settings ***
Documentation   This tests the functions associated with the role/s of the clerk  using the API
Library     RequestsLibrary
Library     Collections
Library     SeleniumLibrary
Library     OperatingSystem
Resource    ./../../resources/common.robot
Variables   ./../../resources/variables.py
Test Setup  common.Rake database

*** Variables ***
${upload_files_path}    ${EXECDIR}\\test_data\\

*** Test Cases ***
Add single valid json data to the database via API
    [Tags]  Acceptance
    [Template]  Add single entry to database via API and verify in UI
    ${upload_files_path}\\single_entry.json     202     success     ${EMPTY}

Add single invalid json data to the database via API
    [Tags]  Acceptance
    [Template]  Add single entry to database via API and verify in UI
    ${upload_files_path}\\single_invalid.json   500     error   ${EMPTY}

Add single existing data to the database via API
    [Tags]  Acceptance
    [Template]  Add single entry to database via API and verify in UI
    ${upload_files_path}\\single_entry.json     202     success     existing

Add single invalid data to the database via API
    [Tags]  Acceptance
    [Template]  Add single entry to database via API and verify in UI
    ${upload_files_path}\\text_file.txt     400     error   ${EMPTY}

Add multiple valid json data to the database via API
    [Tags]  Acceptance
    [Template]  Add multiple entries to database via API and verify in UI
    ${upload_files_path}\\multiple_entries.json     202     success     ${EMPTY}

Add multiple invalid json data to the database via API
    [Tags]  Acceptance
    [Template]  Add multiple entries to database via API and verify in UI
    ${upload_files_path}\\multiple_invalid.json     400     error     ${EMPTY}

Add multiple existing data to the database via API
    [Tags]  Acceptance
    [Template]  Add multiple entries to database via API and verify in UI
    ${upload_files_path}\\multiple_entries.json     202     success     existing

Add multiple duplicate json data to the database via API
    [Tags]  Acceptance
    [Template]  Add multiple entries to database via API and verify in UI
    ${upload_files_path}\\duplicate.json    202     success     duplicate

Add multiple valid json data to the database via API
    [Tags]  Acceptance
    [Template]  Add multiple entries to database via API and verify in UI
    ${upload_files_path}\\text_file.txt     400      error      ${EMPTY}

Add invalid data to the database via multiple entries API
    [Tags]  Acceptance
    [Template]  Add multiple entries to database via API and verify in UI
    ${upload_files_path}\\text_file.txt     400     error       ${EMPTY}


*** Keywords ***
Add single entry via API
    [Arguments]     ${single_entry_json_file}   ${expected_response_code}
    [Documentation]     Adds a single entry to the database
    [Tags]      Acceptancce
    ${body}=    Get file    ${single_entry_json_file}
    ${header}=  Create Dictionary   Content-Type=application/json
    ${response}=    Run Keyword and Ignore Error    POST     ${single_entry_url}      headers=${header}   data=${body}
    Status Should Be    ${expected_response_code}

Add multiple entries to database
    [Arguments]     ${multiple_entries_json_file}   ${expected_response_code}
    [Documentation]     Adds multiple entries to the database
    [Tags]      Acceptance
    ${body}=    Get file    ${multiple_entries_json_file}
    ${header}=  Create Dictionary   Content-Type=application/json
    ${response}=    Run Keyword and Ignore Error    POST      ${multiple_entry_url}      headers=${header}   data=${body}
    Status Should Be    ${expected_response_code}

Verify relief list table in UI
    [Arguments]     ${status}   ${expected_relief_list}
    common.Login to page
    common.Refresh tax relief table
    IF    "${status}" == "success"
        common.Wait table caption
        Log To Console    Verify tax relief table headers
        FOR    ${header}    IN    @{table_headers}
            common.Verify relief list table header  ${header}
        END
        ${table_data}=  common.Get relief list in table
        Lists Should Be Equal    ${table_data}    ${expected_relief_list}
    ELSE
        common.Wait empty table message
    END

Add single entry to database via API and verify in UI
    [Arguments]     ${single_entry_file}   ${response_code}   ${status}     ${case}
    IF    "${case}" == "existing"
         Add single entry via API    ${single_entry_file}    ${response_code}
    END
    IF    "${status}" == "success"
        ${json_data}=   data_fetch.Get data from JSON file    ${single_entry_file}
        ${relief_list}=    common.Get relief list computation from given data    ${json_data}     False
    END
    Add single entry via API    ${single_entry_file}    ${response_code}
    IF    "${status}" == "success"
        Verify relief list table in UI    ${status}   ${relief_list}
    END

Add multiple entries to database via API and verify in UI
    [Arguments]     ${multiple_entries_file}   ${response_code}   ${status}     ${case}
    IF    "${case}" == "existing"
         Add multiple entries to database    ${multiple_entries_file}    ${response_code}
    END
    IF    "${status}" == "success"
        ${json_data}=   data_fetch.Get data from JSON file    ${multiple_entries_file}
        ${relief_list}=    common.Get relief list computation from given data    ${json_data}     False
    END
    Add multiple entries to database    ${multiple_entries_file}    ${response_code}
    IF    "${status}" == "success"
        IF    "${case}" == "duplicate"
            ${relief_list}=    Remove Duplicates    ${relief_list}
        END
        Verify relief list table in UI    ${status}   ${relief_list}
    END
