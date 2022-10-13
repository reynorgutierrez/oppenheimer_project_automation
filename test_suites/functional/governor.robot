*** Settings ***
Documentation   This tests the functions associated with the role/s of the governor
Library         SeleniumLibrary
Resource        ./../../resources/Common.robot
Variables       ./../../resources/Variables.py
Test Setup      Common.Login to page
Test Teardown   Common.Close page


*** Test Cases ***
Dispense Cash
    [Tags]  Acceptance
    Common.Verify background color of element    ${dispense_button_xpath}    ${dispense_button_background_color}
    Common.Verify text of element    ${dispense_button_xpath}    ${dispense_button_text}
    Dispense cash
    Verify that cash has been dispensed

*** Keywords ***
Dispense cash
    Click Element    ${dispense_button_xpath}

Verify that cash has been dispensed
    ${current_url}=    Get Location
    Should Be Equal As Strings    ${current_url}    ${dispense_url}

    ${message}=     Get Text    ${cash_dispensed_confirmation_xpath}
    Should Be Equal As Strings    ${message}    ${cash_dispensed_message}

    # What happens to the database entries after dispensing?
    # Remove entries in database or add markings that relief has been given?
    # In UI, will their be indicator in the table?