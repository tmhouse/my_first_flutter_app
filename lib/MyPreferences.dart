import 'package:shared_preferences/shared_preferences.dart';

/************************************************************
 * preferences.
 ***********************************************************/
class MyPreferences {
  static final String _pref_api_key_name = "apikey";

  static Future<dynamic> _getPrefrence(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.get(key);
  }

  static void _setPreference(String key, dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    if (value is int) {
      pref.setInt(key, value);
    } else if (value is double) {
      pref.setDouble(key, value);
    } else if (value is String) {
      pref.setString(key, value);
    } else {
      throw new UnimplementedError("ohhh");
    }
  }

  static void setApiKey(String apikey) {
    _setPreference(_pref_api_key_name, apikey);
  }

  static Future<String> getApiKey() async {
    String apikey = "";
    await _getPrefrence(_pref_api_key_name).then((value) {
      if (value != null) {
        apikey = value.toString();
      }
    } );
    return apikey;
  }

}