import 'package:get/get_connect/http/src/response/response.dart';

import '../../views/base/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) {
    if (response.statusCode == 401) {
      // Show error message for invalid credentials
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
      // TODO: For token expiration, add logic to clear user data and navigate to sign-in screen
    } else {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
    }
  }
}