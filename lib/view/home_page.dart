import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:team_up/services/data_service.dart';
import 'package:team_up/view/team_detail_page.dart';
import 'package:team_up/widget/calendar_button.dart';
import 'package:team_up/widget/events_list.dart';
import 'package:team_up/widget/team_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List events = [];
  List teams = [];
  bool isLoading = true;

  final dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final eventsData = await dataService.fetchEvents();
      final teamsData = await dataService.fetchTeams();

      if (!mounted) return;

      setState(() {
        events = eventsData;
        teams = teamsData;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load data: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Home'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Teams Section',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                teams.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(90.0),
                        child: Text(
                          'No Teams Joined Yet',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: CarouselSlider.builder(
                          itemCount: teams.length,
                          itemBuilder: (context, index, realIndex) {
                            final team = teams[index];
                            String teamName = team['name']?.toString() ?? 'No Team Name';
                            return TeamCard(
                              teamName: teamName,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TeamDetailPage(team: team, teamId: '',)),
                                );
                              },
                            );
                          },
                          options: CarouselOptions(
                            height: 200,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            enableInfiniteScroll: true,
                            viewportFraction: 0.8,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                const CalendarButton(),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: EventsList(events: events)),
              ],
            ),
    );
  }
}
