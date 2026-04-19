import 'package:flutter/material.dart';
import '../data/models/space_icon.dart';

class SpaceIconMapper {
  SpaceIconMapper._();

  static const List<SpaceIcon> icons = [
    SpaceIcon(code: 'home',        icon: Icons.home_rounded,          label: 'Home'),
    SpaceIcon(code: 'star',        icon: Icons.star_rounded,          label: 'Star'),
    SpaceIcon(code: 'work',        icon: Icons.work_rounded,          label: 'Work'),
    SpaceIcon(code: 'code',        icon: Icons.code_rounded,          label: 'Code'),
    SpaceIcon(code: 'design',      icon: Icons.palette_rounded,       label: 'Design'),
    SpaceIcon(code: 'chart',       icon: Icons.bar_chart_rounded,     label: 'Chart'),
    SpaceIcon(code: 'calendar',    icon: Icons.calendar_today_rounded, label: 'Calendar'),
    SpaceIcon(code: 'people',      icon: Icons.people_rounded,        label: 'People'),
    SpaceIcon(code: 'chat',        icon: Icons.chat_bubble_rounded,   label: 'Chat'),
    SpaceIcon(code: 'docs',        icon: Icons.description_rounded,   label: 'Docs'),
    SpaceIcon(code: 'folder',      icon: Icons.folder_rounded,        label: 'Folder'),
    SpaceIcon(code: 'rocket',      icon: Icons.rocket_launch_rounded, label: 'Rocket'),
    SpaceIcon(code: 'school',      icon: Icons.school_rounded,        label: 'School'),
    SpaceIcon(code: 'finance',     icon: Icons.attach_money_rounded,  label: 'Finance'),
    SpaceIcon(code: 'shopping',    icon: Icons.shopping_bag_rounded,  label: 'Shopping'),
    SpaceIcon(code: 'settings',    icon: Icons.settings_rounded,      label: 'Settings'),
    SpaceIcon(code: 'bug',         icon: Icons.bug_report_rounded,    label: 'Bug'),
    SpaceIcon(code: 'flag',        icon: Icons.flag_rounded,          label: 'Flag'),
    SpaceIcon(code: 'globe',       icon: Icons.language_rounded,      label: 'Globe'),
    SpaceIcon(code: 'heart',       icon: Icons.favorite_rounded,      label: 'Heart'),
  ];

  /// من الـ code → IconData (للعرض)
  static IconData getIcon(String code) {
    return icons
        .firstWhere(
          (e) => e.code == code,
      orElse: () => icons.first,
    )
        .icon;
  }

  /// من الـ code → SpaceIcon كامل
  static SpaceIcon? fromCode(String code) {
    try {
      return icons.firstWhere((e) => e.code == code);
    } catch (_) {
      return null;
    }
  }
}