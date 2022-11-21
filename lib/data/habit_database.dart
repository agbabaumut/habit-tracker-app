import 'package:habit_tracker_app/datetime/date_time.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Habit_database");

class HabitDatabase {
  List todaysHabitList = [];

  Map<DateTime, int> heatMapDataSet = {};

  // create initial database
  void createData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false]
    ];
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load data if it exist
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      for (var i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update the data
  void updateData() {
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
    calculateHabitPercentage();
    loadHeatMap();
  }

  void calculateHabitPercentage() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] = true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? "0.0"
        : (countCompleted / todaysHabitList.length).toStringAsFixed(
            1,
          );
    _myBox.put("PERCENTAGE_SUMMARY_$todaysDateFormatted", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    int daysBetween = DateTime.now().difference(startDate).inDays;
    for (int i = 0; i < daysBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
