import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/models/oauth_config_model.dart';

abstract interface class ConfigRemoteDatasource {
  Future<OAuthConfigModel> getOAuthConfig();
}

@LazySingleton(as: ConfigRemoteDatasource)
class ConfigRemoteDatasourceImpl implements ConfigRemoteDatasource {
  const ConfigRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<OAuthConfigModel> getOAuthConfig() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/config');
    return OAuthConfigModel.fromJson(response.data!);
  }
}
