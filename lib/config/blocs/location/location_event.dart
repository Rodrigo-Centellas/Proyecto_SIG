part of 'location_bloc.dart';

class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class OnNewLocationUserEvent extends LocationEvent {
  final LatLng newLocation;

  const OnNewLocationUserEvent(this.newLocation);
}

class OnStartFollowingUserEvent extends LocationEvent {
  const OnStartFollowingUserEvent();
}

class OnStopFollowingUserEvent extends LocationEvent {
  const OnStopFollowingUserEvent();
}
