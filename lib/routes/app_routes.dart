import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/students/students_screen.dart';
import '../screens/students/add_student_screen.dart';
import '../screens/reports/reports_screen.dart';

/// Centralized route configuration for Attendance Management System.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String attendance = '/attendance';
  static const String students = '/students';
  static const String addStudent = '/add-student';
  static const String reports = '/reports';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      attendance: (context) => const AttendanceScreen(),
      students: (context) => const StudentsScreen(),
      addStudent: (context) => const AddStudentScreen(),
      reports: (context) => const ReportsScreen(),
    };
  }
}
