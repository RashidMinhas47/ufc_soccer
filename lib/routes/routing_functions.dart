import 'package:flutter/material.dart';

class RoutingFuncs {
  static bool conditionToStopPopping(Route<dynamic> route, String routeLink) {
    // Check if the route is of type MyRoute
    return route.settings.name == routeLink;
  }
}
