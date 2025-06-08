import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  const InfoItem({super.key, required this.title, required this.value, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.symmetric(vertical: 12, horizontal: 28),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 28,
          ),
          SizedBox(
            width: 12,
          ),
          Text(title, style: Styles.mediumTextW700,),
          SizedBox(width: 32,),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          value,
                          style: Styles.mediumTextW500
                              .copyWith(fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                  SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.black,
                      size: 16,
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
