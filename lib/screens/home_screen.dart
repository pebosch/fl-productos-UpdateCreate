import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final ProductosService = Provider.of<ProductosServices>(context);

    if( ProductosService.isLoading ) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: ProductosService.productos.length,
        itemBuilder: ( BuildContext context, int index) => GestureDetector(
          onTap: () {
            ProductosService.productoSeleccionado = ProductosService.productos[index].copy();
            Navigator.pushNamed(context, 'product');
          }, 
          child: ProductCard(
            producto: ProductosService.productos[index],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon ( Icons.add ),
        onPressed: () {
          ProductosService.productoSeleccionado = new Producto(
            disponible: true,
            nombre: '',
            precio: 0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
   );
  }
}