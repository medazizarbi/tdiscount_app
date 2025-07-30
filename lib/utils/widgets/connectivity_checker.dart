import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tdiscount_app/utils/constants/colors.dart'; // Add this import

class ConnectivityChecker extends StatefulWidget {
  final Widget child;
  const ConnectivityChecker({required this.child, super.key});

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  late final Connectivity _connectivity;
  Stream<List<ConnectivityResult>>? _stream;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _stream = _connectivity.onConnectivityChanged;
    _stream!.listen((results) {
      // Use the first result as the main connection type
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnection(result);
    });
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    _updateConnection(result);
  }

  void _updateConnection(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    if (!hasInternet && !_dialogShown) {
      _showNoInternetDialog();
    } else if (hasInternet && _dialogShown) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {}); // Reload current screen
    }
  }

  void _showNoInternetDialog() {
    _dialogShown = true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Pas de connexion Internet'),
        content:
            const Text('Cette application nécessite une connexion Internet.'),
        actions: [
          TextButton(
            onPressed: () {
              _dialogShown = false;
              Navigator.of(context, rootNavigator: true).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: isDark ? TColors.primary : Colors.black,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
