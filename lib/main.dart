import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_first_flutter_app/movieInfo.dart';

final counterProvider = StateProvider((ref) => 0);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja', ''),
        const Locale('en', ''),
      ],
      home: TopPage(),
    );
  }
}

/**
 * トップページ画面.
 */
class TopPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("hello=" + AppLocalizations.of(context)!.hello);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.top_page_title)),
      body: Center(
        child: Consumer(builder: (context, ref, _) {
          final count = ref.watch(counterProvider);
          //return Text('$count', style: TextStyle(fontSize: 100, color: Colors.lightBlueAccent));
          return ListView(children: _getListData(context));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.state).update((state) => state + 1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /**
   * Widgeのリストを返す.
   */
  List<Widget> _getListData(BuildContext ctx) {
    List<Widget> widgets = [];
    for (int i = 0; i < 20; i++) {
      widgets.add(new Padding(
          padding: new EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.face)),
            title: Text("Hello, world.$i",
                  style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent), ),
            onTap: () {
              print("onTap:$i");
              Navigator.push(ctx, MaterialPageRoute(builder: (c) => DetailPage(i)));

              // とりあえず映画情報を取得するテスト
              Future<String> res = TheMovieDB().getMoviePopular();
              res.then((value) {
                print("future.then res=" + value);
              });

            },
          )
        ),
      );
    }
    return widgets;
  }
}

/**
 * 詳細ページ.
 */
class DetailPage extends ConsumerWidget {
  int _detailNo;
  DetailPage(this._detailNo);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.detail_page_title)),
      body:Text("Detail Page:detail=$_detailNo"),
    );
  }
}