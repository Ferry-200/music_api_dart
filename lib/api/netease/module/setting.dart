part of '../netease.dart';

// 设置
Future<Answer> _setting(Map params, List<Cookie> cookie) {
  return _request(
    'POST',
    'https://music.163.com/api/user/setting',
    {},
    crypto: Crypto.weApi,
    cookies: cookie,
  );
}
