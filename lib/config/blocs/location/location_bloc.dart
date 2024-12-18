import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionStream;

  LocationBloc() : super(const LocationState()) {
    on<OnNewLocationUserEvent>((event, emit) {
      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
      ));
    });
    on<OnStartFollowingUserEvent>((event, emit) {
      emit(state.copyWith(
        isFollowingUser: true,
      ));
    });
    on<OnStopFollowingUserEvent>((event, emit) {
      emit(state.copyWith(
        isFollowingUser: false,
      ));
    });
  }

  Future<Position> getActualPosition() async {
    final position = await Geolocator.getCurrentPosition();
    add(OnNewLocationUserEvent(LatLng(
      position.latitude,
      position.longitude,
    )));
    return position;
  }

  void startFollowingUser() async {
    bool serviceEnabled;
    LocationPermission permission;

    // LOGIC : Verificar si los servicios de ubicacion estan habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // LOGIC : Los servicios de ubicacion no estan habilitados
      return Future.error('Los servicios de ubicacion no estan habilitados');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // LOGIC : El usuario no dio permisos de ubicacion
        return Future.error('El usuario no dio permisos de ubicacion');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // LOGIC : El usuario no dio permisos de ubicacion
      return Future.error('El usuario no dio permisos de ubicacion');
    }

    // LOGIC : Si llegamos a este punto, el usuario dio permisos de ubicacion
    add(const OnStartFollowingUserEvent());

    _positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(OnNewLocationUserEvent(LatLng(
        position.latitude,
        position.longitude,
      )));
    }, onError: (error) {
      add(const OnStopFollowingUserEvent());
    });
  }

  Future<void> stopFollowingUser() async {
    await _positionStream?.cancel();
    add(const OnStopFollowingUserEvent());
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }
}
