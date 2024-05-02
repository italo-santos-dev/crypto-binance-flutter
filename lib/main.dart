import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CryptoApp());
}

class CryptoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CryptoHomeScreen(),
    );
  }
}

class CryptoHomeScreen extends StatefulWidget {
  @override
  _CryptoHomeScreenState createState() => _CryptoHomeScreenState();
}

class _CryptoHomeScreenState extends State<CryptoHomeScreen> {
  List<dynamic> cryptoData = [];

  @override
  void initState() {
    super.initState();
    _fetchCryptoData();
  }

  Future<void> _fetchCryptoData() async {
    final response = await http.get(Uri.parse('https://api.binance.com/api/v3/ticker/24hr'));
    if (response.statusCode == 200) {
      setState(() {
        cryptoData = jsonDecode(response.body).where((crypto) => double.parse(crypto['lastPrice']) >= 0.00000001).toList();
      });
    } else {
      throw Exception('Failed to load crypto data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryto Prices'),
      ),
      body: ListView.builder(
          itemCount: cryptoData.length,
          itemBuilder: (context, index) {
            final crypto = cryptoData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(
                    crypto['symbol'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Price: \$${crypto['lastPrice']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            );
          },
      ),
    );
  }
}
