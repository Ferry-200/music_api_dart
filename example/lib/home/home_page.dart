import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_api_example/home/audiomack_page.dart';
import 'package:music_api_example/home/kuwo_page.dart';
import 'package:music_api_example/home/netease_page.dart';
import 'package:music_api_example/home/qq_page.dart';
import 'package:music_api_example/home/server_page.dart';

import 'baidu_page.dart';
import 'kugou_page.dart';
import 'migu_page.dart';
import 'mix_page.dart';
import 'my_free_mp3_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController? tabController;

  var pages = {
    "服务": const ServerPage(),
    "MyFreeMp3": const MyFreeMp3Page(),
    "AudioMack": const AudioMackPage(),
    "百度": const BaiduPage(),
    "酷我": const KuwoPage(),
    "酷狗": const KuGouPage(),
    "咪咕": const MiGuPage(),
    "企鹅": const QQPage(),
    "网易": const NeteasePage(),
    "混合api": const MixPage(),
  };

  @override
  void initState() {
    if (kIsWeb) {
      pages.remove("简单代理");
      pages.remove("服务");
    }
    tabController = TabController(length: pages.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("API测试"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: TabBar(
              isScrollable: true,
              controller: tabController,
              tabs: pages.keys.map((e) => Tab(text: e)).toList(),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: pages.values.toList(),
        ));
  }
}
