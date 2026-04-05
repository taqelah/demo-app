import 'package:flutter/material.dart';
import '../constants/test_keys.dart';

class TabsNavigationScreen extends StatefulWidget {
  const TabsNavigationScreen({super.key});

  @override
  State<TabsNavigationScreen> createState() => _TabsNavigationScreenState();
}

class _TabsNavigationScreenState extends State<TabsNavigationScreen> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs & Navigation'),
          bottom: TabBar(
            tabs: [
              Tab(key: TestKeys.tabsFeedTab, text: 'Feed', icon: const Icon(Icons.rss_feed)),
              Tab(key: TestKeys.tabsSearchTab, text: 'Search', icon: const Icon(Icons.search)),
              Tab(key: TestKeys.tabsProfileTab, text: 'Profile', icon: const Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: PageView with swipeable pages
            _buildFeedTab(),
            // Tab 2: Search content
            _buildSearchTab(),
            // Tab 3: Bottom nav demo
            _buildProfileTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Swipe horizontally through pages',
              style: TextStyle(color: Colors.grey)),
        ),
        Expanded(
          child: PageView.builder(
            key: TestKeys.tabsPageView,
            itemCount: 3,
            itemBuilder: (context, index) {
              final colors = [Colors.blue, Colors.green, Colors.orange];
              return Container(
                key: TestKeys.tabsPage(index),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors[index].withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swipe, size: 48, color: colors[index]),
                      const SizedBox(height: 12),
                      Text(
                        'Page ${index + 1} of 3',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors[index],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Swipe left or right',
                          style: TextStyle(color: colors[index])),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return Center(
      key: TestKeys.tabsSearchContent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('Search Tab Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('This tab demonstrates tab switching',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final pages = [
      const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Home Section'),
        ],
      )),
      const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Favorites Section'),
        ],
      )),
      const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Settings Section'),
        ],
      )),
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Bottom navigation bar demo',
              style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: pages[_bottomNavIndex]),
        BottomNavigationBar(
          key: TestKeys.tabsBottomNav,
          currentIndex: _bottomNavIndex,
          onTap: (i) => setState(() => _bottomNavIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, key: TestKeys.tabsBottomNavItem(0)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, key: TestKeys.tabsBottomNavItem(1)),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, key: TestKeys.tabsBottomNavItem(2)),
              label: 'Settings',
            ),
          ],
        ),
      ],
    );
  }
}
