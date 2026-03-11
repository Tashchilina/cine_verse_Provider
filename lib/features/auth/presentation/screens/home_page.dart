import 'package:cine_verse/features/auth/presentation/controllers/navigation_provider.dart';
import 'package:cine_verse/features/auth/presentation/screens/favorites.dart';
import 'package:cine_verse/features/auth/presentation/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/movie_provider.dart';
import '../widgets/build_appbar.dart';
import '../widgets/build_home_content.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Используем watch только внутри метода build
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      // Показываем AppBar только на вкладке Home
      appBar: navProvider.currentIndex == 0 ? BuildAppBar(context) : null,
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: [
          // ВАЖНО: убедитесь, что BuildHomeContent() вызывается правильно
          BuildHomeContent(context),
          const FavoritesPage(),
          const ProfilePage(),
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
  }
}