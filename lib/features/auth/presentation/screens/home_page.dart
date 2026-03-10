import 'package:cine_verse/features/auth/presentation/controllers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/build_appbar.dart';
import '../widgets/build_home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
            backgroundColor: const Color(0xFF1A1D29),
            appBar: navProvider.currentIndex == 0 ? BuildAppBar() : null,
            body: IndexedStack(
              index: navProvider.currentIndex,
              children: [
                BuildHomeContent(context),
                const Center(
                  child: Text(
                      'Favorites', style: TextStyle(color: Colors.white)),
                ),
                const Center(
                  child: Text("Profile", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navProvider.currentIndex,
            onTap: (index) => navProvider.setIndex(index),
            backgroundColor: const Color(0xFF1A1D29),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
                items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        ),
        );
      },
    );
  }
}
