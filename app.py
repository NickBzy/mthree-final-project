from flask import Flask, render_template, request, flash, redirect, url_for
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
    cursor.execute("select * from restaurants")
    restaurant=cursor.fetchall()
    return render_template('restaurants.html', restaurant=restaurant)

@app.route("/dishes")
def dishes():
    cursor.execute("select * from restaurants")
    dishes=cursor.fetchall()
    return render_template('dishes.html', dishes=dishes)

@app.route('/dishes/add', methods=['GET', 'POST'])
def add_menu_item():
    if request.method == 'POST':
        name = request.form.get('name')
        description = request.form.get('description')
        price = request.form.get('price')
        category = request.form.get('category')
        is_available = request.form.get('is_available', 'false') == 'true'
        menu=request.form.get("menu")
        
        if not name or not price:
            flash('Name and price are required', 'danger')
            return redirect(url_for('main.add_menu_item'))
        
        try:
            price = float(price)
        except ValueError:
            flash('Invalid price format', 'danger')
            return redirect(url_for('main.add_menu_item'))
        
        cursor = mysql.connection.cursor()
        cursor.execute("""
            INSERT INTO menu_items (name, description, price, category, is_available)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (name, description, price, category, is_available, menu))
        mysql.connection.commit()
        cursor.close()
        flash('Menu item added successfully!', 'success')
        return redirect(url_for('main.menu'))
    
    return render_template('add_menu_item.html')

@app.route("/reservations")
def reserve():
    return render_template('reservations.html')


app.run("0.0.0.0", port=5000, debug=True)