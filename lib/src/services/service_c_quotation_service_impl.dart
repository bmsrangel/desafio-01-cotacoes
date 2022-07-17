import 'package:dio/dio.dart';

import '../models/service_c_response_model.dart';

class ServiceCQuotationServiceImpl {
  ServiceCQuotationServiceImpl(this._client);

  final Dio _client;

  Future<ServiceCResponseModel> getQuotation(
    String currency, [
    String? callbackAddress,
  ]) async {
    final response = await _client.post(
      '/servico-c/cotacao',
      data: {
        "tipo": currency,
        "callback": callbackAddress,
      },
    );
    if (response.statusCode == 202) {
      return ServiceCResponseModel.fromMap(response.data);
    } else {
      throw Exception();
    }
  }
}
