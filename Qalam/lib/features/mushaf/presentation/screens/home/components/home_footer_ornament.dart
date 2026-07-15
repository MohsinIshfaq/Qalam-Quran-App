import 'package:flutter/material.dart';

import 'home_style.dart';

class HomeFooterOrnament extends StatelessWidget {
  const HomeFooterOrnament({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(36, 30, 36, 22),
      child: Row(
        children: [
          Expanded(child: Divider(color: Color(0x88D4AF37))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.filter_vintage_rounded,
              color: HomeStyle.gold,
              size: 25,
            ),
          ),
          Expanded(child: Divider(color: Color(0x88D4AF37))),
        ],
      ),
    );
  }
}
