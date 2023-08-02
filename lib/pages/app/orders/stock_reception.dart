import 'package:flutter/material.dart';
import 'package:frontend/models/branch.dart';
import 'package:frontend/models/stock_item.dart';
import 'package:frontend/providers/branch_provider.dart';
import 'package:frontend/providers/stock_transfer_provider.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/big_text.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/custom_widgets.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:frontend/widgets/notify.dart';
import 'package:provider/provider.dart';

class StockReceptionPage extends StatefulWidget {
  const StockReceptionPage({super.key});

  @override
  State<StockReceptionPage> createState() => _StockReceptionPageState();
}

class _StockReceptionPageState extends State<StockReceptionPage> {
  String? _displayedFromBranch;
  String? _displayedToBranch;
  final quantityController = TextEditingController();
  final quantityFocusNode = FocusNode();
  dynamic _selectedBatch;

  void confirmTransfer() async {
    final stockTransferProvider =
        Provider.of<StockTransferProvider>(context, listen: false);
    bool res = await stockTransferProvider.confirmTransfer();
    if (res) {
      successMessage('Stock Received Successfully');
    } else {
      dangerMessage('Stock Reception Failed');
    }
  }

  void terminateTransfer() async {
    final stockTransferProvider =
        Provider.of<StockTransferProvider>(context, listen: false);
    bool res = await stockTransferProvider.terminateTransfer();
    if (res) {
      successMessage('Stock Terminated Successfully');
    } else {
      dangerMessage('Stock Termination Failed');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final stockTransferProvider =
          Provider.of<StockTransferProvider>(context, listen: false);
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      if (branchProvider.branches.isEmpty) {
        branchProvider.fetchBranches();
      }
      await stockTransferProvider.fetchStockTransferBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockTransferProvider =
        Provider.of<StockTransferProvider>(context, listen: true);
    final transferBatches = stockTransferProvider.transferBatches;
    final batchItems = stockTransferProvider.incomingStockItems;
    final branches =
        Provider.of<BranchProvider>(context, listen: false).branches;

    return SingleChildScrollView(
      child: Container(
        height: screenHeight * 0.91,
        padding: EdgeInsets.symmetric(horizontal: sH(20), vertical: sH(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //left Pane
            Expanded(
              child: Column(
                children: [
                  //Header
                  Row(
                    children: [
                      PaneContainer(
                        child: CustomDropDown<dynamic>(
                          isLoading:
                              stockTransferProvider.isLoadingTransferBatches,
                          labelText: 'Batches',
                          value: _selectedBatch,
                          itemList: transferBatches,
                          displayItem: (dynamic batch) =>
                              batch['Id'].substring(batch['Id'].length - 4),
                          onChanged: (dynamic batch) {
                            setState(() {
                              _displayedFromBranch = branches
                                  .firstWhere((e) =>
                                      e.branchID == batch['sendingBranch'])
                                  .name;

                              _displayedToBranch = branches
                                  .firstWhere((e) =>
                                      e.branchID == batch['receivingBranch'])
                                  .name;

                              _selectedBatch = batch!;
                            });

                            stockTransferProvider.getBatchDetails(batch);
                          },
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(sH(20)),
                  //Entered Product List
                  Expanded(
                    child: PaneContainer(
                      child: Column(
                        children: [
                          const ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text('Product Name')),
                                Expanded(child: Text('Quantity')),
                              ],
                            ),
                          ),
                          const Divider(),
                          stockTransferProvider.transferBatches.isNotEmpty
                              ? stockTransferProvider.currentBatch != null
                                  ? Expanded(
                                      child: SizedBox(
                                        child: !stockTransferProvider
                                                .isLoadingTransferDetails
                                            ? ListView.builder(
                                                itemCount: batchItems.length,
                                                itemBuilder: (context, index) {
                                                  dynamic batch =
                                                      batchItems[index];
                                                  return ListTile(
                                                    tileColor: index.isEven
                                                        ? AppColor.grey1
                                                        : null,
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                '${batch.productName}')),
                                                        Expanded(
                                                            child: Text(
                                                                '${batch.quantity}'))
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ),
                                    )
                                  : const BigText('Select Batch ID')
                              : const BigText('No Incoming Transfers')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            addHorizontalSpace(sW(20)),
            // right Pane
            SizedBox(
              width: screenWidth * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaneContainer(
                      height: screenHeight * 0.12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CardField(
                            title: 'From',
                            value: _displayedFromBranch ?? '',
                          ),
                          Divider(color: AppColor.grey1),
                          CardField(
                            title: 'To',
                            value: _displayedToBranch ?? '',
                          ),
                        ],
                      )),
                  //Submit Transaction
                  PaneContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubmitButton(
                          label: 'Confirm Transfer',
                          onPressed: () => confirmTransfer()),
                      addVerticalSpace(sH(20)),
                      SubmitButton(
                          danger: true,
                          label: 'Confirm Transfer',
                          onPressed: () => terminateTransfer()),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
