
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'DetailPage.dart';
import 'MyPreferences.dart';
import 'TextInputDialog.dart';
import 'TmProgressBar.dart';
import 'movieInfo.dart';


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
            builder: (context) => ListTile(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => DetailPage(mi.id)));
              },
            )));
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
    // クリアする
    //ref.read(_movieInfoProvider.state).update((oldOne) => <MovieInfo>[]);

    int totalPages = 10;
    _progressBarImpl.show(context);
    for( int i = 1; i <= totalPages; i++ ) {
      TheMovieDB().getPopularMovieInfos(i).then((List<MovieInfo> newOne) {
        // 取得できた
        ref.read(_movieInfoProvider.state).update((oldOne) {
          newOne.addAll(oldOne);
          if( i >= totalPages ) {
            _progressBarImpl.close(context);
          }
          return newOne;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // preferenceからapi_keyを取得する
    MyPreferences.getApiKey().then((value) {
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
                    MyPreferences.setApiKey(value.toString());
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
      body: Consumer(
        builder: (context, ref, _) {
          // 映画情報のリストをwatchする。
          // 画面が表示されると、ここは2回呼ばれる。
          // 1回目は空のリストを表示、2回目は取得したデータを用いて表示する。
          final List<MovieInfo> infoList = ref.watch(_movieInfoProvider);
          log("Consumer.builder called. list num=" + infoList.length.toString());
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
        },
      ),
    );
  }

}
