import 'package:flutter/material.dart';
import 'package:habit_tracker_app/component/my_fab.dart';
import 'package:habit_tracker_app/component/new_habit_box.dart';

import '../component/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todaysHabitList = [
    // ["Habit Name", bool value];
    ["Morning Routine", false],
    ["Workout B ", false],
    ["Meditating ", false],
    ["some things to do", false]
  ];

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index][1] = value;
    });
  }

  void saveNewHabit() {
    setState(() {
      todaysHabitList.add([_newHabitController.text, false]);
    });
    cancelNewHabit();
  }

  void cancelNewHabit() {
    Navigator.of(context).pop();
    _newHabitController.clear();
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
  }

  void saveExistingHabit(int index) {
    setState(() {
      todaysHabitList[index][0] = _newHabitController.text;
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void deleteHabit(index) {
    setState(() {
      todaysHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFloatActionButton(
        onPressed: createNewHabit,
      ),
      backgroundColor: Colors.grey[500],
      body: ListView.builder(
        itemCount: todaysHabitList.length,
        itemBuilder: ((context, index) {
          return HabitTile(
            habitName: todaysHabitList[index][0],
            habitCompleted: todaysHabitList[index][1],
            settingsTapped: (context) => openHabitSettings(index),
            deleteTapped: (context) => deleteHabit(index),
            onChanged: (value) {
              checkBoxTapped(value, index);
            },
          );
        }),
      ),
    );
  }
}
