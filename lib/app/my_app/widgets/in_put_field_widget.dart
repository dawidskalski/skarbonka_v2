// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:skarbonka_v2/app/my_app/text_style/text_style.dart';

// class InPutFieldWidget extends StatelessWidget {
//   final title;
//   final hintText;
//   final Widget? widget;
//   final TextEditingController? controller;
//   final Function(DateTime)? onDateChanged;
//   const InPutFieldWidget(
//       {super.key,
//       required this.title,
//       required this.hintText,
//       this.controller,
//       this.onDateChanged,
//       this.widget});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Container(
//       margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$title ',
//             style: getTextFieldStyle(),
//           ),
//           Container(
//               margin: EdgeInsets.only(
//                 top: 10,
//               ),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//                 //
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         readOnly: widget == null ? false : true,
//                         controller: controller,
//                         autofocus: false,
//                         cursorColor: Colors.orange,
//                         decoration: InputDecoration(
//                           hintText: hintText,
//                           focusedBorder: const UnderlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: Colors.grey, width: 0),
//                           ),
//                           enabledBorder: const UnderlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.grey,
//                               width: 0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     widget == null ? Container() : Container(child: widget)
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }
