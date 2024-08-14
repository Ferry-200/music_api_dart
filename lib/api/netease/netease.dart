import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:music_api/entity/music_entity.dart';
import 'package:music_api/http/http_dio.dart';
import 'package:music_api/utils/answer.dart';
import 'package:music_api/utils/crypto.dart';
import 'package:music_api/utils/types.dart';
import 'package:music_api/utils/utils.dart';
import 'package:universal_io/io.dart';
import 'dart:async';
import 'dart:io';

part 'module/record.dart';
part 'module/sign.dart';
part 'module/album.dart';
part 'module/artist.dart';
part 'module/banner.dart';
part 'module/batch.dart';
part 'module/calendar.dart';
part 'module/captcha.dart';
part 'module/check_music.dart';
part 'module/cloud_match.dart';
part 'module/comment.dart';
part 'module/countries.dart';
part 'module/daily_signin.dart';
part 'module/digitalAlbum.dart';
part 'module/dj.dart';
part 'module/event.dart';
part 'module/fm.dart';
part 'module/history.dart';
part 'module/homepage.dart';
part 'module/hot.dart';
part 'module/like.dart';
part 'module/listen.dart';
part 'module/login.dart';
part 'module/lyric.dart';
part 'module/msg.dart';
part 'module/musician.dart';
part 'module/mlog.dart';
part 'module/mv.dart';
part 'module/personal.dart';
part 'module/playlist.dart';
part 'module/playmode.dart';
part 'module/recommend.dart';
part 'module/register.dart';
part 'module/related.dart';
part 'module/resource_like.dart';
part 'module/scrobble.dart';
part 'module/search.dart';
part 'module/send.dart';
part 'module/setting.dart';
part 'module/share.dart';
part 'module/simi.dart';
part 'module/song.dart';
part 'module/top.dart';
part 'module/user.dart';
part 'module/video.dart';
part 'module/weblog.dart';
part 'module/vip.dart';
part 'module/yunbei.dart';
part 'module/signin_progress.dart';
part 'module/nickname_check.dart';
part 'module/artist_follow_count.dart';
part 'module/music_tasks_new.dart';
part 'module/playlist_update_playcount.dart';
part 'module/vip_timemachine.dart';

class Netease {
  Netease._();

  static Future<Answer> banner() {
    return _banner.call({}, []);
  }

  static Future<Answer> search({String? keyWord, int? type, int? page, int? size}) {
    return _search.call({"keyWord": keyWord, "type": type, "page": page, "size": size}, []);
  }

  static Future<Answer> searchPc({String? keyWord, int? type, int? page, int? size}) {
    return _cloudSearch.call({"keyWord": keyWord, "type": type, "page": page, "size": size}, []);
  }

  static Future<Answer> songUrl({String? id, int? br}) {
    return _songUrl.call({"id": id, "br": br}, []);
  }

  ///歌词
  static Future<Answer> lyric({String? id}) {
    return _lyric.call({"id": id}, []);
  }

  ///精品歌单
  static Future<Answer> topPlaylist({String? cat, int? page, int? size}) {
    return _topPlaylist.call({"cat": cat, "page": page, "size": size}, []);
  }

  ///歌单详情
  // static Future<Answer> playlistInfo({String? id, int? page, int? size}) {
  //   return _playlistTrackAll.call({"id": id}, []);
  // }

  ///推荐歌单
  static Future<Answer> personalized({int? size}) {
    return _personalized.call({"limit": size}, []);
  }

  ///最新专辑
  static Future<Answer> albumNewest() {
    return _albumNewest.call({}, []);
  }

  ///专辑详情
  static Future<Answer> albumInfo({required String id}) {
    return _album({"id": id}, []);
  }

  ///最新专辑
  static Future<Answer> songNew() {
    return _topSong.call({}, []);
  }

  ///通过传过来的歌单id拿到所有歌曲数据
  static Future<Answer> playlistTrackAll({required String? id}) {
    return _playlistTrackAll.call({"id": id}, []);
  }

