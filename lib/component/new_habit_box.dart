import 'package:flutter/material.dart';

class EnterNewHabit extends StatelessWidget {
  final controller;
  final VoidCallback onsave;
  final VoidCallback cancel;
  const EnterNewHabit({
    Key? key,
    required this.onsave,
    required this.cancel,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          focusColor: Colors.blue,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orangeAccent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
      actions: [
        AlertButtonWidget(
          onPressed: onsave,
          buttonName: 'Save',
        ),
        AlertButtonWidget(
          onPressed: cancel,
          buttonName: "Cancel",
        ),
      ],
    );
  }
}

class AlertButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final String buttonName;
  const AlertButtonWidget({
    Key? key,
    required this.onPressed,
    required this.buttonName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.black,
      child: Text(
        buttonName,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
