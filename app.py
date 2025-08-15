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
    cursor.execute("""
        SELECT r.restaurant_id, r.name, r.cuisine, COUNT(res.reservation_id) AS total_reservations, l.province, l.city
        FROM restaurants r
        JOIN tables t ON r.restaurant_id = t.restaurant_id
        JOIN reservations res ON t.table_id = res.table_id
        JOIN locations l ON r.location_id = l.location_id
        GROUP BY r.restaurant_id
        ORDER BY total_reservations DESC
        LIMIT 6;
    """)

    top_restaurants = cursor.fetchall()

    cursor.execute("""
        SELECT d.dish_id, d.name, COUNT(oi.order_item_id) AS times_ordered, r.name, l.city, l.province
        FROM order_items oi
        JOIN dish d ON oi.dish_id = d.dish_id
        JOIN menu m on d.menu_id = m.menu_id
        JOIN restaurants r on m.restaurant_id = r.restaurant_id
        JOIN locations l on r.location_id = l.location_id
        GROUP BY d.dish_id
        ORDER BY times_ordered DESC
        LIMIT 6;
    """)

    top_dishes = cursor.fetchall()

    return render_template('index.html', top_restaurants=top_restaurants, top_dishes=top_dishes)


@app.route("/restaurants")
def restaurants():
    city = request.args.get("city")
    if city:
        cursor.execute("SELECT * FROM restaurants r JOIN locations l ON r.location_id = r.location_id WHERE city =%s", (city,))
    else:
        cursor.execute("SELECT * FROM restaurants")
    restaurant=cursor.fetchall()
    return render_template('restaurants.html', restaurant=restaurant, city=city)

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
    cursor.execute("SELECT tables.table_number, reservations.reservation_time FROM (reservations JOIN tables ON reservations.table_id=tables.table_id) WHERE restaurant_id=%s", (rest_id,))
    reserv=cursor.fetchall()
    return render_template("reserve_resto.html",reservs=reserv)


app.run("0.0.0.0", port=5000, debug=True)