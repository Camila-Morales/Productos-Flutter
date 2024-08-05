import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EliminarProducto extends StatefulWidget {
  final int id;
  final String nombre;
  final String precio;

  const EliminarProducto({
    super.key,
    required this.id,
    required this.nombre,
    required this.precio,
  });

  @override
  State<EliminarProducto> createState() => _EliminarProductoState();
}

class _EliminarProductoState extends State<EliminarProducto> {
  Future<void> _eliminar() async {
    try {
      final respuesta = await http.post(
        Uri.parse("http://localhost/crud_04/pry_crud/delete.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'id': widget.id}),
      );

      if (respuesta.statusCode == 200) {
        final resultado = jsonDecode(respuesta.body);
        if (resultado['mensaje'] == 'Éxito') {
          Navigator.pop(context, true);
        } else {
          print('Error del servidor: ${resultado['error']}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al eliminar el producto')),
          );
        }
      } else {
        print('Código de estado: ${respuesta.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el producto')),
        );
      }
    } catch (e) {
      print('Excepción: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eliminar Producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '¿Está seguro de que desea eliminar el producto "${widget.nombre}"?',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _eliminar();
              },
              child: const Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
