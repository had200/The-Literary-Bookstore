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

// Get category from query parameter
$category = isset($_GET['category']) ? urldecode($_GET['category']) : '';

// Prepare SQL query with category filter
$sql = "SELECT * FROM products WHERE category = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $category);
$stmt->execute();
$result = $stmt->get_result();

$products = [];
$imageBaseUrl = "http://10.0.2.2/flutter_api/assets/";

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Attach full image URL
        $row['image_url'] = $imageBaseUrl . $row['image_url'];
        $products[] = $row;
    }
    echo json_encode(["status" => "success", "products" => $products]);
} else {
    echo json_encode(["status" => "success", "products" => []]);
}

$stmt->close();
$conn->close();
?>