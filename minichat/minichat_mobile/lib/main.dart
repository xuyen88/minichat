import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wallet_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WalletState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F172A),
        ),
        home: MainNavigationScreen(),
      ),
    ),
  );
}

// --- ĐIỀU HƯỚNG CHÍNH ---
class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [MidnightWalletScreen(), MiniChatListPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyanAccent,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Ví tiền'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'MiniChat'),
        ],
      ),
    );
  }
}

// --- MÀN HÌNH VÍ GIAO DIỆN ĐẦY ĐỦ ---
class MidnightWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // LẤY SỐ DƯ THẬT TỪ PROVIDER
    final wallet = Provider.of<WalletState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nexus Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.history), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card Số dư
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Số dư ẩn danh (ZK)", style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 8),
                  Text("${wallet.dustBalance.toStringAsFixed(2)} DUST", 
                       style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text("45 NIGHT", style: TextStyle(color: Colors.cyanAccent, fontSize: 14)),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerLeft, child: Text("Tính năng bảo mật ZK", style: TextStyle(fontWeight: FontWeight.bold))),
            ),

            const SizedBox(height: 20),
            // Các nút chức năng cũ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionBtn(Icons.send, "Gửi ẩn danh", Colors.indigoAccent),
                _buildActionBtn(Icons.qr_code_scanner, "Nhận", Colors.greenAccent),
                _buildActionBtn(Icons.verified_user, "Xác thực ZK", Colors.purpleAccent),
              ],
            ),

            // Phần thưởng AI học tập
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber),
                  SizedBox(width: 15),
                  Expanded(child: Text("Phần thưởng AI học tập: Bạn đã nhận 5 DUST từ việc tóm tắt tài liệu sáng nay.", style: TextStyle(fontSize: 12, color: Colors.white70))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

// --- MÀN HÌNH DANH SÁCH CHAT ---
class MiniChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MiniChat")),
      body: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.indigoAccent, child: Text("A")),
        title: const Text("Alice (ZK-Verified)"),
        subtitle: const Text("Tin nhắn cuối cùng đã được mã hóa..."),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(name: "Alice"))),
      ),
    );
  }
}

// --- MÀN HÌNH CHI TIẾT CHAT (GIỮ NGUYÊN LOGIC /SEND) ---
class ChatDetailPage extends StatefulWidget {
  final String name;
  ChatDetailPage({required this.name});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isEncrypting = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    String text = _controller.text;
    _controller.clear();

    setState(() => _isEncrypting = true);
    await Future.delayed(const Duration(seconds: 2));

    if (text.startsWith('/send')) {
      double amount = double.tryParse(text.replaceAll('/send', '').trim()) ?? 0;
      bool success = Provider.of<WalletState>(context, listen: false).sendMoney(amount);
      if (success) {
        _messages.add({"type": "tx", "amount": amount.toString()});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Số dư không đủ!")));
      }
    } else {
      _messages.add({"type": "text", "text": text});
    }
    setState(() => _isEncrypting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var m = _messages[index];
                if (m["type"] == "tx") return _buildTxCard(m["amount"]);
                return _buildBubble(m["text"]);
              },
            ),
          ),
          if (_isEncrypting) const Text("⚡ Đang tạo bằng chứng ZK...", style: TextStyle(color: Colors.cyanAccent)),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildTxCard(String amount) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.cyanAccent),
            Text("ĐÃ GỬI $amount DUST", style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text("ZK-Proof Verified", style: TextStyle(fontSize: 10, color: Colors.greenAccent)),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.indigoAccent, borderRadius: BorderRadius.circular(15)),
        child: Text(text),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: "Nhập tin nhắn hoặc /send...", border: InputBorder.none))),
          IconButton(icon: const Icon(Icons.send, color: Colors.cyanAccent), onPressed: _sendMessage),
        ],
      ),
    );
  }
}