import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:huobi_flutter/config/router_manager.dart';
import 'package:huobi_flutter/constants/color_constants.dart';
import 'package:huobi_flutter/manager/status_bar_manager.dart';
import 'package:huobi_flutter/provider_model/symbols.dart';
import 'package:huobi_flutter/provider_model/socket_client.dart';

import 'logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 初始化数据
    symbolLogic();
    socketLogic.initSocket();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    statusBar(true, kbgColorKChartDark);

    return Scaffold(
      backgroundColor: kbgColorKChartDark,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Center(
              child: Lottie.asset(
                'assets/lottie/huobisplashscreen_1.json',
                height: 200,
                fit: BoxFit.fitHeight,
                repeat: false,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward().whenComplete(() => {Get.offAllNamed(RouteConfig.index)});
                },
              ),
            ),
            top: 150,
          ),
          Positioned(
            child: Center(
              child: Lottie.asset(
                'assets/lottie/huobisplashscreen_2.json',
                height: 40,
                fit: BoxFit.fitHeight,
                repeat: false,
                onLoaded: (composition) {},
              ),
            ),
            bottom: 50,
          ),
        ],
      ),
    );
  }
}
