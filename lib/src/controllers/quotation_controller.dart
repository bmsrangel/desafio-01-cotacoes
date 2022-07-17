import 'dart:async';

import 'package:desafio_cotacoes/src/extensions/to_json_extension.dart';
import 'package:desafio_cotacoes/src/services/service_a_quotation_service_impl.dart';
import 'package:desafio_cotacoes/src/services/service_b_quotation_service_impl.dart';
import 'package:shelf/shelf.dart';

import '../models/callback_request_model.dart';
import '../models/quotation_model.dart';
import '../services/service_c_quotation_service_impl.dart';

class QuotationController {
  QuotationController({
    required ServiceAQuotationServiceImpl serviceA,
    required ServiceBQuotationServiceImpl serviceB,
    required ServiceCQuotationServiceImpl serviceC,
  }) {
    _serviceA = serviceA;
    _serviceB = serviceB;
    _serviceC = serviceC;

    _callback$ = StreamController<QuotationModel>.broadcast();
  }

  late final ServiceAQuotationServiceImpl _serviceA;
  late final ServiceBQuotationServiceImpl _serviceB;
  late final ServiceCQuotationServiceImpl _serviceC;

  late final StreamController<QuotationModel> _callback$;

  FutureOr<Response> getQuotation(Request request, String currency) async {
    final futureServiceA = _serviceA.getQuotation(currency);
    final futureServiceB = _serviceB.getQuotation(currency);
    await _serviceC.getQuotation(
      currency,
      'http://host.docker.internal:3000/callback',
    );

    List<QuotationModel> result;
    await for (var resultServiceC in _callback$.stream) {
      result = await Future.wait(
        [
          futureServiceA,
          futureServiceB,
        ],
      );
      result.add(resultServiceC);

      var bestQuotation = result.reduce(
          (value, element) => value.price < element.price ? value : element);

      return Response.ok(
        {
          'data': {
            'quotation': bestQuotation.toMap(),
          }
        }.toJson(),
      );
    }
    return Response.badRequest();
  }

  FutureOr<Response> callback(Request request) async {
    final body = await request.readAsString();
    final callbackResponseData = CallbackRequestModel.fromJson(body);
    _callback$.sink.add(
      QuotationModel(
        currency: callbackResponseData.type,
        price: callbackResponseData.value / callbackResponseData.factor,
      ),
    );
    return Response(200);
  }
}
