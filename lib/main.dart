import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/location/location_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:proyecto_sig/config/constant/const.dart';
import 'package:proyecto_sig/config/router/app.router.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(
          create: (context) => MapBloc(
                authBloc: BlocProvider.of<AuthBloc>(context),
              )),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      InitContext.inicializar(context);

      return MaterialApp.router(
        scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        builder: (context, child) {
          // Agregamos el ScaffoldMessenger aquí
          return ScaffoldMessenger(
            child: child ?? const SizedBox(),
          );
        },
      );
    });
  }
}
