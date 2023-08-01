import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_provider.dart';
import '../../../providers/user_provider.dart';
import '../../auth/user_login.dart';

class StockTransferPage extends StatelessWidget {
  const StockTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(sH(20)),
      child: Row(
        children: [
          //left Pane
          Expanded(
            flex: 3,
            child: Container(
              height: double.maxFinite,
              color: Colors.green,
            ),
          ),
          addHorizontalSpace(sW(20)),
          // right Pane
          Expanded(
            child: Container(
              height: double.maxFinite,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
