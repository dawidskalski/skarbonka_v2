import 'package:flutter/material.dart';
import 'package:skarbonka_v2/app/my_app/text_style/text_style.dart';

class AddReminderButtonWidget extends StatelessWidget {
  final String giveName;
  final Function() onTap;
  final Widget? icon;
  const AddReminderButtonWidget(
      {super.key, required this.giveName, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            Text(
              giveName,
              style: getReminderButtonStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
