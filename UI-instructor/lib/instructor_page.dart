import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstructorPage extends StatefulWidget {
  const InstructorPage({Key? key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> {
  List<dynamic> _courses = [];
  List<dynamic> _waitingLists = [];
  bool _showAllCourses = true;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCategoryController =
      TextEditingController();
  final TextEditingController _courseDurationController =
      TextEditingController();
  final TextEditingController _courseCapacityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewAllCourses();
    _fetchWaitingLists();
  }

  Future<void> _viewAllCourses({String? key}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8081/api/instructor/search-courses?key=${key ?? ""}'),
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

  Future<void> _createCourse() async {
    final Map<String, dynamic> courseData = {
      'name': _courseNameController.text,
      'category': _courseCategoryController.text,
      'duration': _courseDurationController.text,
      'capacity': _courseCapacityController.text,
    };
    final int instructorID = widget.userData['id'];
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8081/api/instructor/create-course?instructorID=$instructorID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(courseData),
      );
      if (response.statusCode == 200) {
        print('Course created successfully');
        setState(() {
          _showAllCourses = true;
        });
        _viewAllCourses();
      } else {
        print('Failed to create course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating course: $e');
    }
  }

  Future<void> _fetchWaitingLists() async {
    List<dynamic> waitingLists =
        widget.userData['waitingList'] as List<dynamic>;
    setState(() {
      _waitingLists = waitingLists;
    });
  }

  void _selectCategory(bool showAllCourses) {
    setState(() {
      _showAllCourses = showAllCourses;
      _courses.clear();
    });
    if (showAllCourses) {
      _viewAllCourses();
    }
  }

  void _searchCourses() {
    _viewAllCourses(key: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instructor Page')),
      body: Row(
        children: [
          _buildCoursesColumn(),
          _buildUserInfoColumn(),
          _buildWaitingListsColumn(),
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
                    'View All Courses',
                    style: TextStyle(
                      fontWeight:
                          _showAllCourses ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectCategory(false),
                  child: Text(
                    'Create New Course',
                    style: TextStyle(
                      fontWeight: !_showAllCourses
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!_showAllCourses)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _courseNameController,
                    decoration: const InputDecoration(labelText: 'Course Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _courseCategoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _courseDurationController,
                    decoration: const InputDecoration(labelText: 'Duration'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _courseCapacityController,
                    decoration: const InputDecoration(labelText: 'Capacity'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _createCourse,
                    child: const Text('Create Course'),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          if (_showAllCourses) // Move the search bar inside this condition
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
                    Text('Name: ${course['name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Category: ${course['category']}'),
                    Text('Duration: ${course['duration']}'),
                    Text('Rating: ${course['rating']}'),
                    Text('Capacity: ${course['capacity']}'),
                    Text('Number of enrolled: ${course['numOfEnrolled']}'),
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
            const SizedBox(height: 10),
            Text(
                'Years of experience: ${widget.userData['yearsOfExperience']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingListsColumn() {
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
              children: [
                const Text(
                  'Waiting Lists',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _fetchWaitingLists(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _waitingLists.length,
              itemBuilder: (context, index) {
                var waitingList = _waitingLists[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      waitingList,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept
                          },
                          child: const Text('Accept'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle reject
                          },
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                    if (index < _waitingLists.length - 1) const Divider(),
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
