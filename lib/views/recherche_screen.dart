import 'package:flutter/material.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  _RechercheScreenState createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Font Testing Screen',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFontSection(
              'Coolvetica',
              [
                _buildFontSample('Regular', 'Coolvetica'),
                _buildFontSample('Italic', 'Coolvetica', italic: true),
              ],
            ),
            const SizedBox(height: 24),
            _buildFontSection(
              'Poppins',
              [
                _buildFontSample('Light (300)', 'Poppins',
                    weight: FontWeight.w300),
                _buildFontSample('Light Italic', 'Poppins',
                    weight: FontWeight.w300, italic: true),
                _buildFontSample('Regular (400)', 'Poppins',
                    weight: FontWeight.w400),
                _buildFontSample('Italic', 'Poppins',
                    weight: FontWeight.w400, italic: true),
                _buildFontSample('Medium (500)', 'Poppins',
                    weight: FontWeight.w500),
                _buildFontSample('Medium Italic', 'Poppins',
                    weight: FontWeight.w500, italic: true),
                _buildFontSample('SemiBold (600)', 'Poppins',
                    weight: FontWeight.w600),
                _buildFontSample('SemiBold Italic', 'Poppins',
                    weight: FontWeight.w600, italic: true),
                _buildFontSample('Bold (700)', 'Poppins',
                    weight: FontWeight.w700),
                _buildFontSample('Bold Italic', 'Poppins',
                    weight: FontWeight.w700, italic: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSection(String title, List<Widget> fontSamples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...fontSamples,
      ],
    );
  }

  Widget _buildFontSample(String label, String fontFamily,
      {FontWeight? weight, bool italic = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
              fontWeight: weight,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          const Divider(height: 16, thickness: 0.5),
        ],
      ),
    );
  }
}
