import 'package:flutter/material.dart';
import 'package:my_music/components/style.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({this.index, this.onPressedDelete, this.title, this.content});

  final int index;
  final Function onPressedDelete;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: dialogTitleTextStyle,),
      content: Text(content, style: dialogContentTextStyle,),
      actions: [
        FlatButton(
          child: Text("Cancel", style: dialogButtonTextStyle,),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Delete", style: dialogButtonTextStyle,),
          onPressed: onPressedDelete
        ),
      ],
    );
  }
}