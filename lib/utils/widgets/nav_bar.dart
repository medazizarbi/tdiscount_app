import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final void Function(int) onItemTapped; // To handle item tap
  final int selectedIndex; // To know which index is selected

  const NavBar({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the nav bar
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            blurRadius: 10, // Blur radius for the shadow
            offset: const Offset(0, -5), // Shadow position (above the nav bar)
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              widget.selectedIndex == 0
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined,
            ),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.selectedIndex == 1 ? Icons.search : Icons.search_outlined,
            ),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.selectedIndex == 2 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.selectedIndex == 3
                  ? Icons.favorite
                  : Icons.favorite_outline_outlined,
            ),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.selectedIndex == 4
                  ? Icons.person
                  : Icons.person_outline_outlined,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.teal, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        type: BottomNavigationBarType.fixed, // To avoid shrinking animation
      ),
    );
  }
}
