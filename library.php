<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Database connection
$host = "localhost";
$username = "root";
$password = "";
$database = "bookmanagement";

$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// Query to get all products
$sql = "SELECT * FROM products";
$result = $conn->query($sql);

$products = [];
$imageBaseUrl = "http://10.0.2.2/flutter_api/assets/";

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Attach full image URL
        $row['image_url'] = $imageBaseUrl . $row['image_url'];
        $products[] = $row;
    }
    echo json_encode(["status" => "success", "products" => $products]);
} else {
    echo json_encode(["status" => "success", "products" => []]);
}

$conn->close();
?>
