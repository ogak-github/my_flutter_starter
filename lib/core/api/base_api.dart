import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_starter/core/api/api_client.dart';
import 'package:my_flutter_starter/core/api/api_config.dart';
import 'package:mylogger/mylogger.dart';

class BaseApi {
  late ApiClient apiClient;
  BaseApi() {
    apiClient = ApiClient(ApiConfig.baseUrl);
    MyLogger("BaseApi").i("BaseApi initialized: ${ApiConfig.baseUrl}");
  }
}

final baseApiProvider = Provider<BaseApi>((ref) => BaseApi());
