import 'package:flutter/material.dart';

class WalletState extends ChangeNotifier {
  double _dustBalance = 1250.50; // Số dư khởi tạo

  double get dustBalance => _dustBalance;

  // Hàm xử lý trừ tiền
  bool sendMoney(double amount) {
    if (_dustBalance >= amount) {
      _dustBalance -= amount;
      notifyListeners(); // Lệnh quan trọng để báo cho các màn hình cập nhật UI
      return true;
    }
    return false;
  }
}