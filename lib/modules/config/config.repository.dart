import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/config.dart';
import 'package:mybabernew/entity/user.dart';

class ConfigRepository {

  final Dio _client = Modular.get();

  Future<Config> getConfig() async {
    User user = GetIt.instance.get<User>();
    var response =
    await _client.get("/api/configuracao/config?userId=${user.userId}");
    return Config.fromJson(response.data);
  }


}
