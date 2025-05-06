<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$query = $_GET['query'] ?? '';

// Database connection
$host = "localhost";
$username = "root";
$password = "";
$database = "bookmanagement";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

$sql = "SELECT * FROM products WHERE title LIKE ? OR description LIKE ?";
$stmt = $conn->prepare($sql);
$searchTerm = "%$query%";
$stmt->bind_param("ss", $searchTerm, $searchTerm);
$stmt->execute();
$result = $stmt->get_result();

$products = [];
while ($row = $result->fetch_assoc()) {
    // Fix the image URL so it can be loaded from Flutter
    $row['image_url'] = "http://10.0.2.2/flutter_api/assets/" . $row['image_url'];
    $products[] = $row;
}

echo json_encode(["status" => "success", "products" => $products]);

$stmt->close();
$conn->close();
?>
