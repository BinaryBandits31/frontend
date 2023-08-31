import 'package:flutter/material.dart';
import 'package:frontend/pages/app/admin/branches/branches.dart';
import 'package:frontend/pages/app/admin/products/products.dart';
import 'package:frontend/pages/app/admin/raw_materials/raw_materials.dart';
import 'package:frontend/pages/app/admin/suppliers/suppliers.dart';
import 'package:frontend/pages/app/admin/users/users.dart';
import 'package:frontend/pages/app/inventory_management/products_price.dart';
import 'package:frontend/pages/app/inventory_management/products_stock.dart';
import 'package:frontend/pages/app/inventory_management/raw_material_stock.dart';
import 'package:frontend/pages/app/orders/cash_sales.dart';
import 'package:frontend/pages/app/orders/stock_reception.dart';
import 'package:frontend/pages/app/orders/stock_purchase.dart';
import 'package:frontend/pages/app/orders/stock_transfer.dart';
import 'package:frontend/pages/app/reports/product_expiry.dart';
import 'package:frontend/pages/app/reports/activity_logs_page.dart';
import 'package:frontend/providers/org_provider.dart';
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
    final orgProvider = Provider.of<OrgProvider>(context).organization!;

    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sH(50)),
        child: ListView(
          children: [
            const DrawerMenuItem(
                title: 'Dashboard',
                page: Dashboard(),
                itemIcon: Icons.home_rounded),
            DrawerMenu(
              accessLevel: 2,
              icon: Icons.key_outlined,
              text: 'Admin',
              items: [
                const DrawerMenuItem(
                  accessLevel: 3,
                  title: 'Company Locations',
                  itemIcon: Icons.maps_home_work_outlined,
                  page: CompanyLocationsPage(),
                ),
                const DrawerMenuItem(
                  accessLevel: 2,
                  title: 'Suppliers',
                  itemIcon: Icons.support_agent_outlined,
                  page: SuppliersPage(),
                ),
                const DrawerMenuItem(
                  accessLevel: 2,
                  title: 'Products',
                  itemIcon: Icons.interests,
                  page: ProductsPage(),
                ),
                DrawerMenuItem(
                  visibility: orgProvider.isManufacturer,
                  accessLevel: 2,
                  title: 'Raw Materials',
                  itemIcon: Icons.forest,
                  page: const RawMaterialsPage(),
                ),
                const DrawerMenuItem(
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
                  title: 'Raw Materials Stock',
                  itemIcon: Icons.forest,
                  page: RawMaterialStockPage(),
                ),
                DrawerMenuItem(
                  title: 'Products Stock',
                  itemIcon: Icons.interests,
                  page: ProductStockPage(),
                ),
              ],
            ),
            DrawerMenu(
              text: 'Orders',
              icon: Icons.receipt_long_outlined,
              items: [
                const DrawerMenuItem(
                  title: 'Cash Sale',
                  itemIcon: Icons.attach_money_rounded,
                  page: CashSalePage(),
                ),
                DrawerMenuItem(
                  visibility: orgProvider.isManufacturer,
                  accessLevel: 2,
                  title: 'Raw Materials Purchase',
                  itemIcon: Icons.monetization_on_outlined,
                  //TODO: Change page
                  page: const StockPurchasePage(),
                ),
                DrawerMenuItem(
                  visibility: !orgProvider.isManufacturer,
                  accessLevel: 2,
                  title: 'Stock Purchase',
                  itemIcon: Icons.monetization_on_outlined,
                  page: const StockPurchasePage(),
                ),
                const DrawerMenuItem(
                  title: 'Stock Transfer',
                  itemIcon: Icons.connect_without_contact_outlined,
                  page: StockTransferPage(),
                ),
                const DrawerMenuItem(
                  title: 'Stock Reception',
                  itemIcon: Icons.handshake,
                  page: StockReceptionPage(),
                ),
                DrawerMenuItem(
                  visibility: orgProvider.isManufacturer,
                  title: 'Product Fabrication',
                  itemIcon: Icons.factory_sharp,
                  //TODO: Change page
                  page: const StockReceptionPage(),
                ),
              ],
            ),
            DrawerMenu(
              text: 'Reports',
              icon: Icons.print_outlined,
              items: const [
                DrawerMenuItem(
                  accessLevel: 3,
                  title: 'Activity Logs',
                  itemIcon: Icons.history_edu_outlined,
                  page: ActivityLogsPage(),
                ),
                DrawerMenuItem(
                  title: 'Product Expiry',
                  itemIcon: Icons.hourglass_bottom_rounded,
                  page: ProductExpiryReportPage(),
                )
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
  bool? expanded;

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    for (DrawerMenuItem drawerItem in widget.items) {
      Widget page = drawerItem.page;
      if (page == appProvider.selectedTab) {
        setState(() {
          expanded = true;
        });
      }
    }
    if (expanded == null) {
      setState(() {
        expanded = false;
      });
    }
  }

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
              style: TextStyle(color: expanded! ? AppColor.orange3 : null),
            ),
            leading: Icon(
              widget.icon,
              color: expanded!
                  ? AppColor.orange3
                  : widget.hasAlert
                      ? Colors.blue
                      : null,
            ),
            trailing: expanded!
                ? const Icon(Icons.keyboard_arrow_up_outlined)
                : const Icon(Icons.keyboard_arrow_down_outlined),
            onTap: () {
              setState(() {
                expanded = !expanded!;
              });
            },
          ),
          Visibility(
              visible: expanded!,
              child: Padding(
                padding: EdgeInsets.only(left: sW(25)),
                child: Column(children: [
                  for (var item in widget.items)
                    DrawerMenuItem(
                      itemIcon: item.itemIcon,
                      page: item.page,
                      title: item.title,
                      visibility: item.visibility,
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
  final bool visibility;
  final String? parentName;

  const DrawerMenuItem({
    super.key,
    required this.title,
    required this.page,
    required this.itemIcon,
    this.accessLevel,
    this.visibility = true,
    this.parentName,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userLevel = userProvider.getLevel();
    final appProvider = Provider.of<AppProvider>(context);
    bool isVisible =
        (accessLevel == null ? true : (userLevel! >= accessLevel!)) &&
            visibility;
    bool isSelectedPage = appProvider.selectedTab == page;

    return Visibility(
      visible: isVisible,
      child: ListTile(
        selected: isSelectedPage,
        selectedColor: Colors.blue,
        title: Text(title),
        leading: Icon(itemIcon),
        onTap: () {
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
