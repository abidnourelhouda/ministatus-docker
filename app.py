import os
from flask import Flask, jsonify
app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(status="ok")

@app.get("/version")
def version():
    return jsonify(version=os.getenv("APP_VERSION", "dev"))

@app.get("/hello/<nom>")
def hello(nom):
    return jsonify(message=f"Bonjour {nom}")