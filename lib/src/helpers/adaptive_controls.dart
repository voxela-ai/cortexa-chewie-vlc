import 'package:chewie_vlc/chewie_vlc.dart';
import 'package:flutter/material.dart';

class AdaptiveControls extends StatelessWidget {
  const AdaptiveControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoControls(
      backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
      iconColor: Color.fromARGB(255, 200, 200, 200),
    );
  }
}
