<?php
// Encabezados CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Configuración de la base de datos
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_productos_04";

// Crear conexión
$connect = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($connect->connect_error) {
    die("Conexión fallida: " . $connect->connect_error);
}

// Obtener datos del POST
$input = json_decode(file_get_contents('php://input'), true);
$nombre_producto = isset($input['nombre_producto']) ? $connect->real_escape_string($input['nombre_producto']) : '';
$precio_producto = isset($input['precio_producto']) ? $connect->real_escape_string($input['precio_producto']) : '';

// Agregar logs para depuración
error_log("Nombre del producto: $nombre_producto");
error_log("Precio del producto: $precio_producto");

// Validar datos
if (empty($nombre_producto) || empty($precio_producto)) {
    error_log('Datos incompletos'); // Agregar log
    echo json_encode(['mensaje' => 'Error', 'error' => 'Datos incompletos']);
    $connect->close();
    exit();
}

// Preparar y ejecutar la consulta SQL
$sql = "INSERT INTO tb_productos_04 (nombre_producto, precio_producto) VALUES ('$nombre_producto', '$precio_producto')";

if ($connect->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Éxito']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connect->error]);
}

// Cerrar conexión
$connect->close();
?>
