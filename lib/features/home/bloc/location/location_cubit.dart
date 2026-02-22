import 'package:bloc/bloc.dart';
import 'package:feild_visit_app/features/home/bloc/location/location_state.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> fetchLocation() async {
    if (state is LocationLoaded) {
      emit(LocationInitial());
      return;
    }

    emit(LocationLoading());
    try {
      PermissionStatus permission = await Permission.locationWhenInUse
          .request();
      if (!permission.isGranted) {
        emit(LocationError('Location permission denied'));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = 'Unknown';
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address =
            '${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
      }

      emit(LocationLoaded(position: position, address: address));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
