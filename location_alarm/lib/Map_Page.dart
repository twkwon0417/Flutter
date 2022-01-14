import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'FlutterNotification.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'location_service.dart';

class MapPage extends StatefulWidget {
  static int distanceRange = 0;
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>
with AutomaticKeepAliveClientMixin {

  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  bool cameraSetting = true;
  late LatLng destination;
  late LatLng end;
  LatLng start = LatLng(37.5018425, 127.02668359374994);              //초기값 설정인데 차피 initState에서 바로 바뀜


  Future<void> _determinePosition() async {           //aka. get current location
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please Keep your location on.");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Loction Permission denied");
      }
    }
    if(permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Permission is denied Forever");
    }
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) async {
              print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
              _setUserPointer(LatLng(position.latitude, position.longitude));
              if(cameraSetting) {
                await moveCameraPosition(position);           //만약 목적지가 설정되었다면 쓰면 될 기능
              }
              try {
                double distanceInMeters = Geolocator.distanceBetween(position.latitude, position.longitude, end.latitude, end.longitude);
                if(distanceInMeters <= MapPage.distanceRange){
                  print("beep");
                  await NotificationService().showNotification(1, "띵동", "근처에 도착 했어요.", 1,);
                }
              } catch (e){
              }
        });


    // try {                                                                  만약 touch한 위치에 대한 정보도 가져오게 하려 바꿀때;   다시 geocoding 가져와 주셈
    //   List<Placemark> placemarks = await placemarkFromCoordinates(
    //       position.latitude, position.longitude);
    //   Placemark place = placemarks[0];
    //   setState(() {
    //     currentposition = position;
    //     currentAdress =
    //     "${place.locality}, ${place.postalCode}, ${place.country}";
    //   });
    // } catch(e) {
    //   print(e);
    // }
  }




  @override
  void initState() {
    _determinePosition();
    super.initState();
    tz.initializeTimeZones();
  }

  final Set<Marker> _userpointer = <Marker>{};

  void _setUserPointer(LatLng point) {                 //현재위치로 될듯 since MarkerId is always same
    if(mounted) {
      setState(() {
        _userpointer.add(
          Marker(
            markerId: MarkerId('User'),
            position: point,
          ),
        );
      });
    }
  }
  // static final Marker Start = Marker(
  //   markerId: MarkerId("Start"),
  //   infoWindow: InfoWindow(title : "Start"),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position: LatLng(37.773972, -122.431297)
  // );


  void _setDestinationPointer(LatLng point) {                 //현재위치로 될듯 since MarkerId is always same
    if(mounted) {
      setState(() {
        _userpointer.add(
          Marker(
            markerId: MarkerId('Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: point,
            draggable: true,
            onDragEnd: (newPosition) {
              end = LatLng(newPosition.latitude, newPosition.longitude);
            },
            onTap: (){
        showDialog(context: context, builder: (context){
        return DialogUI();
        });
        },

          ),
        );
        });
      print("hi");
      print(end);
    }
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;        //아래에 있는 method로 간략히 할수 있음.

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)
    ));
    end = LatLng(lat, lng);
    _setDestinationPointer(LatLng(lat, lng));
  }

  Future<void> moveCameraPosition(Position point) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(point.latitude, point.longitude), zoom: 12)
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: TextFormField(
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "도착지를 입력하세요."),
              onChanged: (value){
              },
            )),
            IconButton(
                onPressed: () async {
                  cameraSetting = false;
                  var place =  await LocationService().getPlace(_searchController.text);
                  _goToPlace(place);
                },
                icon: Icon(Icons.search))
          ]
        ),
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            markers: _userpointer,
            initialCameraPosition: CameraPosition(
              target : start,
              zoom: 11.5
            ),
            onMapCreated: (GoogleMapController controller) {          //Camera이동 등을 위해서 꼭필요한 코드이다.
              _controller.complete(controller);
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key,}) : super(key: key);
  var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 150,
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: "얼마나 가까워 졌을때 알림을 줄까요? (m)"
              ),),
            TextButton( child: Text("확인"), onPressed:(){
              MapPage.distanceRange = int.parse(name.text);
              Navigator.pop(context);
              final snackBar = SnackBar(
                content: const Text('목적지가 선택 되었습니다.'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    MapPage.distanceRange = 0;
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } ),

            TextButton(
                child: Text("취소"),
                onPressed:(){ Navigator.pop(context); })
          ],
        ),
      ),
    );
  }
}

