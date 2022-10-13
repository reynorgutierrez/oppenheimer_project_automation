from pathlib import Path
root = Path(__file__).parents[2]

APP_URL = 'http://localhost:8080'
# APIs
add_single_entry = '/calculator/insert'
add_multiple_entries = '/calculator/insertMultiple'
rake_database = '/calculator/rakeDatabase'
get_tax_relief = '/calculator/taxRelief'


# Data path
single_json = f'{root}\\test_data\\single_entry.json'
multiple_json = f'{root}\\test_data\\multiple_entries.json'
