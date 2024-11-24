USE `buoi21/11`;


-- Bảng products
ALTER TABLE products ADD CONSTRAINT fk_products_categories 
FOREIGN KEY(categoryId) REFERENCES categories(categoryId);
ALTER TABLE products ADD CONSTRAINT fk_products_stores 
FOREIGN KEY(storeId) REFERENCES stores(storeId);
-- Bảng images
ALTER TABLE images ADD CONSTRAINT fk_images_products 
FOREIGN KEY(productId) REFERENCES products(productId);
-- Bảng reviews
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_users 
FOREIGN KEY(userId) REFERENCES users(userId);
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_products 
FOREIGN KEY(productId) REFERENCES products(productId);
-- Bảng carts
ALTER TABLE carts ADD CONSTRAINT fk_carts_users 
FOREIGN KEY(userId) REFERENCES users(userId);
ALTER TABLE carts ADD CONSTRAINT fk_carts_products 
FOREIGN KEY(productId) REFERENCES products(productId);
-- Bảng order_details
ALTER TABLE order_details ADD CONSTRAINT fk_order_details_products 
FOREIGN KEY(productId) REFERENCES products(productId);
ALTER TABLE order_details ADD CONSTRAINT fk_order_details_orders 
FOREIGN KEY(orderId) REFERENCES orders(orderId);
-- Bảng ordres
ALTER TABLE orders ADD CONSTRAINT fk_orders_users 
FOREIGN KEY(userId) REFERENCES users(userId);
ALTER TABLE orders ADD CONSTRAINT fk_orders_stores 
FOREIGN KEY(storeId) REFERENCES stores(storeId);
-- Bảng stores
ALTER TABLE stores ADD CONSTRAINT fk_stores_users 
FOREIGN KEY(userId) REFERENCES users(userId);


 
 
 
 -- ex2
 -- Liệt kê tất cả các thông tin về sản phẩm (products).
 SELECT * FROM `products`;
 --
 SELECT *FROM `orders`
 WHERE totalPrice >500000;
 
 --
 SELECT StoreName,addressStore FROM `stores`;
 --
 SELECT * FROM `users`
 WHERE email LIKE '%@gmail.com';
 
 -- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5.
 SELECT * FROM `reviews`
 WHERE rate ='5';
 --
 SELECT * FROM `products`
 WHERE quantity <10;
--
SELECT * FROM `products`
WHERe   categoryId = 1;
--
SELECT COUNT(*) FROM `users`;

--
SELECT SUM(totalPrice) FROM orders;
--
SELECT MAX(price) FROM products;

--
SELECT * FROM stores 
WHERE statusStore = 1;
--
SELECT COUNT(*) FROM categories;
-- Tìm tất cả các sản phẩm mà chưa từng có đánh giá.
SELECT p.productId, p.productName FROM products p
LEFT JOIN reviews r ON p.productId = r.productId
WHERE r.rate  IS NULL;
-- Hiển thị tổng số lượng hàng đã bán (quantityOrder) của từng sản phẩm. 
SELECT  p.productName, SUM(od.quantityOrder) AS totalQuantitySold
FROM products p
LEFT JOIN order_details od ON p.productId = od.productId
GROUP BY p.productId, p.productName;
-- Tìm các người dùng (users) chưa đặt bất kỳ đơn hàng nào.

SELECT u.userId, u.userName AS idname
FROM users u
LEFT JOIN orders o ON u.userId = o.userId
WHERE o.userId IS NULL;

-- Hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng.

SELECT s.storeName, COUNT(o.orderId) AS totalOrders
FROM stores s
LEFT JOIN orders o ON s.storeId = o.storeId
GROUP BY s.storeId, s.storeName;

-- Hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan
SELECT p.productId, p.productName, COUNT(s.imageId) AS totalImages
FROM products p
LEFT JOIN images s ON p.productId = s.productId
GROUP BY p.productId, p.productName;
 -- Hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình.
SELECT p.productId, p.productName, COUNT(r.reviewId) AS totalReviews, AVG(r.rate) AS averageRating
FROM products p
LEFT JOIN reviews r ON p.productId = r.productId
GROUP BY p.productId, p.productName;
-- TÌM người dùng user chưa đặt bất kì đơn hàng nào


SELECT u.userId, u.userName, COUNT(r.reviewId) AS totalReviews
FROM users u
JOIN reviews r ON u.userId = r.userId
GROUP BY u.userId, u.userName
ORDER BY totalReviews DESC
LIMIT 1;

