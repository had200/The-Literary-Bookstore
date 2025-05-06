<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Database credentials
$dbhost = "localhost";
$dbuser = "root";
$dbpassword = "";
$dbname = "bookmanagement";

// Connect to DB
$conn = new mysqli($dbhost, $dbuser, $dbpassword, $dbname);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "DB connection failed"]);
    exit;
}

// Receive POST data
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

// Validate inputs
if (empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Missing email or password"]);
    exit;
}

// Fetch user
$stmt = $conn->prepare("SELECT password FROM admins WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $storedPassword = $row['password'];

    // Compare directly since it's not hashed
    if ($password === $storedPassword) {
        echo json_encode(["status" => "success", "message" => "Login successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Email not found"]);
}

$stmt->close();
$conn->close();
?>
