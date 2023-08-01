import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/splash.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/stock_purchase_provider.dart';
import 'package:frontend/providers/stock_transfer_provider.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:frontend/theme/dark_theme.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'providers/org_provider.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<OrgProvider>(create: (_) => OrgProvider()),
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<BranchProvider>(create: (_) => BranchProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider()),
        ChangeNotifierProvider<SupplierProvider>(
            create: (_) => SupplierProvider()),
        ChangeNotifierProvider<StockPurchaseProvider>(
            create: (_) => StockPurchaseProvider()),
        ChangeNotifierProvider<StockTransferProvider>(
            create: (_) => StockTransferProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EPR Frontend',
        home: const SplashPage(),
        theme: darkTheme,
      ),
    );
  }
}
