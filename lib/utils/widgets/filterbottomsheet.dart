import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 100000);
  String _sortOrder = 'desc';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) =>
          _buildContainer(isDark, scrollController),
    );
  }

  Widget _buildContainer(bool isDark, ScrollController scrollController) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            _buildHandleBar(isDark),
            _buildTitle(isDark),
            _buildFilterContent(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: isDark ? TColors.grey : TColors.darkGrey,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        "Filtres",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? TColors.textWhite : TColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFilterContent(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceSection(isDark),
          const SizedBox(height: 24),
          _buildSortSection(isDark),
          const SizedBox(height: 32),
          _buildApplyButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPriceSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Fourchette de prix", isDark),
        const SizedBox(height: 12),
        _buildPriceSlider(isDark),
        _buildPriceDisplay(isDark),
        _buildManualPriceInputs(isDark),
      ],
    );
  }

  Widget _buildPriceSlider(bool isDark) {
    return Builder(
      builder: (context) {
        final sliderConfig = _getSliderConfiguration();

        return Column(
          children: [
            RangeSlider(
              values: RangeValues(
                _priceRange.start.clamp(0, sliderConfig.max),
                _priceRange.end.clamp(0, sliderConfig.max),
              ),
              min: 0,
              max: sliderConfig.max,
              divisions: sliderConfig.divisions,
              activeColor: TColors.primary,
              inactiveColor: TColors.primary.withOpacity(0.3),
              labels: RangeLabels(
                '${_priceRange.start.round()} DT',
                '${_priceRange.end.round()} DT',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            const SizedBox(height: 8),
            _buildQuickRangeButtons(isDark),
          ],
        );
      },
    );
  }

  SliderConfiguration _getSliderConfiguration() {
    if (_priceRange.end <= 1000) {
      return SliderConfiguration(max: 1000, divisions: 100);
    } else if (_priceRange.end <= 5000) {
      return SliderConfiguration(max: 5000, divisions: 100);
    } else if (_priceRange.end <= 20000) {
      return SliderConfiguration(max: 20000, divisions: 100);
    } else if (_priceRange.end <= 50000) {
      return SliderConfiguration(max: 50000, divisions: 100);
    } else {
      return SliderConfiguration(max: 100000, divisions: 100);
    }
  }

  Widget _buildQuickRangeButtons(bool isDark) {
    return Wrap(
      spacing: 8,
      children: [
        _buildQuickRangeButton("0-500", 0, 500, isDark),
        _buildQuickRangeButton("500-2K", 500, 2000, isDark),
        _buildQuickRangeButton("2K-10K", 2000, 10000, isDark),
        _buildQuickRangeButton("10K-50K", 10000, 50000, isDark),
        _buildQuickRangeButton("50K+", 50000, 100000, isDark),
      ],
    );
  }

  Widget _buildPriceDisplay(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: ${_priceRange.start.round()} DT',
                style: _getPriceDisplayStyle(isDark),
              ),
              Text(
                'Max: ${_priceRange.end.round()} DT',
                style: _getPriceDisplayStyle(isDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  TextStyle _getPriceDisplayStyle(bool isDark) {
    return TextStyle(
      color: isDark ? TColors.textWhite : TColors.textPrimary,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );
  }

  Widget _buildManualPriceInputs(bool isDark) {
    return Row(
      children: [
        Expanded(child: _buildMinPriceInput(isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildMaxPriceInput(isDark)),
      ],
    );
  }

  Widget _buildMinPriceInput(bool isDark) {
    return TextField(
      keyboardType: TextInputType.number,
      style: _getInputTextStyle(isDark),
      decoration: _getInputDecoration("Prix min", isDark),
      onChanged: (value) {
        final newMin = double.tryParse(value) ?? 0;
        if (newMin <= _priceRange.end) {
          setState(() {
            _priceRange = RangeValues(newMin, _priceRange.end);
          });
        }
      },
    );
  }

  Widget _buildMaxPriceInput(bool isDark) {
    return TextField(
      keyboardType: TextInputType.number,
      style: _getInputTextStyle(isDark),
      decoration: _getInputDecoration("Prix max", isDark),
      onChanged: (value) {
        final newMax = double.tryParse(value) ?? 100000;
        if (newMax >= _priceRange.start) {
          setState(() {
            _priceRange = RangeValues(_priceRange.start, newMax);
          });
        }
      },
    );
  }

  TextStyle _getInputTextStyle(bool isDark) {
    return TextStyle(
      color: isDark ? TColors.textWhite : TColors.textPrimary,
      fontSize: 14,
    );
  }

  InputDecoration _getInputDecoration(String labelText, bool isDark) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: isDark ? TColors.grey : Colors.grey[600],
        fontSize: 12,
      ),
      suffixText: "DT",
      suffixStyle: TextStyle(
        color: isDark ? TColors.grey : Colors.grey[600],
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: TColors.primary),
      ),
    );
  }

  Widget _buildSortSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Ordre de tri", isDark),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? TColors.grey : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isDark ? TColors.dark.withOpacity(0.3) : Colors.transparent,
          ),
          child: Column(
            children: [
              _buildSortOption('desc', 'Prix décroissant', isDark),
              Divider(
                height: 1,
                color: isDark ? TColors.grey : Colors.grey[300],
              ),
              _buildSortOption('asc', 'Prix croissant', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOption(String value, String title, bool isDark) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? TColors.textWhite : TColors.textPrimary,
        ),
      ),
      value: value,
      groupValue: _sortOrder,
      activeColor: TColors.primary,
      onChanged: (newValue) {
        setState(() {
          _sortOrder = newValue!;
        });
      },
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        child: const Text(
          "Appliquer les filtres",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? TColors.textWhite : TColors.textPrimary,
      ),
    );
  }

  Widget _buildQuickRangeButton(
      String label, double min, double max, bool isDark) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _priceRange = RangeValues(min, max);
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: TColors.primary,
        backgroundColor: isDark ? TColors.dark : TColors.lightContainer,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? TColors.textWhite : TColors.textPrimary,
        ),
      ),
    );
  }

  void _applyFilters() {
    final filterData = {
      'minPrice': _priceRange.start.round(),
      'maxPrice': _priceRange.end.round(),
      'sortOrder': _sortOrder,
    };

    Navigator.pop(context, filterData);
  }
}

class SliderConfiguration {
  final double max;
  final int divisions;

  SliderConfiguration({required this.max, required this.divisions});
}
