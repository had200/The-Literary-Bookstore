<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "bookmanagement";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get POST data from Flutter app
$data = json_decode(file_get_contents('php://input'), true);

// Extract user data
$name = $data['name'];
$email = $data['email'];
$password = password_hash($data['password'], PASSWORD_DEFAULT); // hash the password for security
$gender = $data['gender'];
$profile_image = $data['profile_image'];

// SQL query to insert data into users table
$sql = "INSERT INTO users (name, email, password, gender, profile_image)
VALUES ('$name', '$email', '$password', '$gender', '$profile_image')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $conn->error]);
}

$conn->close();
?>