-- Hiển thị top 3 sản phẩm bán chạy nhhất dựa tren số sp đã bán 
SELECT p.productId, p.productName, SUM(od.quantityOrder) AS totalSold
FROM products p
JOIN order_details od ON p.productId = od.productId
GROUP BY p.productId, p.productName
ORDER BY totalSold DESC
LIMIT 3;


-- Tìm sản phẩm bán chạy nhất tại cửa hàng có storeId = 'S001'.
SELECT p.productId, p.productName, SUM(od.quantityOrder) AS totalSold
FROM products p
JOIN order_details od ON p.productId = od.productId
WHERE p.storeId = 'S001'
GROUP BY p.productId, p.productName
ORDER BY totalSold DESC
LIMIT 1;

-- Hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng).
SELECT p.productId, p.productName, (p.price * p.quantity) AS totalValue
FROM products p
WHERE (p.price * p.quantity) > 1000000;

-- Tìm cửa hàng có tổng doanh thu cao nhất.
SELECT s.storeId, s.storeName, SUM(o.totalPrice) AS total
FROM stores s
JOIN orders o ON s.storeId = o.storeId
GROUP BY s.storeId, s.storeName
ORDER BY total DESC
LIMIT 1;
-- Hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu.
select p.userId, p.userName, SUM(o.totalPrice) AS total
FROM users p
JOIN orders o ON p.userId = o.userId
GROUP BY p.userId, p.userName;
-- Tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết.
SELECT * FROM orders
ORDER BY totalPrice DESC
LIMIT 1;

-- Tìm các đơn hàng được thực hiện bởi người dùng có email là duong@gmail.com'
SELECT o.orderId, o.totalPrice FROM orders o
JOIN users u ON o.userId = u.userId
WHERE u.email = 'duong@gmail.com';
-- Hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu.
SELECT s.storeId, s.storeName, SUM(p.quantity) AS totalProducts
FROM stores s
JOIN products p ON s.storeId = p.storeId
GROUP BY s.storeId, s.storeName;

-- EX4 

CREATE VIEW expensive_products AS
SELECT productName, price
FROM products
WHERE price > 500000;
-- Truy vấn dữ liệu từ view vừa tạo expensive_products
SELECT * FROM expensive_products;
-- Làm thế nào để cập nhật giá trị của view? Ví dụ, cập nhật giá (price) thành 600,000 cho sản phẩm có tên Product A trong view expensive_products.
UPDATE products
SET price = 600000
WHERE productName = 'Product A ';
-- Xóa 
DROP VIEW expensive_products;

-- Tạo view products_categories
CREATE VIEW products_categories AS
SELECT p.productName, c.categoryName FROM products p
INNER JOIN categories c ON c.categoryId = p.categoryId;

-- ex5 
-- Tạo một index trên cột productName của bảng products
CREATE INDEX idx_productName ON products(productName);

-- Hiển thị danh sách các index trong cơ sở dữ liệu
SHOW INDEX FROM products;

-- Xóa index idx_productName đã tạo trước đó
DROP INDEX idx_productName ON products;

-- Tạo một procedure tên getProductByPrice để lấy danh sách sản phẩm với giá lớn hơn một giá trị đầu vào (priceInput)
DELIMITER //
CREATE PROCEDURE getProductByPrice(IN priceInput DECIMAL(10, 2))
BEGIN
    SELECT * FROM products WHERE price > priceInput;
END //
DELIMITER ;

-- Gọi procedure getProductByPrice với đầu vào là 500000
CALL getProductByPrice(500000);
-- Tạo một procedure getOrderDetails trả về thông tin chi tiết đơn hàng với đầu vào là orderId
DELIMITER //
CREATE PROCEDURE getOrderDetails(IN orderId INT)
BEGIN
    SELECT * FROM orderDetails WHERE orderId = orderId;
END //
DELIMITER ;

-- Xóa procedure getOrderDetails
DROP PROCEDURE IF EXISTS getOrderDetails;

-- Tạo procedure addNewProduct để thêm mới một sản phẩm vào bảng products
DELIMITER //
CREATE PROCEDURE addNewProduct(
    IN productName VARCHAR(255),
    IN price DECIMAL(10, 2),
    IN description TEXT,
    IN quantity INT
)
BEGIN
    INSERT INTO products (productName, price, description, quantity)
    VALUES (productName, price, description, quantity);
END //
DELIMITER ;




 