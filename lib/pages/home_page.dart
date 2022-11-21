import 'package:flutter/material.dart';
import 'package:habit_tracker_app/component/monthly_summary.dart';
import 'package:habit_tracker_app/component/my_fab.dart';
import 'package:habit_tracker_app/component/new_habit_box.dart';
import 'package:habit_tracker_app/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../component/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();

  final _myBox = Hive.box("Habit_database");

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createData();
    } else {
      db.loadData();
    }
    db.updateData();

    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
      db.updateData();
    });
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitController.text, false]);
    });
    cancelNewHabit();
    db.updateData();
  }

  void cancelNewHabit() {
    Navigator.of(context).pop();
    _newHabitController.clear();
    db.updateData();
  }

  final _newHabitController = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabit(
            controller: _newHabitController,
            cancel: cancelNewHabit,
            onsave: saveNewHabit,
          );
        });
    db.updateData();
  }

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabit(
            controller: _newHabitController,
            onsave: () {
              saveExistingHabit(index);
            },
            cancel: cancelNewHabit,
          );
        });
    db.updateData();
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitController.text;
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
    db.updateData();
  }

  void deleteHabit(index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: MyFloatActionButton(
          onPressed: createNewHabit,
        ),
        backgroundColor: Colors.blue[500],
        body: ListView(
          children: [
            MonthlySummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),
            ListView.builder(
              shrinkWrap: true,
              itemCount: db.todaysHabitList.length,
              itemBuilder: ((context, index) {
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitCompleted: db.todaysHabitList[index][1],
                  settingsTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                  onChanged: (value) {
                    checkBoxTapped(value, index);
                  },
                );
              }),
            ),
          ],
        ));
  }
}
