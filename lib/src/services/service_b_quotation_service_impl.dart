import 'package:dio/dio.dart';

import '../models/quotation_model.dart';

class ServiceBQuotationServiceImpl {
  ServiceBQuotationServiceImpl(this._client);

  final Dio _client;

  Future<QuotationModel> getQuotation(String currency) async {
    final response = await _client.get(
      '/servico-b/cotacao',
      queryParameters: {
        'curr': 'USD',
      },
    );
    if (response.statusCode == 200) {
      return QuotationModel(
        currency: response.data['cotacao']['currency'],
        price: double.parse(response.data['cotacao']['valor']) /
            response.data['cotacao']['fator'],
      );
    } else {
      throw Exception();
    }
  }
}
