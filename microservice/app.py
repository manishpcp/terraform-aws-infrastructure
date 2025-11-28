from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        'message': 'Namaste from Container',
        'hostname': socket.gethostname(),
        'version': '1.0.0'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

@app.route('/info')
def info():
    return jsonify({
        'service': 'custom-microservice',
        'version': '1.0.0',
        'environment': os.environ.get('ENVIRONMENT', 'production')
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
