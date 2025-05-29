import 'package:flutter/material.dart';
import 'screens/attractions_screen.dart';
import 'screens/events_screen.dart';
import 'screens/tours_screen.dart';
import 'screens/reviews_screen.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: TravelHomePage()),
  );
}

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  TravelHomePageState createState() => TravelHomePageState();
}

class TravelHomePageState extends State<TravelHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attractions'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Attractions'),
            Tab(text: 'Events'),
            Tab(text: 'Tours'),
            Tab(text: 'Reviews'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AttractionsScreen(),
          EventsScreen(),
          TourScreen(),
          ReviewScreen(),
        ],
      ),
    );
  }
}
