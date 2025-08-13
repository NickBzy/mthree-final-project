from flask import Flask, render_template
import mysql.connector
import os

# Change to environment variables later
conn = mysql.connector.connect(
    host=os.environ.get("DB_HOST", "3.139.96.127"),
    port=int(os.environ.get("DB_PORT", 3306)),
    user=os.environ.get("DB_USER", "flaskuser"),
    password=os.environ.get("DB_PASS", "flaskpass"),
    database=os.environ.get("DB_NAME", "restaurant"),
)
cursor=conn.cursor()

app=Flask("restaurant")

@app.route('/')
def index():
    return render_template('index.html')


@app.route("/restaurants")
def restaurants():
    return render_template('restaurants.html')

@app.route("/dishes")
def dishes():
    return render_template('dishes.html')

@app.route("/reservations")
def reserve():
    return render_template('reservations.html')


app.run("0.0.0.0", port=5000, debug=True)