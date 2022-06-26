import json

def test_swagger_existence():
    with open('src/swagger.json','rt') as myfile:
        swagger_string = myfile.read()
    assert True

def test_swagger_parsable():
    with open('src/swagger.json','rt') as myfile:
        swagger_string = myfile.read()
    swagger_d = json.loads(swagger_string)
    assert type(swagger_d) == dict

def test_swagger_format_top_level():
    expected_top_level_keys = [
        'openapi', 
        'info', 
        'schemes', 
        'components', 
        'securityDefinitions', 
        'paths', 
        'servers'
    ]

    with open('src/swagger.json','rt') as myfile:
        swagger_string = myfile.read()
    swagger_d = json.loads(swagger_string)
    for key in expected_top_level_keys:
        assert key in swagger_d
