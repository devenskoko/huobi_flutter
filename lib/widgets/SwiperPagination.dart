import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huobi_flutter/manager/device_manager.dart';

class MySwiperPagination extends StatefulWidget {
  final swiper_length;
  final swiper_index;

  const MySwiperPagination({Key? key, @required this.swiper_length, this.swiper_index}) : super(key: key);

  @override
  _MySwiperPaginationState createState() => _MySwiperPaginationState();
}

class _MySwiperPaginationState extends State<MySwiperPagination> with TickerProviderStateMixin {

  double blockWidth = 20.0;
  double childLeft = 0.0;

  @override
  void initState() {
    super.initState();
    childLeft = DeviceManager.getInstance().screenWidth/2 - blockWidth * widget.swiper_length/2;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: blockWidth * widget.swiper_length,
            height: 3,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color(0xd8e7ebee),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          AnimatedPositioned(
            left: childLeft + widget.swiper_index * 20.0,
            bottom: 10,
            curve: Curves.easeIn,
            //将要执行动画的子view
            duration: Duration(milliseconds: 300),
            child: Container(
              width: blockWidth,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
