import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import '../globals.dart';
import '../providers/bluetoothProvider.dart';
import '../utils/enums.dart';
import '../providers/locationStatusProvider.dart';
import '../providers/gpsTrackProvider.dart';
import '../widgets/gpsTrackingWidgets/detailsIcon.dart';
import '../widgets/gpsTrackingWidgets/statusIndicatorWidget.dart';
import '../widgets/gpsTrackingWidgets/timeWidget.dart';
import '../widgets/statusIndicatorCard.dart';
import 'bluetoothDevicesScreen.dart';

class GpsTrackingScreen extends StatefulWidget {
  static String routeName = '/gpsTracking';

  @override
  _GpsTrackingScreenState createState() => _GpsTrackingScreenState();
}

class _GpsTrackingScreenState extends State<GpsTrackingScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GpsTrackProvider gpsTrackProvider;

  @override
  void initState() {
    final provider = Provider.of<GpsTrackProvider>(context, listen: false);
    provider.trackScreenMounted(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    gpsTrackProvider = Provider.of<GpsTrackProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    gpsTrackProvider.trackScreenMounted(false);
    if (gpsTrackProvider.getEndTrackStatus) {
      gpsTrackProvider.resetAllValues();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (gpsTrackProvider.needsRebuild) {
      gpsTrackProvider.setUpMap();
    }

    final bool showMap = gpsTrackProvider.locationDetermined;
    final locationStatusProvider = Provider.of<LocationStatusProvider>(context);
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return Scaffold(
      body: showMap ? Stack(
          children: [
            Visibility(
              visible: locationStatusProvider.locationState == LocationStatus.enabled,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                markers: gpsTrackProvider.getMarkers,
                polylines: gpsTrackProvider.getPolyLines,
                circles: gpsTrackProvider.getCircles,
                zoomControlsEnabled: false,
                initialCameraPosition: gpsTrackProvider.getCameraPosition,
                onMapCreated: (GoogleMapController googleMapController) async {
                  _googleMapController.complete(googleMapController);
                  await gpsTrackProvider.setMapController(_googleMapController.future);
                  gpsTrackProvider.addMarkersAndCircles();
                },
              ),
            ),
            Visibility(
              visible: locationStatusProvider.locationState == LocationStatus.enabled,
              child: Container(
                margin: const EdgeInsets.only(right: 5, top: 25),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: kSpringColor,
                        child: InkWell(
                          splashColor: kSecondaryColor,
                          onTap: () async {
                            await myLocation();
                          },
                          child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.my_location, color: kWhiteColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: kSpringColor,
                      child: InkWell(
                        splashColor: kWhiteColor,
                        onTap: () async {
                          await zoomIn();
                        },
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.add, color: kWhiteColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      height: 2,
                    ),
                    Material(
                      color: kSpringColor,
                      child: InkWell(
                        splashColor: kWhiteColor,
                        onTap: () async {
                          await zoomOut();
                        },
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.remove, color: kWhiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: locationStatusProvider.locationState == LocationStatus.enabled,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, deviceHeight * 0.73, 10, 25),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: deviceWidth,
                height: deviceHeight * 0.24,
                decoration: BoxDecoration(
                  color: kSpringColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Track ${gpsTrackProvider.trackId}',
                      style: const TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Column(
                          children: [
                            Consumer<LocationStatusProvider>(
                                builder: (context, gpsStateProvider, child) {
                                  final bool locationEnabled = gpsStateProvider.locationState == LocationStatus.enabled ? true : false;

                                  return StatusIndicatorWidget(
                                    title: 'gps'.toUpperCase(),
                                    icon: Icon(locationEnabled ? Icons.location_on : Icons.location_off, color: kSpringColor),
                                  );
                                }
                            ),
                            const SizedBox(height: 5),
                            Consumer<BluetoothProvider>(
                                builder: (context, bluetoothProvider, child) {
                                  final bool connectedToOBD = bluetoothProvider.isConnected();

                                  return StatusIndicatorWidget(
                                    title: 'Bluetooth',
                                    icon: connectedToOBD ? const Icon(Icons.bluetooth, color: kWhiteColor) : const Icon(Icons.bluetooth_disabled, color: kSpringColor),
                                    backgroundColor: connectedToOBD ? kBlueColor : kWhiteColor,
                                  );
                                }
                            ),
                          ],
                        ),
                        const Spacer(),
                        TimeWidget(
                          duration: gpsTrackProvider.getTrackDuration,
                          function: () {
                            gpsTrackProvider.stopTrack();
                            Navigator.of(context).pop();
                          },
                        ),
                        const Spacer(),
                        Column(
                          children: const [
                            DetailsIcon(
                              title: 'Avg speed',
                              data: '40 km/h',
                              iconData: Icons.speed,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            DetailsIcon(
                              title: 'Distance',
                              data: '1 km',
                              iconData: Icons.trending_up_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (locationStatusProvider.locationState == LocationStatus.disabled)
              StatusIndicatorCard(
                heading: 'Location turned off',
                subHeading: 'Your location services is turned off.',
                buttonTitle: 'Turn on location',
                icon: const Icon(Icons.location_off, size: 50, color: kWhiteColor),
                function: () {
                  // TODO: turn on location
                },
              ),
            if (bluetoothProvider.isConnected())
              StatusIndicatorCard(
                heading: 'No OBD-II selected',
                subHeading: 'Your device is not connected to OBD-II adapter',
                buttonTitle: 'Select OBD-II adapter',
                icon: const Icon(Icons.bluetooth, size: 50, color: kWhiteColor),
                function: () {
                  Navigator.pushReplacementNamed(context, BluetoothDevicesScreen.routeName);
                },
              )
          ],
        ) : const Center(
          child: CircularProgressIndicator(),
      ),
    );
  }

  Future zoomIn() async {
    final GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  Future zoomOut() async {
    final GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  Future myLocation() async {
    final GoogleMapController mapController = await _googleMapController.future;
    final CameraPosition cameraPosition = gpsTrackProvider.getCameraPosition;
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

}
