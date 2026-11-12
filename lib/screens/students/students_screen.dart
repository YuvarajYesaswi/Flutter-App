import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../models/student_model.dart';
import '../../routes/app_routes.dart';
import '../../services/student_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/student_card.dart';

/// Students Screen showing searchable list of students, detail view, deletion, and addition flow.
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final StudentService _studentService = MockStudentService();
  final TextEditingController _searchController = TextEditingController();
  List<StudentModel> _students = [];
  String _selectedSection = 'All';
  bool _isLoading = true;

  final List<String> _sectionFilters = ['All', 'CS-3A', 'CS-3B', 'IT-2A'];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });
    final list = await _studentService.getStudentsBySection(_selectedSection);
    if (mounted) {
      setState(() {
        _students = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _onSearchChanged(String query) async {
    final filtered = await _studentService.searchStudents(
      query,
      sectionId: _selectedSection,
    );
    if (mounted) {
      setState(() {
        _students = filtered;
      });
    }
  }

  void _confirmDeleteStudent(StudentModel student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.danger),
            SizedBox(width: AppSizes.p8),
            Text(
              'Delete Student',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete ${student.name} (${student.rollNumber})? This action cannot be undone.',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.textLight,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _studentService.deleteStudent(student.id);
              await _onSearchChanged(_searchController.text);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Student "${student.name}" deleted.'),
                    backgroundColor: AppColors.danger,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showStudentDetailModal(StudentModel student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.p20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.infoLight,
                  child: Text(
                    student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.p4),
                      Text(
                        'Roll: ${student.rollNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p12,
                    vertical: AppSizes.p6,
                  ),
                  decoration: BoxDecoration(
                    color: student.attendancePercentage >= 75
                        ? AppColors.successLight
                        : AppColors.dangerLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(
                    '${student.attendancePercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: student.attendancePercentage >= 75
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p24),
            const Divider(),
            const SizedBox(height: AppSizes.p16),
            _buildDetailRow(Icons.email_outlined, 'Email', student.email),
            const SizedBox(height: AppSizes.p12),
            _buildDetailRow(Icons.business_outlined, 'Department', student.department),
            const SizedBox(height: AppSizes.p12),
            _buildDetailRow(Icons.school_outlined, 'Class', '${student.year} • ${student.semester}'),
            const SizedBox(height: AppSizes.p24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSizes.p12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Header with Add Button
            AppHeader(
              title: 'Students',
              subtitle: 'Manage and view registered students',
              trailing: IconButton(
                onPressed: () async {
                  final result = await Navigator.of(context).pushNamed(AppRoutes.addStudent);
                  if (result == true) {
                    _loadStudents();
                  }
                },
                icon: Container(
                  padding: const EdgeInsets.all(AppSizes.p8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
              child: CustomTextField(
                hint: 'Search students by name or roll number...',
                controller: _searchController,
                prefixIcon: Icons.search,
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: AppSizes.p12),

            // Section Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
              child: Row(
                children: _sectionFilters.map((sec) {
                  final isSelected = sec == _selectedSection;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.p8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(
                        sec == 'All' ? 'All Sections' : sec,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 1,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedSection = sec;
                          });
                          _loadStudents();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSizes.p12),

            // Student Cards List / Empty State
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _students.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p20,
                            vertical: AppSizes.p8,
                          ),
                          itemCount: _students.length,
                          separatorBuilder: (ctx, i) => const SizedBox(height: AppSizes.p8),
                          itemBuilder: (ctx, index) {
                            final student = _students[index];
                            return StudentCard(
                              student: student,
                              onTap: () => _showStudentDetailModal(student),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.danger,
                                  size: 20,
                                ),
                                onPressed: () => _confirmDeleteStudent(student),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p20),
              decoration: const BoxDecoration(
                color: AppColors.inputFill,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              'No Students Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'No student profiles match your search criteria. Try a different search term or add a new student.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
