from __main__ import app

@app.route('/hello')
def hello():
    return '[{"message":"hello yourself"}]'

@app.route('/swagger.json')
def swagger_json():
    with open('swagger.json','rt') as myfile:
        swagger_string = myfile.read()
    return swagger_string
