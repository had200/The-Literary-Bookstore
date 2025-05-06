<?php
header('Content-Type: application/json');
include 'db.php';

$data = json_decode(file_get_contents("php://input"));

$name = $conn->real_escape_string($data->name);
$email = $conn->real_escape_string($data->email);
$gender = $conn->real_escape_string($data->gender);

$sql = "INSERT INTO users (name, email, gender) VALUES ('$name', '$email', '$gender')";

if ($conn->query($sql)) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $conn->error]);
}
$conn->close();
?>

