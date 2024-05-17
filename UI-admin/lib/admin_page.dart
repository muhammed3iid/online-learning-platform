import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> _instructors = [];
  List<dynamic> _students = [];
  List<dynamic> _courses = [];
  List<dynamic> _courseApprovalRequests = [];
  String _currentCategory = 'Instructors';
  Map<String, dynamic>? _selectedItem;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'affiliation': TextEditingController(),
    'yearsOfExperience': TextEditingController(),
    'bio': TextEditingController(),
    'category': TextEditingController(),
    'duration': TextEditingController(),
    'rating': TextEditingController(),
    'capacity': TextEditingController(),
    'numOfEnrolled': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _fetchInstructors();
    _fetchStudents();
    _fetchCourses();
    _fetchCourseApprovalRequests();
  }

  Future<void> _fetchInstructors() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8083/Admin-service-1.0-SNAPSHOT/api/admin/view-instructors'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _instructors = json.decode(response.body) as List<dynamic>;
        });
      } else {
        print('Failed to load instructors: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading instructors: $e');
    }
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8083/Admin-service-1.0-SNAPSHOT/api/admin/view-students'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _students = json.decode(response.body) as List<dynamic>;
        });
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
  }

  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8083/Admin-service-1.0-SNAPSHOT/api/admin/view-courses'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _courses = json.decode(response.body) as List<dynamic>;
        });
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
  }

  Future<void> _fetchCourseApprovalRequests() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8081/api/admin/course-approval-requests'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _courseApprovalRequests = json.decode(response.body) as List<dynamic>;
        });
      } else {
        print(
            'Failed to load course approval requests: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading course approval requests: $e');
    }
  }

  Future<void> _editSelectedItem() async {
    if (_formKey.currentState!.validate()) {
      switch (_currentCategory) {
        case 'Instructors':
          _editInstructor();
          break;
        case 'Students':
          // _editStudent();
          break;
        case 'Courses':
          _editCourse();
          break;
        default:
          print('Invalid category');
      }
    }
  }

  Future<void> _editInstructor() async {
    Map<String, dynamic> updatedData = {};
    _controllers.forEach((key, controller) {
      updatedData[key] = controller.text;
    });

    try {
      final response = await http.put(
        Uri.parse(
            'http://your-api-url/update/instructor/${_selectedItem!['id']}'),
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Instructor updated successfully');
        _fetchInstructors();
      } else {
        print('Failed to update instructor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating instructor: $e');
    }
  }

  Future<void> _editCourse() async {
    Map<String, dynamic> updatedData = {};
    _controllers.forEach((key, controller) {
      if (key == 'rating' || key == 'capacity' || key == 'numOfEnrolled') {
        updatedData[key] = int.tryParse(controller.text) ?? 0;
      } else {
        updatedData[key] = controller.text;
      }
    });

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8083/Admin-service-1.0-SNAPSHOT/api/admin/edit-course?courseId=${_selectedItem!['id']}'),
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Course updated successfully');
        _fetchCourses();
      } else {
        print('Failed to update course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating course: $e');
    }
  }


  // void _clearControllers() {
  //   _nameController.clear();
  //   _emailController.clear();
  //   _passwordController.clear();
  //   _affiliationController.clear();
  //   _experienceController.clear();
  //   _bioController.clear();
  //   // Clear other controllers as needed
  // }

  void _setCurrentCategory(String category) {
    setState(() {
      _currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: Row(
        children: [
          _buildCategoryColumn(),
          _buildUserInfoColumn(),
          _buildCourseApprovalRequestsColumn(),
        ],
      ),
    );
  }

  Widget _buildCategoryColumn() {
    List<dynamic> currentList;
    switch (_currentCategory) {
      case 'Instructors':
        currentList = _instructors;
        break;
      case 'Students':
        currentList = _students;
        break;
      case 'Courses':
        currentList = _courses;
        break;
      default:
        currentList = [];
    }

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
                  onPressed: () => _setCurrentCategory('Instructors'),
                  child: Text(
                    'Instructors',
                    style: TextStyle(
                      fontWeight: _currentCategory == 'Instructors'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _setCurrentCategory('Students'),
                  child: Text(
                    'Students',
                    style: TextStyle(
                      fontWeight: _currentCategory == 'Students'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _setCurrentCategory('Courses'),
                  child: Text(
                    'Courses',
                    style: TextStyle(
                      fontWeight: _currentCategory == 'Courses'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                var item = currentList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItem = item;
                      _controllers.forEach((key, controller) {
                        if (key == 'yearsOfExperience' || key == 'duration' || key == 'rating' || key == 'capacity' || key == 'numOfEnrolled') {
                          _controllers[key] = TextEditingController(text: _selectedItem![key]?.toString());
                        } else {
                          controller.text = _selectedItem![key] ?? '';
                        }
                      });
                    });
                  },

                  child: Container(
                    color: _selectedItem == item ? Colors.grey[300] : null,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var field in _getFieldsForCategory(_currentCategory))
                          Text('$field: ${item[field]}'),
                        if (index < currentList.length - 1) const Divider(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoColumn() {
    if (_selectedItem == null) {
      return const Expanded(
        child: Center(
          child: Text(
            'Select an item to view details',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                '$_currentCategory Details',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              for (var field in _getFieldsForCategory(_currentCategory))
                TextFormField(
                  controller: _controllers[field],
                  decoration: InputDecoration(labelText: field),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the $field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedItem![field] = value!;
                  },
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editSelectedItem,
                child: const Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getFieldsForCategory(String category) {
    switch (category) {
      case 'Instructors':
        return [
          'name',
          'email',
          'password',
          'affiliation',
          'yearsOfExperience',
          'bio'
        ];
      case 'Students':
        return ['name', 'email', 'password', 'affiliation', 'bio'];
      case 'Courses':
        return [
          'name',
          'category',
          'duration',
          'rating',
          'capacity',
          'numOfEnrolled'
        ];
      default:
        return [];
    }
  }


  Widget _buildCourseApprovalRequestsColumn() {
    return Container(
      width: 500,
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
                  'Course Approval Requests',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _fetchCourseApprovalRequests(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _courseApprovalRequests.length,
              itemBuilder: (context, index) {
                var request = _courseApprovalRequests[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${request['courseName']} - ${request['instructorName']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle approval
                          },
                          child: const Text('Approve'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle rejection
                          },
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                    if (index < _courseApprovalRequests.length - 1)
                      const Divider(),
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
