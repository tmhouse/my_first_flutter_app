import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_first_flutter_app/movieInfo.dart';

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
    TheMovieDB().getMovieDetail(_id).then((detail) {
      log("then detail result:" + detail.title);
      log("backdrop path=" + detail.getBackdropPath());
      ref.read(_movieDetailProvider.state).update((oldOne) => detail);
    });

    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.detail_page_title)),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(child: Consumer(
              builder: (context, ref, _) {
                final MovieDetail detail = ref.watch(_movieDetailProvider);
                log("consumer.builder detail is " + detail.title);
                return Column(
                    children: detail.id.length == 0
                        ? <Widget>[]
                        : <Widget>[
                      Image.network(detail.getPosterPath()),
                      paddingWrapper(
                          Text(detail.title, textScaleFactor: 2.0)),
                      paddingWrapper(Text(detail.original_title,
                          textScaleFactor: 1.5)),
                      //Text("status:" + detail.status, textScaleFactor: 1.5,),
                      Image.network(detail.getBackdropPath()),
                      Text(detail.vote_count.toString() + "いいね!",
                          textScaleFactor: 1.5),
                      Text("公開日:" + detail.release_date,
                          textScaleFactor: 1.5),
                      paddingWrapper(
                          Text(detail.overview, textScaleFactor: 1.2))
                    ]);
              },
            ))));
  }

  Widget paddingWrapper(Widget w, {double padding = 20}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: w,
    );
  }
}
