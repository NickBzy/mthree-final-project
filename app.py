from flask import Flask, render_template, request, flash, redirect, jsonify
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
    cities = request.args.getlist("city")
    order = request.args.get("order", "desc")
    city = None
    if len(cities) ==1:
        city = cities[0]

    if cities:
        placeholders = ','.join(['%s'] * len(cities))
        query = f"""
            SELECT r.restaurant_id, r.name, r.cuisine, 
                   COUNT(res.reservation_id) AS total_reservations, 
                   l.province, l.city
            FROM restaurants r
            JOIN locations l ON r.location_id = l.location_id
            LEFT JOIN tables t ON r.restaurant_id = t.restaurant_id
            LEFT JOIN reservations res ON t.table_id = res.table_id
            WHERE l.city IN ({placeholders})
            GROUP BY r.restaurant_id, r.name, r.cuisine, l.province, l.city
            ORDER BY total_reservations {order.upper()}
        """
        cursor.execute(query, cities)

    else:
        query = f"""
            SELECT r.restaurant_id, r.name, r.cuisine, 
                   COUNT(res.reservation_id) AS total_reservations, 
                   l.province, l.city
            FROM restaurants r
            JOIN locations l ON r.location_id = l.location_id
            LEFT JOIN tables t ON r.restaurant_id = t.restaurant_id
            LEFT JOIN reservations res ON t.table_id = res.table_id
            GROUP BY r.restaurant_id, r.name, r.cuisine, l.province, l.city
            ORDER BY total_reservations {order.upper()}
        """
        cursor.execute(query)

    restaurant = cursor.fetchall()

    cursor.execute("SELECT DISTINCT province FROM locations ORDER BY province")
    provinces = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT DISTINCT city FROM locations ORDER BY city")
    all_cities = [row[0] for row in cursor.fetchall()]

    return render_template(
        "restaurants.html",
        restaurant=restaurant,
        selected_cities=cities,
        all_cities=all_cities,
        order=order,
        city=city,
        provinces=provinces
    )

@app.route("/restaurants/<int:resto_id>")
def resto_dishes(resto_id):
    cursor.execute("SELECT * FROM (dish JOIN menu ON dish.menu_id=menu.menu_id) WHERE menu.restaurant_id=%s", (resto_id,))
    dishes=cursor.fetchall()
    return render_template("dishes.html",dishes=dishes, resto_id=resto_id)
@app.route("/add_restaurant", methods=["POST"])
def add_restaurant():
    name = request.form.get("name")
    cuisine = request.form.get("cuisine")
    province = request.form.get("province")
    city = request.form.get("city")

    # Get location_id for the chosen city/province
    cursor.execute("""
        SELECT location_id FROM locations WHERE province = %s AND city = %s
    """, (province, city))
    location_id = cursor.fetchone()

    if location_id:
        location_id = location_id[0]
    else:
        # If not found, insert new location
        cursor.execute("INSERT INTO locations (province, city) VALUES (%s, %s)", (province, city))
        location_id = cursor.lastrowid

    # Insert into restaurants table
    cursor.execute("""
        INSERT INTO restaurants (name, cuisine, location_id)
        VALUES (%s, %s, %s)
    """, (name, cuisine, location_id))
    conn.commit()

    return redirect("/restaurants")

@app.route("/get_cities")
def get_cities():
    province = request.args.get("province")
    cursor.execute("SELECT DISTINCT city FROM locations WHERE province = %s ORDER BY city", (province,))
    cities = [row[0] for row in cursor.fetchall()]
    return jsonify(cities)


@app.route("/dishes")
def dishes():

    selected_cities = request.args.getlist("city")

    city = None
    if len(selected_cities) ==1:
        city = selected_cities[0]

    order_by_orders = request.args.get("order_by_orders", "desc")
    if order_by_orders not in ["asc", "desc"]:
        order_by_orders = "desc"

    sql = """
        SELECT d.dish_id, d.name, COUNT(oi.order_item_id) AS times_ordered, 
               r.name, l.city, l.province
        FROM order_items oi
        RIGHT JOIN dish d ON oi.dish_id = d.dish_id
        JOIN menu m ON d.menu_id = m.menu_id
        JOIN restaurants r ON m.restaurant_id = r.restaurant_id
        JOIN locations l ON r.location_id = l.location_id
    """

    params = []

    if selected_cities:
        placeholders = ",".join(["%s"] * len(selected_cities))
        sql += f" WHERE l.city IN ({placeholders})"
        params.extend(selected_cities)

    sql += """
        GROUP BY d.dish_id
        ORDER BY times_ordered {}
    """.format(order_by_orders.upper())

    cursor.execute(sql, tuple(params))
    dishes = cursor.fetchall()

    cursor.execute("SELECT DISTINCT city FROM locations ORDER BY city")
    all_cities = [row[0] for row in cursor.fetchall()]

    cursor.execute("SELECT restaurant_id, name FROM restaurants ORDER BY name")
    restaurants = cursor.fetchall()

    return render_template(
        'dishes.html',
        dishes=dishes,
        selected_cities=selected_cities,
        order_by_orders=order_by_orders,
        all_cities=all_cities,
        city=city,
        restaurants=restaurants
    )

@app.route("/get_menus/<int:restaurant_id>")
def get_menus(restaurant_id):
    cursor.execute("SELECT menu_id, name FROM menu WHERE restaurant_id = %s ORDER BY name", (restaurant_id,))
    menus = cursor.fetchall()
    return jsonify(menus)

@app.route("/add_dish", methods=["POST"])
def add_dish():
    restaurant_id = request.form["restaurant_id"]
    menu_id = request.form["menu_id"]
    dish_name = request.form["dish_name"]
    price = request.form["price"]

    cursor.execute("""
        INSERT INTO dish (menu_id, name, price)
        VALUES (%s, %s, %s)
    """, (menu_id, dish_name, price))
    conn.commit()

    return redirect("/dishes")

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
    cursor.execute("SELECT tables.table_number, reservations.reservation_time, reservations.status FROM (reservations JOIN tables ON reservations.table_id=tables.table_id) WHERE restaurant_id=%s", (rest_id,))
    reserv=cursor.fetchall()
    return render_template("reserve_resto.html",reservs=reserv)
@app.route("/reservation/add", methods=["POST", "GET"])
def add_reserv():
    costumer_id = request.form.get('costumer_id')
    table_id = request.form.get('table_id')
    reservation_time = request.form.get('reservation_time')
    if request.form.get("pending"):
        status="pending"
    elif request.form.get("completed"):
        status="completed"
    elif request.form.get("confirmed"):
        status="confirmed"
    else:
        status="cancelled"
    cursor.execute("""
        INSERT INTO reservations (customer_id, table_id, reservation_time, status)
        VALUES (%s, %s, %s, %s)
    """, (costumer_id, table_id, reservation_time, status))
    return redirect("/reservations")


app.run("0.0.0.0", port=5000, debug=True)