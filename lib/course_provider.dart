import 'package:flutter/material.dart';
import 'course.dart';

class CourseProvider with ChangeNotifier {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void removeCourse(int index) {
    _courses.removeAt(index);
    notifyListeners();
  }

  double calculateGPA() {
    if (_courses.isEmpty) return 0.0;
    double totalWeighted = 0;
    int totalUnits = 0;
    
    for (var course in _courses) {
      totalWeighted += course.grade * course.units;
      totalUnits += course.units;
    }
    
    return totalUnits == 0 ? 0.0 : totalWeighted / totalUnits;
  }
}
