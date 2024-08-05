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
$nombre_producto = isset($input['nombre_producto']) ? $connect->real_escape_string($input['nombre_producto']) : '';
$precio_producto = isset($input['precio_producto']) ? $connect->real_escape_string($input['precio_producto']) : '';

if (empty($id) || empty($nombre_producto) || empty($precio_producto)) {
    echo json_encode(['mensaje' => 'Error', 'error' => 'Datos incompletos']);
    $connect->close();
    exit();
}

$sql = "UPDATE tb_productos_04 SET nombre_producto='$nombre_producto', precio_producto='$precio_producto' WHERE id_producto='$id'";

if ($connect->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Éxito']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connect->error]);
}

$connect->close();
?>
