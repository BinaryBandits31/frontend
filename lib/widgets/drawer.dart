import 'package:flutter/material.dart';
import 'package:frontend/pages/app/admin/branches/branches.dart';
import 'package:frontend/pages/app/admin/products/products.dart';
import 'package:frontend/pages/app/admin/suppliers/suppliers.dart';
import 'package:frontend/pages/app/admin/users/users.dart';
import 'package:frontend/pages/app/inventory_management/products_price.dart';
import 'package:frontend/pages/app/inventory_management/products_stock.dart';
import 'package:frontend/pages/app/orders/sale.dart';
import 'package:frontend/pages/app/orders/stock_purchase.dart';
import 'package:frontend/pages/app/orders/stock_transfer.dart';
import 'package:frontend/pages/app/reports/product_expiry.dart';
import 'package:frontend/providers/user_provider.dart';
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
    final appProvider = Provider.of<AppProvider>(context, listen: true);

    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sH(50)),
        child: ListView(
          children: [
            const DrawerMenuItem(
                title: 'Dashboard',
                page: Dashboard(),
                itemIcon: Icons.home_rounded),
            const DrawerMenu(
              accessLevel: 2,
              icon: Icons.key_outlined,
              text: 'Admin',
              items: [
                DrawerMenuItem(
                  accessLevel: 3,
                  title: 'Company Locations',
                  itemIcon: Icons.maps_home_work_outlined,
                  page: CompanyLocationsPage(),
                ),
                DrawerMenuItem(
                  accessLevel: 2,
                  title: 'Suppliers',
                  itemIcon: Icons.support_agent_outlined,
                  page: SuppliersPage(),
                ),
                DrawerMenuItem(
                  accessLevel: 2,
                  title: 'Products',
                  itemIcon: Icons.interests,
                  page: ProductsPage(),
                ),
                DrawerMenuItem(
                  accessLevel: 2,
                  title: 'Users',
                  itemIcon: Icons.people,
                  page: UsersPage(),
                ),
              ],
            ),
            const DrawerMenu(
              icon: Icons.shopping_cart,
              text: 'Inventory Management',
              items: [
                DrawerMenuItem(
                  title: 'Products Price',
                  itemIcon: Icons.attach_money_outlined,
                  page: ProductPricePage(),
                ),
                DrawerMenuItem(
                  title: 'Products Stock',
                  itemIcon: Icons.library_books_outlined,
                  page: StockItemsPage(),
                ),
              ],
            ),
            const DrawerMenu(
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
            DrawerMenu(
              text: 'Reports',
              icon: Icons.print_outlined,
              items: const [
                DrawerMenuItem(
                  title: 'Product Expiry',
                  itemIcon: Icons.hourglass_bottom_rounded,
                  page: ProductExpiryReportPage(),
                ),
              ],
              hasAlert: appProvider.alerts > 0,
            )
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
  final bool hasAlert;

  const DrawerMenu({
    super.key,
    required this.text,
    required this.icon,
    required this.items,
    this.hasAlert = false,
    this.accessLevel,
  });

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userLevel = userProvider.getLevel();

    return Visibility(
      visible: widget.accessLevel == null
          ? true
          : (userLevel! >= widget.accessLevel!),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.text,
              style: TextStyle(color: expanded ? AppColor.orange3 : null),
            ),
            leading: Icon(
              widget.icon,
              color: expanded
                  ? AppColor.orange3
                  : widget.hasAlert
                      ? Colors.blue
                      : null,
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
  final String? parentName;

  const DrawerMenuItem({
    super.key,
    required this.title,
    required this.page,
    required this.itemIcon,
    this.accessLevel,
    this.parentName,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userLevel = userProvider.getLevel();

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
