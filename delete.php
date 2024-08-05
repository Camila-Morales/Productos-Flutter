<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_productos_04";

$connect = new mysqli($servername, $username, $password, $dbname);

if ($connect->connect_error) {
    die("Conexión fallida: " . $connect->connect_error);
}

$input = json_decode(file_get_contents('php://input'), true);
$id = isset($input['id']) ? $connect->real_escape_string($input['id']) : '';

if (empty($id)) {
    echo json_encode(['mensaje' => 'Error', 'error' => 'Datos incompletos']);
    $connect->close();
    exit();
}

$sql = "DELETE FROM tb_productos_04 WHERE id_producto='$id'";

if ($connect->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Éxito']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connect->error]);
}

$connect->close();
?>
