from flask import Flask
import mysql.connector
conn=mysql.connector.connect(host="localhost", user="root", password="sample", database="restaurant")
cursor=conn.cursor()

app=Flask("restaurant")

@app.route('/')
def index():
    msg = '''
<body>
    <header>
        <h1>Welcome to Our Restaurant</h1>
    </header>
    
    <nav>
        <h2>Main Navigation</h2>
        <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/menu/">Menu</a></li>
            <li><a href="/reservation/">Reservation</a></li>
            <li><a href="/orders/">Orders</a></li>
            <li><a href="/tables/">Tables</a></li>
        </ul>
    </nav>  
    
    <footer>
        <p>© 2023 Our Restaurant. All rights reserved.</p>
    </footer>
</body>'''
    return msg


@app.route("/orders")


@app.route("/menu")


@app.route("/tables")


@app.route("/reservations")
