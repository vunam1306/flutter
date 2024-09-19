<?php
$host = 'localhost';  // Địa chỉ MySQL
$dbname = 'users_db'; // Tên cơ sở dữ liệu
$username = 'root';   // Username của MySQL
$password = '';       // Password của MySQL

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['username'];
    $pass = password_hash($_POST['password'], PASSWORD_BCRYPT); // Mã hóa mật khẩu

    $stmt = $conn->prepare("INSERT INTO users (username, password) VALUES (?, ?)");
    $stmt->bind_param("ss", $user, $pass);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "User registered successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to register user"]);
    }

    $stmt->close();
}
$conn->close();
?>
