from flask import Flask, render_template, request, flash, redirect
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
    cursor.execute("SELECT * FROM restaurants")
    restaurant=cursor.fetchall()
    return render_template('restaurants.html', restaurant=restaurant)

@app.route("/dishes")
def dishes():
    cursor.execute("SELECT * FROM dish")
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
            return render_template("add_dishes.html")
        
        try:
            price = float(price)
        except ValueError:
            return render_template("add_dishes.html")
        
        cursor.execute("""
            INSERT INTO dish (name, description, price, category)
            VALUES (%s, %s, %s, %s)
        """, (name, description, price, category))
        return redirect("/dishes")
    
    return render_template('add_dishes.html')
@app.route("/dishes/delete/<int:item_id>")
def remove_menu_item(item_id):
    cursor.execute("""SELECT dish_id FROM dish WHERE dish_id = %s""", (item_id,))
    if not cursor.fetchone():
            return redirect("/")
    cursor.execute("DELETE FROM order_items WHERE dish_id = %s", (item_id,))
    cursor.execute("DELETE FROM dish WHERE dish_id = %s", (item_id,))
    return redirect("/dishes")

@app.route("/reservations")
def reserve():
    cursor.execute("SELECT * FROM restaurants")
    resto=cursor.fetchall()
    return render_template('reservations.html', restaurant=resto)
@app.route("/reservation/<int:rest_id>")
def reserve_resto(rest_id):
    cursor.execute("SELECT * FROM (reservations JOIN tables ON reservations.table_id=tables.table_id) WHERE restaurant_id=%s", (rest_id,))
    reserv=cursor.fetchall()
    return render_template("reserve_resto.html",reservs=reserv)


app.run("0.0.0.0", port=5000, debug=True)