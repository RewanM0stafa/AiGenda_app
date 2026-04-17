// lib/core/utils/icon_mapper.dart

class WorkspaceEmoji {
  final String emoji;
  final String code;
  final String label;

  const WorkspaceEmoji({
    required this.emoji,
    required this.code,
    required this.label,
  });
}

class IconMapper {
  // ── كل الـ emojis المتاحة مع كود فريد لكل واحدة ──
  static const List<WorkspaceEmoji> all = [
    // Work & Business
    WorkspaceEmoji(emoji: '💼', code: 'E001', label: 'Briefcase'),
    WorkspaceEmoji(emoji: '🚀', code: 'E002', label: 'Rocket'),
    WorkspaceEmoji(emoji: '🎯', code: 'E003', label: 'Target'),
    WorkspaceEmoji(emoji: '📊', code: 'E004', label: 'Chart'),
    WorkspaceEmoji(emoji: '💡', code: 'E005', label: 'Idea'),
    WorkspaceEmoji(emoji: '🏆', code: 'E006', label: 'Trophy'),
    WorkspaceEmoji(emoji: '⚡', code: 'E007', label: 'Lightning'),
    WorkspaceEmoji(emoji: '🔥', code: 'E008', label: 'Fire'),
    WorkspaceEmoji(emoji: '💎', code: 'E009', label: 'Diamond'),
    WorkspaceEmoji(emoji: '🌟', code: 'E010', label: 'Star'),

    // Tech & Code
    WorkspaceEmoji(emoji: '💻', code: 'E011', label: 'Laptop'),
    WorkspaceEmoji(emoji: '🤖', code: 'E012', label: 'Robot'),
    WorkspaceEmoji(emoji: '⚙️', code: 'E013', label: 'Gear'),
    WorkspaceEmoji(emoji: '🔧', code: 'E014', label: 'Wrench'),
    WorkspaceEmoji(emoji: '📱', code: 'E015', label: 'Phone'),
    WorkspaceEmoji(emoji: '🖥️', code: 'E016', label: 'Monitor'),
    WorkspaceEmoji(emoji: '🔬', code: 'E017', label: 'Microscope'),
    WorkspaceEmoji(emoji: '🧬', code: 'E018', label: 'DNA'),
    WorkspaceEmoji(emoji: '🛸', code: 'E019', label: 'UFO'),
    WorkspaceEmoji(emoji: '🌐', code: 'E020', label: 'Globe'),

    // Creative & Art
    WorkspaceEmoji(emoji: '🎨', code: 'E021', label: 'Art'),
    WorkspaceEmoji(emoji: '✏️', code: 'E022', label: 'Pencil'),
    WorkspaceEmoji(emoji: '📸', code: 'E023', label: 'Camera'),
    WorkspaceEmoji(emoji: '🎬', code: 'E024', label: 'Film'),
    WorkspaceEmoji(emoji: '🎵', code: 'E025', label: 'Music'),
    WorkspaceEmoji(emoji: '🎭', code: 'E026', label: 'Theater'),
    WorkspaceEmoji(emoji: '📝', code: 'E027', label: 'Notes'),
    WorkspaceEmoji(emoji: '📚', code: 'E028', label: 'Books'),
    WorkspaceEmoji(emoji: '🖊️', code: 'E029', label: 'Pen'),
    WorkspaceEmoji(emoji: '🗺️', code: 'E030', label: 'Map'),

    // People & Teams
    WorkspaceEmoji(emoji: '👥', code: 'E031', label: 'Team'),
    WorkspaceEmoji(emoji: '🤝', code: 'E032', label: 'Handshake'),
    WorkspaceEmoji(emoji: '👑', code: 'E033', label: 'Crown'),
    WorkspaceEmoji(emoji: '🧠', code: 'E034', label: 'Brain'),
    WorkspaceEmoji(emoji: '💪', code: 'E035', label: 'Strong'),
    WorkspaceEmoji(emoji: '🙌', code: 'E036', label: 'Celebrate'),
    WorkspaceEmoji(emoji: '❤️', code: 'E037', label: 'Heart'),
    WorkspaceEmoji(emoji: '😊', code: 'E038', label: 'Happy'),
    WorkspaceEmoji(emoji: '🌈', code: 'E039', label: 'Rainbow'),
    WorkspaceEmoji(emoji: '🌸', code: 'E040', label: 'Flower'),

    // Nature & Places
    WorkspaceEmoji(emoji: '🏠', code: 'E041', label: 'Home'),
    WorkspaceEmoji(emoji: '🌍', code: 'E042', label: 'Earth'),
    WorkspaceEmoji(emoji: '🏔️', code: 'E043', label: 'Mountain'),
    WorkspaceEmoji(emoji: '🌊', code: 'E044', label: 'Wave'),
    WorkspaceEmoji(emoji: '🌿', code: 'E045', label: 'Plant'),
    WorkspaceEmoji(emoji: '☀️', code: 'E046', label: 'Sun'),
    WorkspaceEmoji(emoji: '🌙', code: 'E047', label: 'Moon'),
    WorkspaceEmoji(emoji: '⭐', code: 'E048', label: 'Star2'),
    WorkspaceEmoji(emoji: '🦋', code: 'E049', label: 'Butterfly'),
    WorkspaceEmoji(emoji: '🐉', code: 'E050', label: 'Dragon'),

    // Tasks & Productivity
    WorkspaceEmoji(emoji: '✅', code: 'E051', label: 'Check'),
    WorkspaceEmoji(emoji: '📋', code: 'E052', label: 'Clipboard'),
    WorkspaceEmoji(emoji: '🗓️', code: 'E053', label: 'Calendar'),
    WorkspaceEmoji(emoji: '⏰', code: 'E054', label: 'Clock'),
    WorkspaceEmoji(emoji: '📌', code: 'E055', label: 'Pin'),
    WorkspaceEmoji(emoji: '🔑', code: 'E056', label: 'Key'),
    WorkspaceEmoji(emoji: '🔒', code: 'E057', label: 'Lock'),
    WorkspaceEmoji(emoji: '📦', code: 'E058', label: 'Box'),
    WorkspaceEmoji(emoji: '🎁', code: 'E059', label: 'Gift'),
    WorkspaceEmoji(emoji: '💰', code: 'E060', label: 'Money'),
  ];

  // ── Backward compatibility مع الكود القديم ──
  static String getCode(String emoji) {
    return all.firstWhere(
      (e) => e.emoji == emoji,
      orElse: () => all.first,
    ).code;
  }

  static String getEmoji(String code) {
    return all.firstWhere(
      (e) => e.code == code,
      orElse: () => all.first,
    ).emoji;
  }

  // ── للتوافق مع الكود القديم اللي بيستخدم IconData ──
  static String getCodeFromIndex(int index) {
    if (index < 0 || index >= all.length) return all.first.code;
    return all[index].code;
  }
}