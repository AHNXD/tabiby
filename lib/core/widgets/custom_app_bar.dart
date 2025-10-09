import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/constats.dart';


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.backBtn,
  });
  final String title;
  final bool backBtn;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: kHorizontalPadding + 4),
      decoration: BoxDecoration(
          color: AppColors.primaryColors,
          gradient: LinearGradient(
            colors: [AppColors.primaryColors, AppColors.secColors],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backBtn
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    size: 20,
                    color: AppColors.backgroundColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : SizedBox(
                  height: 50,
                  width: 50,
                ),
          Flexible(
            child: Text(
              overflow: TextOverflow.ellipsis,
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
          ),
        ],
      ),
    );
  }
}
