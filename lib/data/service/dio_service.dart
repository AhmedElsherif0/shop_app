import 'package:dio/dio.dart';

class DioService {
  static Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://shop-app-374e3-default-rtdb.firebaseio.com',
        receiveDataWhenStatusError: false));
  }

  Future<Response> getResponse(
      {String url, Map<String, dynamic> queryParameters}) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> postResponse(String url,dynamic data) async {
    return await dio.post(url,data: data);
  }
}
