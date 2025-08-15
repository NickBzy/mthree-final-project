use restaurant;

CREATE TABLE locations (
     location_id INT PRIMARY KEY AUTO_INCREMENT,
     province VARCHAR(50) NOT NULL,
     city VARCHAR(50) NOT NULL
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    location_id INT,
    cuisine VARCHAR(50),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE menu (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    name VARCHAR(50),
    status ENUM('active', 'inactive'),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE dish (
    dish_id INT PRIMARY KEY AUTO_INCREMENT,
    menu_id INT,
    name VARCHAR(50),
    description VARCHAR(200),
    price DECIMAL(10, 2),
    category VARCHAR(50),
    available BOOLEAN,
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
);

CREATE TABLE waiters (
    waiter_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    restaurant_id INT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    email VARCHAR(50) UNIQUE
);

CREATE TABLE tables (
    table_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    table_number INT,
    capacity INT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    table_id INT,
    reservation_time DATETIME,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (table_id) REFERENCES tables(table_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    waiter_id INT,
    order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'in_progress', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (waiter_id) REFERENCES waiters(waiter_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    dish_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (dish_id) REFERENCES dish(dish_id)
);

show tables;

INSERT INTO locations (province, city) VALUES
-- Ontario
('Ontario', 'Toronto'),
('Ontario', 'Ottawa'),
('Ontario', 'Mississauga'),
('Ontario', 'Brampton'),
('Ontario', 'Hamilton'),

-- Quebec
('Quebec', 'Montreal'),
('Quebec', 'Quebec City'),
('Quebec', 'Laval'),
('Quebec', 'Gatineau'),

-- British Columbia
('British Columbia', 'Vancouver'),
('British Columbia', 'Victoria'),
('British Columbia', 'Surrey'),
('British Columbia', 'Burnaby'),

-- Alberta
('Alberta', 'Calgary'),
('Alberta', 'Edmonton'),
('Alberta', 'Red Deer'),

-- Manitoba
('Manitoba', 'Winnipeg'),

-- Nova Scotia
('Nova Scotia', 'Halifax'),

-- New Brunswick
('New Brunswick', 'Moncton'),
('New Brunswick', 'Saint John'),

-- Saskatchewan
('Saskatchewan', 'Saskatoon'),
('Saskatchewan', 'Regina');

SELECT * FROM locations;

-- Toronto (location_id = 1)
INSERT INTO restaurants (name, location_id) VALUES
('Maple Delight', 1),
('The Great North Grill', 1),
('Toronto Tastes', 1),
('Urban Eats Toronto', 1),
('Lakeview Bistro', 1),
('Harbourfront Diner', 1),
('Downtown Delicacies', 1),
('The Queen’s Feast', 1),
('Northern Lights Cafe', 1),
('The City Oven', 1);

-- Montreal (location_id = 6)
INSERT INTO restaurants (name, location_id) VALUES
('Montreal Bistro', 6),
('Poutine Palace', 6),
('Le Vieux Port Grill', 6),
('St. Laurent Eats', 6),
('The French Quarter Cafe', 6),
('Mount Royal Deli', 6),
('Old Montreal Table', 6),
('Plateau Pizzeria', 6),
('La Belle Province', 6),
('The Montreal Brasserie', 6);

-- Quebec City (location_id = 7)
INSERT INTO restaurants (name, location_id) VALUES
('Quebec Charm', 7),
('Citadelle Cafe', 7),
('Saint Lawrence Tavern', 7),
('The Chateau Grill', 7),
('Old Town Eats', 7),
('Fleur de Lys Dining', 7),
('Plains Bistro', 7),
('La Petite Maison', 7),
('The Royal Plate', 7),
('Le Vieux Restaurant', 7);

-- Vancouver (location_id = 10)
INSERT INTO restaurants (name, location_id) VALUES
('Pacific Rim Grill', 10),
('Vancouver Seaside', 10),
('Coal Harbour Bistro', 10),
('Granville Eats', 10),
('Sunset Terrace', 10),
('West End Diner', 10),
('The Rainforest Cafe', 10),
('Gastown Grill', 10),
('Downtown Delights', 10),
('Capilano Bistro', 10);

-- Other cities (2 per city):

-- Ottawa (location_id = 2)
INSERT INTO restaurants (name, location_id) VALUES
('Parliament Plates', 2),
('Rideau River Grill', 2);

-- Mississauga (location_id = 3)
INSERT INTO restaurants (name, location_id) VALUES
('Square One Eats', 3),
('Mississauga Morsels', 3);

-- Calgary (location_id = 14)
INSERT INTO restaurants (name, location_id) VALUES
('Calgary Cookhouse', 14),
('Bow River Bistro', 14);

-- Edmonton (location_id = 15)
INSERT INTO restaurants (name, location_id) VALUES
('Edmonton Eats', 15),
('North Saskatchewan Grill', 15);

-- Winnipeg (location_id = 17)
INSERT INTO restaurants (name, location_id) VALUES
('Prairie Plates', 17),
('Red River Diner', 17);

SELECT * FROM restaurants;

-- Toronto (location_id = 1), restaurants 1-10
INSERT INTO menu (restaurant_id, name, status) VALUES
(1, 'Breakfast', 'active'),
(1, 'Lunch', 'active'),
(2, 'Full', 'active'),
(3, 'Lunch', 'active'),
(3, 'Dinner', 'active'),
(4, 'Full', 'active'),
(5, 'Full', 'active'),
(6, 'Brunch', 'active'),
(6, 'Dinner', 'active'),
(7, 'Full', 'active'),
(8, 'Lunch', 'active'),
(8, 'Dinner', 'active'),
(9, 'Full', 'active'),
(10, 'Full', 'active');

-- Montreal (location_id = 6), restaurants 11-20
INSERT INTO menu (restaurant_id, name, status) VALUES
(11, 'Full', 'active'),
(12, 'Breakfast', 'active'),
(12, 'Lunch', 'active'),
(13, 'Full', 'active'),
(14, 'Lunch', 'active'),
(14, 'Dinner', 'active'),
(15, 'Brunch', 'active'),
(16, 'Full', 'active'),
(17, 'Full', 'active'),
(18, 'Dinner', 'active'),
(19, 'Full', 'active'),
(20, 'Full', 'active');

-- Quebec City (location_id = 7), restaurants 21-30
INSERT INTO menu (restaurant_id, name, status) VALUES
(21, 'Full', 'active'),
(22, 'Breakfast', 'active'),
(22, 'Lunch', 'active'),
(23, 'Full', 'active'),
(24, 'Full', 'active'),
(25, 'Lunch', 'active'),
(25, 'Dinner', 'active'),
(26, 'Full', 'active'),
(27, 'Full', 'active'),
(28, 'Full', 'active'),
(29, 'Full', 'active'),
(30, 'Full', 'active');

-- Vancouver (location_id = 10), restaurants 31-40
INSERT INTO menu (restaurant_id, name, status) VALUES
(31, 'Breakfast', 'active'),
(31, 'Dinner', 'active'),
(32, 'Full', 'active'),
(33, 'Lunch', 'active'),
(34, 'Full', 'active'),
(35, 'Full', 'active'),
(36, 'Brunch', 'active'),
(37, 'Full', 'active'),
(38, 'Full', 'active'),
(39, 'Full', 'active'),
(40, 'Full', 'active');

-- Ottawa (location_id = 2), restaurants 41-42
INSERT INTO menu (restaurant_id, name, status) VALUES
(41, 'Full', 'active'),
(42, 'Full', 'active');

-- Mississauga (location_id = 3), restaurants 43-44
INSERT INTO menu (restaurant_id, name, status) VALUES
(43, 'Full', 'active'),
(44, 'Full', 'active');

-- Calgary (location_id = 14), restaurants 45-46
INSERT INTO menu (restaurant_id, name, status) VALUES
(45, 'Full', 'active'),
(46, 'Full', 'active');

-- Edmonton (location_id = 15), restaurants 47-48
INSERT INTO menu (restaurant_id, name, status) VALUES
(47, 'Full', 'active'),
(48, 'Full', 'active');

-- Winnipeg (location_id = 17), restaurants 49-50
INSERT INTO menu (restaurant_id, name, status) VALUES
(49, 'Full', 'active'),
(50, 'Full', 'active');

SELECT * FROM menu;


INSERT INTO dish (menu_id, name, description, price, category, available) VALUES
-- menu_id = 1 (Breakfast)
(1, 'Pancakes', 'Fluffy pancakes with maple syrup', 7.99, 'Breakfast', TRUE),
(1, 'Omelette', 'Three-egg omelette with cheese and veggies', 8.99, 'Breakfast', TRUE),
(1, 'French Toast', 'Bread dipped in egg batter and grilled', 7.49, 'Breakfast', TRUE),
(1, 'Breakfast Burrito', 'Eggs, cheese, and bacon wrapped in tortilla', 9.99, 'Breakfast', TRUE),
(1, 'Fruit Salad', 'Fresh seasonal fruits', 5.99, 'Breakfast', TRUE),

-- menu_id = 2 (Lunch)
(2, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 10.99, 'Salad', TRUE),
(2, 'Club Sandwich', 'Turkey, bacon, lettuce, tomato on toast', 12.99, 'Sandwich', TRUE),
(2, 'Grilled Cheese', 'Classic grilled cheese sandwich', 8.49, 'Sandwich', TRUE),
(2, 'Tomato Soup', 'Creamy tomato soup served with bread', 6.99, 'Soup', TRUE),
(2, 'Steak Frites', 'Grilled steak with fries', 18.99, 'Main', TRUE),

-- menu_id = 3 (Lunch)
(3, 'Chicken Caesar Wrap', 'Grilled chicken, lettuce, Caesar sauce', 11.99, 'Wrap', TRUE),
(3, 'Beef Burger', 'Grilled beef patty with cheese and lettuce', 13.99, 'Burger', TRUE),
(3, 'Greek Salad', 'Salad with feta, olives, tomatoes, cucumber', 10.99, 'Salad', TRUE),
(3, 'French Fries', 'Crispy fries', 4.99, 'Side', TRUE),
(3, 'Chocolate Brownie', 'Warm chocolate brownie with ice cream', 5.99, 'Dessert', TRUE),

-- menu_id = 4 (Full)
(4, 'Spaghetti Bolognese', 'Pasta with rich meat sauce', 14.99, 'Main', TRUE),
(4, 'Margherita Pizza', 'Classic pizza with tomato, mozzarella', 13.99, 'Main', TRUE),
(4, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 11.99, 'Salad', TRUE),
(4, 'Minestrone Soup', 'Vegetable soup with beans and pasta', 7.99, 'Soup', TRUE),
(4, 'Tiramisu', 'Italian coffee-flavored dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 5 (Full)
(5, 'BBQ Ribs', 'Slow cooked ribs with BBQ sauce', 22.99, 'Main', TRUE),
(5, 'Coleslaw', 'Cabbage and carrot salad with mayo', 5.99, 'Side', TRUE),
(5, 'Cornbread', 'Sweet cornbread muffin', 4.99, 'Side', TRUE),
(5, 'Mac and Cheese', 'Baked macaroni with cheese sauce', 10.99, 'Side', TRUE),
(5, 'Apple Pie', 'Classic apple pie with cinnamon', 6.49, 'Dessert', TRUE),

-- menu_id = 6 (Brunch)
(6, 'Eggs Benedict', 'Poached eggs on English muffin with hollandaise', 12.99, 'Brunch', TRUE),
(6, 'Avocado Toast', 'Sourdough with smashed avocado and chili flakes', 10.99, 'Brunch', TRUE),
(6, 'Mimosa', 'Champagne and orange juice', 7.99, 'Drink', TRUE),
(6, 'Breakfast Burrito', 'Eggs, cheese, and bacon wrapped in tortilla', 9.99, 'Brunch', TRUE),
(6, 'Fruit Parfait', 'Yogurt, granola, and fresh berries', 6.99, 'Brunch', TRUE),

-- menu_id = 7 (Full)
(7, 'Roast Chicken', 'Herb roasted chicken with vegetables', 18.99, 'Main', TRUE),
(7, 'Grilled Salmon', 'Salmon fillet with lemon butter sauce', 21.99, 'Main', TRUE),
(7, 'Risotto', 'Creamy mushroom risotto', 17.99, 'Main', TRUE),
(7, 'Garlic Bread', 'Toasted bread with garlic butter', 5.49, 'Side', TRUE),
(7, 'Cheesecake', 'Classic New York style cheesecake', 6.99, 'Dessert', TRUE),

-- menu_id = 8 (Lunch)
(8, 'Chicken Caesar Wrap', 'Grilled chicken, lettuce, Caesar sauce', 11.99, 'Wrap', TRUE),
(8, 'Beef Burger', 'Grilled beef patty with cheese and lettuce', 13.99, 'Burger', TRUE),
(8, 'Greek Salad', 'Salad with feta, olives, tomatoes, cucumber', 10.99, 'Salad', TRUE),
(8, 'French Fries', 'Crispy fries', 4.99, 'Side', TRUE),
(8, 'Chocolate Brownie', 'Warm chocolate brownie with ice cream', 5.99, 'Dessert', TRUE),

-- menu_id = 9 (Dinner)
(9, 'Beef Wellington', 'Filet wrapped in puff pastry', 29.99, 'Main', TRUE),
(9, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 11.99, 'Salad', TRUE),
(9, 'Mashed Potatoes', 'Creamy mashed potatoes', 5.99, 'Side', TRUE),
(9, 'Green Beans Almondine', 'Green beans sautéed with almonds', 6.49, 'Side', TRUE),
(9, 'Crème Brûlée', 'Classic vanilla custard dessert', 7.49, 'Dessert', TRUE),

-- menu_id = 10 (Full)
(10, 'Grilled Steak', '10oz ribeye steak with herb butter', 25.99, 'Main', TRUE),
(10, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 11.49, 'Salad', TRUE),
(10, 'Onion Rings', 'Crispy fried onion rings', 6.99, 'Side', TRUE),
(10, 'Mashed Potatoes', 'Creamy mashed potatoes with garlic', 5.99, 'Side', TRUE),
(10, 'Chocolate Mousse', 'Light and fluffy chocolate dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 11 (Full)
(11, 'Smoked Meat Sandwich', 'Montreal style smoked meat on rye', 13.99, 'Sandwich', TRUE),
(11, 'Poutine', 'Fries topped with cheese curds and gravy', 10.99, 'Side', TRUE),
(11, 'Maple Glazed Salmon', 'Salmon with sweet maple glaze', 19.99, 'Main', TRUE),
(11, 'BeaverTails', 'Fried dough pastry with cinnamon sugar', 6.49, 'Dessert', TRUE),
(11, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 11.49, 'Salad', TRUE),

-- menu_id = 12 (Breakfast)
(12, 'Crepes', 'Thin pancakes with choice of fillings', 9.99, 'Breakfast', TRUE),
(12, 'Bagel and Lox', 'Smoked salmon on bagel with cream cheese', 12.99, 'Breakfast', TRUE),
(12, 'French Toast', 'Bread dipped in egg batter and grilled', 7.99, 'Breakfast', TRUE),
(12, 'Eggs Benedict', 'Poached eggs with hollandaise sauce', 13.49, 'Breakfast', TRUE),
(12, 'Fresh Fruit Cup', 'Assortment of fresh fruits', 5.99, 'Breakfast', TRUE),

-- menu_id = 13 (Full)
(13, 'Beef Bourguignon', 'French beef stew with red wine', 22.99, 'Main', TRUE),
(13, 'Ratatouille', 'Stewed vegetables with herbs', 14.99, 'Main', TRUE),
(13, 'French Onion Soup', 'Caramelized onions in broth with cheese', 8.99, 'Soup', TRUE),
(13, 'Baguette', 'Fresh baked French bread', 3.49, 'Side', TRUE),
(13, 'Crème Brûlée', 'Classic vanilla custard dessert', 7.99, 'Dessert', TRUE),

-- menu_id = 14 (Lunch)
(14, 'Tourtière', 'Traditional Quebec meat pie', 14.99, 'Main', TRUE),
(14, 'Poutine', 'Fries with cheese curds and gravy', 9.99, 'Side', TRUE),
(14, 'Salade Verte', 'Mixed green salad with vinaigrette', 7.99, 'Salad', TRUE),
(14, 'Baked Beans', 'Slow-cooked beans with maple syrup', 5.99, 'Side', TRUE),
(14, 'Maple Tart', 'Sweet maple syrup tart', 6.49, 'Dessert', TRUE),

-- menu_id = 15 (Dinner)
(15, 'Duck Confit', 'Slow-cooked duck leg with crispy skin', 24.99, 'Main', TRUE),
(15, 'Scalloped Potatoes', 'Potatoes baked with cheese and cream', 8.99, 'Side', TRUE),
(15, 'Green Beans', 'Steamed green beans with butter', 6.49, 'Side', TRUE),
(15, 'French Baguette', 'Fresh baked bread', 3.99, 'Side', TRUE),
(15, 'Chocolate Soufflé', 'Light and airy chocolate dessert', 7.99, 'Dessert', TRUE),

-- menu_id = 16 (Full)
(16, 'Montreal Smoked Meat', 'Sandwich with smoked meat and mustard', 13.99, 'Main', TRUE),
(16, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 11.99, 'Salad', TRUE),
(16, 'Poutine', 'Fries topped with cheese curds and gravy', 10.99, 'Side', TRUE),
(16, 'Maple Syrup Pie', 'Sweet pie with maple syrup filling', 6.49, 'Dessert', TRUE),
(16, 'French Fries', 'Crispy fries', 4.99, 'Side', TRUE),

-- menu_id = 17 (Full)
(17, 'Beef Stew', 'Slow cooked beef with vegetables', 18.99, 'Main', TRUE),
(17, 'Mashed Potatoes', 'Creamy mashed potatoes', 6.49, 'Side', TRUE),
(17, 'Carrot Salad', 'Fresh shredded carrots with vinaigrette', 5.99, 'Salad', TRUE),
(17, 'Dinner Rolls', 'Fresh baked rolls', 3.49, 'Side', TRUE),
(17, 'Apple Crisp', 'Baked apples with oat topping', 6.49, 'Dessert', TRUE),

-- menu_id = 18 (Dinner)
(18, 'Pan-Seared Duck Breast', 'Duck breast with cherry sauce', 25.99, 'Main', TRUE),
(18, 'Wild Rice Pilaf', 'Rice cooked with wild herbs', 7.99, 'Side', TRUE),
(18, 'Roasted Vegetables', 'Seasonal roasted vegetables', 6.99, 'Side', TRUE),
(18, 'French Baguette', 'Fresh baked bread', 3.99, 'Side', TRUE),
(18, 'Chocolate Fondant', 'Molten chocolate cake', 7.99, 'Dessert', TRUE),

-- menu_id = 19 (Full)
(19, 'Maple Glazed Pork Chop', 'Pork chop with maple glaze', 19.99, 'Main', TRUE),
(19, 'Sweet Potato Fries', 'Crispy sweet potato fries', 5.99, 'Side', TRUE),
(19, 'Garden Salad', 'Mixed greens with vinaigrette', 7.99, 'Salad', TRUE),
(19, 'Cornbread Muffin', 'Sweet cornbread muffin', 4.99, 'Side', TRUE),
(19, 'Maple Pudding', 'Sweet pudding flavored with maple', 6.49, 'Dessert', TRUE),

-- menu_id = 20 (Full)
(20, 'Seafood Chowder', 'Creamy chowder with mixed seafood', 14.99, 'Soup', TRUE),
(20, 'Grilled Salmon', 'Salmon with lemon dill sauce', 21.99, 'Main', TRUE),
(20, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 11.99, 'Salad', TRUE),
(20, 'Steamed Asparagus', 'Asparagus with butter', 7.49, 'Side', TRUE),
(20, 'Blueberry Tart', 'Sweet blueberry tart', 6.99, 'Dessert', TRUE),

-- menu_id = 21 (Full)
(21, 'Bison Burger', 'Grilled bison patty with cheese', 15.99, 'Burger', TRUE),
(21, 'Sweet Potato Fries', 'Crispy sweet potato fries', 5.99, 'Side', TRUE),
(21, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(21, 'Apple Pie', 'Classic apple pie', 6.49, 'Dessert', TRUE),
(21, 'Lemonade', 'Fresh squeezed lemonade', 3.99, 'Drink', TRUE),

-- menu_id = 22 (Breakfast)
(22, 'Eggs Florentine', 'Poached eggs with spinach and hollandaise', 12.49, 'Breakfast', TRUE),
(22, 'Breakfast Sandwich', 'Egg, bacon, cheese on English muffin', 8.99, 'Breakfast', TRUE),
(22, 'Granola Parfait', 'Granola with yogurt and berries', 6.99, 'Breakfast', TRUE),
(22, 'Fruit Salad', 'Fresh seasonal fruits', 5.99, 'Breakfast', TRUE),
(22, 'Coffee', 'Fresh brewed coffee', 2.99, 'Drink', TRUE),

-- menu_id = 23 (Full)
(23, 'Beef Stroganoff', 'Beef in creamy mushroom sauce', 18.99, 'Main', TRUE),
(23, 'Butter Noodles', 'Egg noodles with butter and herbs', 7.99, 'Side', TRUE),
(23, 'Cucumber Salad', 'Fresh cucumbers with dill', 6.49, 'Salad', TRUE),
(23, 'Dinner Rolls', 'Fresh baked rolls', 3.49, 'Side', TRUE),
(23, 'Raspberry Sorbet', 'Refreshing raspberry dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 24 (Full)
(24, 'Grilled Lamb Chops', 'Chops with rosemary and garlic', 26.99, 'Main', TRUE),
(24, 'Roasted Potatoes', 'Potatoes with herbs and olive oil', 6.99, 'Side', TRUE),
(24, 'Greek Salad', 'Feta, olives, tomatoes, cucumber', 9.99, 'Salad', TRUE),
(24, 'Pita Bread', 'Warm pita bread', 3.99, 'Side', TRUE),
(24, 'Baklava', 'Honey and nut pastry', 7.49, 'Dessert', TRUE),

-- menu_id = 25 (Lunch)
(25, 'Fish and Chips', 'Battered fish with fries', 15.99, 'Main', TRUE),
(25, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(25, 'Garden Salad', 'Mixed greens with vinaigrette', 7.49, 'Salad', TRUE),
(25, 'Tartar Sauce', 'Creamy tartar sauce', 1.99, 'Side', TRUE),
(25, 'Chocolate Chip Cookie', 'Fresh baked cookie', 2.99, 'Dessert', TRUE),

-- menu_id = 26 (Full)
(26, 'Pasta Primavera', 'Pasta with fresh vegetables', 14.99, 'Main', TRUE),
(26, 'Garlic Bread', 'Toasted bread with garlic butter', 4.99, 'Side', TRUE),
(26, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 10.99, 'Salad', TRUE),
(26, 'Minestrone Soup', 'Vegetable soup with beans and pasta', 7.99, 'Soup', TRUE),
(26, 'Tiramisu', 'Coffee-flavored dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 27 (Full)
(27, 'Chicken Alfredo', 'Pasta with creamy Alfredo sauce and chicken', 15.99, 'Main', TRUE),
(27, 'Steamed Broccoli', 'Broccoli with lemon butter', 6.49, 'Side', TRUE),
(27, 'Garden Salad', 'Mixed greens with vinaigrette', 7.49, 'Salad', TRUE),
(27, 'Breadsticks', 'Garlic breadsticks', 4.99, 'Side', TRUE),
(27, 'Cheesecake', 'Classic New York cheesecake', 6.99, 'Dessert', TRUE),

-- menu_id = 28 (Full)
(28, 'Beef Tacos', 'Soft tacos with seasoned beef', 12.99, 'Main', TRUE),
(28, 'Guacamole', 'Avocado dip with lime and cilantro', 5.99, 'Appetizer', TRUE),
(28, 'Mexican Rice', 'Spiced rice with tomatoes and beans', 6.49, 'Side', TRUE),
(28, 'Refried Beans', 'Mashed and fried beans', 5.99, 'Side', TRUE),
(28, 'Churros', 'Fried dough with cinnamon sugar', 6.49, 'Dessert', TRUE),

-- menu_id = 29 (Full)
(29, 'Veggie Burger', 'Grilled vegetable patty with toppings', 13.49, 'Main', TRUE),
(29, 'Sweet Potato Fries', 'Crispy sweet potato fries', 5.99, 'Side', TRUE),
(29, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(29, 'Mixed Green Salad', 'Salad with vinaigrette', 7.49, 'Salad', TRUE),
(29, 'Chocolate Cake', 'Rich chocolate cake', 6.99, 'Dessert', TRUE),

-- menu_id = 30 (Full)
(30, 'Chicken Curry', 'Spicy chicken curry with rice', 16.99, 'Main', TRUE),
(30, 'Naan Bread', 'Soft Indian flatbread', 3.99, 'Side', TRUE),
(30, 'Mango Chutney', 'Sweet and spicy chutney', 2.99, 'Side', TRUE),
(30, 'Raita', 'Yogurt cucumber sauce', 3.49, 'Side', TRUE),
(30, 'Gulab Jamun', 'Sweet fried dough balls', 6.49, 'Dessert', TRUE),

-- menu_id = 31 (Breakfast)
(31, 'Croissant', 'Buttery flaky pastry', 4.99, 'Breakfast', TRUE),
(31, 'Espresso', 'Strong coffee shot', 3.49, 'Drink', TRUE),
(31, 'Fruit Tart', 'Pastry filled with custard and fresh fruits', 6.99, 'Dessert', TRUE),
(31, 'Bagel with Cream Cheese', 'Fresh bagel with cream cheese', 5.49, 'Breakfast', TRUE),
(31, 'Oatmeal', 'Warm oatmeal with brown sugar and raisins', 6.49, 'Breakfast', TRUE),

-- menu_id = 31 (Dinner)
(31, 'Beef Stroganoff', 'Beef in creamy mushroom sauce', 19.99, 'Main', TRUE),
(31, 'Roasted Potatoes', 'Potatoes roasted with herbs', 6.99, 'Side', TRUE),
(31, 'Steamed Green Beans', 'Green beans with butter', 5.99, 'Side', TRUE),
(31, 'Garden Salad', 'Mixed greens with vinaigrette', 7.49, 'Salad', TRUE),
(31, 'Chocolate Mousse', 'Light and airy chocolate dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 32 (Full)
(32, 'Seafood Paella', 'Spanish rice dish with seafood', 22.99, 'Main', TRUE),
(32, 'Gazpacho', 'Cold tomato soup', 7.99, 'Soup', TRUE),
(32, 'Mixed Green Salad', 'Salad with vinaigrette', 7.49, 'Salad', TRUE),
(32, 'Breadsticks', 'Garlic breadsticks', 4.99, 'Side', TRUE),
(32, 'Churros', 'Fried dough with cinnamon sugar', 6.49, 'Dessert', TRUE),

-- menu_id = 33 (Lunch)
(33, 'BLT Sandwich', 'Bacon, lettuce, tomato sandwich', 11.99, 'Sandwich', TRUE),
(33, 'Potato Salad', 'Creamy potato salad', 5.99, 'Side', TRUE),
(33, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(33, 'Chips', 'Potato chips', 2.99, 'Side', TRUE),
(33, 'Chocolate Chip Cookie', 'Fresh baked cookie', 2.99, 'Dessert', TRUE),

-- menu_id = 34 (Full)
(34, 'Chicken Parmesan', 'Breaded chicken with tomato sauce and cheese', 16.99, 'Main', TRUE),
(34, 'Spaghetti', 'Pasta with tomato sauce', 12.99, 'Main', TRUE),
(34, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 10.99, 'Salad', TRUE),
(34, 'Garlic Bread', 'Toasted bread with garlic butter', 4.99, 'Side', TRUE),
(34, 'Tiramisu', 'Coffee-flavored dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 35 (Full)
(35, 'Grilled Shrimp', 'Shrimp grilled with garlic butter', 19.99, 'Main', TRUE),
(35, 'Rice Pilaf', 'Rice cooked with herbs', 6.99, 'Side', TRUE),
(35, 'Steamed Vegetables', 'Seasonal vegetables', 6.49, 'Side', TRUE),
(35, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 10.99, 'Salad', TRUE),
(35, 'Lemon Sorbet', 'Refreshing lemon dessert', 6.49, 'Dessert', TRUE),

-- menu_id = 36 (Brunch)
(36, 'Huevos Rancheros', 'Eggs with salsa on tortillas', 11.99, 'Brunch', TRUE),
(36, 'Breakfast Burrito', 'Eggs, cheese, and bacon wrapped in tortilla', 10.99, 'Brunch', TRUE),
(36, 'Avocado Toast', 'Sourdough with smashed avocado and chili flakes', 10.99, 'Brunch', TRUE),
(36, 'Fresh Fruit Cup', 'Assorted seasonal fruits', 5.99, 'Brunch', TRUE),
(36, 'Coffee', 'Fresh brewed coffee', 2.99, 'Drink', TRUE),

-- menu_id = 37 (Full)
(37, 'Lamb Tagine', 'Moroccan spiced lamb stew', 24.99, 'Main', TRUE),
(37, 'Couscous', 'Steamed semolina grains', 6.99, 'Side', TRUE),
(37, 'Roasted Vegetables', 'Seasonal roasted vegetables', 6.49, 'Side', TRUE),
(37, 'Flatbread', 'Soft flatbread', 3.99, 'Side', TRUE),
(37, 'Baklava', 'Honey and nut pastry', 7.49, 'Dessert', TRUE),

-- menu_id = 38 (Full)
(38, 'Beef Kebabs', 'Grilled beef skewers with spices', 18.99, 'Main', TRUE),
(38, 'Rice Pilaf', 'Rice cooked with herbs', 6.99, 'Side', TRUE),
(38, 'Greek Salad', 'Feta, olives, tomatoes, cucumber', 9.99, 'Salad', TRUE),
(38, 'Pita Bread', 'Warm pita bread', 3.99, 'Side', TRUE),
(38, 'Baklava', 'Honey and nut pastry', 7.49, 'Dessert', TRUE),

-- menu_id = 39 (Full)
(39, 'Pho', 'Vietnamese beef noodle soup', 14.99, 'Main', TRUE),
(39, 'Spring Rolls', 'Rice paper rolls with veggies', 6.99, 'Appetizer', TRUE),
(39, 'Steamed Rice', 'Jasmine rice', 3.99, 'Side', TRUE),
(39, 'Vietnamese Iced Coffee', 'Strong coffee with condensed milk', 4.49, 'Drink', TRUE),
(39, 'Mango Sticky Rice', 'Sticky rice with mango and coconut milk', 6.99, 'Dessert', TRUE),

-- menu_id = 40 (Full)
(40, 'Sushi Platter', 'Assortment of sushi rolls', 24.99, 'Main', TRUE),
(40, 'Miso Soup', 'Traditional miso soup', 4.99, 'Soup', TRUE),
(40, 'Edamame', 'Steamed soybeans with salt', 5.99, 'Appetizer', TRUE),
(40, 'Seaweed Salad', 'Salad with seaweed and sesame', 6.49, 'Salad', TRUE),
(40, 'Green Tea Ice Cream', 'Matcha flavored ice cream', 5.99, 'Dessert', TRUE),

-- menu_id = 41 (Full)
(41, 'Pad Thai', 'Thai stir-fried noodles with shrimp', 14.99, 'Main', TRUE),
(41, 'Spring Rolls', 'Vegetable spring rolls', 6.99, 'Appetizer', TRUE),
(41, 'Tom Yum Soup', 'Spicy and sour Thai soup', 7.99, 'Soup', TRUE),
(41, 'Steamed Rice', 'Jasmine rice', 3.99, 'Side', TRUE),
(41, 'Mango Sticky Rice', 'Sticky rice with mango and coconut milk', 6.99, 'Dessert', TRUE),

-- menu_id = 42 (Full)
(42, 'Beef Bulgogi', 'Korean marinated beef', 17.99, 'Main', TRUE),
(42, 'Kimchi', 'Spicy fermented cabbage', 4.99, 'Side', TRUE),
(42, 'Steamed Rice', 'White rice', 3.99, 'Side', TRUE),
(42, 'Seaweed Soup', 'Soup with seaweed and tofu', 5.99, 'Soup', TRUE),
(42, 'Mochi Ice Cream', 'Sweet rice cake with ice cream filling', 6.49, 'Dessert', TRUE),

-- menu_id = 43 (Full)
(43, 'Fish Curry', 'Spicy fish curry with coconut milk', 18.99, 'Main', TRUE),
(43, 'Rice', 'Steamed basmati rice', 3.99, 'Side', TRUE),
(43, 'Naan Bread', 'Indian flatbread', 3.99, 'Side', TRUE),
(43, 'Samosas', 'Fried pastry with spiced vegetables', 6.49, 'Appetizer', TRUE),
(43, 'Gulab Jamun', 'Sweet fried dough balls', 6.49, 'Dessert', TRUE),

-- menu_id = 44 (Full)
(44, 'Roast Beef', 'Beef roast with gravy', 19.99, 'Main', TRUE),
(44, 'Yorkshire Pudding', 'Traditional British side', 4.99, 'Side', TRUE),
(44, 'Roasted Vegetables', 'Seasonal roasted vegetables', 6.49, 'Side', TRUE),
(44, 'Mashed Potatoes', 'Creamy mashed potatoes', 5.99, 'Side', TRUE),
(44, 'Sticky Toffee Pudding', 'Sweet sponge pudding with toffee sauce', 7.49, 'Dessert', TRUE),

-- menu_id = 45 (Full)
(45, 'Fish and Chips', 'Battered fish with fries', 16.99, 'Main', TRUE),
(45, 'Mushy Peas', 'Green pea purée', 4.99, 'Side', TRUE),
(45, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(45, 'Tartar Sauce', 'Creamy tartar sauce', 1.99, 'Side', TRUE),
(45, 'Treacle Tart', 'Sweet syrup tart', 6.99, 'Dessert', TRUE),

-- menu_id = 46 (Full)
(46, 'Chicken Tikka Masala', 'Spiced chicken in creamy tomato sauce', 16.99, 'Main', TRUE),
(46, 'Basmati Rice', 'Fragrant long grain rice', 3.99, 'Side', TRUE),
(46, 'Naan Bread', 'Indian flatbread', 3.99, 'Side', TRUE),
(46, 'Raita', 'Yogurt and cucumber sauce', 3.49, 'Side', TRUE),
(46, 'Kheer', 'Indian rice pudding', 6.49, 'Dessert', TRUE),

-- menu_id = 47 (Full)
(47, 'BBQ Chicken', 'Grilled chicken with BBQ sauce', 17.99, 'Main', TRUE),
(47, 'Corn on the Cob', 'Grilled corn with butter', 5.99, 'Side', TRUE),
(47, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(47, 'Baked Beans', 'Slow cooked beans', 4.99, 'Side', TRUE),
(47, 'Peach Cobbler', 'Baked peaches with sweet topping', 6.49, 'Dessert', TRUE),

-- menu_id = 48 (Full)
(48, 'Veggie Stir Fry', 'Mixed vegetables stir fried with sauce', 14.99, 'Main', TRUE),
(48, 'Steamed Rice', 'White rice', 3.99, 'Side', TRUE),
(48, 'Spring Rolls', 'Vegetable spring rolls', 6.99, 'Appetizer', TRUE),
(48, 'Miso Soup', 'Traditional miso soup', 4.99, 'Soup', TRUE),
(48, 'Green Tea Ice Cream', 'Matcha flavored ice cream', 5.99, 'Dessert', TRUE),

-- menu_id = 49 (Full)
(49, 'Turkey Sandwich', 'Turkey breast sandwich with lettuce and tomato', 12.99, 'Sandwich', TRUE),
(49, 'Chips', 'Potato chips', 2.99, 'Side', TRUE),
(49, 'Coleslaw', 'Cabbage and carrot salad', 4.99, 'Side', TRUE),
(49, 'Pickle', 'Sour pickle', 1.99, 'Side', TRUE),
(49, 'Brownie', 'Chocolate brownie', 5.99, 'Dessert', TRUE),

-- menu_id = 50 (Full)
(50, 'Eggplant Parmesan', 'Breaded eggplant with tomato sauce and cheese', 14.99, 'Main', TRUE),
(50, 'Spaghetti', 'Pasta with tomato sauce', 12.99, 'Main', TRUE),
(50, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 10.99, 'Salad', TRUE),
(50, 'Garlic Bread', 'Toasted bread with garlic butter', 4.99, 'Side', TRUE),
(50, 'Tiramisu', 'Coffee-flavored dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 51 (Full)
(51, 'Classic Cheeseburger', 'Beef patty with cheese, lettuce, and tomato', 12.99, 'Main', TRUE),
(51, 'French Fries', 'Crispy golden fries', 4.99, 'Side', TRUE),
(51, 'Caesar Salad', 'Romaine lettuce with Caesar dressing', 9.99, 'Salad', TRUE),
(51, 'Onion Rings', 'Deep-fried battered onion rings', 5.49, 'Side', TRUE),
(51, 'Chocolate Milkshake', 'Rich chocolate milkshake', 6.49, 'Drink', TRUE),

-- menu_id = 52 (Full)
(52, 'Grilled Salmon', 'Salmon fillet with lemon butter', 18.99, 'Main', TRUE),
(52, 'Steamed Asparagus', 'Fresh asparagus steamed to perfection', 6.99, 'Side', TRUE),
(52, 'Wild Rice', 'Savory wild rice blend', 5.99, 'Side', TRUE),
(52, 'Mixed Greens', 'Fresh mixed greens salad', 7.99, 'Salad', TRUE),
(52, 'Key Lime Pie', 'Tangy lime pie with graham crust', 6.49, 'Dessert', TRUE),

-- menu_id = 53 (Full)
(53, 'BBQ Ribs', 'Slow cooked pork ribs with BBQ sauce', 21.99, 'Main', TRUE),
(53, 'Coleslaw', 'Creamy cabbage salad', 4.99, 'Side', TRUE),
(53, 'Baked Beans', 'Slow-cooked beans with bacon', 5.49, 'Side', TRUE),
(53, 'Cornbread', 'Sweet corn muffin', 3.99, 'Side', TRUE),
(53, 'Peach Cobbler', 'Warm peach dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 54 (Full)
(54, 'Pasta Primavera', 'Pasta with fresh vegetables', 15.99, 'Main', TRUE),
(54, 'Garlic Bread', 'Toasted bread with garlic butter', 4.99, 'Side', TRUE),
(54, 'Caprese Salad', 'Tomato, basil, mozzarella', 9.99, 'Salad', TRUE),
(54, 'Minestrone Soup', 'Vegetable soup with beans and pasta', 7.49, 'Soup', TRUE),
(54, 'Tiramisu', 'Coffee-flavored layered dessert', 6.99, 'Dessert', TRUE),

-- menu_id = 55 (Full)
(55, 'Steak Frites', 'Grilled steak with fries', 22.99, 'Main', TRUE),
(55, 'Green Beans Almondine', 'Green beans with almonds', 6.99, 'Side', TRUE),
(55, 'Caesar Salad', 'Romaine with Caesar dressing', 9.99, 'Salad', TRUE),
(55, 'French Onion Soup', 'Caramelized onion soup with cheese', 7.99, 'Soup', TRUE),
(55, 'Creme Brulee', 'Custard topped with caramelized sugar', 7.49, 'Dessert', TRUE),

-- menu_id = 56 (Full)
(56, 'Chicken Alfredo', 'Pasta with creamy Alfredo sauce and chicken', 16.99, 'Main', TRUE),
(56, 'Steamed Broccoli', 'Fresh broccoli steamed', 5.99, 'Side', TRUE),
(56, 'Garden Salad', 'Mixed greens with veggies', 7.49, 'Salad', TRUE),
(56, 'Garlic Knots', 'Garlic-flavored bread knots', 4.99, 'Side', TRUE),
(56, 'Cheesecake', 'Creamy New York style cheesecake', 6.99, 'Dessert', TRUE),

-- menu_id = 57 (Full)
(57, 'Fish Tacos', 'Grilled fish in corn tortillas with salsa', 14.99, 'Main', TRUE),
(57, 'Black Beans', 'Seasoned black beans', 5.99, 'Side', TRUE),
(57, 'Mexican Rice', 'Flavored rice with tomato and spices', 5.99, 'Side', TRUE),
(57, 'Corn Salad', 'Fresh corn with peppers and herbs', 6.49, 'Salad', TRUE),
(57, 'Churros', 'Fried dough with cinnamon sugar', 6.99, 'Dessert', TRUE),

-- menu_id = 58 (Full)
(58, 'Vegan Burger', 'Plant-based patty with lettuce and tomato', 13.99, 'Main', TRUE),
(58, 'Sweet Potato Fries', 'Crispy sweet potato fries', 5.49, 'Side', TRUE),
(58, 'Quinoa Salad', 'Quinoa with vegetables and lemon dressing', 8.99, 'Salad', TRUE),
(58, 'Hummus & Pita', 'Chickpea dip with pita bread', 6.49, 'Appetizer', TRUE),
(58, 'Fruit Sorbet', 'Assorted fruit sorbets', 5.99, 'Dessert', TRUE),

-- menu_id = 59 (Full)
(59, 'Lobster Roll', 'Lobster salad in a toasted bun', 24.99, 'Main', TRUE),
(59, 'Clam Chowder', 'Creamy New England clam chowder', 7.99, 'Soup', TRUE),
(59, 'Coleslaw', 'Cabbage salad with dressing', 4.99, 'Side', TRUE),
(59, 'Potato Chips', 'Crunchy potato chips', 2.99, 'Side', TRUE),
(59, 'Blueberry Pie', 'Fresh blueberry pie', 6.99, 'Dessert', TRUE);

SELECT * FROM dish;

INSERT INTO waiters (name, restaurant_id) VALUES
('John Smith', 1),
('Emily Johnson', 1),
('Michael Brown', 2),
('Sarah Davis', 2),
('David Wilson', 3),
('Laura Martinez', 3),
('James Taylor', 4),
('Megan Anderson', 4),
('Robert Thomas', 5),
('Jessica Moore', 5),
('William White', 6),
('Ashley Harris', 6),
('Joseph Martin', 7),
('Amanda Thompson', 7),
('Charles Garcia', 8),
('Jennifer Martinez', 8),
('Daniel Robinson', 9),
('Patricia Clark', 9),
('Matthew Rodriguez', 10),
('Kimberly Lewis', 10),
('Anthony Lee', 11),
('Elizabeth Walker', 11),
('Mark Hall', 12),
('Nancy Allen', 12),
('Steven Young', 13),
('Karen Hernandez', 13),
('Paul King', 14),
('Lisa Wright', 14),
('Andrew Scott', 15),
('Michelle Green', 15),
('Joshua Baker', 16),
('Angela Adams', 16),
('Kevin Nelson', 17),
('Stephanie Carter', 17),
('Brian Mitchell', 18),
('Rebecca Perez', 18),
('Edward Roberts', 19),
('Laura Turner', 19),
('Jason Phillips', 20),
('Rachel Campbell', 20),
('Jeffrey Parker', 21),
('Melissa Evans', 21),
('Ryan Edwards', 22),
('Amy Collins', 22),
('Jacob Stewart', 23),
('Angela Sanchez', 23),
('Gary Morris', 24),
('Emily Rogers', 24),
('Justin Reed', 25),
('Megan Cook', 25),
('Scott Morgan', 26),
('Jessica Bell', 26),
('Eric Murphy', 27),
('Sara Bailey', 27),
('Brandon Rivera', 28),
('Anna Cooper', 28),
('Gregory Richardson', 29),
('Heather Cox', 29),
('Benjamin Howard', 30),
('Nicole Ward', 30),
('Patrick Brooks', 31),
('Laura Sanders', 31),
('Sean Price', 32),
('Katherine Bennett', 32),
('Dylan Wood', 33),
('Emily Barnes', 33),
('Jonathan Ross', 34),
('Olivia Henderson', 34),
('Aaron Coleman', 35),
('Samantha Jenkins', 35),
('Timothy Perry', 36),
('Natalie Powell', 36),
('Justin Long', 37),
('Morgan Patterson', 37),
('Adam Hughes', 38),
('Vanessa Flores', 38),
('Charles Bryant', 39),
('Stephanie Simmons', 39),
('Jason Foster', 40),
('Melanie Butler', 40),
('Jacob Gonzalez', 41),
('Amanda Fisher', 41),
('Mark Simmons', 42),
('Laura Simmons', 42),
('Derek Russell', 43),
('Paula Jenkins', 43),
('Shawn Powell', 44),
('Cynthia Bryant', 44),
('Brandon Griffin', 45),
('Kimberly Russell', 45),
('Keith Price', 46),
('Tina Hamilton', 46),
('Joseph Perry', 47),
('Karen Patterson', 47),
('Ryan Myers', 48),
('Jessica Ross', 48),
('Tyler Ross', 49),
('Heather Ross', 49),
('Samuel Brooks', 50),
('Victoria Morgan', 50);

SELECT * FROM waiters;

INSERT INTO customers (first_name, last_name, phone_number, email) VALUES
('John', 'Smith', '416-555-1001', 'john.smith@example.com'),
('Emma', 'Johnson', '416-555-1002', 'emma.johnson@example.com'),
('Liam', 'Williams', '416-555-1003', 'liam.williams@example.com'),
('Olivia', 'Brown', '416-555-1004', 'olivia.brown@example.com'),
('Noah', 'Jones', '416-555-1005', 'noah.jones@example.com'),
('Ava', 'Garcia', '416-555-1006', 'ava.garcia@example.com'),
('Sophia', 'Miller', '416-555-1007', 'sophia.miller@example.com'),
('Jackson', 'Davis', '416-555-1008', 'jackson.davis@example.com'),
('Isabella', 'Martinez', '416-555-1009', 'isabella.martinez@example.com'),
('Lucas', 'Rodriguez', '416-555-1010', 'lucas.rodriguez@example.com'),
('Mia', 'Lopez', '416-555-1011', 'mia.lopez@example.com'),
('Ethan', 'Gonzalez', '416-555-1012', 'ethan.gonzalez@example.com'),
('Amelia', 'Wilson', '416-555-1013', 'amelia.wilson@example.com'),
('James', 'Anderson', '416-555-1014', 'james.anderson@example.com'),
('Harper', 'Thomas', '416-555-1015', 'harper.thomas@example.com'),
('Benjamin', 'Taylor', '416-555-1016', 'benjamin.taylor@example.com'),
('Charlotte', 'Moore', '416-555-1017', 'charlotte.moore@example.com'),
('Elijah', 'Jackson', '416-555-1018', 'elijah.jackson@example.com'),
('Abigail', 'Martin', '416-555-1019', 'abigail.martin@example.com'),
('Henry', 'Lee', '416-555-1020', 'henry.lee@example.com'),
('Ella', 'Perez', '416-555-1021', 'ella.perez@example.com'),
('Alexander', 'White', '416-555-1022', 'alexander.white@example.com'),
('Grace', 'Harris', '416-555-1023', 'grace.harris@example.com'),
('Sebastian', 'Sanchez', '416-555-1024', 'sebastian.sanchez@example.com'),
('Chloe', 'Clark', '416-555-1025', 'chloe.clark@example.com'),
('Daniel', 'Ramirez', '416-555-1026', 'daniel.ramirez@example.com'),
('Victoria', 'Lewis', '416-555-1027', 'victoria.lewis@example.com'),
('Matthew', 'Robinson', '416-555-1028', 'matthew.robinson@example.com'),
('Scarlett', 'Walker', '416-555-1029', 'scarlett.walker@example.com'),
('David', 'Young', '416-555-1030', 'david.young@example.com'),
('Aria', 'Allen', '416-555-1031', 'aria.allen@example.com'),
('Joseph', 'King', '416-555-1032', 'joseph.king@example.com'),
('Lily', 'Wright', '416-555-1033', 'lily.wright@example.com'),
('Samuel', 'Scott', '416-555-1034', 'samuel.scott@example.com'),
('Zoey', 'Torres', '416-555-1035', 'zoey.torres@example.com'),
('Carter', 'Nguyen', '416-555-1036', 'carter.nguyen@example.com'),
('Penelope', 'Hill', '416-555-1037', 'penelope.hill@example.com'),
('Owen', 'Flores', '416-555-1038', 'owen.flores@example.com'),
('Layla', 'Green', '416-555-1039', 'layla.green@example.com'),
('Wyatt', 'Adams', '416-555-1040', 'wyatt.adams@example.com'),
('Riley', 'Nelson', '416-555-1041', 'riley.nelson@example.com'),
('Gabriel', 'Baker', '416-555-1042', 'gabriel.baker@example.com'),
('Nora', 'Hall', '416-555-1043', 'nora.hall@example.com'),
('Jack', 'Rivera', '416-555-1044', 'jack.rivera@example.com'),
('Hannah', 'Campbell', '416-555-1045', 'hannah.campbell@example.com'),
('Levi', 'Mitchell', '416-555-1046', 'levi.mitchell@example.com'),
('Lillian', 'Carter', '416-555-1047', 'lillian.carter@example.com'),
('Mason', 'Roberts', '416-555-1048', 'mason.roberts@example.com'),
('Evelyn', 'Phillips', '416-555-1049', 'evelyn.phillips@example.com'),
('Hudson', 'Evans', '416-555-1050', 'hudson.evans@example.com');

SELECT * FROM customers;

INSERT INTO tables (restaurant_id, table_number, capacity) VALUES
(1, 1, 4),
(1, 2, 2),

(2, 1, 4),
(2, 2, 6),

(3, 1, 2),
(3, 2, 4),

(4, 1, 4),
(4, 2, 6),

(5, 1, 2),
(5, 2, 4),

(6, 1, 6),
(6, 2, 4),

(7, 1, 2),
(7, 2, 4),

(8, 1, 4),
(8, 2, 6),

(9, 1, 2),
(9, 2, 4),

(10, 1, 6),
(10, 2, 4),

(11, 1, 2),
(11, 2, 4),

(12, 1, 4),
(12, 2, 6),

(13, 1, 2),
(13, 2, 4),

(14, 1, 4),
(14, 2, 6),

(15, 1, 2),
(15, 2, 4),

(16, 1, 4),
(16, 2, 6),

(17, 1, 2),
(17, 2, 4),

(18, 1, 6),
(18, 2, 4),

(19, 1, 2),
(19, 2, 4),

(20, 1, 4),
(20, 2, 6),

(21, 1, 2),
(21, 2, 4),

(22, 1, 4),
(22, 2, 6),

(23, 1, 2),
(23, 2, 4),

(24, 1, 4),
(24, 2, 6),

(25, 1, 2),
(25, 2, 4),

(26, 1, 4),
(26, 2, 6),

(27, 1, 2),
(27, 2, 4),

(28, 1, 4),
(28, 2, 6),

(29, 1, 2),
(29, 2, 4),

(30, 1, 4),
(30, 2, 6),

(31, 1, 2),
(31, 2, 4),

(32, 1, 4),
(32, 2, 6),

(33, 1, 2),
(33, 2, 4),

(34, 1, 4),
(34, 2, 6),

(35, 1, 2),
(35, 2, 4),

(36, 1, 4),
(36, 2, 6),

(37, 1, 2),
(37, 2, 4),

(38, 1, 4),
(38, 2, 6),

(39, 1, 2),
(39, 2, 4),

(40, 1, 4),
(40, 2, 6),

(41, 1, 2),
(41, 2, 4),

(42, 1, 4),
(42, 2, 6),

(43, 1, 2),
(43, 2, 4),

(44, 1, 4),
(44, 2, 6),

(45, 1, 2),
(45, 2, 4),

(46, 1, 4),
(46, 2, 6),

(47, 1, 2),
(47, 2, 4),

(48, 1, 4),
(48, 2, 6),

(49, 1, 2),
(49, 2, 4),

(50, 1, 4),
(50, 2, 6);


INSERT INTO reservations (customer_id, table_id, reservation_time, status) VALUES
(1, 1, '2025-08-10 19:00:00', 'completed'),
(2, 2, '2025-08-11 20:30:00', 'completed'),
(3, 3, '2025-08-12 18:45:00', 'cancelled'),
(4, 4, '2025-08-15 13:00:00', 'confirmed'),
(5, 5, '2025-08-20 19:30:00', 'pending'),
(6, 6, '2025-08-21 20:00:00', 'confirmed'),
(7, 7, '2025-07-25 18:00:00', 'completed'),
(8, 8, '2025-07-30 19:15:00', 'completed'),
(9, 9, '2025-08-01 20:00:00', 'cancelled'),
(10, 10, '2025-08-22 21:00:00', 'pending'),

(11, 11, '2025-08-13 12:30:00', 'confirmed'),
(12, 12, '2025-08-14 19:00:00', 'pending'),
(13, 13, '2025-08-09 18:00:00', 'completed'),
(14, 14, '2025-08-05 19:00:00', 'completed'),
(15, 15, '2025-08-24 20:30:00', 'confirmed'),
(16, 16, '2025-08-16 18:00:00', 'pending'),
(17, 17, '2025-08-18 19:45:00', 'confirmed'),
(18, 18, '2025-08-19 20:15:00', 'confirmed'),
(19, 19, '2025-08-07 19:00:00', 'completed'),
(20, 20, '2025-08-25 21:00:00', 'pending'),

(21, 21, '2025-08-02 18:30:00', 'cancelled'),
(22, 22, '2025-08-03 20:00:00', 'completed'),
(23, 23, '2025-08-23 19:00:00', 'confirmed'),
(24, 24, '2025-08-17 18:00:00', 'pending'),
(25, 25, '2025-08-26 19:30:00', 'pending'),
(26, 26, '2025-07-28 18:45:00', 'completed'),
(27, 27, '2025-08-27 20:00:00', 'confirmed'),
(28, 28, '2025-08-28 21:00:00', 'pending'),
(29, 29, '2025-08-29 19:15:00', 'confirmed'),
(30, 30, '2025-08-04 18:00:00', 'completed'),

(31, 31, '2025-08-30 19:00:00', 'pending'),
(32, 32, '2025-09-01 20:30:00', 'pending'),
(33, 33, '2025-09-02 19:45:00', 'pending'),
(34, 34, '2025-09-03 18:15:00', 'pending'),
(35, 35, '2025-09-04 20:00:00', 'pending'),
(36, 36, '2025-09-05 19:30:00', 'pending'),
(37, 37, '2025-09-06 21:00:00', 'pending'),
(38, 38, '2025-09-07 19:00:00', 'pending'),
(39, 39, '2025-09-08 18:00:00', 'pending'),
(40, 40, '2025-09-09 20:30:00', 'pending'),

(41, 41, '2025-08-14 18:45:00', 'confirmed'),
(42, 42, '2025-08-12 19:30:00', 'completed'),
(43, 43, '2025-08-11 20:00:00', 'cancelled'),
(44, 44, '2025-08-10 21:15:00', 'completed'),
(45, 45, '2025-08-09 18:30:00', 'completed'),
(46, 46, '2025-08-08 19:45:00', 'completed'),
(47, 47, '2025-08-07 20:00:00', 'completed'),
(48, 48, '2025-08-06 19:15:00', 'completed'),
(49, 49, '2025-08-05 18:30:00', 'completed'),
(50, 50, '2025-08-04 20:00:00', 'completed');


INSERT INTO orders (customer_id, waiter_id, order_time, status) VALUES
(1, 5, '2025-08-10 19:05:00', 'completed'),
(2, 6, '2025-08-10 19:30:00', 'completed'),
(3, 7, '2025-08-11 12:15:00', 'completed'),
(4, 8, '2025-08-11 13:00:00', 'completed'),
(5, 9, '2025-08-12 20:00:00', 'cancelled'),

(6, 10, '2025-08-12 18:45:00', 'completed'),
(7, 11, '2025-08-13 19:30:00', 'completed'),
(8, 12, '2025-08-13 20:15:00', 'pending'),
(9, 13, '2025-08-14 18:00:00', 'in_progress'),
(10, 14, '2025-08-14 19:45:00', 'pending'),

(11, 15, '2025-08-15 12:30:00', 'completed'),
(12, 16, '2025-08-15 13:15:00', 'completed'),
(13, 17, '2025-08-16 19:00:00', 'completed'),
(14, 18, '2025-08-16 20:00:00', 'completed'),
(15, 19, '2025-08-17 18:30:00', 'cancelled'),

(16, 20, '2025-08-17 19:15:00', 'pending'),
(17, 21, '2025-08-18 20:45:00', 'in_progress'),
(18, 22, '2025-08-19 21:00:00', 'pending'),
(19, 23, '2025-08-19 19:00:00', 'completed'),
(20, 24, '2025-08-20 18:30:00', 'completed'),

(21, 25, '2025-08-20 20:15:00', 'completed'),
(22, 26, '2025-08-21 18:45:00', 'completed'),
(23, 27, '2025-08-21 19:30:00', 'pending'),
(24, 28, '2025-08-22 20:00:00', 'in_progress'),
(25, 29, '2025-08-22 21:15:00', 'pending'),

(26, 30, '2025-08-23 19:00:00', 'completed'),
(27, 31, '2025-08-24 18:30:00', 'completed'),
(28, 32, '2025-08-24 20:00:00', 'cancelled'),
(29, 33, '2025-08-25 19:45:00', 'completed'),
(30, 34, '2025-08-25 21:00:00', 'completed'),

(31, 35, '2025-08-26 18:15:00', 'pending'),
(32, 36, '2025-08-26 19:30:00', 'pending'),
(33, 37, '2025-08-27 20:45:00', 'pending'),
(34, 38, '2025-08-28 19:00:00', 'in_progress'),
(35, 39, '2025-08-28 18:45:00', 'completed'),

(36, 40, '2025-08-29 20:15:00', 'completed'),
(37, 41, '2025-08-30 19:00:00', 'completed'),
(38, 42, '2025-08-30 20:30:00', 'pending'),
(39, 43, '2025-08-31 18:30:00', 'pending'),
(40, 44, '2025-08-31 19:45:00', 'pending'),

(41, 45, '2025-09-01 20:00:00', 'pending'),
(42, 46, '2025-09-02 19:00:00', 'pending'),
(43, 47, '2025-09-02 20:15:00', 'pending'),
(44, 48, '2025-09-03 18:30:00', 'pending'),
(45, 49, '2025-09-03 19:45:00', 'pending'),

(46, 50, '2025-09-04 20:30:00', 'pending'),
(47, 1,  '2025-09-05 18:15:00', 'pending'),
(48, 2,  '2025-09-05 19:00:00', 'pending'),
(49, 3,  '2025-09-06 20:00:00', 'pending'),
(50, 4,  '2025-09-06 21:00:00', 'pending');


INSERT INTO order_items (order_id, dish_id, quantity) VALUES
(1, 2, 1),
(1, 5, 2),
(1, 9, 1),

(2, 7, 1),
(2, 12, 1),

(3, 15, 3),
(3, 22, 1),

(4, 4, 2),
(4, 19, 1),

(5, 3, 1),
(5, 8, 2),

(6, 14, 1),
(6, 20, 1),
(6, 25, 1),

(7, 11, 1),
(7, 24, 2),

(8, 10, 1),

(9, 13, 2),
(9, 16, 1),

(10, 6, 1),
(10, 18, 3),

(11, 17, 1),
(11, 21, 1),

(12, 23, 2),
(12, 27, 1),

(13, 28, 1),
(13, 29, 1),
(13, 30, 1),

(14, 31, 1),
(14, 33, 1),

(15, 34, 2),

(16, 35, 1),
(16, 36, 2),

(17, 37, 1),
(17, 38, 1),

(18, 39, 2),

(19, 40, 1),
(19, 41, 1),

(20, 42, 1),

(21, 43, 1),
(21, 44, 1),

(22, 45, 1),

(23, 46, 2),

(24, 47, 1),
(24, 48, 2),

(25, 49, 1),

(26, 50, 1),

(27, 1, 1),
(27, 5, 1),

(28, 2, 2),

(29, 3, 1),
(29, 7, 1),

(30, 8, 2),

(31, 9, 1),
(31, 10, 1),

(32, 11, 1),
(32, 12, 1),

(33, 13, 1),
(33, 14, 1),

(34, 15, 1),

(35, 16, 2),

(36, 17, 1),

(37, 18, 1),
(37, 19, 1),

(38, 20, 1),

(39, 21, 2),

(40, 22, 1),

(41, 23, 1),

(42, 24, 1),

(43, 25, 2),

(44, 26, 1),

(45, 27, 1),

(46, 28, 1),

(47, 29, 1),

(48, 30, 2),

(49, 31, 1),

(50, 32, 1);

SELECT * FROM order_items;

SELECT d.dish_id, d.name, COUNT(oi.order_item_id) AS times_ordered, r.name
        FROM order_items oi
        JOIN dish d ON oi.dish_id = d.dish_id
        JOIN menu m on d.menu_id = m.menu_id
        JOIN restaurants r on m.restaurant_id = r.restaurant_id
        GROUP BY d.dish_id
        ORDER BY times_ordered DESC
        LIMIT 6;
        
SELECT * FROM restaurants r
JOIN locations l ON r.location_id = r.location_id
WHERE l.city = "montReal";

SELECT 
    r.restaurant_id, 
    r.name, 
    r.cuisine, 
    COUNT(res.reservation_id) AS total_reservations, 
    l.province, 
    l.city
FROM restaurants r
JOIN locations l 
    ON r.location_id = l.location_id
JOIN tables t 
    ON r.restaurant_id = t.restaurant_id
LEFT JOIN reservations res 
    ON t.table_id = res.table_id
GROUP BY r.restaurant_id, r.name, r.cuisine, l.province, l.city;

SELECT * FROM restaurants;

SELECT d.dish_id, d.name, COUNT(oi.order_item_id) AS times_ordered, r.name, l.city, l.province
        FROM order_items oi
        RIGHT JOIN dish d ON oi.dish_id = d.dish_id
        JOIN menu m on d.menu_id = m.menu_id
        JOIN restaurants r on m.restaurant_id = r.restaurant_id
        JOIN locations l on r.location_id = l.location_id
        GROUP BY d.dish_id
        ORDER BY times_ordered DESC;
        
SELECT * FROM dish WHERE name like "Potato%";
