import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_registration_di.dart';
import 'presentation/pages/product_registration_page.dart';

class ProductRegistrationWrapper extends StatelessWidget {
  const ProductRegistrationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductRegistrationDI.createProductRegistrationBloc(),
      child: const ProductRegistrationPage(),
    );
  }
}