import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/app/add_timer_screen.dart';
import 'package:flutter_application_1/views/app/shared_prefs_service.dart';
import 'package:flutter_application_1/views/app/timer_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> savedTimers = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTimers();
  }

  _loadSavedTimers() async {
    List<Map<String, dynamic>> timers =
        (await SharedPrefsService.getSavedTimers()).cast<Map<String, dynamic>>();
    setState(() {
      savedTimers = timers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 78, 96, 166), // خلفية الصفحة
      appBar: AppBar(
        title: Text(
          'Timer',
          style: TextStyle(
            color: Color.fromARGB(255, 42, 89, 158),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFB388EB),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 213, 200, 200)),
        elevation: 4,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: savedTimers.length,
              itemBuilder: (context, index) {
                final timer = savedTimers[index];
                return Card(
                  elevation: 4,
                  color: Color(0xFFEDE7F6), // لون الكارت
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      timer["name"],
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${timer["duration"]} sec",
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerScreen(
                            purpose: timer["name"],
                            duration: timer["duration"],
                            timerType: '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTimerScreen()),
                );

                if (result != null && result is Map<String, dynamic>) {
                  _loadSavedTimers();
                }
              },
              backgroundColor: Color(0xFF957DAD),
              child: Icon(Icons.add, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
