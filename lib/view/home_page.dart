import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart';
import 'package:team_up/services/data_service.dart';
import 'package:team_up/view/notifications.dart';
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

  final Dio dio = Dio();
  final SembastService sembastService = SembastService();

  Future<void> fetchData() async {
    final token = await sembastService.getToken();

    final teamsResponse = await dio.get(
      'https://kcgteamupserver-production.up.railway.app/api/team/getUserTeams',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(teamsResponse);

    final eventsResponse = await dio.get(
      'https://kcgteamupserver-production.up.railway.app/api/event/all',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print(eventsResponse);
    if (teamsResponse.statusCode == 200 && eventsResponse.statusCode == 200) {
      final teamsData = teamsResponse.data;
      final eventsData = eventsResponse.data;

      if (!mounted) return;

      setState(() {
        events = eventsData;
        teams = teamsData;
        isLoading = false;
      });
    } else {
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(),
                    ));
              },
              icon: Icon(Icons.notifications_active_sharp))
        ],
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
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: CarouselSlider.builder(
                          itemCount: teams.length,
                          itemBuilder: (context, index, realIndex) {
                            final team = teams[index];
                            String teamName =
                                team['teamName']?.toString() ?? 'No Team Name';
                            String teamId = team['teamId']?.toString() ?? '';

                            return TeamCard(
                              teamName: teamName,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamDetailPage(
                                      teamId: teamId,
                                      team: team,
                                    ),
                                  ),
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
