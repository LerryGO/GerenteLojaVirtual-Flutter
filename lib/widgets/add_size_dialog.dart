import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget{
  final  _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  
                  Navigator.of(context).pop(_controller.text);
                },
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.pinkAccent),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
