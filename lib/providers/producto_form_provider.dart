import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Producto? producto;

  ProductoFormProvider( this.producto );

  updateAvailability( bool value ) {
    this.producto?.disponible = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}