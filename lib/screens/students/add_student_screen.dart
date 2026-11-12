import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_mock_data.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/validators.dart';
import '../../models/student_model.dart';
import '../../services/student_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Screen for enrolling a new student into the Attendance System.
class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _studentService = MockStudentService();
  String _selectedSection = 'CS-3A';
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _selectedSection = args;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNumberController.dispose();
    super.dispose();
  }

  void _handleAddStudent() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final newStudent = StudentModel(
        id: 'st_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        rollNumber: _rollNumberController.text.trim().toUpperCase(),
        email: '${_rollNumberController.text.trim().toLowerCase()}@college.edu',
        department: 'Computer Science',
        sectionId: _selectedSection,
        year: '3rd Year',
        semester: '6th Sem',
        attendancePercentage: 100.0,
      );

      await _studentService.addStudent(newStudent);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student "${newStudent.name}" added to $_selectedSection!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Add Student',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Form(
            key: _formKey,
            child: Card(
              color: AppColors.cardBackground,
              elevation: AppSizes.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                side: const BorderSide(color: AppColors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.p24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enrol New Student',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Student Name
                    CustomTextField(
                      label: 'STUDENT NAME',
                      hint: 'e.g. Rahul Kumar',
                      controller: _nameController,
                      validator: (val) => Validators.validateRequired(val, 'Student Name'),
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Roll Number
                    CustomTextField(
                      label: 'ROLL NUMBER / STUDENT ID',
                      hint: 'e.g. 23CS001',
                      controller: _rollNumberController,
                      validator: Validators.validateRollNumber,
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Section Dropdown
                    const Text(
                      'SECTION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSection,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                          isExpanded: true,
                          items: AppMockData.sections.map((sec) {
                            return DropdownMenuItem<String>(
                              value: sec.id,
                              child: Text(
                                '${sec.name} (${sec.department})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedSection = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.p28),

                    // Submit Button
                    CustomButton(
                      text: 'Add Student',
                      icon: Icons.person_add_alt_1_rounded,
                      isLoading: _isLoading,
                      onPressed: _handleAddStudent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
