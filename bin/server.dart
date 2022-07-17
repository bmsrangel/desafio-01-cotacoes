import 'dart:io';

import 'package:desafio_cotacoes/src/controllers/quotation_controller.dart';
import 'package:desafio_cotacoes/src/middlewares/application_json_middleware.dart';
import 'package:desafio_cotacoes/src/services/service_a_quotation_service_impl.dart';
import 'package:desafio_cotacoes/src/services/service_b_quotation_service_impl.dart';
import 'package:desafio_cotacoes/src/services/service_c_quotation_service_impl.dart';
import 'package:dio/dio.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  var isDockerImage = false;
  if (args.isNotEmpty && args[0] == 'docker') {
    isDockerImage = true;
  }
  Dio dioClient;
  if (isDockerImage) {
    dioClient = Dio(
      BaseOptions(
        baseUrl: 'http://host.docker.internal:8080',
      ),
    );
  } else {
    dioClient = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8080',
      ),
    );
  }
  final serviceA = ServiceAQuotationServiceImpl(dioClient);
  final serviceB = ServiceBQuotationServiceImpl(dioClient);
  final serviceC = ServiceCQuotationServiceImpl(dioClient);

  final quotationController = QuotationController(
    serviceA: serviceA,
    serviceB: serviceB,
    serviceC: serviceC,
  );

  // Configure routes.
  final router = Router();
  router.get('/quotation/<currency>', quotationController.getQuotation);
  router.post('/callback', quotationController.callback);

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(applicationJsonMiddleware())
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
