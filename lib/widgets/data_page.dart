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
    required this.searchFunction,
    required this.refreshPageFunction,
    required this.adminPage,
    this.filterWidget,
  });

  final bool isLoading;
  final List dataList;
  final Function refreshPageFunction;
  final List<String> columnNames;
  final String pageTitle;
  final Widget createNewDialog;
  final DataTableSource source;
  final Function searchFunction;
  final Widget? filterWidget;
  final bool adminPage;

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
                            child: adminPage
                                ? TriggerButton(
                                    title: 'CREATE NEW',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => createNewDialog,
                                      );
                                    },
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                      addVerticalSpace(20),
                      // Search Section
                      SizedBox(
                        height: screenHeight * 0.16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.25,
                              child: Card(
                                color: AppColor.black1,
                                child: Padding(
                                  padding: EdgeInsets.all(sH(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('What are you looking for?',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: screenWidth * 0.2,
                                          child: TextField(
                                            decoration: const InputDecoration(
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white)),
                                                labelText: 'Search',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey)),
                                            onChanged: (value) =>
                                                searchFunction(value),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            addHorizontalSpace(20),
                            if (filterWidget != null)
                              SizedBox(
                                child: Card(
                                  color: AppColor.black1,
                                  child: Padding(
                                    padding: EdgeInsets.all(sH(20)),
                                    child: filterWidget,
                                  ),
                                ),
                              )
                          ],
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
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.refresh_rounded),
                                            color: Colors.blue,
                                            onPressed: () async {
                                              await refreshPageFunction();
                                            },
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
