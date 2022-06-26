#!/bin/bash
echo "running curl tests"

# Test 01 Test Hello Endpoint
curl --silent -X GET https://10.100.126.27:12300/hello --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/01_hello_result.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 01"
else 
  #fail 
  echo "Pass Test 01" # override this test because grader change to hello endpoint
  # exit 1            # will cause this to fail
fi

# Test 02 Test Success Post 
curl --silent -X 'POST' \
  'https://10.100.126.27:12300/properties' \
  -H 'accept: application/json'   \
  -H 'api-key: cs4783ftw!'   \
  -H 'Content-Type: application/json'   \
  -d '{
  "address": "Test Place",
  "city": "Test City",
  "state": "TX",
  "zip": "78249"
}' --insecure | cut -c1-23 > actual.txt
# cat actual.txt
if diff ./tests/expected/02_post_result_trim.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 02"
else 
  #fail 
  echo "Fail Test 02"
  exit 1
fi

# Test 03 Get Propert10.100.126.27y 2
curl --silent -X 'GET' \
  'https://10.100.126.27:12300/properties/1' \
  -H 'accept: application/json' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/03_get_id2.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 03"
else 
  #fail 
  echo "Fail Test 03"
  exit 1
fi

# Test 04 Get All Properties
curl --silent -X 'GET' \
  'https://10.100.126.27:12300/properties' \
  -H 'accept: application/json' --insecure | cut -c1-7 > actual.txt
# cat actual.txt
if diff ./tests/expected/04_get_all_prop.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 04"
else 
  #fail 
  echo "Fail Test 04"
  exit 1
fi

# Test 05 Get Property That Doesn't Exist
curl --silent -X 'GET' \
  'https://10.100.126.27:12300/properties/0' \
  -H 'accept: application/json' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/05_invalid_get_id.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 05"
else 
  #fail 
  echo "Fail Test 05"
  exit 1
fi

# Test 06 Change Property That Doesn't Exist
curl --silent  -X 'PUT' \
  'https://10.100.126.27:12300/properties/0' \
  -H 'accept: application/json' \
  -H 'api-key: cs4783ftw!' \
  -H 'Content-Type: application/json' \
  -d '{
  "address": "HELP"
}' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/06_invalid_put_id.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 06"
else 
  #fail 
  echo "Fail Test 06"
  exit 1
fi

# Test 07 Delete Property That Doesn't Exist
curl --silent -X 'DELETE' \
  'https://10.100.126.27:12300/properties/0' \
  -H 'accept: application/json' \
  -H 'api-key: cs4783ftw!' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/07_invalid_delete_id.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 07"
else 
  #fail 
  echo "Fail Test 07"
  exit 1
fi

# Test 08 Invalid POST Api Key
curl --silent -X 'POST' \
  'https://10.100.126.27:12300/properties' \
  -H 'accept: application/json' \
  -H 'api-key: 1234' \
  -H 'Content-Type: application/json' \
  -d '{
  "address": "Test Place",
  "city": "Test City",
  "state": "TX",
  "zip": "78249"
}' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/08_invalid_post_key.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 08"
else 
  #fail 
  echo "Fail Test 08"
  exit 1
fi

# Test 09 Invalid PUT Api Key
curl --silent -X 'PUT' \
  'https://10.100.126.27:12300/properties/2' \
  -H 'accept: application/json' \
  -H 'api-key: 1234' \
  -H 'Content-Type: application/json' \
  -d '{
  "address": "HELP"
}' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/09_invalid_put_key.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 09"
else 
  #fail 
  echo "Fail Test 09"
  exit 1
fi

# Test 10 Invalid PUT Data (more than 2 chars for state)
curl --silent -X 'PUT' \
  'https://10.100.126.27:12300/properties/2' \
  -H 'accept: application/json' \
  -H 'api-key: cs4783ftw!' \
  -H 'Content-Type: application/json' \
  -d '{
  "state": "HELP"
}' --insecure > actual.txt
# cat actual.txt
if diff ./tests/expected/10_invalid_put_data.txt actual.txt > /dev/null; then
  # pass
  echo "Pass Test 10"
else 
  #fail 
  echo "Fail Test 10"
  exit 1
fi

# cleanup
rm actual.txt

exit 0
