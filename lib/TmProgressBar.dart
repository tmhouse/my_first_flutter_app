import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 処理中を示すプログレスバー.
 */
class TmProgressBarImpl {
  Future? _future;

  void show(BuildContext context) {
    close(context);
    _future = showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void close(BuildContext context) {
    if (_future != null) {
      Navigator.of(context).pop();
      _future = null;
    }
  }
}
