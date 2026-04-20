// lib/features/worksspace/presentation/screens/workspace_dashboard_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/constants/app_widget_styles.dart';
import '../widgets/workspace_widgets/dashboard_header.dart';
import '../widgets/workspace_widgets/manage_members_button.dart';
import '../widgets/workspace_widgets/stats_grid.dart';
import '../widgets/workspace_widgets/space_card.dart';
import '../widgets/workspace_widgets/empty_spaces.dart';
import '../widgets/workspace_widgets/add_space_fab.dart';
import '../widgets/workspace_widgets/create_space_sheet.dart';
import '../widgets/workspace_widgets/edit_space_sheet.dart';

// ════════════════════════════════════════════════
// LOCAL UI-ONLY SPACE MODEL — no backend yet
// ════════════════════════════════════════════════
class _SpaceModel {
  String name;
  String description;
  String icon;
  Color color;
  final int totalTasks;
  final int completedTasks;
  final int noteCount;
  int visibility; // 0=Private, 1=Public

  _SpaceModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.noteCount = 0,
    this.visibility = 0,
  });

  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
}

// ════════════════════════════════════════════════
// MAIN SCREEN
// ════════════════════════════════════════════════
class WorkspaceDashboardScreen extends StatefulWidget {
  final int workspaceId;
  final String workspaceName;
  final String workspaceDescription;
  final int numberOfMembers;
  final int numberOfTasks;
  final bool isCurrentUserOwner;

  const WorkspaceDashboardScreen({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
    this.workspaceDescription = '',
    required this.numberOfMembers,
    required this.numberOfTasks,
    required this.isCurrentUserOwner,
  });

  @override
  State<WorkspaceDashboardScreen> createState() =>
      _WorkspaceDashboardScreenState();
}

class _WorkspaceDashboardScreenState
    extends State<WorkspaceDashboardScreen> {
  // Mock spaces — will be replaced when Spaces API is ready
  final List<_SpaceModel> _spaces = [
    _SpaceModel(
      name: 'Design',
      description: 'UI/UX design tasks and assets',
      icon: '🎨',
      color: const Color(0xFF6C4AB6),
      totalTasks: 12,
      completedTasks: 8,
      noteCount: 5,
    ),
    _SpaceModel(
      name: 'Development',
      description: 'Backend & frontend development',
      icon: '💻',
      color: const Color(0xFF1D9E75),
      totalTasks: 20,
      completedTasks: 14,
      noteCount: 3,
    ),
    _SpaceModel(
      name: 'Marketing',
      description: 'Campaigns and content strategy',
      icon: '📊',
      color: const Color(0xFF4A90E2),
      totalTasks: 8,
      completedTasks: 2,
      noteCount: 7,
    ),
  ];

  // ── Computed stats ──
  int get _totalTasks => _spaces.fold(0, (s, sp) => s + sp.totalTasks);
  int get _completedTasks =>
      _spaces.fold(0, (s, sp) => s + sp.completedTasks);
  double get _productivityScore =>
      _totalTasks == 0 ? 0 : (_completedTasks / _totalTasks) * 100;

  void _addSpace(dynamic data) {
  final space = _SpaceModel(
    name: data['name'],
    description: data['description'],
    icon: data['icon'],
    color: data['color'],
    visibility: data['visibility'],
    totalTasks: data['totalTasks'],
    completedTasks: data['completedTasks'],
    noteCount: data['noteCount'],
  );
  setState(() => _spaces.add(space));
}

  void _updateSpace(
      _SpaceModel space, String name, String desc, String icon, Color color) {
    setState(() {
      space.name = name;
      space.description = desc;
      space.icon = icon;
      space.color = color;
    });
  }

  void _confirmDeleteSpace(_SpaceModel space) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.radiusCard)),
        backgroundColor: AppColors.white,
        title: Text('Delete Space?',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        content: Text('"${space.name}" will be permanently deleted.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textMuted, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(),
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(d).pop();
              setState(() => _spaces.remove(space));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppValues.radiusSm)),
              child: Text('Delete',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CreateSpaceSheet(onCreated: _addSpace),
    );
  }

  void _openEditSheet(_SpaceModel space) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => EditSpaceSheet(
        space: space,
        onSaved: (n, d, i, c) => _updateSpace(space, n, d, i, c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -50, right: -30,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.14),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 200, left: -60,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.gradientBlue.withOpacity(0.1),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: DashboardHeader(
                    workspaceName: widget.workspaceName,
                    workspaceDescription: widget.workspaceDescription,
                    numberOfMembers: widget.numberOfMembers,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppValues.horizontalPadding, 0,
                        AppValues.horizontalPadding, 20),
                    child: ManageMembersButton(
                      onTap: () => context.push(
                        RouteNames.members,
                        extra: {
                          'workspaceId': widget.workspaceId,
                          'workspaceName': widget.workspaceName,
                          'isCurrentUserOwner': widget.isCurrentUserOwner,
                        },
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding),
                    child: StatsGrid(
                      totalTasks: _totalTasks,
                      activeSpaces: _spaces.length,
                      productivityScore: _productivityScore,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppValues.horizontalPadding, 24,
                        AppValues.horizontalPadding, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4, height: 20,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Spaces',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                                letterSpacing: -0.3)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppValues.radiusSm - 2),
                          ),
                          child: Text('${_spaces.length}',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_spaces.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptySpaces(onCreateTap: _openCreateSheet),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.horizontalPadding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SpaceCard(
                            space: _spaces[i],
                            onEdit: () => _openEditSheet(_spaces[i]),
                            onDelete: () => _confirmDeleteSpace(_spaces[i]),
                          ),
                        ),
                        childCount: _spaces.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AddSpaceFAB(onTap: _openCreateSheet),
    );
  }
}