<?php
$host = "localhost";
$user = "root";
$password = "";
$dbname = "bookmanagement";

$conn = new mysqli($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed"]));
}
?>
