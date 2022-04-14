import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_first_flutter_app/movieInfo.dart';

final counterProvider = StateProvider((ref) => 0);

/************************************************************
 * main.
 ***********************************************************/
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/************************************************************
 * MyApp.
 ***********************************************************/
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

/************************************************************
 * トップページ画面.
 * 1. TopPageコンストラクタで映画情報の取得を開始して非同期結果待ちにする.
 * 2. 結果が届いたら内部データとcountProviderを更新して画面の再描画を促す.
 ***********************************************************/
class TopPage extends ConsumerWidget {
  TopPage() {
    print("consumer widget constructor called");
  }

  void update(WidgetRef ref) {
    ref.read(counterProvider.state).update((state) => state + 1);
  }

  List<MovieInfo>? _movieInfoList = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("hello=" + AppLocalizations.of(context)!.hello);

    // 映画情報の取得を開始する
    TheMovieDB().startGettingPopularMovieList().then(
            (List<MovieInfo> value) {
              // 取得できた
              _movieInfoList = value;
              update(ref);
            }
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.top_page_title)),
      body: Center(
        child: Consumer(builder: (context, ref, _) {
          final count = ref.watch(counterProvider);
          return ListView(children: _getListData(context));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          update(ref);
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
    int cnt = _movieInfoList?.length ?? 0;
    for (int i = 0; i < cnt; i++) {
      MovieInfo mi = _movieInfoList![i];
      widgets.add(new Padding(
          padding: new EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.face)),
            title: Text(mi.title,
                  style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent), ),
            onTap: () {
              print("onTap:$i");
              Navigator.push(ctx, MaterialPageRoute(builder: (c) => DetailPage(i)));
            },
          )
        ),
      );
    }
    return widgets;
  }
}

/************************************************************
 * 詳細ページ.
 ************************************************************/
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