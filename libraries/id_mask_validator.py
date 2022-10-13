from robot.api.deco import keyword


@keyword("Validate nat ID masking")
def validate_nat_id_masking(json_data):
    print(json_data)
    for natid in get_all_nat_ids(json_data):
        if is_not_masked(natid[:4]):
            if is_masked(natid[4:]):
                return True
            else:
                return False
        else:
            return False


def get_all_nat_ids(data):
    return [item['natid'] for item in data]


def is_masked(natid):
    return True if all(c == '$' for c in natid) else False


def is_not_masked(natid):
    return True if natid.isdigit() else False
