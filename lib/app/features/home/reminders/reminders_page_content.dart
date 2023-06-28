import 'package:flutter/material.dart';

class ReminderPageContent extends StatelessWidget {
  const ReminderPageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
    );
  }
}
