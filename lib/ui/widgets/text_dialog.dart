import 'package:game_tv_demo/utils/locale/app_translation.dart';
import 'package:flutter/material.dart';

class TextDialog {
  static void showTextDialog(BuildContext context, String message,
      {String title,
      Function onPressed,
      Color backgroundColor,
      bool barrierDismissible = true,
      String actionButtonText,
      String cancelButtonText,
      bool isNeedToAvoidOnPressCallOnBackPress = false}) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
            if (onPressed != null && !isNeedToAvoidOnPressCallOnBackPress) {
              onPressed();
            }
            return Future<bool>.value(false);
          },
          child: AlertDialog(
            title: title != null && title.isNotEmpty
                ? Text(title)
                : const Text('Oops!'),
            content: Text(message),
            actions: <Widget>[
              if (cancelButtonText != null)
                FlatButton(
                  child: Text(cancelButtonText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              FlatButton(
                child: actionButtonText != null
                    ? Text(actionButtonText)
                    : Text(AppTranslations.of(context).getString('ok')),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onPressed != null) {
                    onPressed();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
