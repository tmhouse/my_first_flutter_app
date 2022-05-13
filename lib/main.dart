import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_first_flutter_app/movieInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TextInputDialog.dart';
import 'TmProgressBar.dart';

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
  // 映画情報のリストデータをRiverPodで管理する
  final _movieInfoProvider = StateProvider<List<MovieInfo>>((ref) {
    return <MovieInfo>[];
  });

  //ScrollController _scrollController = ScrollController();
  TmProgressBarImpl _progressBarImpl = TmProgressBarImpl();

  TopPage() {
    log("consumer widget constructor called");
  }

  // 映画情報の取得を開始し、取得できたら画面更新を行う
  void updateMovieInfos(BuildContext context, WidgetRef ref) {
    _progressBarImpl.show(context);

    // 一度クリアする
    ref.read(_movieInfoProvider.state).update((oldOne) => <MovieInfo>[]);
    TheMovieDB().startGettingPopularMovieList(minLength:100).then((List<MovieInfo> newOne) {
      // 取得できた
      ref.read(_movieInfoProvider.state).update((oldOne) => newOne);
      _progressBarImpl.close(context);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // preferenceからapi_keyを取得する
    getPrefrence(_pref_api_key_name).then((value) {
      log("apiKey=" + value.toString());
      if (value != null) {
        TheMovieDB.setApiKey(value.toString());
        updateMovieInfos(context, ref);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.top_page_title)),
      // 上部固定のエリア
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Settings'),
            ),
            ListTile(
              title: const Text('Setup API KEY'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TextInputDialog("input your api key", "api key");
                  },
                ).then((value) {
                  if (value != null) {
                    log("dialog returns=" + value.toString());
                    setPreference(_pref_api_key_name, value.toString());
                    TheMovieDB.setApiKey(value.toString());
                    updateMovieInfos(context, ref);
                  } else {
                    log("dialog canceled");
                  }
                });
              },
            ),
          ],
        ),
      ),

      // 本体
      body: Consumer(builder: (context, ref, _) {
        // 映画情報のリストをwatchする。
        // 画面が表示されると、ここは2回呼ばれる。
        // 1回目は空のリストを表示、2回目は取得したデータを用いて表示する。
        final List<MovieInfo> infoList = ref.watch(_movieInfoProvider);
        return SingleChildScrollView(
          child: PaginatedDataTable(
            //header: Text("スクロールするよ"),
            //rowsPerPage: ,
            dataRowHeight: 120,
            source: MyMovieData(infoList),
            columns: const [
              DataColumn(label: Text("一覧")),
            ],
            columnSpacing: 10,
            horizontalMargin: 10,
            //rowsPerPage: 8,
            showCheckboxColumn: false,
          ),
        );
      },),
    );
  }

  final String _pref_api_key_name = "apikey";

  Future<dynamic> getPrefrence(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.get(key);
  }

  void setPreference(String key, dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    if (value is int) {
      pref.setInt(key, value);
    } else if (value is double) {
      pref.setDouble(key, value);
    } else if (value is String) {
      pref.setString(key, value);
    } else {
      throw new UnimplementedError("ohhh");
    }
  }
}

/**
 * リスト表示を司る.
 */
class MyMovieData extends DataTableSource {
  List<MovieInfo> _list = [];

  MyMovieData(this._list);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _list.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    MovieInfo mi = _list[index];
    return DataRow(cells: [
      DataCell(_getRowWidget(mi)),
    ]);
  }

  Widget _getRowWidget(MovieInfo mi) {
    return Padding(
        padding: new EdgeInsets.all(10.0),
        child: Builder(
          builder:(context) =>
            ListTile(
              leading: Image.network(mi.getPosterPath()),
              title: Text(
                mi.title + "\n" + mi.original_title,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.lightBlueAccent,
                    fontStyle: FontStyle.italic),
                ),
              subtitle: Text(mi.overview, maxLines: 3),
              isThreeLine: true,
            onTap: () {
              log("onTap:");
              Navigator.push(
                    context, MaterialPageRoute(builder: (c) => DetailPage(mi.id)));
            },
        )
    ));
  }
}

/************************************************************
 * 詳細ページ.
 ************************************************************/
class DetailPage extends ConsumerWidget {
  // 映画の詳細情報をRiverPodで管理する
  final _movieDetailProvider = StateProvider<MovieDetail>((ref) {
    return MovieDetail();
  });

  String _id;

  DetailPage(this._id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TheMovieDB().startGettingMovieDetail(_id).then((detail) {
      log("then detail result:" + detail.title);
      log("backdrop path=" + detail.getBackdropPath());
      ref.read(_movieDetailProvider.state).update((oldOne) => detail);
    });

    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.detail_page_title)),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
            child: Center(
              child: Consumer(
                builder: (context, ref, _) {
                  final MovieDetail detail = ref.watch(_movieDetailProvider);
                  log("consumer.builder detail is " + detail.title);
                  return Column(
                    children: detail.id.length == 0 ? <Widget>[] :
                      <Widget>[
                        Image.network(detail.getPosterPath()),
                        paddingWrapper(Text(detail.title, textScaleFactor: 2.0)),
                        paddingWrapper(Text(detail.original_title, textScaleFactor: 1.5)),
                        //Text("status:" + detail.status, textScaleFactor: 1.5,),
                        Image.network(detail.getBackdropPath()),
                        Text(detail.vote_count.toString() + "いいね!", textScaleFactor: 1.5),
                        Text("公開日:" + detail.release_date, textScaleFactor: 1.5),
                        paddingWrapper(Text(detail.overview, textScaleFactor: 1.2))
                      ]
                  );
                },
              )
            )
          )
    );
  }

  Widget paddingWrapper(Widget w, {double padding=20}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: w,
    );
  }
}
