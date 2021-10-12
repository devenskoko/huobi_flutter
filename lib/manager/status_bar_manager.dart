import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 沉浸式状态栏 这里吧，感觉flutter支持得很不好，如果在其他页面切换状态栏颜色切换时有明显卡顿
statusBar(bool isLight, [Color systemNavigationBarColor = Colors.transparent]) {
  // 白色沉浸式状态栏颜色  白色文字
  SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: systemNavigationBarColor,
    systemNavigationBarDividerColor: Colors.transparent,

    /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness:
        isLight ? Brightness.light : Brightness.dark,
    statusBarIconBrightness: isLight ? Brightness.light : Brightness.dark,
    statusBarBrightness: isLight ? Brightness.dark : Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(light);
}
