import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductosServices extends ChangeNotifier {
  final String _baseURL = 'fl-productos-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Producto> productos = [];
  Producto? productoSeleccionado;

  bool isLoading = true;
  bool isSaving = false;

  ProductosServices() {
    this.loadProductos();
  }

  Future<List<Producto>> loadProductos() async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseURL, 'productos.json');
    final resp = await http.get( url );

    final Map<String, dynamic> productosMap = json.decode( resp.body );

    productosMap.forEach((key, value) {
      final tempProduct = Producto.fromMap( value );
      tempProduct.id = key;
      this.productos.add( tempProduct );
    });

    this.isLoading = false;
    notifyListeners();

    return this.productos;
  }
    
  Future saveOrCreateProducto( Producto producto ) async {
      isSaving = true;
      notifyListeners();

      if ( producto.id == null ) {
        // Crear
        await this.createProducto(producto);
      } else {
        // Actualizar
        await this.updateProducto(producto);
      }

      isSaving = false;
      notifyListeners();

    }
  

  Future<String> updateProducto( Producto producto ) async {
      final url = Uri.https( _baseURL, 'productos/${ producto.id }.json');
      final resp = await http.put( url, body:  producto.toJson() );
      final decodedData = resp.body;

      final index = this.productos.indexWhere((element) => element.id == producto.id );
      this.productos[index] = producto;

      return producto.id!;
    }

    Future<String> createProducto( Producto producto ) async {
      final url = Uri.https( _baseURL, 'productos.json');
      final resp = await http.post( url, body:  producto.toJson() );
      final decodedData = json.decode( resp.body );

      producto.id = decodedData['nombre'];

      print('producto.id');

      this.productos.add(producto);

      return producto.id!;
    }
}