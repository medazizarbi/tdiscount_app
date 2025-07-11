import 'package:flutter/material.dart';
import 'package:tdiscount_app/utils/constants/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> availableCategories;

  const FilterBottomSheet({
    super.key,
    required this.availableCategories,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final TextEditingController _brandController = TextEditingController();

  RangeValues _priceRange = const RangeValues(0, 3000);
  String _sortOrder = 'desc';
  final List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _brandController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.8,
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

              // Title - Now scrollable
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

              // Filter content - All in the same scrollable area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Categories Selection
                    _buildSectionTitle("Catégories", isDark),
                    const SizedBox(height: 12),

                    // Available categories as selectable chips
                    if (widget.availableCategories.isNotEmpty) ...[
                      Text(
                        "Sélectionner des catégories:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? TColors.grey : TColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.availableCategories.map((category) {
                          final isSelected =
                              _selectedCategories.contains(category);
                          return GestureDetector(
                            onTap: () => _toggleCategory(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? TColors.primary
                                        .withOpacity(0.2) // Yellow with opacity
                                    : isDark
                                        ? TColors.dark.withOpacity(0.5)
                                        : Colors.grey[100]!,
                                border: Border.all(
                                  color: isSelected
                                      ? TColors.primary // Yellow border
                                      : isDark
                                          ? TColors.grey
                                          : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSelected ? Icons.remove : Icons.add,
                                    color: isSelected
                                        ? Colors
                                            .black // Black icon for readability
                                        : isDark
                                            ? TColors.grey
                                            : Colors.grey[600],
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors
                                              .black // Keep text black for readability
                                          : isDark
                                              ? TColors.textWhite
                                              : TColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? TColors.dark.withOpacity(0.5)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? TColors.grey : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          "Aucune catégorie disponible",
                          style: TextStyle(
                            color: isDark ? TColors.grey : Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // 2. Brand Search Field
                    _buildSectionTitle("Marque", isDark),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _brandController,
                      style: TextStyle(
                        color: isDark ? TColors.textWhite : TColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "Rechercher une marque",
                        hintStyle: TextStyle(
                          color: isDark ? TColors.grey : Colors.grey[600],
                        ),
                        prefixIcon: Icon(
                          Icons.branding_watermark,
                          color: isDark ? TColors.grey : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? TColors.grey : Colors.grey[300]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? TColors.grey : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: TColors.primary, // Yellow focus border
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? TColors.dark.withOpacity(0.5)
                            : Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Price Range
                    _buildSectionTitle("Fourchette de prix", isDark),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 10000,
                      divisions: 100,
                      activeColor: TColors.primary, // Yellow for active
                      inactiveColor: TColors.primary
                          .withOpacity(0.3), // Yellow with opacity
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
                    // Price display - Simple left and right alignment
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_priceRange.start.round()} DT',
                            style: TextStyle(
                              color: isDark
                                  ? TColors.textWhite
                                  : TColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${_priceRange.end.round()} DT',
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
                    ),
                    const SizedBox(height: 24),

                    // 4. Order Selection
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
                            activeColor:
                                TColors.primary, // Yellow for radio buttons
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
                            activeColor:
                                TColors.primary, // Yellow for radio buttons
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

                    // 5. Apply Filters Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary, // Yellow background
                          foregroundColor: Colors.black, // Black text on yellow
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
                            color: Colors.black, // Black text for readability
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

  void _applyFilters() {
    final filterData = {
      'categories': _selectedCategories,
      'brand': _brandController.text.trim(),
      'minPrice': _priceRange.start.round(),
      'maxPrice': _priceRange.end.round(),
      'sortOrder': _sortOrder,
    };

    Navigator.pop(context, filterData);
  }
}
