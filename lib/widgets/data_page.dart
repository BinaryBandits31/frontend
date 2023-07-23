import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'buttons.dart';

import 'helper_widgets.dart';

class DataPage extends StatelessWidget {
  const DataPage({
    super.key,
    required this.isLoading,
    required this.dataList,
    required this.pageTitle,
    required this.columnNames,
    required this.createNewDialog,
    required this.source,
  });

  final bool isLoading;
  final List dataList;
  final List<String> columnNames;
  final String pageTitle;
  final Widget createNewDialog;
  final DataTableSource source;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: sH(25), left: sH(25), right: sH(25)),
        child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pageTitle,
                            style: TextStyle(
                                fontSize: sH(25), fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: sH(10)),
                            child: TriggerButton(
                              title: 'CREATE NEW',
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: !isLoading,
                                  context: context,
                                  builder: (context) => createNewDialog,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(20),
                      // Search Section
                      Card(
                        color: AppColor.black1,
                        child: Padding(
                          padding: EdgeInsets.all(sH(20)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Search Field
                              SizedBox(
                                width: screenWidth * 0.3,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('What are you looking for?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextField()
                                  ],
                                ),
                              ),
                              // Search Button
                              TriggerButton(
                                title: 'SEARCH',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Result Section
                      addVerticalSpace(20),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : dataList.isNotEmpty
                              ? ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth),
                                  child: PaginatedDataTable(
                                      source: source,
                                      header: // Result Options
                                          Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '$pageTitle Summary',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      rowsPerPage: dataList.length >= 10
                                          ? 10
                                          : dataList.length,
                                      headingRowHeight: sH(40),
                                      columns: columnNames
                                          .map((columnName) => DataColumn(
                                              label: Text(columnName)))
                                          .toList()),
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth),
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(sH(20)),
                                      child: Text(
                                        'No Data Found',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: sH(25)),
                                      ),
                                    ),
                                  ),
                                )
                    ],
                  ),
                )));
  }
}