  /**
   * 歌手列表
      initial 取值 a-z/A-Z
      type 取值
      1:男歌手
      2:女歌手
      3:乐队

      area 取值
      -1:全部
      7华语
      96欧美
      8:日本
      16韩国
      0:其他
   */
  static Future<Answer> artistList({String? initial, int? type, int? area, int? page, int? size}) {
    return _artistList.call({"initial": initial, "type": type, "area": area, "page": page, "size": size}, []);
  }

  static Future<Answer> topArtists() {
    return _topArtists.call({}, []);
  }

  ///排行榜
  static Future<Answer> topList() {
    return _toplistDetail.call({}, []);
  }

  ///排行榜
  static Future<Answer> artistSongs({required String id, int? page, int? size}) {
    return _artistSongs.call({"id": id, "page": page, "size": size}, []);
  }

  static Future<Answer> api(String? path, {Map? params, List<Cookie> cookie = const []}) {
    if (!_api.containsKey(path)) {
      return Future.value(const Answer(site: MusicSite.Netease).copy(code: 500, msg: "url:“$path”未被定义, 请检查", data: _api.keys.toList()));
    }
    return _api[path]!.call(params ?? {}, cookie);
  }
}

//Api列表
final _api = <String, Api>{
  //专辑
  "/album": _album,
  "/album/detail/dynamic": _albumDetailDynamic,
  "/album/detail": _albumDetail,
  "/album/style": _albumStyle,
  "/album/list": _albumList,
  "/album/new": _albumNew,
  "/album/newest": _albumNewest,
  "/album/songsaleboard": _albumSongSaleBoard,
  "/album/sub": _albumSub,
  "/album/sublist": _albumSublist,
  "/album/sales": _albumSales,
  //歌手
  "/artist/album": _artistAlbum,
  "/artist/desc": _artistDesc,
  "/artist/detail": _artistDetail,
  "/artist/list": _artistList,
  "/artist/mv": _artistMv,
  "/artist/video": _artistVideo,
  "/artist/new/mv": _artistNewMv,
  "/artist/new/song": _artistNewSong,
  "/artist/songs": _artistSongs,
  "/artist/sub": _artistSub,
  "/artist/sublist": _artistSubList,
  "/artist/top/song": _artistTopSong,
  "/artists": _artists,
  "/artists/fans": _artistFans,
  //Banner
  "/banner": _banner,
  // 批量请求接口
  "/batch": _batch,
  //音乐日历
  "/calendar": _calendar,
  //验证码
  "/captcha/send": _captchaSend,
  "/captcha/verify": _captchaVerify,
  //音乐是否可用
  "check/music": _checkMusic,
  //云盘
  "cloud/match": _cloudMatch,
  //评论
  "/comment/album": _commentAlbum,
  "/comment/dj": _commentDj,
  "/comment/events": _commentEvents,
  "/comment/floor": _commentFloor,
  "/comment/hot": _commentHot,
  "/comment/hug/list": _commentHugList,
  "/comment/hug": _commentHugListener,
  "/comment/like": _commentLike,
  "/comment/music": _commentMusic,
  "/comment/mv": _commentMv,
  "/comment/playlist": _commentPlaylist,
  "/comment/video": _commentVideo,
  "/comment/new": _commentNew,
  "/comment": _comment,
  //签到
  "/daily_signin": _dailySignin,
  //数字专辑
  "/digitalAlbum/ordering": _digitalAlbumOrdering,
  "/digitalAlbum/purchased": _digitalAlbumPurchased,
  //电台
  "/dj/banner": _djBanner,
  "/dj/category/excludehot": _djCategoryExcludehot,
  "/dj/category/recommend": _djCategoryRecommend,
  "/dj/catelist": _djCatelist,
  "/dj/detail": _djDetail,
  "/dj/hot": _djHot,
  "/dj/paygift": _djPaygift,
  "/dj/personalize/recommend": _djPersonalizeRcmd,
  "/dj/program/detail": _djProgramDetail,
  "/dj/program/toplist/hours": _djProgramToplistHours,
  "/dj/program/toplist": _djProgramToplist,
  "/dj/program": _djProgram,
  "/dj/radio/hot": _djRadioHot,
  "/dj/recommend/type": _djRecommendType,
  "/dj/recommend": _djRecommend,
  "/dj/sub": _djSub,
  "/dj/sublist": _djSublist,
  "/dj/subscriber": _djSubscriber,
  "/dj/today/perfered": _djTodayPerfered,
  "/dj/toplist/hours": _djToplistHours,
  "/dj/toplist/newcomer": _djToplistNewcomer,
  "/dj/toplist/pay": _djToplistPay,
  "/dj/toplist/popular": _djToplistPopular,
  "/dj/toplist": _djToplist,
  //动态
  "/event/del": _eventDel,
  "/event/forward": _eventForward,
  "/event": _event,
  //垃圾桶
  "/fm_trash": _fmTrash,
  //历史日推
  "/history/recommend/songs/detail": _historyRecommendSongsDetail,
  "/history/recommend/songs": _historyRecommendSongs,
  //首页
  "/homepage/block/page": _homepageBlockPage,
  "/homepage/dragon/ball": _homepageDragonBall,
  //热门话题
  "/hot/topic": _hotTopic,
  //喜欢音乐
  "/like": _like,
  "/likelist": _likelist,
  //一起听状态
  "listen/together/status": _listenTogetherStatus,
  //登录
  "/login/cellphone": _loginCellphone,
  "/login/qr/check": _loginQrCheck,
  "/login/qr/create": _loginQrCreate,
  "/login/qr/key": _loginQrKey,
  "/login/refresh": _loginRefresh,
  "/login/status": _loginStatus,
  "/login": _login,
  "/logout": _logout,
  "/cellphone/existence/check": _cellphoneExistenceCheck,
  "/activate/init/profile": _activateInitProfile,
  //歌词
  "/lyric": _lyric,
  //mlog
  "/mlog/video": _mlogToVideo,
  "/mlog/url": _mlogUrl,
  "/mlog/music/rcmd": _mlogMusicRcmd,
  //通知消息
  "/msg/comment": _msgComment,
  "/msg/forwards": _msgForwards,
  "/msg/notice": _msgNotice,
  "/msg/private/history": _msgPrivateHistory,
  "/msg/private": _msgPrivate,
  "/msg/recentcontact": _msgRecentcontact,
  //音乐人
  'musician/cloudbean': _musicianCloudBean,
  'musician/cloudbean/obtain': _musicianCloudBeanObtain,
  'musician/data/overview': _musicianDataOverview,
  'musician/play/trend': _musicianPlayTrend,
  'musician/task': _musicianTask,
  'musician/sign': _musicianSign,
  //MV
  "/mv/all": _mvAll,
  "/mv/detail/info": _mvDetailInfo,
  "/mv/detail": _mvDetail,
  "/mv/exclusive/rcmd": _mvExclusiveRcmd,
  "/mv/first": _mvFirst,
  "/mv/sub": _mvSub,
  "/mv/sublist": _mvSublist,
  "/mv/url": _mvUrl,
  //电台
  "/personal_fm": _personalFm,
  "/personalized/djprogram": _personalizedDjprogram,
  "/personalized/mv": _personalizedMv,
  "/personalized/newsong": _personalizedNewsong,
  "/personalized/privatecontent/list": _personalizedPrivatecontentList,
  "/personalized/privatecontent": _personalizedPrivatecontent,
  "/personalized": _personalized,

  //歌单
  "/playlist/catlist": _playlistCatlist,
  "/playlist/create": _playlistCreate,
  "/playlist/delete": _playlistDelete,
  "/playlist/desc/update": _playlistDescUpdate,
  "/playlist/detail/dynamic": _playlistDetailDynamic,
  "/playlist/detail": _playlistDetail,
  "/playlist/track/all": _playlistTrackAll,
  "/playlist/highquality/tags": _playlistHighqualityTags,
  "/playlist/hot": _playlistHot,
  "/playlist/mylike": _playlistMyLike,
  "/playlist/name/update": _playlistNameUpdate,
  "/playlist/order/update": _playlistOrderUpdate,
  "/playlist/subscribe": _playlistSubscribe,
  "/playlist/subscribers": _playlistSubscribers,
  "/playlist/tags/update": _playlistTagsUpdate,
  "/playlist/track/add": _playlistTrackAdd,
  "/playlist/track/delete": _playlistTrackDelete,
  "/playlist/tracks": _playlistTracks,
  "/playlist/update": _playlistUpdate,
  "/playlist/video/recent": _playlisVideoRecent,
  "/playlist/privacy": _playlisPrivacy,
  //心动模式/智能播放
  "/playmode/intelligence/list": _playmodeIntelligenceList,
  //推荐
  "/program/recommend": _programRecommend,
  "/recommend/resource": _recommendResource,
  "/recommend/songs": _recommendSongs,
  //注册(修改密码)
  "/register/cellphone": _registerCellphone,
  //相关
  "/related/allvideo": _relatedAllvideo,
  "/related/playlist": _relatedPlaylist,
  //资源点赞( MV,电台,视频)
  "/resource/like": _resourceLike,
  "/scrobble": _scrobble,
  //搜索
  "/search/default": _searchDefaultKeyword,
  "/search/hot/detail": _searchHotDetail,
  "/search/hot": _searchHot,
  "/search/multimatch": _searchMultimatch,
  "/search/suggest": _searchSuggest,
  "/search": _search,
  "/cloudSearch": _cloudSearch,
  //私信
  "send/playlist": _sendPlaylist,
  "send/song": _sendSong,
  "send/text": _sendText,
  //设置
  "setting": _setting,
  //分享
  "/share/resource": _shareResource,
  //相似
  "/simi/artist": _simiArtist,
  "/simi/mv": _simiMv,
  "/simi/playlist": _simiPlaylist,
  "/simi/song": _simiSong,
  "/simi/user": _simiUser,
  //歌曲
  "/song/detail": _songDetail,
  "/song/order/update": _songOrderUpdate,
  "/song/url": _songUrl,
  "/song/download/url": _songDownloadUrl,
  "/song/purchased": _songPurchased,
  //热门
  "/top/album": _topAlbum,
  "/top/artists": _topArtists,
  "/top/list": _topList,
  "/top/mv": _topMv,
  "/top/playlist/highquality": _topPlaylistHighquality,
  "/top/playlist": _topPlaylist,
  "/top/song": _topSong,
  //话题
  "/topic/detail/event/hot": _topicDetailEventHot,
  "/topic/detail": _topicDetail,
  "/topic/sublist": _topicSubList,
  //榜单
  "/toplist/artist": _toplistArtist,
  "/toplist/detail": _toplistDetail,
  "/toplist": _toplist,
  //用户
  "/user/account": _userAccount,
  "/user/audio": _userAudio,
  "/user/bindingCellphone": _userBindingCellphone,
  "/user/binding": _userBinding,
  "/user/cloud/del": _userCloudDel,
  "/user/cloud/detail": _userCloudDetail,
  "/user/cloud": _userCloud,
  "/user/detail": _userDetail,
  "/user/dj": _userDj,
  "/user/event": _userEvent,
  "/follow": _userFollow,
  "/user/followeds": _userFolloweds,
  "/user/follows": _userFollows,
  "/user/level": _userLevel,
  "/user/playlist": _userPlaylist,
  "/user/record": _userRecord,
  "/user/replacephone": _userReplaceCellphone,
  "/user/subcount": _userSubcount,
  "/user/update": _userUpdate,
  "/user/comment/history": _userCommentHistory,
  //视频
  "/video/detail/info": _videoDetailInfo,
  "/video/detail": _videoDetail,
  "/video/group/list": _videoGroupList,
  "/video/group": _videoGroup,
  "/video/sub": _videoSub,
  "/video/timeline/all": _videoTimelineAll,
  "/video/timeline/recommend": _videoTimelineRecommend,
  "/video/url": _videoUrl,
  //VIP
  "vip/growthpoint": _vipGrowthpoint,
  "vip/growthpoint/detail": _vipGrowthpointDetail,
  "vip/growthpoint/get": _vipGrowthpointGet,
  "vip/task": _vipTasks,
  "vip/info": _vipInfo,

  "/weblog": _weblog,
  //云贝
  "/yunbei/tasks/expense": _yunbeiExpense,
  "/yunbei/info": _yunbeiInfo,
  "/yunbei/tasks/receipt": _yunbeiReceipt,
  "/yunbei/sign": _yunbeiSign,
  "/yunbei/task/finish": _yunbeiTaskFinish,
  "/yunbei/tasks/todo": _yunbeiTaskTodo,
  "/yunbei/tasks": _yunbeiTask,
  "/yunbei/today": _yunbeiToday,
  "/yunbei": _yunbei,
  "/yunbei/rcmd/song": _yunbeiRcmdSong,
  "/yunbei/rcmd/song/hhistory": _yunbeiRcmdSongHistory,

  // 乐签信息接口
  "/sign/happy/info": _signHappyInfo,

  //签到进度
  "/signin/progress": _signInProgress,

  ///最近播放
  "/record/recent/album": _recordRecentAlbum,
  "/record/recent/dj": _recordRecentDj,
  "/record/recent/song": _recordRecentSong,
  "/record/recent/playlist": _recordRecentPlaylist,
  "/record/recent/voice": _recordRecentVoice,
  "/record/recent/cideo": _recordRecentVideo,

  //重复昵称检测
  "/nickname/check": _nicknameCheck,
  // 歌手粉丝数量
  "/artist/follow/count": _artistFollowCount,
  // 获取音乐人任务
  "/music/tasks/new": _musicTasksNew,
  //// 歌单打卡
  "/playlist/update/playcount": _playlistUpdatePlaycount,
  "/vip/timemachine": _vipTimemachine,
};

