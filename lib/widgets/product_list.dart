// import 'package:flutter/material.dart';
// import 'package:frontend/models/product.dart';

// class CustomListWidget extends StatefulWidget {
//   @override
//   _CustomListWidgetState createState() => _CustomListWidgetState();
// }

// class _CustomListWidgetState extends State<CustomListWidget> {
//   List<Product> _products = [];

//   void _addProduct(Product product) {
//     setState(() {
//       _products.add(product);
//     });
//   }

//   void _removeProduct(int index) {
//     setState(() {
//       _products.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const ListTile(
//           title: Text('Product Name'),
//           subtitle: Row(
//             children: [
//               Text('Quantity'),
//               SizedBox(width: 10),
//               Text('Expiry'),
//             ],
//           ),
//         ),
//         const Divider(),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _products.length,
//             itemBuilder: (context, index) {
//               Product product = _products[index];
//               return ListTile(
//                 title: Text(product.name),
//                 subtitle: Row(
//                   children: [
//                     Text('${product.quantity}'),
//                     SizedBox(width: 10),
//                     Text('${product.expiry}'),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () => _removeProduct(index),
//                 ),
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }
// }
