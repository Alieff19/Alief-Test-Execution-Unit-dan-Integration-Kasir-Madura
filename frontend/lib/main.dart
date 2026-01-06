import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'state/product_controller.dart';
import 'state/toko_controller.dart';
import 'state/cart_controller.dart';
import 'state/kasir_controller.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KasirController()),
        ChangeNotifierProvider(create: (_) => TokoController.http()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
      ],
      child: const KasirMaduraApp(),
    ),
  );
}


class KasirMaduraApp extends StatelessWidget {
  const KasirMaduraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kasir Madura',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      themeAnimationDuration: const Duration(milliseconds: 300),
    );
  }
}
