import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_flutter_app/MyPreferences.dart';

import 'DetailPage.dart';
import 'TextInputDialog.dart';
import 'movieInfo.dart';

/************************************************************
 * リスト画面.
 * 1. ListPageコンストラクタで映画情報の取得を開始して非同期結果待ちにする.
 * 2. 結果が届いたら内部データとcountProviderを更新して画面の再描画を促す.
 ***********************************************************/
class ListPage extends ConsumerWidget {
  // 映画情報のリストデータをRiverPodで管理する
  final _movieInfoProvider = StateProvider<List<MovieInfo>>((ref) {
    return <MovieInfo>[];
  });

  int _curPage = 0;
  int _processingCount = 0;

  ListPage() {
    log("consumer widget constructor called");
  }

  // 映画情報の取得を開始し、取得できたら画面更新を行う
  void updateMovieInfos(BuildContext context, WidgetRef ref) {
    if (!TheMovieDB.hasApiKey()) {
      log("no api key yet.");
      return;
    }

    // 一度クリアする
    //ref.read(_movieInfoProvider.state).update((oldOne) => <MovieInfo>[]);

    if (_processingCount > 3) {
      log("updateMovieInfo: processing overflow: " +
          _processingCount.toString());
      return;
    }
    _processingCount++;

    TheMovieDB()
        .getPopularMovieInfos(++_curPage)
        .then((List<MovieInfo> newOne) {
      final int cur = _curPage;
      ref.read(_movieInfoProvider.state).update((List<MovieInfo> oldOne) {
        List<MovieInfo> ret = <MovieInfo>[];
        ret.addAll(oldOne);
        ret.addAll(newOne);
        _processingCount--;
        log("newOne come. page=$cur, total element length=" +
            ret.length.toString());
        return ret;
      });
    });
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
        //appBar: AppBar(title: Text(AppLocalizations.of(context)!.top_page_title)),
        appBar: AppBar(title: Text("ListPage app bar")),
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
        body: Consumer(builder: (context, ref, _) {
          final List<MovieInfo> infoList = ref.watch(_movieInfoProvider);
          return _buildMovieList(infoList, ref);
        }));
  }

  Widget _buildMovieList(List<MovieInfo> list, WidgetRef ref) {
    return ListView.builder(
        //padding: const EdgeInsets.all(30.0),
        itemBuilder: (context, i) {
      MovieInfo? info = null;
      if (list.length <= i) {
        updateMovieInfos(context, ref);
        return Text("");
      } else {
        info = list[i];
      }
      log("i=$i, title=" + info!.title);

      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            minVerticalPadding: 20,
            horizontalTitleGap: 20,
            title: Text(info.title),
            subtitle: Text(
              info.overview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Image.network(info.getPosterPath()),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20) /*BorderRadiusで角の丸みを指定*/
                ),
            tileColor: Colors.black12,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => DetailPage(info!.id)));
            },
          ));
    });
  }
}
