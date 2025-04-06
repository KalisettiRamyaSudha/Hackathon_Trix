import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:flutter/semantics.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Offset currentPosition = Offset(20, 10); // Start at A Wing
  Offset? destination;
  String? destinationName;
  Map<String, Offset> locationMap = {
    "A Wing": Offset(20, 10),
    "B Wing": Offset(50, 30),
    "E Wing": Offset(20, 40),
    "D Wing": Offset(80, 50),
    "F Wing": Offset(20, 20),
    "G Wing": Offset(40, 50),
    "H Wing": Offset(60, 60),
    "J Wing": Offset(90, 60),
    "K Wing": Offset(10, 50),
    "M Wing": Offset(80, 30),
  };
  Map<String, Offset> destinations = {
    "Exit A Wing": Offset(15, 5),
    "AED B Wing": Offset(50, 25),
    "Shelter E Wing": Offset(15, 45),
  };
  // Define stair locations
  List<Map<String, dynamic>> stairs = [
    {"name": "Stairs in B Wing", "position": Offset(50, 20)},
    {"name": "Stairs in M Wing", "position": Offset(80, 35)},
  ];
  Map<String, List<WifiFingerprint>> fingerprintDB = {
    "A Wing": [
      WifiFingerprint("AA:BB:CC:DD:EE:FF", -50),
      WifiFingerprint("11:22:33:44:55:66", -60),
    ],
    "B Wing": [
      WifiFingerprint("AA:BB:CC:DD:EE:FF", -70),
      WifiFingerprint("11:22:33:44:55:66", -40),
    ],
    "E Wing": [
      WifiFingerprint("AA:BB:CC:DD:EE:FF", -60),
      WifiFingerprint("11:22:33:44:55:66", -50),
    ],
  };
  String currentLocation = "A Wing";
  Timer? scanTimer;
  DateTime? lastStairAlert; // Track the last time a stair alert was announced
  final double stairAlertThreshold = 10.0; // ~5 meters in custom coordinates
  final Duration stairAlertCooldown = Duration(seconds: 10); // Avoid spamming alerts

  @override
  void initState() {
    super.initState();
    // Start periodic Wi-Fi scanning
    scanTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      scanWifi();
      if (destination != null) {
        SemanticsService.announce(
          "You are in $currentLocation, heading to $destinationName",
          TextDirection.ltr,
        );
      }
    });
  }

  @override
  void dispose() {
    scanTimer?.cancel();
    super.dispose();
  }

  Future<void> scanWifi() async {
  final canScan = await WiFiScan.instance.canStartScan();

  if (canScan == CanStartScan.yes) {
    await WiFiScan.instance.startScan();
    List<WiFiAccessPoint> results = await WiFiScan.instance.getScannedResults();
    updatePosition(results);
  } else {
    print("WiFi scan cannot start: $canScan");
  }
}

  void updatePosition(List<WiFiAccessPoint> scanResults) {
    String closestMatch = findClosestFingerprint(scanResults);
    setState(() {
      currentPosition = locationMap[closestMatch]!;
      currentLocation = closestMatch;
      // Announce new location for visually impaired users
      SemanticsService.announce(
        "You are now in $closestMatch",
        TextDirection.ltr,
      );
      // Check proximity to stairs
      checkStairProximity();
    });
  }

  String findClosestFingerprint(List<WiFiAccessPoint> scanResults) {
    double minDiff = double.infinity;
    String bestMatch = currentLocation;
    for (var location in fingerprintDB.keys) {
      double diff = calculateDifference(scanResults, fingerprintDB[location]!);
      if (diff < minDiff) {
        minDiff = diff;
        bestMatch = location;
      }
    }
    return bestMatch;
  }

double calculateDifference(List<WiFiAccessPoint> scan, List<WifiFingerprint> db) {
  double totalDiff = 0;
  int count = 0;

  for (var ap in scan) {
    var match = db.firstWhere((f) => f.mac == ap.bssid, orElse: () => WifiFingerprint("", 0));
    if (match.mac != "") {
      totalDiff += (ap.level - match.rssi).abs(); // <- changed from ap.rssi to ap.level
      count++;
    }
  }

  return count > 0 ? totalDiff / count : double.infinity;
}


  void checkStairProximity() {
    // Check if enough time has passed since the last alert
    if (lastStairAlert != null &&
        DateTime.now().difference(lastStairAlert!) < stairAlertCooldown) {
      return;
    }

    // Check distance to each stair location
    for (var stair in stairs) {
      double distance = (currentPosition - stair["position"]).distance;
      if (distance <= stairAlertThreshold) {
        SemanticsService.announce(
          "Caution: You are close to ${stair["name"]}",
          TextDirection.ltr,
        );
        lastStairAlert = DateTime.now();
        break; // Announce only one stair alert at a time
      }
    }
  }

  void navigateTo(String destName) {
    setState(() {
      destination = destinations[destName];
      destinationName = destName;
      SemanticsService.announce(
        "Navigating to $destName",
        TextDirection.ltr,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Indoor Navigation")),
      body: Stack(
        children: [
          // Display the floor plan PNG
          Image.asset('assets/floorplan.jpg', fit: BoxFit.contain),
          // Overlay position and navigation
          CustomPaint(
            painter: MapPainter(currentPosition, destination),
            child: Container(),
          ),
          // Buttons for navigation
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Semantics(
                  label: "Navigate to Exit A Wing",
                  child: ElevatedButton(
                    onPressed: () => navigateTo("Exit A Wing"),
                    child: Text("Navigate to Exit A Wing"),
                  ),
                ),
                Semantics(
                  label: "Navigate to AED B Wing",
                  child: ElevatedButton(
                    onPressed: () => navigateTo("AED B Wing"),
                    child: Text("Navigate to AED B Wing"),
                  ),
                ),
                Semantics(
                  label: "Navigate to Shelter E Wing",
                  child: ElevatedButton(
                    onPressed: () => navigateTo("Shelter E Wing"),
                    child: Text("Navigate to Shelter E Wing"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WifiFingerprint {
  String mac;
  int rssi;
  WifiFingerprint(this.mac, this.rssi);
}

class MapPainter extends CustomPainter {
  final Offset position;
  final Offset? destination;

  MapPainter(this.position, this.destination);

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / 100;
    double scaleY = size.height / 60;
    Offset scaledPosition = Offset(position.dx * scaleX, position.dy * scaleY);

    // Draw user position (blue dot)
    final positionPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(scaledPosition, 10, positionPaint);

    // Draw destination and navigation line if set
    if (destination != null) {
      Offset scaledDestination = Offset(destination!.dx * scaleX, destination!.dy * scaleY);
      final destPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(scaledDestination, 10, destPaint);

      final linePaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 3;
      canvas.drawLine(scaledPosition, scaledDestination, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}