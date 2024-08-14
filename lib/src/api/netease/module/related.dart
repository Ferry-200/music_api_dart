part of '../netease.dart';

// 相关视频
Future<Answer> _relatedAllvideo(Map params, List<Cookie> cookie) {
  return _request(
    'POST',
    'https://music.163.com/weapi/cloudvideo/v1/allvideo/rcmd',
    {
      'id': params['id'],
      'type': ((RegExp(r'^\d+$')).hasMatch(params['id'])) ? 0 : 1
    },
    crypto: Crypto.weApi,
    cookies: cookie,
  );
}

// 相关歌单
Future<Answer> _relatedPlaylist(Map params, List<Cookie> cookie) {
  return _request(
    'POST',
    'https://music.163.com/playlist?id=${params['id']}',
    {},
    crypto: Crypto.weApi,
    ua: 'pc',
    cookies: cookie,
  ).then((value) {
    throw 'TODO';
  });
}
