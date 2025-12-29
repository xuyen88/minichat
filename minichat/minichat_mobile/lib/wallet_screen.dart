import 'package:flutter/material.dart';

class MidnightWalletScreen extends StatefulWidget {
  @override
  _MidnightWalletScreenState createState() => _MidnightWalletScreenState();
}

class _MidnightWalletScreenState extends State<MidnightWalletScreen> {
  // Giả lập dữ liệu từ SDK Midnight
  bool _isPrivateMode = true;
  double _dustBalance = 1250.50;
  double _nightBalance = 45.0;
  String _walletAddress = "mid1...zk789privacy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A), // Màu nền tối sâu
      appBar: AppBar(
        title: Text("Nexus Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.history), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ ví Midnight (ZK Card)
            _buildMainWalletCard(),
            
            SizedBox(height: 30),
            
            Text("Tính năng bảo mật ZK", 
              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
            
            SizedBox(height: 15),
            
            // Các nút chức năng nhanh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction(Icons.send_rounded, "Gửi ẩn danh", Colors.blueAccent),
                _buildQuickAction(Icons.qr_code_scanner, "Nhận", Colors.greenAccent),
                _buildQuickAction(Icons.verified_user, "Xác thực ZK", Colors.purpleAccent),
              ],
            ),

            SizedBox(height: 30),

            // Trạng thái AI Learning Rewards
            _buildAIRewardsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWalletCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số dư ẩn danh (ZK)", style: TextStyle(color: Colors.white60)),
              Icon(Icons.security, color: Colors.cyanAccent, size: 20),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "${_isPrivateMode ? '****' : _dustBalance.toString()} DUST",
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          Text("${_nightBalance} NIGHT", style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                child: Text(_walletAddress, style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
              IconButton(
                icon: Icon(_isPrivateMode ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                onPressed: () => setState(() => _isPrivateMode = !_isPrivateMode),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 28),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildAIRewardsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.amber),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phần thưởng AI học tập", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Bạn đã nhận được 5 DUST từ việc tóm tắt tài liệu sáng nay.", 
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