enum Crypto { linuxApi, weApi }

String _chooseUserAgent({String? ua}) {
  const userAgentList = [
    'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1',
    'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
    'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Mobile/14F89;GameHelper',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1',
    'Mozilla/5.0 (iPad; CPU OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:46.0) Gecko/20100101 Firefox/46.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:46.0) Gecko/20100101 Firefox/46.0',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/13.10586'
  ];

  var r = Random();
  int index;
  if (ua == 'mobile') {
    index = (r.nextDouble() * 7).floor();
  } else if (ua == "pc") {
    index = (r.nextDouble() * 5).floor() + 8;
  } else {
    index = (r.nextDouble() * (userAgentList.length - 1)).floor();
  }
  return userAgentList[index];
}

Map<String, String> _buildHeader(String url, String? ua, String method, List<Cookie> cookies) {
  final headers = {'User-Agent': _chooseUserAgent(ua: ua)};
  if (method.toUpperCase() == 'POST') headers['Content-Type'] = 'application/x-www-form-urlencoded';
  if (url.contains('music.163.com')) headers['Referer'] = 'https://music.163.com';
  headers['Cookie'] = cookies.join("; ");
  return headers;
}

Future<Answer> _eApiRequest({
  required String url,
  required String optionUrl,
  required Map<String, dynamic> data,
  List<Cookie> cookies = const [],
  String? ua,
  String method = 'POST',
}) {
  final headers = _buildHeader(url, ua, method, cookies);

  final cookie = {for (var item in cookies) item.name: item.value};
  final csrfToken = cookie['__csrf'] ?? '';
  final header = {
    //系统版本
    "osver": cookie['osver'],
    //encrypt.base64.encode(imei + '\t02:00:00:00:00:00\t5106025eb79a5247\t70ffbaac7')
    "deviceId": cookie['deviceId'],
    // app版本
    "appver": cookie['appver'] ?? "8.7.01",
    //版本号
    "versioncode": cookie['versioncode'] ?? "140",
    //设备model
    "mobilename": cookie['mobilename'],
    "buildver": cookie['buildver'] ?? (DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)),
    //设备分辨率
    "resolution": cookie['resolution'] ?? "1920x1080",
    "__csrf": csrfToken,
    "os": cookie['os'] ?? 'android',
    "channel": cookie['channel'],
    "requestId": '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000).toString().padLeft(4, '0')}'
  };
  if (cookie['MUSIC_U'] != null) header["MUSIC_U"] = cookie['MUSIC_U'];
  if (cookie['MUSIC_A'] != null) header["MUSIC_A"] = cookie['MUSIC_A'];
  headers['Cookie'] = header.keys.map((key) => '${Uri.encodeComponent(key)}=${Uri.encodeComponent(header[key] ?? '')}').join('; ');

  data['header'] = header;
  data = eapi(optionUrl, data);
  url = url.replaceAll(RegExp(r"\w*api"), 'eapi');

  return HttpDio().request(url, method: method, headers: headers, params: data).then((response) async {
    // final bytes = (await response.expand((e) => e).toList()).cast<int>();
    //
    // List<int> data;
    // try {
    //   data = zlib.decode(bytes);
    // } catch (e) {
    //   //解压失败,不处理
    //   data = bytes;
    // }
    var cookies = response?.headers[HttpHeaders.setCookieHeader] ?? [];
    var ans = const Answer(site: MusicSite.Netease);
    ans = ans.copy(cookie: cookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
    ans = ans.copy(code: response?.statusCode);
    try {
      Map content = json.decode(decrypt(response?.data?.toString().codeUnits ?? []));
      ans = ans.copy(
        data: content,
        code: content['code'],
      );
    } catch (e) {
      ans = ans.copy(data: json.decode(response?.data));
    }

    ans = ans.copy(code: ans.code > 100 && ans.code < 600 ? ans.code : 400);
    return ans;
  }).catchError((e, s) {
    return Answer(site: MusicSite.Netease, code: 502, msg: e.toString(), data: {'code': 502, 'msg': e.toString()});
  });
}

