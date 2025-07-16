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
      builder: (context, scrollController) => Container(
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
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: isDark ? TColors.grey : TColors.darkGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  "Filtres",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.textWhite : TColors.textPrimary,
                  ),
                ),
              ),

              // Filter content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Price Range
                    _buildSectionTitle("Fourchette de prix", isDark),
                    const SizedBox(height: 12),

                    // Dynamic max value based on current selection
                    Builder(
                      builder: (context) {
                        // Determine dynamic max based on current end value
                        double dynamicMax;
                        int divisions;

                        if (_priceRange.end <= 1000) {
                          dynamicMax = 1000;
                          divisions = 100; // 10 DT steps
                        } else if (_priceRange.end <= 5000) {
                          dynamicMax = 5000;
                          divisions = 100; // 50 DT steps
                        } else if (_priceRange.end <= 20000) {
                          dynamicMax = 20000;
                          divisions = 100; // 200 DT steps
                        } else if (_priceRange.end <= 50000) {
                          dynamicMax = 50000;
                          divisions = 100; // 500 DT steps
                        } else {
                          dynamicMax = 100000;
                          divisions = 100; // 1000 DT steps
                        }

                        return Column(
                          children: [
                            RangeSlider(
                              values: RangeValues(
                                _priceRange.start.clamp(0, dynamicMax),
                                _priceRange.end.clamp(0, dynamicMax),
                              ),
                              min: 0,
                              max: dynamicMax,
                              divisions: divisions,
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

                            // Quick range buttons
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildQuickRangeButton("0-500", 0, 500, isDark),
                                _buildQuickRangeButton(
                                    "500-2K", 500, 2000, isDark),
                                _buildQuickRangeButton(
                                    "2K-10K", 2000, 10000, isDark),
                                _buildQuickRangeButton(
                                    "10K-50K", 10000, 50000, isDark),
                                _buildQuickRangeButton(
                                    "50K+", 50000, 100000, isDark),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    // Price display with manual input option
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min: ${_priceRange.start.round()} DT',
                                style: TextStyle(
                                  color: isDark
                                      ? TColors.textWhite
                                      : TColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Max: ${_priceRange.end.round()} DT',
                                style: TextStyle(
                                  color: isDark
                                      ? TColors.textWhite
                                      : TColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Manual input fields
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: isDark
                                        ? TColors.textWhite
                                        : TColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Prix min",
                                    labelStyle: TextStyle(
                                      color: isDark
                                          ? TColors.grey
                                          : Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    suffixText: "DT",
                                    suffixStyle: TextStyle(
                                      color: isDark
                                          ? TColors.grey
                                          : Colors.grey[600],
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
                                      borderSide: const BorderSide(
                                          color: TColors.primary),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    final newMin = double.tryParse(value) ?? 0;
                                    if (newMin <= _priceRange.end) {
                                      setState(() {
                                        _priceRange = RangeValues(
                                            newMin, _priceRange.end);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: isDark
                                        ? TColors.textWhite
                                        : TColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Prix max",
                                    labelStyle: TextStyle(
                                      color: isDark
                                          ? TColors.grey
                                          : Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    suffixText: "DT",
                                    suffixStyle: TextStyle(
                                      color: isDark
                                          ? TColors.grey
                                          : Colors.grey[600],
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
                                      borderSide: const BorderSide(
                                          color: TColors.primary),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    final newMax =
                                        double.tryParse(value) ?? 100000;
                                    if (newMax >= _priceRange.start) {
                                      setState(() {
                                        _priceRange = RangeValues(
                                            _priceRange.start, newMax);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Order Selection
                    _buildSectionTitle("Ordre de tri", isDark),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? TColors.grey : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark
                            ? TColors.dark.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(
                              'Prix décroissant',
                              style: TextStyle(
                                color: isDark
                                    ? TColors.textWhite
                                    : TColors.textPrimary,
                              ),
                            ),
                            value: 'desc',
                            groupValue: _sortOrder,
                            activeColor: TColors.primary,
                            onChanged: (value) {
                              setState(() {
                                _sortOrder = value!;
                              });
                            },
                          ),
                          Divider(
                            height: 1,
                            color: isDark ? TColors.grey : Colors.grey[300],
                          ),
                          RadioListTile<String>(
                            title: Text(
                              'Prix croissant',
                              style: TextStyle(
                                color: isDark
                                    ? TColors.textWhite
                                    : TColors.textPrimary,
                              ),
                            ),
                            value: 'asc',
                            groupValue: _sortOrder,
                            activeColor: TColors.primary,
                            onChanged: (value) {
                              setState(() {
                                _sortOrder = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 3. Apply Filters Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                        },
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
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
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
