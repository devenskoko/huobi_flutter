import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  /// 临时目录
  static late Directory temporaryDirectory;

  static late LocalStorage storage;

  /// 必备数据的初始化操作
  ///
  /// 由于是同步操作会导致阻塞,所以应尽量减少存储容量
  static init() async {
    temporaryDirectory = await getTemporaryDirectory(); //临时存储目录
    storage = LocalStorage('my_data.json');
    return storage.ready;
  }
}
