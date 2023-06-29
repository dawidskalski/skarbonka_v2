import 'package:flutter/material.dart';

class NotificationPageContent extends StatelessWidget {
  const NotificationPageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.050,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_left),
                ),
                const Text('Data'),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_right),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
