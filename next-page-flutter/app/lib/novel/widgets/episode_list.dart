import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../../member/screens/sign_in_screen.dart';
import '../../model/tmp_novel_episode.dart';
import '../../model/tmp_novel_model.dart';
import '../screens/scroll_novel_viewer_screen.dart';

class EpisodeList extends StatefulWidget {
  final String thumbnail;
  final int id;

  const EpisodeList({Key? key, required this.thumbnail, required this.id})
      : super(key: key);

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  late bool _loginState;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _asyncMethod();
    });
    super.initState();
  }

  void _asyncMethod() async {
    var prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    if (userToken != null) {
      setState(() {
        _loginState = true;
      });
    } else {
      setState(() {
        _loginState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: TmpEpisodeModel.episodeList.map((episode) {
            return _episodeCardList(episode);
          }).toList(),
        ),
      ),
    );
  }

  Widget _episodeCardList(dynamic episode) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(19), bottomLeft: Radius.circular(19)),
      child: Card(
        color: AppTheme.chalk,
        child: InkWell(
          onTap: () {
            print(_loginState);
            (_loginState)
                ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScrollNovelViewerScreen(
                      id: widget.id,
                      appBarTitle: TmpNovelModel.novelList[0].title,
                      episode: episode.episode)),
            )
                : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.13,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage(widget.thumbnail),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${TmpNovelModel.novelList[widget.id-1].title} ${episode.episode.toString()}화',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(episode.regDate),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
