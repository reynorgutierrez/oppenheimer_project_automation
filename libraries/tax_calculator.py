from datetime import datetime
import json
import math

from robot.api.deco import keyword


@keyword("Get tax relief computation")
def get_tax_relief_computation(data, with_name):
    relief_list = []
    data = data if type(data) is list else [data]
    for item in data:
        temp = list(item['natid'])
        _natid = ['$' if idx > 3 in range(len(temp)) else ele for idx, ele in enumerate(temp)]
        _natid = ''.join(_natid)
        _salary = float(item['salary'])
        _tax_paid = float(item['tax'])
        _variable = float(get_variable(get_age(item['birthday'])))
        _gender_bonus = float(get_gender_bonus(item['gender']))
        tax_relief = calculate_tax_relief(_salary, _tax_paid, _variable, _gender_bonus)
        if with_name == 'True':
            relief_list.append({"natid": _natid, "name": item['name'], "relief": tax_relief})
        else:
            relief_list.append({"natid": _natid, "relief": tax_relief})
    return relief_list


def get_data_from_json_file(json_file):
    with open(json_file) as json_file:
        data = json.load(json_file)
    return data


def calculate_tax_relief(salary, tax_paid, variable, gender_bonus):
    tax_relief = ((salary - tax_paid) * variable) + gender_bonus
    rounded_tax_relief = "{:.2f}".format(round((math.floor(tax_relief / 0.01) / 100)))
    print(rounded_tax_relief)
    if 0 > float(rounded_tax_relief) > 50:
        return "50.00"
    else:
        return rounded_tax_relief


def get_variable(age):
    int(age)
    variable = 0
    if age <= 18:
        variable = 1
    elif 18 < age <= 35:
        variable = 0.8
    elif 35 < age <= 50:
        variable = 0.5
    elif 50 < age <= 75:
        variable = 0.367
    elif age >= 76:
        variable = 0.05
    return variable


def get_age(birthdate):
    today = datetime.today()
    birthday = datetime.strptime(birthdate, "%d%m%Y")
    age = today.year - birthday.year
    return age


def get_gender_bonus(gender):
    return 0 if gender.lower() == 'm' or gender.lower() == 'male' else 500
