*** Settings ***
Documentation   This tests the functions associated with the role/s of the clerk using the UI
Library         Collections
Library         SeleniumLibrary
Library         OperatingSystem
Resource        ./../../resources/common.robot
Variables       ./../../resources/variables.py
Test Setup      common.Rake database
Test Teardown   common.Close page
Test Template   Upload CSV file to portal

*** Variables ***
${upload_files_path}    ${EXECDIR}\\test_data\\

*** Test Cases ***          FILE_PATH                                 STATUS      NOTIFICATION                  CASE
Valid CSV file              ${upload_files_path}sample_valid.csv      success     ${upload_success_message}     ${EMPTY}
Invalid CSV file            ${upload_files_path}sample_invalid.csv    error       ${upload_error_message}       ${EMPTY}
Large CSV file              ${upload_files_path}sample_large.csv      success     ${upload_success_message}     ${EMPTY}
Invalid file type           ${upload_files_path}text_file.txt         error       ${upload_error_message}       ${EMPTY}
Duplicate data in CSV       ${upload_files_path}duplicate.csv         success     ${upload_success_message}     duplicate
Multiple same file upload   ${upload_files_path}sample_valid.csv      success     ${upload_success_message}     existing

*** Keywords ***
Upload CSV file to portal
    [Arguments]     ${file_path}    ${status}   ${notification}     ${case}
    [Documentation]     Uploads a valid CSV file from UI
    [Tags]  Acceptance
    ${upload_data}=    common.Convert CSV to JSON  ${file_path}
    IF    "${status}" == "success"
         ${relief_list}=    common.Get relief list computation from given data    ${upload_data}     False
    END
    common.Login to page
    common.Verify text of element    ${upload_csv_section_label_xpath}    ${upload_csv_section_label}
    Upload file    ${file_path}
    IF    "${case}" == "existing"
         Upload file    ${file_path}
    END
#    Run Keyword And Continue On Failure     Verify upload notification message      ${notification}
    common.Refresh tax relief table
    IF    "${status}" == "success"
        common.Wait table caption
        Log To Console    Verify tax relief table headers
        FOR    ${header}    IN    @{table_headers}
            common.Verify relief list table header  ${header}
        END
        ${table_data}=  common.Get relief list in table
        IF    "${case}" == "duplicate"
            ${relief_list}=    Remove Duplicates    ${relief_list}
        END
        Lists Should Be Equal    ${table_data}    ${relief_list}
    ELSE
        common.Wait empty table message
    END


Upload file
    [Arguments]    ${file_to_upload}
    Choose File    ${upload_csv_file_xpath}   ${file_to_upload}

Verify upload notification message
    [Arguments]     ${message}
    ${notifiacation_message}=    Get Text    ${upload_notification_xpath}
    Should Be Equal As Strings    ${notifiacation_message}    ${message}

