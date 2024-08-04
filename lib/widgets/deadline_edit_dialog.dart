import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeadlineEditDialog extends StatefulWidget {
  final DateTime initialDeadline;
  final String groupId;
  final String todoListId;
  final String todoId;

  DeadlineEditDialog({
    required this.initialDeadline,
    required this.groupId,
    required this.todoListId,
    required this.todoId,
  });

  @override
  _DeadlineEditDialogState createState() => _DeadlineEditDialogState();
}

class _DeadlineEditDialogState extends State<DeadlineEditDialog> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late TimeOfDay _selectedTime;
  bool _isTimeSelected = false;

  @override
  void initState() {
    super.initState();

    DateTime initialDate = widget.initialDeadline;
    // Check if the initialDeadline is January 1, 2000
    if (initialDate == DateTime(2000, 1, 1)) {
      initialDate = DateTime.now();
    }

    _calendarFormat = CalendarFormat.month;
    _focusedDay = initialDate;
    _selectedDay = initialDate;
    _selectedTime = TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
    _isTimeSelected = true;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _isTimeSelected = false;
      _selectedTime = TimeOfDay(hour: 0, minute: 0);
    });
  }

Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showDialog<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      int selectedHour = _selectedTime.hour;
      int selectedMinute = _selectedTime.minute; // 1分単位で表示

        return AlertDialog(
          title: Text('時間を選択'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 150,
                      child: NumberPicker(
                        initialValue: selectedHour,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (value) {
                          selectedHour = value;
                        },
                      ),
                    ),
                  ),
                  Text(':'),
                  Expanded(
                    child: Container(
                      height: 150,
                      child: NumberPicker(
                        initialValue: selectedMinute,
                        minValue: 0,
                        maxValue: 59,
                        step: 1,
                        onChanged: (value) {
                          selectedMinute = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context)
                    .pop(TimeOfDay(hour: selectedHour, minute: selectedMinute));
              },
            ),
          ],
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _isTimeSelected = true;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveDeadlineToFirestore(DateTime deadline) async {
    // Firestoreへの保存処理をここに追加します
    await FirebaseFirestore.instance
        .collection('GROUP')
        .doc(widget.groupId)
        .collection('TODOLIST')
        .doc(widget.todoListId)
        .collection('TODO')
        .doc(widget.todoId)
        .update({
      'DEADLINE': deadline,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0.0),
      child: Container(
        width: 392,
        height: 664,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 245, 236),
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '期限を設定する',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: GoogleFonts.notoSansJp(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ).fontFamily,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 195, 195, 195),
                          blurRadius: 0,
                          offset: Offset(0, 2.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  '日付を選択',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: 360,
              height: 408,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: Offset(6, 6),
                  )
                ],
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: TableCalendar(
                locale: 'ja_JP',
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 5,
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  '時間を選択',
                  style: TextStyle(fontSize: 18),
                ),
                Checkbox(
                  value: _isTimeSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTimeSelected = value ?? false;
                      if (_isTimeSelected) {
                        _selectTime(context);
                      }
                    });
                  },
                ),
                if (_isTimeSelected)
                  Text(
                    _formatTime(_selectedTime),
                    style: TextStyle(fontSize: 18),
                  ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 128,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 0,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 255, 102, 112),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        '戻  る',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ).fontFamily,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 128, 128, 128),
                              blurRadius: 0,
                              offset: Offset(0, 2.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 24.0,
                ),
                Container(
                  width: 128,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 0,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime selectedDateTime = DateTime(
                        _selectedDay.year,
                        _selectedDay.month,
                        _selectedDay.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                      await _saveDeadlineToFirestore(selectedDateTime);
                      Navigator.of(context).pop(selectedDateTime);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 116, 199, 156),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Text(
                        '決  定',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: GoogleFonts.notoSansJp(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ).fontFamily,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 118, 168, 141),
                              blurRadius: 0,
                              offset: Offset(0, 2.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NumberPicker extends StatelessWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;
  final ValueChanged<int> onChanged;

  NumberPicker({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 50,
      physics: FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final value = minValue + (index * step);
          if (value > maxValue) return null;
          return Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 24),
            ),
          );
        },
        childCount: ((maxValue - minValue) ~/ step) + 1,
      ),
    );
  }
}
