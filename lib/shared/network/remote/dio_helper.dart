import 'package:dio/dio.dart';


class DioHelper {
  static late Dio dio;

  static init(){
    dio = Dio(
        BaseOptions(
            baseUrl:'https://student.valuxapps.com/api/',
            receiveDataWhenStatusError: true,
        )
    );
  }


  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang= 'en',
    String? token,
  }) async
  {
    dio.options.headers={
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required Map<String,dynamic>? data,
  })async
  {
    dio.options.headers={
      'Content-Type':'application/json',
      'Authorization':'Key = AAAAk8LRqi4:APA91bFQpZDNUBEagvXsY1b4ECtkS9m6wRAIRbne2dq34X3KpoqKXQCRwGEGN4A40PqwtxmPbsZNOC6ALoR0nwa5Swic6SExoYR5Qgjm26nC9VIbgeQdmEnPQYTp6PMNYymwxnijyHPu',
    };
    return dio.post(
      'https://fcm.googleapis.com/fcm/send',
       data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String,dynamic>? query,
    required Map<String,dynamic>? data,
    String lang= 'en',
    String? token,
  })async
  {
    dio.options.headers={
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}