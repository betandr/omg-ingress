import base64
import json
import logging
import os
import socket

from flask import current_app, Flask, render_template, request, jsonify

from domain import root

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    res = {'hello_world_from': socket.gethostname()}
    return jsonify(res)

@app.route('/headers', methods=['GET'])
def headers():
    res = request.headers
    return jsonify(res)

@app.errorhandler(500)
def server_error(e):
    logging.exception('An error occurred during a request.')
    return """Uh oh!""".format(e), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0')
