import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  void Function(BuildContext)? settingsTapped;
  void Function(BuildContext)? deleteTapped;
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  HabitTile({
    Key? key,
    required this.settingsTapped,
    required this.deleteTapped,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: settingsTapped,
              borderRadius: BorderRadius.circular(23.0),
              icon: Icons.settings,
            ),
            SlidableAction(
              onPressed: deleteTapped,
              borderRadius: BorderRadius.circular(23.0),
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
              ),
              Text(
                habitName,
                style: TextStyle(
                  decoration: habitCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
