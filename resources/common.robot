*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     OperatingSystem
Library     ./../libraries/tax_calculator.py
Library     ./../libraries/data_fetch.py
Library    XML
Library    Collections
Variables   ./variables.py

*** Keywords ***
Login to page
    Open Browser    ${APP_URL}  ${BROWSER}
    Maximize Browser Window

Close page
    Close Browser

Verify background color of element
    [Arguments]     ${element_path}     ${expected_text}
    ${element}=     Get WebElement    ${element_path}
    ${background_color}=  Call Method    ${element}    value_of_css_property    background-color
    log  ${background_color}
    Should Be Equal As Strings    ${background_color}    ${expected_text}

Verify text of element
    [Arguments]     ${element_path}     ${expected_text}
    ${element_text}=     Get text    ${element_path}
    Should Be Equal As Strings    ${element_text}    ${expected_text}

Refresh tax relief table
    [Arguments]
    Click Element    ${refresh_tax_relief_table_button}

Wait empty table message
    Wait Until Keyword Succeeds    30s  5s  Wait Until Element Is Visible    ${no_records_message}

Wait table caption
    Wait Until Keyword Succeeds    30s  5s  Wait Until Element Is Visible    ${tax_relief_table_caption}

Rake database
    POST     ${rake_database_url}
    Status Should Be    200

Add multiple data to system
    [Arguments]     ${json_file}
    ${body}=    Get file    ${json_file}
    ${header}=  Create Dictionary   Content-Type=application/json
    ${response}=    POST     ${multiple_entry_url}      headers=${header}   data=${body}
    ${json_data}=   data_fetch.Get data from JSON file    ${json_file}
    ${relief_list}=     Get relief list computation from given data    ${json_data}
    [Return]    ${relief_list}

Get relief list computation from given data
    [Arguments]     ${data}     ${with_name}=True
    ${relief_list}=     tax_calculator.Get tax relief computation    ${data}     ${with_name}
    [Return]    ${relief_list}

Get relief list in table
    ${rowList}=  Create List
    ${rows}=  SeleniumLibrary.Get Element Count  ${table_row}
    FOR    ${index}    IN RANGE    ${rows}
        ${natid_path}=  Catenate    ${table_row}    [${index}+1]/td[1]
        ${relief_path}=     Catenate    ${table_row}    [${index}+1]/td[2]
        ${natid}=  Get Text    ${natid_path}
        ${relief}=  Get Text    ${relief_path}
        ${table_data}=  Create Dictionary    natid=${natid}     relief=${relief}
        Append To List  ${rowList}  ${table_data}
    END
    [Return]    ${rowList}

Verify relief list table header
    [Arguments]     ${text}
    Table Header Should Contain     ${tax_relief_table}     ${text}

Convert CSV to JSON
    [Arguments]     ${path_to_csv}
    ${json_data}    Convert CSV data to JSON    ${path_to_csv}
    [Return]   ${json_data}
