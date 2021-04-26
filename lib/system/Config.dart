import 'dart:core';

import 'package:sqflite/sqflite.dart';

class Config {
  Database _db;
  String _tableName;

  final Map<String, dynamic> _defaultData = {
    "Theme": "dark", // カラーテーマ: ["light","dark","black"]
    "Theme.dark.bgColor": "#000000", // 背景色: #NNNNNN
    "Thumbnail.size": "big", // サムネイルのサイズ: ["none","small","large"]
  };

  Config(String dbFileName, String tableName) {
    _tableName = tableName;
    _initDB(dbFileName);
  }

  Future<void> _initDB(String dbFileName) async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + dbFileName + '.db';

    _db = await openDatabase(path,
        version: 1,
        onCreate: (Database db, int version) async => await db.execute('''
create table $_tableName ( 
  key text primary key not null,
  value text not null)
'''));
  }

  Future<Data> getData(String key) async {
    List<Map> maps = await _db.query(_tableName,
        columns: ["key", "value"], where: 'key = ?', whereArgs: [key]);
    if (maps.length > 0) {
      return Data.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertData(Data data) async {
    await _db.insert(_tableName, data.toMap());
    return;
  }

  Future<int> delete(String key) async {
    return await _db.delete(_tableName, where: 'key = ?', whereArgs: [key]);
  }

  Future<bool> containsKey(String key) async {
    List<Map> maps = await _db.query(_tableName,
        columns: ["key", "value"], where: 'key = ?', whereArgs: [key]);
    if (maps.length > 0) {
      return false;
    }
    return true;
  }

  Future<List<String>> getKeys() async {
    List<Map> maps = await _db.query(_tableName, columns: ["key", "value"]);
    if (maps.length > 0) {
      return maps.first.keys;
    }
    return [];
  }

  void resetData() async {
    _defaultData.forEach((key, value) async {
      if (!(await containsKey(key))) {
        insertData(new Data.fromMap({"key": key, "value": value}));
      }
    });
    (await getKeys()).forEach((key) {
      if (!_defaultData.containsKey(key)) {
        delete(key);
      }
    });
  }

  void initData() {
    _defaultData.forEach((key, value) async {
      if (!(await containsKey(key))) {
        insertData(new Data.fromMap({"key": key, "value": value}));
      }
    });
  }

  dynamic getDefaultData(String key) {
    return _defaultData[key];
  }
}

class Data {
  String key;
  Object value;

  Map<String, Object> toMap() {
    var map = <String, Object>{"key": key, "value": value};
    return map;
  }

  Data();

  Data.fromMap(Map<String, Object> map) {
    key = map["key"];
    value = map["value"];
  }
}
