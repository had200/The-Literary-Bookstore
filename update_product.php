<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$host = "localhost";
$db = "bookmanagement";
$user = "root";
$pass = "";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$data = json_decode(file_get_contents("php://input"));

$id = $data->id;
$title = $data->title;
$category = $data->category;
$description = $data->description;
$price = $data->price;
$image_url = $data->image_url;

$stmt = $conn->prepare("UPDATE products SET title=?, category=?, description=?, price=?, image_url=? WHERE id=?");
$stmt->bind_param("sssssi", $title, $category, $description, $price, $image_url, $id);

if ($stmt->execute()) {
    echo json_encode(["message" => "Product updated successfully"]);
} else {
    echo json_encode(["error" => "Unable to update product"]);
}

$conn->close();
?>