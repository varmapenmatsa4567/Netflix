import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DownloadProvider extends ChangeNotifier {
  Map _downloads = {};
  Box box = Hive.box<Map>('downloads');

  Map get downloads => _downloads;

  bool fileExists(String filename) {
    File file = File('/storage/emulated/0/Download/Netflix/$filename');
    if (file.existsSync()) {
      return false;
    }
    return true;
  }

  DownloadProvider() {
    _downloads = box.get('downloads', defaultValue: {});
    _downloads.removeWhere((key, value) => fileExists(value[1]));
    box.put('downloads', _downloads);
  }

  // function to generate a uniuque code for each download
  String generateCode() {
    String code = '';
    for (int i = 0; i < 10; i++) {
      code += String.fromCharCode(97 + (i % 26));
    }
    return code;
  }

  void addDownload(String name, String id, String url) async {
    String dir = '/storage/emulated/0/Download/Netflix';
    String filename = '$name-${generateCode()}.mp4';
    String path = '$dir/$filename';
    print(path);
    Dio dio = Dio();
    await dio.download(
      url,
      path,
      onReceiveProgress: (count, total) {
        List a = [];
        a.add(name);
        a.add(path);
        a.add((count / total) * 100);
        _downloads[id] = a;
        box.put('downloads', _downloads);
        print(a);
        notifyListeners();
      },
    );
    notifyListeners();
  }
}
