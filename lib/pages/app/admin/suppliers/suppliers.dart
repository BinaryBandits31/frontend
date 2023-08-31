import 'package:flutter/material.dart';
import 'package:frontend/models/supplier.dart';
import 'package:frontend/pages/app/admin/suppliers/create_supplier_dialog.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/providers/supplier_provider.dart';
import 'package:frontend/widgets/data_page.dart';
import 'package:provider/provider.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final supplierProvider =
          Provider.of<SupplierProvider>(context, listen: false);
      if (supplierProvider.suppliers.isEmpty) {
        await supplierProvider.fetchSuppliers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = Provider.of<AppProvider>(context, listen: false)
        .pathTitle!
        .split(' > ')[1];
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final suppliers = supplierProvider.filteredSuppliers;

    return DataPage(
      refreshPageFunction: supplierProvider.fetchSuppliers,
      isLoading: supplierProvider.isLoading,
      dataList: suppliers,
      pageTitle: pageTitle,
      searchFunction: supplierProvider.searchSupplier,
      columnNames: const [
        'DATE CREATED',
        'SUPPLIER',
        'PHONE',
        'EMAIL',
        'ADDRESS',
      ],
      createNewDialog: CreateSupplierDialog(),
      source: SupplierDataTableSource(suppliers),
      adminPage: true,
    );
  }
}

class SupplierDataTableSource extends DataTableSource {
  final List<Supplier> suppliers;

  SupplierDataTableSource(this.suppliers);

  @override
  DataRow? getRow(int index) {
    if (index >= suppliers.length) return null;
    final supplier = suppliers[index];
    return DataRow(cells: [
      DataCell(Text(supplier.dateCreated!)),
      DataCell(Text(supplier.name)),
      DataCell(Text(supplier.phone)),
      DataCell(Text(supplier.email)),
      DataCell(Text(supplier.address)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => suppliers.length;

  @override
  int get selectedRowCount => 0;
}
