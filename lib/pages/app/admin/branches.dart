import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import '../../../utils/constants.dart';

class CompanyLocationsPage extends StatelessWidget {
  const CompanyLocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(sH(25)),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Company Locations',
                  style:
                      TextStyle(fontSize: sH(30), fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(right: sH(10)),
                  child: TriggerButton(
                    title: 'CREATE NEW',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            addVerticalSpace(20),
            // Search Section
            Container(
              padding: EdgeInsets.all(sH(20)),
              color: AppColor.black1,
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
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
            // Result Section
            addVerticalSpace(20),
            Container(
              padding: EdgeInsets.all(sH(20)),
              color: AppColor.black1,
              child: Column(
                children: [
                  // Result Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Locations Summary',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('< 1 2 3...10 >')
                    ],
                  ),
                  Divider(),
                  // Result Header
                  Container(
                    color: AppColor.blackBG,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                        ),
                        Text('COMPNAY LOCATION'),
                        addHorizontalSpace(sW(200)),
                        Text('DATE CREATED'),
                      ],
                    ),
                  ),
                  Divider(),
                  // Result List
                  Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                          Text('Main Branch'),
                          addHorizontalSpace(sW(200)),
                          Text('Aug 14, 2023'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class TriggerButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;

  const TriggerButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.blue),
          minimumSize: MaterialStatePropertyAll(Size(sW(130), sH(40)))),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
