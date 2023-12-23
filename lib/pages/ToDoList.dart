import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:dissertationtest/features/routes.dart' as route;

import '../model/routeToDoList.dart';
import '../widget/ListView.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}


class _ToDoListState extends State<ToDoList> {
  CalendarFormat _formatOfCalendar = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  routeToDoList createTask = routeToDoList(
      "", "", "", DateTime.parse('2020-01-02 03:04:05'), "", false, "create");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                    child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2022),
                  lastDay: DateTime(2024),
                  
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  calendarFormat: _formatOfCalendar,
                  calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      )),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: ((selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        // debugPrint("yollo");
                      });
                    }
                  }),
                )),
              ),
            ),
            Flexible(
                child: SizedBox(
              height: 300,
              child: ListItem(selectedDate: _selectedDay),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            createTask.setDate(_selectedDay);
            // Navigator.pushNamed(context, route.addItemPage,
            //     arguments: createTask);
          }
          ),
    );
  }
}
