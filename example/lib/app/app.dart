import 'package:chewie_vlc/chewie_vlc.dart';
import 'package:chewie_example/app/full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Chewie Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  late VlcPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  int time = 0;

  setTime(int time) {
    setState(() {
      this.time = time;
    });
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _createChewieController();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(
        "https://www.shutterstock.com/shutterstock/videos/1104530479/preview/stock-footage-countdown-video-from-minute-to-minute-timer-countdown-second-countdown-part-of.webm",
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
            advanced:
                VlcAdvancedOptions([VlcAdvancedOptions.networkCaching(2000)])))
      ..addOnInitListener(vlcInitListener)
      ..addListener(vlcListener);
  }

  void vlcListener() {
    if (!mounted) return;
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
        await _chewieController.pause();
        time = await _videoPlayerController.getTime();
        String url =
            "https://www.shutterstock.com/shutterstock/videos/1104530479/preview/stock-footage-countdown-video-from-minute-to-minute-timer-countdown-second-countdown-part-of.webm";
        onEnterFullScreen();
        WakelockPlus.enable();
        await Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
          return ChewieDemoFullScreen(url: url, time: time, setTime: setTime);
        })));
        await _chewieController.play();
        await _videoPlayerController.setTime(time);
        WakelockPlus.disable();
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
    });
  }

  void onEnterFullScreen() {
    final videoWidth = _chewieController.videoPlayerController.value.size.width;
    final videoHeight =
        _chewieController.videoPlayerController.value.size.height;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    final isLandscapeVideo = videoWidth > videoHeight;
    final isPortraitVideo = videoWidth < videoHeight;

    /// Default behavior
    /// Video w > h means we force landscape
    if (isLandscapeVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    /// Video h > w means we force portrait
    else if (isPortraitVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    /// Otherwise if h == w (square video)
    else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: widget.title,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*

// below code contains chewie player testing and the vlc player is working fine in both portrait moda and landscape mode while landscape mode is used after pushing to landscape mode.

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Chewie Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  late VlcPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _createChewieController();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(
        "https://www.shutterstock.com/shutterstock/videos/1104530479/preview/stock-footage-countdown-video-from-minute-to-minute-timer-countdown-second-countdown-part-of.webm",
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
            advanced:
                VlcAdvancedOptions([VlcAdvancedOptions.networkCaching(2000)])))
      ..addOnInitListener(vlcInitListener)
      ..addListener(vlcListener);
  }

  void vlcListener() {
    if (!mounted) return;
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
      looping: true,
      hideControlsTimer: const Duration(seconds: 5),
      placeholder: Container(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: widget.title,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/


// below code is just using vlc player in a small app using without chewie, it is also working fine in both portrait and landscape mode.

/*
import 'package:chewie/chewie.dart';
import 'package:chewie_example/app/full_screen.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Chewie Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  VlcPlayerController? _videoPlayerController;
  late ChewieController _chewieController;
  // final GlobalKey playerKey = GlobalKey();
  // late VlcPlayer vlc;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _createChewieController();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(
        "https://www.shutterstock.com/shutterstock/videos/1104530479/preview/stock-footage-countdown-video-from-minute-to-minute-timer-countdown-second-countdown-part-of.webm",
        hwAcc: HwAcc.full,
        autoInitialize: true,
        options: VlcPlayerOptions(
            advanced:
                VlcAdvancedOptions([VlcAdvancedOptions.networkCaching(2000)])))
      ..addOnInitListener(vlcInitListener)
      ..addListener(vlcListener);

    // ..initialize();
    // vlc = VlcPlayer(
    //   controller: _videoPlayerController!,
    //   aspectRatio: 16 / 9,
    //   placeholder: Text("testings"),
    // );
    // if (!_videoPlayerController.value.isInitialized) {
    //   _videoPlayerController.initialize();
    // }
    // _videoPlayerController.initialize();
  }

  void vlcListener() async {
    log("listener getting called " + _videoPlayerController!.viewId.toString());

    if (!mounted) return;
    // if (_videoPlayerController.isReadyToInitialize != null &&
    //     _videoPlayerController.isReadyToInitialize!) {
    //   await _videoPlayerController.initialize();
    //   await _videoPlayerController.play();
    // }
    if (_videoPlayerController!.value.isEnded) {
      _videoPlayerController!.stop();
      _videoPlayerController!.play();
    }
  }

  void vlcInitListener() async {
    _videoPlayerController!.startRendererScanning();
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      looping: true,
      hideControlsTimer: const Duration(seconds: 5),
      placeholder: Container(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: widget.title,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      // if (_videoPlayerController.value.isInitialized)
                      VlcPlayer(
                        // key: playerKey,
                        aspectRatio: 16 / 9,
                        controller: _videoPlayerController!,
                      ),
                      // vlc,
                      IconButton(
                          onPressed: () async {
                            log("inside double tap");
                            _videoPlayerController!.pause();
                            int time = await _videoPlayerController!.getTime();
                            // _videoPlayerController!.autoInitialize = false;
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => ChewieDemoFullScreen(
                                      child: _videoPlayerController!,
                                      // child: vlc,
                                      time: time,
                                    ))));
                            // setState(() async {
                            // vlc = VlcPlayer(
                            //   controller: _videoPlayerController!,
                            //   aspectRatio: 16 / 9,
                            //   placeholder: Text("testings"),
                            // );
                            if (_videoPlayerController!.viewId >= 1) {
                              int time =
                                  await _videoPlayerController!.getTime();
                              await _videoPlayerController!.platformDispose();
                              _videoPlayerController!.viewId = 0;
                              _videoPlayerController!.play();
                              _videoPlayerController!.setTime(time);
                            }
                            // _videoPlayerController!.initialize();
                            log("set state called");
                            // });
                          },
                          icon: Icon(Icons.bubble_chart))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/