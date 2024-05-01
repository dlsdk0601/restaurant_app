import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';

class DataUtils {
  static pathToUrl(String value) {
    return "${ip}${value}";
  }

  static Future<void> setTokenStorage(SignInRes res) async {
    final refreshToken = res.refreshToken;
    final accessToken = res.accessToken;
    // await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    // await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  }
}
