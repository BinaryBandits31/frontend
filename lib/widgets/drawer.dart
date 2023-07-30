import 'package:flutter/material.dart';
import 'package:frontend/pages/app/admin/branches/branches.dart';
import 'package:frontend/pages/app/admin/products/products.dart';
import 'package:frontend/pages/app/admin/suppliers/suppliers.dart';
import 'package:frontend/pages/app/admin/users.dart';
import 'package:frontend/pages/app/inventory_management/products_price.dart';
import 'package:frontend/pages/app/inventory_management/products_stock.dart';
import 'package:frontend/pages/app/orders/sale.dart';
import 'package:frontend/pages/app/orders/stock_purchase.dart';
import 'package:frontend/pages/app/orders/stock_transfer.dart';
import 'package:provider/provider.dart';
import '../pages/app/dashboard.dart';
import '../providers/app_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sH(50)),
        child: ListView(
          children: const [
            DrawerMenuItem(
                title: 'Dashboard',
                page: Dashboard(),
                itemIcon: Icons.home_rounded),
            DrawerMenu(
              icon: Icons.key_outlined,
              text: 'Admin',
              items: [
                DrawerMenuItem(
                  title: 'Company Locations',
                  itemIcon: Icons.maps_home_work_outlined,
                  page: CompanyLocationsPage(),
                ),
                DrawerMenuItem(
                  title: 'Suppliers',
                  itemIcon: Icons.support_agent_outlined,
                  page: SuppliersPage(),
                ),
                DrawerMenuItem(
                  title: 'Products',
                  itemIcon: Icons.interests,
                  page: ProductsPage(),
                ),
                DrawerMenuItem(
                  title: 'Users',
                  itemIcon: Icons.people,
                  page: UsersPage(),
                ),
              ],
            ),
            DrawerMenu(
              icon: Icons.shopping_cart,
              text: 'Inventory Management',
              items: [
                DrawerMenuItem(
                  title: 'Products Price',
                  itemIcon: Icons.attach_money_outlined,
                  page: ProductsPricePage(),
                ),
                DrawerMenuItem(
                  title: 'Products Stock',
                  itemIcon: Icons.library_books_outlined,
                  page: ProductStocksPage(),
                ),
              ],
            ),
            DrawerMenu(
              text: 'Orders',
              icon: Icons.receipt_long_outlined,
              items: [
                DrawerMenuItem(
                  title: 'Sales',
                  itemIcon: Icons.attach_money_outlined,
                  page: SalesPage(),
                ),
                DrawerMenuItem(
                  title: 'Stock Transfer',
                  itemIcon: Icons.connect_without_contact_outlined,
                  page: StockTransferPage(),
                ),
                DrawerMenuItem(
                  title: 'Stock Purchase',
                  itemIcon: Icons.handshake,
                  page: StockPurchasePage(),
                ),
              ],
            ),
            DrawerMenu(text: 'Reports', icon: Icons.print_outlined, items: [])
          ],
        ),
      ),
    );
  }
}

class DrawerMenu extends StatefulWidget {
  final String text;
  final IconData icon;
  final List<DrawerMenuItem> items;
  final int? accessLevel;
  final int? userLevel;

  const DrawerMenu({
    super.key,
    required this.text,
    required this.icon,
    required this.items,
    this.accessLevel,
    this.userLevel,
  });

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.accessLevel == null
          ? true
          : (widget.userLevel! >= widget.accessLevel!),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.text,
              style: TextStyle(color: expanded ? AppColor.orange3 : null),
            ),
            leading: Icon(
              widget.icon,
              color: expanded ? AppColor.orange3 : null,
            ),
            trailing: expanded
                ? const Icon(Icons.keyboard_arrow_up_outlined)
                : const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
          ),
          Visibility(
              visible: expanded,
              child: Padding(
                padding: EdgeInsets.only(left: sW(25)),
                child: Column(children: [
                  for (var item in widget.items)
                    DrawerMenuItem(
                      itemIcon: item.itemIcon,
                      page: item.page,
                      title: item.title,
                      accessLevel: item.accessLevel,
                      userLevel: item.userLevel,
                      parentName: widget.text,
                    )
                ]),
              ))
        ],
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final String title;
  final Widget page;
  final IconData itemIcon;
  final int? accessLevel;
  final int? userLevel;
  final String? parentName;

  const DrawerMenuItem({
    super.key,
    required this.title,
    required this.page,
    required this.itemIcon,
    this.accessLevel,
    this.userLevel,
    this.parentName,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: accessLevel == null ? true : (userLevel! >= accessLevel!),
      child: ListTile(
        title: Text(title),
        leading: Icon(itemIcon),
        onTap: () {
          final appProvider = Provider.of<AppProvider>(context, listen: false);

          if (appProvider.pathTitle != title) {
            appProvider.updatedSelectedTitle(
                '${parentName ?? ''}${parentName != null ? '  >  ' : ''}$title');
            appProvider.updateSelectedTab(page);
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
