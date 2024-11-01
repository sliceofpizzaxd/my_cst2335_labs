import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String? username, firstName, lastName, phoneNumber, email;

  /// Loads user data from EncryptedSharedPreferences
  static void loadData() {
    EncryptedSharedPreferences().getInstance().then( (prefs) {
      firstName = prefs.getString("firstName");
      lastName = prefs.getString("lastName");
      phoneNumber = prefs.getString("phoneNumber");
      email = prefs.getString("email");
    });
  }

  static void saveData() {
    EncryptedSharedPreferences().getInstance().then( (prefs) {
      prefs.setString("firstName", firstName!);
      prefs.setString("lastName", firstName!);
    });
  }
}