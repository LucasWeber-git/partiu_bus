import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class RouteWidget extends StatefulWidget {
  const RouteWidget({super.key});

  @override
  State<RouteWidget> createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  GoogleNavigationViewController? _navigationViewController;
  bool _navigationSessionInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNavigationSession();
  }

  Future<void> _initializeNavigationSession() async {
    await checkTermsAccepted();    
    await checkLocationPermission();

    await GoogleMapsNavigator.initializeNavigationSession(
      taskRemovedBehavior: TaskRemovedBehavior.continueService,
    );
    setState(() {
      _navigationSessionInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Navigation Sample')),
      body:
          _navigationSessionInitialized
              ? GoogleMapsNavigationView(
                onViewCreated: _onViewCreated,
                initialNavigationUIEnabledPreference:
                    NavigationUIEnabledPreference.disabled,
                // Other view initialization settings
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  void _onViewCreated(GoogleNavigationViewController controller) {
    _navigationViewController = controller;
    controller.setMyLocationEnabled(true);
    // Additional setup can be added here.
  }

  @override
  void dispose() {
    if (_navigationSessionInitialized) {
      GoogleMapsNavigator.cleanup();
    }
    super.dispose();
  }
}

Future<void> checkTermsAccepted() async {
  if (!await GoogleMapsNavigator.areTermsAccepted()) {
    await GoogleMapsNavigator.showTermsAndConditionsDialog(
      'Example title',
      'Example company',
    );
  }
}

Future<void> checkLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }
}
