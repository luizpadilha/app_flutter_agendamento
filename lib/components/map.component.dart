import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mybabernew/components/alert.component.dart';

class MapComponent<T> extends StatefulWidget {
  LatLng? local;

  MapComponent({this.local});

  @override
  _MapComponentState createState() => _MapComponentState<T>();
}

class _MapComponentState<T> extends State<MapComponent> {
  MapController? mapController;
  List<Marker> layers = <Marker>[];

  Future<LocationData?>? _future;

  Marker buildPin(LatLng point) => Marker(
        point: point,
        child: const Icon(Icons.location_pin, size: 30, color: Colors.black),
        width: 30,
        height: 30,
      );

  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = new Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  @override
  void initState() {
    super.initState();
    addLayers();
    _future = _currentLocation();
  }

  void addLayers() {
    setState(() {
      layers.clear();

      if (widget.local != null) {
        layers.add(buildPin(widget.local!));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlutterMap(
                              options: MapOptions(
                                initialZoom: 17,
                                initialCenter: widget.local != null
                                    ? widget.local!
                                    : (snapshot.hasData
                                        ? new LatLng(snapshot.data!.latitude!,
                                            snapshot.data!.longitude!)
                                        : new LatLng(0, 0)),
                                onLongPress: (_, p) => setState(() => {
                                      widget.local = p,
                                      print('p: ${p.latitude}'),
                                      print('p: ${p.longitude}'),
                                      layers.clear(),
                                      layers.add(buildPin(p))
                                    }),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/"
                                      "{z}/{x}/{y}?access_token=sk.eyJ1IjoiZ3VzdGF2b3NjYXJwaW5pIiwiYSI6ImNreXhhMmZiMTBnZjcydmxyeWRoenJ5dGIifQ.ewfIZ1VJ2T00NCSEONyizw",
                                ),
                                MarkerLayer(markers: layers),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: AutoSizeText(
                                "Pressione e segure uma região do mapa para definir a localização",
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 30, right: 30, bottom: 20),
                              height: 60,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: TextButton(
                                  onPressed: () async {
                                    AlertComponent.show(context,
                                        title: "Posição gravada",
                                        subTitle:
                                            "Lat. ${snapshot.data!.latitude!} / Long. ${snapshot.data!.longitude!}");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Salvar",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            fontSize: 18),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        )
                      ],
                    ));
              }
            }));
  }
}
