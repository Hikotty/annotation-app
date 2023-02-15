from threading import local
from unicodedata import decomposition
from flask import Flask, request, make_response, jsonify, render_template

import session
import record

app = Flask(__name__)

@app.route('/')
def main():
    return "server is alive"

#セッション終了
@app.route('/change_session', methods=['GET'])
def change_session():
    session.chage_session()
    return make_response(jsonify("success"))

#行動開始
@app.route('/start_action', methods=['POST'])
def start_action():
    data = request.get_json()
    action = data["action"]
    print(data)
    r = record.record(action)
    if r == -1:
        return make_response(jsonify("error"))
    else:
        return make_response(jsonify("success"))

if __name__ == '__main__':
    #app.debug = True
    app.run(host="0.0.0.0", port=8080)
    #app.run(host="localhost")
