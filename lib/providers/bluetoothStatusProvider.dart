import 'package:flutter/foundation.dart';

import '../utils/enums.dart';
import '../services/bluetoothStatusChecker.dart';

class BluetoothStatusProvider extends ChangeNotifier {
  BluetoothConnectionStatus bluetoothStatus;

  BluetoothStatusProvider() {
    bluetoothStatus = BluetoothConnectionStatus.OFF;
    sendStatusUpdates();
  }

  /// function to update bluetooth status upon listening status updates
  void sendStatusUpdates() {
    BluetoothStatusChecker().onStatusChange.listen((status) {
      bluetoothStatus = status;
      notifyListeners();
    });
  }

  /// function to get current [bluetoothStatus]
  BluetoothConnectionStatus get bluetoothState => bluetoothStatus;
}
