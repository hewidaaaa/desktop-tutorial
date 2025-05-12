import 'package:flutter/material.dart';
import 'shared_prefs_service.dart'; // تأكد من وجود الملف ده

class AddTimerScreen extends StatefulWidget {
  @override
  _AddTimerScreenState createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  final TextEditingController _controller = TextEditingController();
  int _selectedHours = 0;
  int _selectedMinutes = 25;
  int _selectedSeconds = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveTimer() async {
    int totalSeconds = (_selectedHours * 3600) + (_selectedMinutes * 60) + _selectedSeconds;
    String purpose = _controller.text.trim();

    if (purpose.isEmpty || totalSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name and valid time')),
      );
      return;
    }

    Map<String, dynamic> timer = {
      "name": purpose,
      "duration": totalSeconds,
    };

    // حفظ التايمر في SharedPreferences
    await SharedPrefsService.saveTimer(timer);

    // العودة إلى الصفحة الرئيسية بعد الحفظ
    Navigator.pop(context, timer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Timer'),
        backgroundColor: Colors.deepPurple,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter Timer Purpose',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimePicker('Hours', _selectedHours, 24, (val) {
                      setState(() => _selectedHours = val);
                    }),
                    _buildTimePicker('Minutes', _selectedMinutes, 60, (val) {
                      setState(() => _selectedMinutes = val);
                    }),
                    _buildTimePicker('Seconds', _selectedSeconds, 60, (val) {
                      setState(() => _selectedSeconds = val);
                    }),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _saveTimer,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Timer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    int value,
    int max,
    void Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButton<int>(
          value: value,
          items: List.generate(max, (index) => index).map((int val) {
            return DropdownMenuItem<int>(
              value: val,
              child: Text(val.toString().padLeft(2, '0')),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    );
  }
}
