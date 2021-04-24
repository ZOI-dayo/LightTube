import 'package:googleapis/admob/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  SharedPreferences _prefs;
  Map<String, dynamic> _defaultData = {
    "Theme": "dark", // カラーテーマ: ["light","dark","black"]
    "Theme.dark.bgColor": "#000000", // 背景色: #NNNNNN
    "Thumbnail.size": "big", // サムネイルのサイズ: ["none","small","large"]
  };

  Config() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences getPrefs() {
    return _prefs;
  }

  void setData(String key, dynamic value) {
    switch (_defaultData[key].runtimeType) {
      case String:
        _prefs.setString(key, _defaultData[key]);
        break;
      case StringList:
        _prefs.setStringList(key, _defaultData[key]);
        break;
      case bool:
        _prefs.setBool(key, _defaultData[key]);
        break;
      case int:
        _prefs.setInt(key, _defaultData[key]);
        break;
      case double:
        _prefs.setDouble(key, _defaultData[key]);
        break;
      default:
        break;
    }
  }

  void resetData() {
    _defaultData.forEach((key, value) {
      if (!_prefs.containsKey(key)) {
        setData(key, value);
      }
    });
    _prefs.getKeys().forEach((key) {
      if (!_defaultData.containsKey(key)) {
        _prefs.remove(key);
      }
    });
  }

  void initData() {
    _defaultData.forEach((key, value) {
      if (!_prefs.containsKey(key)) {
        setData(key, value);
      }
    });
  }

  dynamic getDefaultData(String key) {}
}
