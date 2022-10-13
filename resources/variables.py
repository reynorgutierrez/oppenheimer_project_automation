# App settings
APP_URL = 'http://localhost:8080'
BROWSER = 'Headless Chrome'

# APIs
rake_database_url = f'{APP_URL}/calculator/rakeDatabase'
single_entry_url = f'{APP_URL}/calculator/insert'
multiple_entry_url = f'{APP_URL}/calculator/insertMultiple'
get_tax_relief_url = f'{APP_URL}/calculator/taxRelief'

# Upload section
upload_csv_section_label_xpath = '//div[@id="contents"]//span'
upload_csv_section_label = 'Upload CSV file'
upload_csv_file_xpath = '//div[@id="contents"]//input'

# Notifications
# Nice to have
upload_notification_xpath = '//div[@id="notification"]'
upload_success_message = 'Success!'
upload_error_message = 'Error!'

# Tax relief table
refresh_tax_relief_table_button = '//div[@id="contents"]/button[contains(text(),"Refresh Tax Relief Table")]'
tax_relief_table_caption = '//div[@id="contents"]//table/caption'
no_records_message = '//div[@id="contents"]/h1'
tax_relief_table = '//div[@id="contents"]//table'
table_headers = ["NatId", "Relief"]
table_row = '//div[@id="contents"]//table/tbody/tr'

# Dispense section
dispense_button_xpath = '//a[@href="dispense"]'
dispense_button_text = 'Dispense Now'
dispense_url = 'http://localhost:8080/dispense'
cash_dispensed_confirmation_xpath = '//*[@id="app"]/div/main/div/div/div'
cash_dispensed_message = 'Cash dispensed'
dispense_button_background_color = 'rgba(220, 53, 69, 1)'
