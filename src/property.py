from __main__ import app
from flask import request, make_response
from apikey import validatekey
import gateway

@app.route('/properties', methods=['GET', 'POST'])
def properties():
    if request.method == 'GET':
        data = gateway.get_all_properties()
        return make_response(str(data), 200)
    else:
        if validatekey(request.headers.get('api-key')): 
            result = gateway.post_property(request.data)
            return make_response(str([{"message":result[0]}]), result[1])
        else:
            return make_response(str([{"message":"invalid api key"}]), 401)

@app.route('/properties/<id>', methods=['GET','DELETE', 'PUT'])
def properties_id(id):
    try:
        if type(id) is float:
            return make_response(str([{"message":"id must be an integer"}]),400)
        id = int(id) # double check
    except:
        return make_response(str([{"message":"id must be an integer"}]),400)

    if request.method == 'GET':
        response, status = gateway.get_property_id(id)
        return make_response(str([response]), status)
    else:
        if not validatekey(request.headers.get('api-key')): 
            return make_response(str([{"message":"invalid api key"}]), 401)

        if request.method == 'DELETE':
            rows_deleted = gateway.delete_property_id(id)
            if rows_deleted == 1:
                return make_response(str([{"message":"deleted"}]), 200)
            else:
                return make_response(str([{"message":"id not found"}]),404)

        elif request.method == 'PUT':
            data = gateway.put_property_id(id, request.data) # TODO: double check request.data is the body of request
            return make_response(str([{"message":data[0]}]), data[1])
