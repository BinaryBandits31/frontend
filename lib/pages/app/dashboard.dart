import 'package:flutter/material.dart';
import 'package:frontend/providers/app_provider.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/helper_functions.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> dashboardData = appProvider.dashboardData;
    dynamic salesSummary = dashboardData['salesSummary'];
    dynamic productionSummary = dashboardData['productionSummary'];
    dynamic rawMaterialSummary = dashboardData['rawMaterialSummary'];
    dynamic stockTransferSummary = dashboardData['stockTransferSummary'];

    return Padding(
        padding: EdgeInsets.all(sH(20)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        // Sales Report
                        child: salesSummary["LatestSales"] == null
                            ? SalesReportWidget(
                                total: abbreviateNumber(
                                    salesSummary["totalEarnings"]),
                              )
                            : SalesReportWidget(
                                total: abbreviateNumber(
                                    salesSummary["totalEarnings"]),
                                branchData: salesSummary["LatestSales"],
                              )),
                    addHorizontalSpace(20),
                    // Estimates RM Stock
                    Expanded(
                        child: ProductEstimateReportWidget(
                            productionSummary: productionSummary)),
                  ],
                ),
              ),
              addVerticalSpace(20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Major Report
                    Expanded(
                        child: ReportBox(
                            title: 'Recent Transfers',
                            child: SizedBox(
                              height: screenHeight * 0.32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: RecentTransferReportWidget(
                                      from: stockTransferSummary[0]['from'],
                                      to: stockTransferSummary[0]['to'],
                                    ),
                                  ),
                                  addVerticalSpace(sH(10)),
                                  Expanded(
                                    child: RecentTransferReportWidget(
                                      from: stockTransferSummary[1]['from'],
                                      to: stockTransferSummary[1]['to'],
                                    ),
                                  ),
                                  addVerticalSpace(sH(10)),
                                  Expanded(
                                    child: RecentTransferReportWidget(
                                      from: stockTransferSummary[2]['from'],
                                      to: stockTransferSummary[2]['to'],
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                    addHorizontalSpace(20),
                    // Major Report
                    Expanded(
                        child: RawMaterialsReportWidget(
                      rawMaterialSummary: rawMaterialSummary,
                    )),
                  ],
                ),
              ),
            ]));
  }
}

class RecentTransferReportWidget extends StatelessWidget {
  final String? from;
  final String? to;
  final String? timeStamp;

  const RecentTransferReportWidget({
    super.key,
    this.from,
    this.to,
    this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {
    return PaneContainer(
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.18,
              child: Text(
                '$from',
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: sH(40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.arrow_right_alt_sharp, size: sH(40)),
            SizedBox(
              width: screenWidth * 0.18,
              child: Text(
                '$to',
                textAlign: TextAlign.end,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: sH(40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }
}

class ProductEstimateReportWidget extends StatelessWidget {
  const ProductEstimateReportWidget({
    super.key,
    required this.productionSummary,
  });

  final dynamic productionSummary;

  @override
  Widget build(BuildContext context) {
    return ReportBox(
      title: 'Product Yield Estimates',
      child: Column(
        children: [
          const ListTile(
            title: Row(
              children: [
                Expanded(
                    child: Text(
                  'Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(
                    child: Text(
                  'Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(
                    child: Text(
                  'Estimate',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              itemCount: productionSummary.length,
              itemBuilder: (context, index) {
                dynamic data = productionSummary[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text('${data["name"]}')),
                      Expanded(child: Text('${data["totalProduction"]}')),
                      Expanded(
                          child: Text(
                        '${data["forecastedMaxProduction"]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// RM Stock Report
class RawMaterialsReportWidget extends StatelessWidget {
  const RawMaterialsReportWidget({
    super.key,
    required this.rawMaterialSummary,
  });

  final dynamic rawMaterialSummary;

  @override
  Widget build(BuildContext context) {
    return ReportBox(
      title: 'Raw Material Stock',
      child: Column(
        children: [
          const ListTile(
            title: Row(
              children: [
                Expanded(
                    child: Text(
                  'Raw Material',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(
                    child: Text(
                  'Base Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Expanded(
                    child: Text(
                  'Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              itemCount: rawMaterialSummary.length,
              itemBuilder: (context, index) {
                dynamic data = rawMaterialSummary[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text('${data["name"]}')),
                      Expanded(child: Text('${data["unit"]}')),
                      Expanded(child: Text('${data["qtyRemaining"]}')),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ReportBox extends StatelessWidget {
  final String title;
  final Widget child;
  const ReportBox({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PaneContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            height: 1,
            fontWeight: FontWeight.bold,
            fontSize: sH(30),
          ),
        ),
        addVerticalSpace(20),
        child
      ],
    ));
  }
}

class SalesReportWidget extends StatelessWidget {
  final String? total;
  final List<dynamic>? branchData;

  const SalesReportWidget({
    super.key,
    this.total,
    this.branchData = const [{}, {}, {}],
  });

  @override
  Widget build(BuildContext context) {
    return PaneContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total revenue this year',
          style: TextStyle(
            height: 1,
            fontWeight: FontWeight.bold,
            fontSize: sH(30),
          ),
        ),
        addVerticalSpace(20),
        CurrencyValue(
          text: total ?? '',
          height: sH(150),
        ),
        addVerticalSpace(10),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: RecentSaleTab(
                  branchName: branchData![0]['name'],
                  total: abbreviateNumber(branchData![0]['total']),
                  timeStamp: formatTimeAgoFromString(branchData![0]['time']),
                ),
              ),
              addHorizontalSpace(sW(10)),
              Expanded(
                child: RecentSaleTab(
                  branchName: branchData![1]['name'],
                  total: abbreviateNumber(branchData![1]['total']),
                  timeStamp: formatTimeAgoFromString(branchData![1]['time']),
                ),
              ),
              addHorizontalSpace(sW(10)),
              Expanded(
                child: RecentSaleTab(
                  branchName: branchData![2]['name'],
                  total: abbreviateNumber(branchData![2]['total']),
                  timeStamp: formatTimeAgoFromString(branchData![2]['time']),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class RecentSaleTab extends StatelessWidget {
  final String? branchName;
  final String? total;
  final String? timeStamp;

  const RecentSaleTab({
    super.key,
    this.branchName,
    this.total,
    this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {
    return PaneContainer(
        color: Colors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              branchName ?? '-',
              style: TextStyle(
                fontSize: sH(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            CurrencyValue(
              text: total,
              height: sH(50),
            ),
            Text(
              timeStamp ?? '',
              style: TextStyle(
                fontSize: sH(20),
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }
}

class CurrencyValue extends StatelessWidget {
  final String? text;
  final double height;

  const CurrencyValue({
    super.key,
    required this.height,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        text == null
            ? const Text('')
            : Text(
                '₵',
                style: TextStyle(
                    height: 0.9,
                    fontWeight: FontWeight.bold,
                    fontSize: height / 3),
              ),
        Text(
          text ?? '',
          style: TextStyle(
              height: 0.74, fontWeight: FontWeight.bold, fontSize: height),
        ),
      ],
    );
  }
}
