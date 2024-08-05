import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarProducto extends StatefulWidget {
  final int id;
  final String nombre;
  final String precio;

  const EditarProducto({
    super.key,
    required this.id,
    required this.nombre,
    required this.precio,
  });

  @override
  State<EditarProducto> createState() => _EditarProductoState();
}

class _EditarProductoState extends State<EditarProducto> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nombreProducto;
  late TextEditingController precioProducto;

  @override
  void initState() {
    super.initState();
    nombreProducto = TextEditingController(text: widget.nombre);
    precioProducto = TextEditingController(text: widget.precio);
  }

  Future<bool> _editar() async {
    try {
      final respuesta = await http.post(
        Uri.parse("http://localhost/crud_04/pry_crud/update.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id': widget.id,
          'nombre_producto': nombreProducto.text,
          'precio_producto': precioProducto.text,
        }),
      );

      if (respuesta.statusCode == 200) {
        final resultado = jsonDecode(respuesta.body);
        if (resultado['mensaje'] == 'Éxito') {
          return true;
        } else {
          print('Error del servidor: ${resultado['error']}');
        }
      } else {
        print('Código de estado: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Excepción: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreProducto,
                decoration: const InputDecoration(hintText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: precioProducto,
                decoration: const InputDecoration(hintText: 'Precio del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El precio del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    bool success = await _editar();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos guardados exitosamente')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al guardar los datos')),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
