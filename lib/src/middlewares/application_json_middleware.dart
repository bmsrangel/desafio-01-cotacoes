import 'dart:io';

import 'package:shelf/shelf.dart';

Middleware applicationJsonMiddleware() => (handler) => (request) async {
      var response = await handler(request);
      if (!response.headers.containsKey('application/json')) {
        response = response.change(
          headers: {
            ...response.headers,
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        );
      }
      return response;
    };
