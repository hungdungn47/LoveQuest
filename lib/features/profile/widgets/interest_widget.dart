import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class InterestWidget extends StatelessWidget {
  final List<String> hobbies;
  const InterestWidget({super.key, required this.hobbies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            child: Text(
              "Interests",
              style: Styles.bigTextW800,
            )),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 28),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                    _getStringFromList(hobbies),
                style: Styles.mediumTextW500.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.black,
                size: 16,
              )
            ],
          ),
        )
      ],
    );
  }

  String _getStringFromList(List<String> hobbies) {
    return hobbies.join(", ");
  }
}
