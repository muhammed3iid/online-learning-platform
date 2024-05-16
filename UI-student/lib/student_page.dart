import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const StudentPage({Key? key, required this.userData}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<dynamic> _courses = [];
  List<dynamic> _notifications = [];
  bool _showEnrolledCourses = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewEnrolledCourses();
    _fetchNotifications();
  }

  Future<void> _viewEnrolledCourses() async {
    final studentID = widget.userData['id'];
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8082/api/student/view-enrolled-courses?studentID=$studentID'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> enrolledCourses =
            json.decode(response.body) as List<dynamic>;
        setState(() {
          _courses = enrolledCourses;
        });
      } else {
        print('Failed to load enrolled courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading enrolled courses: $e');
    }
  }

  Future<void> _viewAllCourses({String? key}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8082/api/student/search-courses?key=${key ?? ""}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> allCourses =
            json.decode(response.body) as List<dynamic>;
        setState(() {
          _courses = allCourses;
        });
      } else {
        print('Failed to load all courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading all courses: $e');
    }
  }

  Future<void> _enrollInCourse(int courseId) async {
    final studentID = widget.userData['id'];
    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:8082/api/student/request?studentID=$studentID&courseID=$courseId'),
        body: json.encode({'studentID': studentID, 'courseID': courseId}),
      );
      if (response.statusCode == 200) {
        print('Successfully requested to enroll in course');
      } else {
        print('Failed to request enroll in course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error enrolling in course: $e');
    }
  }

  Future<void> _fetchNotifications() async {
    List<dynamic> notifications =
        widget.userData['notifications'] as List<dynamic>;
    setState(() {
      _notifications = notifications;
    });
  }

  void _selectCategory(bool showEnrolled) {
    setState(() {
      _showEnrolledCourses = showEnrolled;
      _courses.clear();
    });
    if (showEnrolled) {
      _viewEnrolledCourses();
    } else {
      _viewAllCourses();
    }
  }

  void _searchCourses() {
    _viewAllCourses(key: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Page')),
      body: Row(
        children: [
          _buildCoursesColumn(),
          _buildUserInfoColumn(),
          _buildNotificationsColumn(),
        ],
      ),
    );
  }

  Widget _buildCoursesColumn() {
    return Container(
      width: 400,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _selectCategory(true),
                  child: Text(
                    'Enrolled Courses',
                    style: TextStyle(
                      fontWeight: _showEnrolledCourses
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectCategory(false),
                  child: Text(
                    'All Courses',
                    style: TextStyle(
                      fontWeight: !_showEnrolledCourses
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!_showEnrolledCourses)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Courses',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchCourses,
                      ),
                    ),
                    onSubmitted: (_) => _searchCourses(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                var course = _courses[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Name: ${course['name']}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        if (!_showEnrolledCourses)
                          ElevatedButton(
                            onPressed: () => _enrollInCourse(course['id']),
                            child: const Text('Enroll'),
                          ),
                      ],
                    ),
                    Text('Category: ${course['category']}'),
                    Text('Duration: ${course['duration']}'),
                    Text('Rating: ${course['rating']}'),
                    if (index < _courses.length - 1) const Divider(),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoColumn() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${widget.userData['name']}'),
            const SizedBox(height: 10),
            Text('Affiliation: ${widget.userData['affiliation']}'),
            const SizedBox(height: 10),
            Text('Bio: ${widget.userData['bio']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsColumn() {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _fetchNotifications(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                var notification = _notifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (index < _notifications.length - 1) const Divider(),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
