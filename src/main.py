from flask import Flask, make_response
from flask_cors import add_cors_headers


app = Flask(__name__)
app.after_request(add_cors_headers)
cert_context = ('my_cert/cert.pem', 'my_cert/pkey.pem')
import hello
import property

if __name__ == "__main__":
    #app.run(host='127.0.0.1', port=12300, ssl_context=cert_context, debug=True)
    #app.run(host='localhost', port=12300, ssl_context=cert_context, debug=True)
    app.run(host='0.0.0.0', port=12300, ssl_context=cert_context, debug=True)
