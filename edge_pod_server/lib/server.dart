import 'dart:io';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/web/routes/app_config_route.dart';

void run(List<String> args) async {
  final portStr = Platform.environment['PORT'];
  final port = portStr != null ? int.tryParse(portStr) : null;

  final pod = Serverpod(
    args,
    configOverride: port != null
        ? (config) => config.copyWith(
            apiServer: ServerConfig(
              port: port,
              publicHost: config.apiServer.publicHost,
              publicPort: port,
              publicScheme: config.apiServer.publicScheme,
            ),
          )
        : null,
  );

  if (pod.config.webServer != null) {
    pod.webServer.addRoute(
      StaticRoute.withCacheBusting(cacheBustingConfig),
      cacheBustingConfig.mountPrefix,
    );

    pod.webServer.addRoute(
      AppConfigRoute(apiConfig: pod.config.apiServer),
      '/assets/assets/config.json',
    );

    final appDir = Directory(Uri(path: 'web/app').toFilePath());
    if (appDir.existsSync()) {
      pod.webServer.addRoute(
        FlutterRoute(
          appDir,
          enableWasmHeaders: false,
        ),
        '/',
      );
    } else {
      final defaultRoute = StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      );

      pod.webServer.addMiddleware(
        FallbackMiddleware(
          fallback: defaultRoute,
          on: (response) => response.statusCode == 404,
        ).call,
        '/',
      );

      pod.webServer.addRoute(
        defaultRoute,
        '/**',
      );
    }
  }

  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  await pod.start();
}
