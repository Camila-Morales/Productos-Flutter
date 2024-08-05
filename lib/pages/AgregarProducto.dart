import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgregarProducto extends StatefulWidget {
  const AgregarProducto({super.key});

  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreProducto = TextEditingController();
  TextEditingController precioProducto = TextEditingController();

  Future<bool> _agregar() async {
    try {
      print('Nombre del producto: ${nombreProducto.text}');
      print('Precio del producto: ${precioProducto.text}');

      final respuesta = await http.post(
        Uri.parse("http://localhost/crud_04/pry_crud/create.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'nombre_producto': nombreProducto.text,
          'precio_producto': precioProducto.text,
        }),
      );

      print('Código de estado: ${respuesta.statusCode}');
      print('Cuerpo de respuesta: ${respuesta.body}');

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
        title: const Text("Agregar Producto"),
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
                    bool success = await _agregar();
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
