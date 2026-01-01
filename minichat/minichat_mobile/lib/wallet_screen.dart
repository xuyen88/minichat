import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MainNavigationScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0F172A),
      hintColor: Colors.cyanAccent,
    ),
  ));
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
        unselectedItemColor: Colors.white54,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Ví tiền'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'MiniChat'),
        ],
      ),
    );
  }
}

// --- MÀN HÌNH VÍ: NEXUS WALLET ---
class MidnightWalletScreen extends StatefulWidget {
  @override
  _MidnightWalletScreenState createState() => _MidnightWalletScreenState();
}

class _MidnightWalletScreenState extends State<MidnightWalletScreen> {
  bool _isPrivateMode = true;
  double _dustBalance = 1250.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Nexus Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, 
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.history), onPressed: () {})],
      ),
      body: Column(
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Align(alignment: Alignment.centerLeft, child: Text("Tính năng bảo mật ZK", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600))),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionBtn(Icons.send_rounded, "Gửi ẩn danh", Colors.blueAccent),
              _actionBtn(Icons.qr_code_scanner, "Nhận", Colors.greenAccent),
              _actionBtn(Icons.verified_user, "Xác thực ZK", Colors.purpleAccent),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          const Text("Số dư ẩn danh (ZK)", style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_isPrivateMode ? "****" : "$_dustBalance", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Text("DUST", style: TextStyle(fontSize: 18, color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const Text("45 NIGHT", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
          IconButton(
            icon: Icon(_isPrivateMode ? Icons.visibility_off : Icons.visibility, color: Colors.white38), 
            onPressed: () => setState(() => _isPrivateMode = !_isPrivateMode)
          )
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color col) => Column(
    children: [
      CircleAvatar(radius: 28, backgroundColor: col.withOpacity(0.1), child: Icon(icon, color: col)),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
    ],
  );
}

// --- MÀN HÌNH DANH SÁCH CHAT ---
class MiniChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text("MiniChat (ZK-Encrypted)"), backgroundColor: Colors.transparent),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.blueGrey, child: Text("A")),
            title: const Text("Alice (ZK-Verified)"),
            subtitle: const Text("Tin nhắn được mã hóa đầu cuối..."),
            trailing: const Text("Vừa xong", style: TextStyle(fontSize: 10, color: Colors.white38)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(name: "Alice"))),
          ),
        ],
      ),
    );
  }
}

// --- MÀN HÌNH CHI TIẾT CHAT + LOGIC /SEND ---
class ChatDetailPage extends StatefulWidget {
  final String name;
  ChatDetailPage({required this.name});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final List<Map<String, dynamic>> _messages = [
    {"text": "Chào bạn! Đây là kênh chat bảo mật Midnight.", "isMe": false, "type": "text"}
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isEncrypting = false;
  String _loadingText = "Đang tạo ZK-Proof cho tin nhắn...";

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    
    String inputText = _controller.text;
    bool isTx = inputText.startsWith('/send');
    String amount = "";
    
    if (isTx) {
      amount = inputText.replaceFirst('/send', '').trim();
      if (amount.isEmpty) amount = "0";
      setState(() => _loadingText = "Đang tạo bằng chứng giao dịch $amount DUST...");
    } else {
      setState(() => _loadingText = "Đang tạo ZK-Proof cho tin nhắn...");
    }

    _controller.clear();
    setState(() => _isEncrypting = true);

    // Giả lập thời gian Midnight SDK xử lý Proof
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _messages.add({
        "text": inputText, 
        "isMe": true, 
        "type": isTx ? "transaction" : "text",
        "amount": amount
      });
      _isEncrypting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: Text(widget.name), backgroundColor: const Color(0xFF1E293B)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageItem(_messages[index]),
            ),
          ),
          if (_isEncrypting) _buildEncryptingOverlay(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> msg) {
    bool isMe = msg["isMe"];
    if (msg["type"] == "transaction") {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: _buildTransactionCard(msg["amount"], isMe),
      );
    }
    return _buildChatBubble(msg["text"], isMe);
  }

  Widget _buildTransactionCard(String amount, bool isMe) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      width: 240,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5)],
      ),
      child: Column(
        children: [
          const Icon(Icons.swap_horizontal_circle, color: Colors.cyanAccent, size: 35),
          const SizedBox(height: 8),
          Text(isMe ? "BẠN ĐÃ GỬI" : "BẠN ĐÃ NHẬN", style: const TextStyle(fontSize: 10, color: Colors.white54)),
          Text("$amount DUST", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
          const Divider(color: Colors.white10, height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user, size: 12, color: Colors.greenAccent),
              SizedBox(width: 5),
              Text("ZK-Proof Verified", style: TextStyle(fontSize: 10, color: Colors.greenAccent)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.white10,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildEncryptingOverlay() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.05)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.cyanAccent)),
          const SizedBox(width: 15),
          Text(_loadingText, style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Nhập tin nhắn hoặc /send...", border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 15)),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(icon: const Icon(Icons.lock, color: Colors.cyanAccent), onPressed: _sendMessage),
        ],
      ),
    );
  }
}