///[crypto] 只支持 [Crypto.linuxApi] 和 [Crypto.weApi]
Future<Answer> _request(
  String method,
  String url,
  Map<String, dynamic> data, {
  List<Cookie> cookies = const [],
  String? ua,
  Crypto crypto = Crypto.weApi,
}) async {
  final headers = _buildHeader(url, ua, method, cookies);
  if (crypto == Crypto.weApi) {
    var csrfToken = cookies.firstWhere((c) => c.name == "__csrf", orElse: () => Cookie("__csrf", ""));
    data["csrf_token"] = csrfToken.value;
    data = weApi(data);
    url = url.replaceAll(RegExp(r"\w*api"), 'weapi');
  } else if (crypto == Crypto.linuxApi) {
    data = linuxApi({"params": data, "url": url.replaceAll(RegExp(r"\w*api"), 'api'), "method": method});
    headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36';
    url = 'https://music.163.com/api/linux/forward';
  }
  return HttpDio().request(url, method: method, headers: headers, params: data).then((response) async {
    var cookies = response?.headers[HttpHeaders.setCookieHeader] ?? [];
    var ans = const Answer(site: MusicSite.Netease);
    ans = ans.copy(cookie: cookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
    ans = ans.copy(code: response?.statusCode);

    // String content = await response.transform(utf8.decoder).join();
    dynamic body;
    if (response?.data is String) {
      body = json.decode(response?.data);
    } else {
      body = response?.data;
    }
    ans = ans.copy(code: int.parse(body['code'].toString()), data: body);
    ans = ans.copy(code: ans.code > 100 && ans.code < 600 ? ans.code : 400);
    return ans;
  }).catchError((e, s) {
    return Answer(site: MusicSite.Netease, code: 502, data: {'code': 502, 'msg': e.toString()});
  });
}