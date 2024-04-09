import 'package:flutter/material.dart';
import 'package:me_and_flora/me_and_flora_app.dart';

import 'core/domain/service/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MeAndFloraApp());
}
