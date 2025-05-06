<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$host = "localhost";
$db = "bookmanagement";
$user = "root";
$pass = "";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$sql = "SELECT * FROM products";
$result = $conn->query($sql);

if (!$result) {
    die(json_encode(["error" => "Query failed: " . $conn->error]));
}

$products = [];

while ($row = $result->fetch_assoc()) {
    if (!empty($row['image_url'])) {
        $row['image_url'] = "http://10.0.2.2/flutter_api/assets/" . $row['image_url'];
    }
    $products[] = $row;
}

echo json_encode($products);

$conn->close();
?>