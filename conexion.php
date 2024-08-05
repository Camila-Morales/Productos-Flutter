<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET");
header("Access-Control-Allow-Headers: Content-Type");

// Configuración de conexión
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_productos_04";

// Crear conexión
$connec = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($connec->connect_error) {
    die(json_encode(['mensaje' => 'Error', 'error' => $connec->connect_error]));
}

// Procesar solicitud POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data['nombre_producto']) && isset($data['precio_producto'])) {
        $nombre = $connec->real_escape_string($data['nombre_producto']);
        $precio = $connec->real_escape_string($data['precio_producto']);

        $query = "INSERT INTO tb_productos_04 (nombre_producto, precio_producto) VALUES ('$nombre', '$precio')";

        if ($connec->query($query) === TRUE) {
            echo json_encode(['mensaje' => 'Éxito']);
        } else {
            echo json_encode(['mensaje' => 'Error', 'error' => $connec->error]);
        }
    } else {
        echo json_encode(['mensaje' => 'Error', 'error' => 'Datos faltantes']);
    }
}

// Procesar solicitud GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $query = "SELECT * FROM tb_productos_04";
    $result = $connec->query($query);

    $data = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }

    echo json_encode($data);
}

// Cerrar conexión
$connec->close();
?>
