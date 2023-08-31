import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/helper_widgets.dart';
import 'package:intl/intl.dart';

class CustomSearchField<T> extends StatefulWidget {
  final List<T> itemList;
  final String Function(T) getItemName;
  final void Function(T) onItemSelected;

  const CustomSearchField({
    super.key,
    required this.itemList,
    required this.getItemName,
    required this.onItemSelected,
  });

  @override
  _CustomSearchFieldState<T> createState() => _CustomSearchFieldState<T>();
}

class _CustomSearchFieldState<T> extends State<CustomSearchField<T>> {
  List<T> _filteredItems = [];
  TextEditingController? textEditingController;
  final focusNode = FocusNode();

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.itemList
          .where((item) => widget
              .getItemName(item)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onItemTap(T item) {
    widget.onItemSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) => focusNode.unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            focusNode: focusNode,
            onTap: () {
              _filterItems('');
            },
            onChanged: _filterItems,
            decoration: InputDecoration(
              labelText: 'Search $T',
            ),
          ),
          if (_filteredItems.isNotEmpty && focusNode.hasFocus)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.getItemName(_filteredItems[index])),
                    onTap: () {
                      _onItemTap(_filteredItems[index]);
                      _filterItems('*');
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CustomDropDown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<T> itemList;
  final String Function(T)? displayItem;
  final void Function(T?)? onChanged;
  final bool? isLoading;

  const CustomDropDown({
    super.key,
    required this.labelText,
    required this.value,
    required this.itemList,
    this.displayItem,
    this.onChanged,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(labelText),
        SizedBox(
          width: screenWidth * 0.15,
          child: Visibility(
            visible: isLoading != null ? !isLoading! : true,
            replacement: const Center(child: CircularProgressIndicator()),
            child: DropdownButton<T>(
              isExpanded: true,
              alignment: AlignmentDirectional.centerStart,
              value: value,
              onChanged: onChanged,
              items: itemList.map<DropdownMenuItem<T>>(
                (T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      displayItem != null
                          ? displayItem!(item)
                          : item.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomExpiryDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;

  const CustomExpiryDatePicker(
      {super.key, this.selectedDate, this.onDateSelected});

  @override
  State<CustomExpiryDatePicker> createState() => _CustomExpiryDatePickerState();
}

class _CustomExpiryDatePickerState extends State<CustomExpiryDatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(const Duration(days: 365 * 50)), // Limit to 50 years from today
    );

    if (picked != null && picked != widget.selectedDate) {
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.selectedDate == null
              ? 'Select Date'
              : DateFormat('dd MMM yyyy').format(widget.selectedDate!),
          style: TextStyle(
              fontSize: sH(18),
              fontWeight: widget.selectedDate != null ? FontWeight.bold : null),
        ),
        addHorizontalSpace(sW(10)),
        InkWell(
          onTap: () => _selectDate(context),
          child: const Icon(
            Icons.date_range_rounded,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class CustomDOBDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;

  const CustomDOBDatePicker(
      {super.key, this.selectedDate, this.onDateSelected});

  @override
  State<CustomDOBDatePicker> createState() => _CustomDOBDatePickerState();
}

class _CustomDOBDatePickerState extends State<CustomDOBDatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1999, 1, 1),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 50)),
      lastDate: DateTime.now().subtract(
          const Duration(days: 365 * 10)), // Limit to 10 years from today
    );

    if (picked != null && picked != widget.selectedDate) {
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.selectedDate == null
              ? 'Select Date'
              : DateFormat('dd MMM yyyy').format(widget.selectedDate!),
          style: TextStyle(
              fontSize: sH(18),
              fontWeight: widget.selectedDate != null ? FontWeight.bold : null),
        ),
        addHorizontalSpace(sW(10)),
        InkWell(
          onTap: () => _selectDate(context),
          child: const Icon(
            Icons.date_range_rounded,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class PaneContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  const PaneContainer(
      {super.key, required this.child, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(padding: EdgeInsets.all(sH(10)), child: child),
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final String title;
  final String? value;
  final bool isValueWidget;
  final Widget? widget;

  const CardField(
      {super.key,
      required this.title,
      this.value,
      this.isValueWidget = false,
      this.widget});

  @override
  Widget build(BuildContext context) {
    double customFontSize = sH(18);

    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: TextStyle(fontSize: customFontSize),
        )),
        Expanded(
          child: !isValueWidget
              ? Card(
                  margin: EdgeInsets.zero,
                  color: AppColor.grey1,
                  child: Center(
                    child: Text(
                      ' ${value ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: customFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : widget!,
        )
      ],
    );
  }
}
