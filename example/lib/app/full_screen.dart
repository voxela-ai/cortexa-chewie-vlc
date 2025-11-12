import 'package:chewie_vlc/chewie_vlc.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';

class ChewieDemoFullScreen extends StatefulWidget {
  const ChewieDemoFullScreen(
      {Key? key,
      this.title = 'Chewie Demo',
      required this.url,
      required this.time,
      required this.setTime})
      : super(key: key);

  final String title;
  final Function(int) setTime;
  // final Widget child;
  final String url;
  final int time;
  // final VlcPlayer child;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoFullScreenState();
  }
}

class _ChewieDemoFullScreenState extends State<ChewieDemoFullScreen> {
  late VlcPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool isTimeSet = false;
  // bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    // widget.child.addOnInitListener(onInitListener);
    // widget.child.value.isInitialized =
    // widget.child.play();
    initializePlayer();
    _createChewieController();
  }

  // onInitListener() {
  //   // setState(() {
  //   //   log("inside on init listener full screen");
  //   // });
  //   // widget.child.setTime(widget.time);
  // }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(widget.url,
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
            advanced:
                VlcAdvancedOptions([VlcAdvancedOptions.networkCaching(2000)])))
      ..addOnInitListener(vlcInitListener)
      ..addListener(vlcListener);
  }

  void vlcListener() async {
    if (!mounted) return;
    if (_chewieController.isPlaying && !isTimeSet) {
      await _videoPlayerController.setTime(widget.time);
      isTimeSet = true;
      setState(() {});
    }
    if (_videoPlayerController.value.isEnded) {
      _videoPlayerController.stop();
      _videoPlayerController.play();
    }
  }

  void vlcInitListener() {
    _videoPlayerController.startRendererScanning();
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      hideControlsTimer: const Duration(seconds: 5),
      placeholder: Container(
        color: Colors.black,
      ),
    );
    _chewieController.addListener(() async {
      if (_chewieController.isFullScreen) {
        _chewieController.pause();
        int time = await _videoPlayerController.getTime();
        widget.setTime(time);
        Navigator.of(context).pop();
      }
    });
  }

  // chewieListener() async {
  //   if (!_chewieController.isFullScreen) {
  //     Navigator.pop(context);
  //   }
  // }

  // Widget _buildFullScreenVideo(
  //   BuildContext context,
  //   Animation<double> animation,
  //   ChewieControllerProvider controllerProvider,
  // ) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: false,
  //     body: Container(
  //       alignment: Alignment.center,
  //       color: Colors.black,
  //       child: controllerProvider,
  //     ),
  //   );
  // }

  // AnimatedWidget _defaultRoutePageBuilder(
  //   BuildContext context,
  //   Animation<double> animation,
  //   Animation<double> secondaryAnimation,
  //   ChewieControllerProvider controllerProvider,
  // ) {
  //   return AnimatedBuilder(
  //     animation: animation,
  //     builder: (BuildContext context, Widget? child) {
  //       return _buildFullScreenVideo(context, animation, controllerProvider);
  //     },
  //   );
  // }

  // Widget _fullScreenRoutePageBuilder(
  //   BuildContext context,
  //   Animation<double> animation,
  //   Animation<double> secondaryAnimation,
  // ) {
  //   final controllerProvider = ChewieControllerProvider(
  //     controller: _chewieController2,
  //     child: ChangeNotifierProvider<PlayerNotifier>.value(
  //       value: notifier,
  //       builder: (context, w) => const PlayerWithControls(),
  //     ),
  //   );

  //   if (widget.controller.routePageBuilder == null) {
  //     return _defaultRoutePageBuilder(
  //       context,
  //       animation,
  //       secondaryAnimation,
  //       controllerProvider,
  //     );
  //   }
  //   return widget.controller.routePageBuilder!(
  //     context,
  //     animation,
  //     secondaryAnimation,
  //     controllerProvider,
  //   );
  // }

  // Future<dynamic> _pushFullScreenWidget(BuildContext context) async {
  //   final TransitionRoute<void> route = PageRouteBuilder<void>(
  //     pageBuilder: _fullScreenRoutePageBuilder,
  //   );

  //   onEnterFullScreen();

  //   if (!widget.controller.allowedScreenSleep) {
  //     WakelockPlus.enable();
  //   }

  //   await Navigator.of(
  //     context,
  //     rootNavigator: widget.controller.useRootNavigator,
  //   ).push(route);
  //   _isFullScreen = false;
  //   widget.controller.exitFullScreen();

  //   // The wakelock plugins checks whether it needs to perform an action internally,
  //   // so we do not need to check WakelockPlus.isEnabled.
  //   WakelockPlus.disable();

  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.manual,
  //     overlays: widget.controller.systemOverlaysAfterFullScreen,
  //   );
  //   SystemChrome.setPreferredOrientations(
  //     widget.controller.deviceOrientationsAfterFullScreen,
  //   );
  // }

  // void onEnterFullScreen() {
  //   final videoWidth = widget.controller.videoPlayerController.value.size.width;
  //   final videoHeight =
  //       widget.controller.videoPlayerController.value.size.height;

  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  //   // if (widget.controller.systemOverlaysOnEnterFullScreen != null) {
  //   //   /// Optional user preferred settings
  //   //   SystemChrome.setEnabledSystemUIMode(
  //   //     SystemUiMode.manual,
  //   //     overlays: widget.controller.systemOverlaysOnEnterFullScreen,
  //   //   );
  //   // } else {
  //   //   /// Default behavior
  //   //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  //   // }

  //   if (widget.controller.deviceOrientationsOnEnterFullScreen != null) {
  //     /// Optional user preferred settings
  //     SystemChrome.setPreferredOrientations(
  //       widget.controller.deviceOrientationsOnEnterFullScreen!,
  //     );
  //   } else {
  //     final isLandscapeVideo = videoWidth > videoHeight;
  //     final isPortraitVideo = videoWidth < videoHeight;

  //     /// Default behavior
  //     /// Video w > h means we force landscape
  //     if (isLandscapeVideo) {
  //       SystemChrome.setPreferredOrientations([
  //         DeviceOrientation.landscapeLeft,
  //         DeviceOrientation.landscapeRight,
  //       ]);
  //     }

  //     /// Video h > w means we force portrait
  //     else if (isPortraitVideo) {
  //       SystemChrome.setPreferredOrientations([
  //         DeviceOrientation.portraitUp,
  //         DeviceOrientation.portraitDown,
  //       ]);
  //     }

  //     /// Otherwise if h == w (square video)
  //     else {
  //       SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

/*

// fullscreen.dart

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'dart:developer';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class ChewieDemoFullScreen extends StatefulWidget {
  const ChewieDemoFullScreen({
    Key? key,
    this.title = 'Chewie Demo',
    required this.child,
    required this.time,
  }) : super(key: key);

  final String title;
  final VlcPlayerController child;
  final int time;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoFullScreenState();
  }
}

class _ChewieDemoFullScreenState extends State<ChewieDemoFullScreen> {

  @override
  void initState() {
    super.initState();
    widget.child.addOnInitListener(onInitListener);
  }

  onInitListener() {
    widget.child.setTime(widget.time);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.of(context).pop();
        },
        child:
            //  widget.child
            VlcPlayer(
          aspectRatio: 16 / 9,
          controller: widget.child,
        ),
      ),
    ));
  }
}

*/
