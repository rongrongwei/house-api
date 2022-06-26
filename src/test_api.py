from apikey import validatekey

def test_api_key_good():
    result = validatekey('cs4783ftw!')
    assert result

def test_api_key_bad():
    result = validatekey('cs4873ftw!!!!!!?!?!?!?!')
    assert not result
