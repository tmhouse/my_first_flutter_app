import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * テキスト入力を行うダイアログWidget.
 */
class TextInputDialog extends ConsumerWidget {
  final textCtrl = TextEditingController();
  String _title;
  String _hint;

  TextInputDialog(this._title, this._hint);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> actions = [
      TextButton(
        child: Text(localizations.cancelButtonLabel),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          Navigator.pop<String>(context, textCtrl.text);
        },
      ),
    ];
    final AlertDialog dialog = AlertDialog(
      title: Text(this._title),
      content: TextField(
        controller: textCtrl,
        decoration: InputDecoration(
          hintText: this._hint,
        ),
        autofocus: true,
        keyboardType: TextInputType.text,
      ),
      actions: actions,
    );

    return dialog;
  }
}
