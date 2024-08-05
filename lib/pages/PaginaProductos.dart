import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pry_crud/pages/AgregarProducto.dart';
import 'package:pry_crud/pages/EditarProductos.dart';
import 'package:pry_crud/pages/EliminarProducto.dart'; // Importa la nueva página

class Paginaproductos extends StatefulWidget {
  const Paginaproductos({super.key});

  @override
  State<Paginaproductos> createState() => _PaginaproductosState();
}

class _PaginaproductosState extends State<Paginaproductos> {
  List<Map<String, dynamic>> _listdata = [];
  bool _loading = true;

  Future<void> _obtenerDatos() async {
    try {
      final respuesta = await http.get(Uri.parse("http://localhost/crud_04/pry_crud/conexion.php"));

      print('Código de estado: ${respuesta.statusCode}');
      print('Cuerpo de respuesta: ${respuesta.body}');

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        if (datos is List) {
          setState(() {
            _listdata = datos.map((item) {
              return {
                'id': int.parse(item['id_producto']), // Asegúrate de convertir a entero
                'nombre_producto': item['nombre_producto'] ?? 'Nombre no disponible',
                'precio_producto': item['precio_producto'] ?? 'Precio no disponible',
              };
            }).toList();
            _loading = false;
          });
        } else {
          print('La respuesta no es una lista de datos: $datos');
        }
      } else {
        print('La respuesta del servidor: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
  }

  Future<void> _eliminarProducto(int id) async {
    final respuesta = await http.post(
      Uri.parse("http://localhost/crud_04/pry_crud/delete.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': id}),
    );

    if (respuesta.statusCode == 200) {
      final resultado = jsonDecode(respuesta.body);
      if (resultado['mensaje'] == 'Éxito') {
        _obtenerDatos();
      } else {
        print('Error al eliminar el producto: ${resultado['error']}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _obtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PRODUCTOS DEL VALLE"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                final item = _listdata[index];
                return Card(
                  child: ListTile(
                    title: Text(item['nombre_producto'] ?? 'Nombre no disponible'),
                    subtitle: Text(item['precio_producto'] ?? 'Precio no disponible'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarProducto(
                                  id: item['id'],
                                  nombre: item['nombre_producto'],
                                  precio: item['precio_producto'],
                                ),
                              ),
                            ).then((_) => _obtenerDatos());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EliminarProducto(
                                  id: item['id'],
                                  nombre: item['nombre_producto'],
                                  precio: item['precio_producto'],
                                ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                _obtenerDatos();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarProducto()),
          ).then((_) => _obtenerDatos());
        },
      ),
    );
  }
}
