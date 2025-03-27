import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import 'info_item.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12, horizontal: 18),
            child: Text(
              "Basic Info",
              style: Styles.bigTextW800,
            )),
        InfoItem(icon: Icons.work_sharp, title: "Job", value: "Software Engineer",),
        InfoItem(icon: Icons.public_outlined, title: "Country", value: "VietNam",),
        InfoItem(icon: Icons.location_on_outlined, title: "Address", value: "Thai Binh, Viet Nam",),
        InfoItem(icon: Icons.email_outlined, title: "Email", value: "hungdungn47@gmail.com",),
        InfoItem(icon: Icons.female_outlined, title: "Gender", value: "Male",),
        SizedBox(height: 32,)
      ],
    );
  }
}
