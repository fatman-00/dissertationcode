import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget  implements PreferredSizeWidget{
  final titleText;

  const MyAppBar({
    super.key,
    required this.titleText
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();
  
  @override
  // TODO: implement preferredSize
  //Size get preferredSize => MediaQuery.of(context).size.height;
  
  Size get preferredSize => const Size.fromHeight(50);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(
        widget.titleText,
        style: const TextStyle(
          color: Colors.white
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
