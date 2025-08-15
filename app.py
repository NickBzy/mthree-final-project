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
            flash('Name and price are required', 'danger')
            return render_template("add_dishes.html")
        
        try:
            price = float(price)
        except ValueError:
            flash('Invalid price format', 'danger')
            return render_template("add_dishes.html")
        
        cursor.execute("""
            INSERT INTO menu_items (name, description, price, category, is_available, menu)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (name, description, price, category, is_available, menu))
        mysql.connection.commit()
        cursor.close()
        flash('Menu item added successfully!', 'success')
        return redirect("/")
    
    return render_template('add_dishes.html')
@app.route("/dishes/delete/<int:item_id>")
def remove_menu_item(item_id):
    cursor.execute("SELECT id FROM dish WHERE id = %s", (item_id,))
    if not cursor.fetchone():
            flash('Dish not found', 'danger')
            return redirect("/")
    cursor.execute("DELETE FROM menu_items WHERE id = %s", (item_id,))
    flash('Dish deleted successfully', 'success')
    return redirect("/")

@app.route("/reservations")
def reserve():
    return render_template('reservations.html')


app.run("0.0.0.0", port=5000, debug=True)