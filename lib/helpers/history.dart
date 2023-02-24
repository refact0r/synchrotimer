import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchrotimer/helpers/utils.dart';

class History {
  final SharedPreferences sharedPrefs;
  List<String> localHistory = [];

  History(this.sharedPrefs) {
    if (sharedPrefs.getStringList('history') == null) {
      sharedPrefs.setStringList('history', []);
    } else {
      localHistory = sharedPrefs.getStringList('history')!;
    }
  }

  List<List<Object>> get history {
    List<List<Object>> history = [];
    for (String str in localHistory) {
      List<String> split = str.split(',');
      history.add([split[0], split[1], split[2], split[3], split[4] == 'true', split[5] == 'true']);
    }
    return history;
  }

  void add(List<String> timeStrings, String eventString, bool deckExceeded, bool walkExceeded) {
    List<String> strList = sharedPrefs.getStringList('history')!;
    strList.add('${timeStrings.join(',')},$eventString,$deckExceeded,$walkExceeded');
    localHistory = strList;
    sharedPrefs.setStringList('history', strList);
  }

  void clear() {
    sharedPrefs.setStringList('history', []);
    localHistory = [];
  }
}
