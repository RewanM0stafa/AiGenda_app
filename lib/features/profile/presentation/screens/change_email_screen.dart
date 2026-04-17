// // presentation/screens/change_email_screen.dart
// // ملف جديد — نفس اللوجيك القديم من edit_profile_screen

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../auth/presentation/widgets/auth_helpers.dart';
// import '../../logic/profile_cubit/profile_cubit.dart';
// import '../../logic/profile_cubit/profile_state.dart';
// import '../profile_widgets/shared_profile_widgets.dart';

// class ChangeEmailScreen extends StatefulWidget {
//   const ChangeEmailScreen({super.key});

//   @override
//   State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
// }

// class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
//   final _newEmailCtrl  = TextEditingController();
//   final _emailCodeCtrl = TextEditingController();

//   bool _isEmailStep2      = false;
//   bool _isSendingEmail    = false;
//   bool _isConfirmingEmail = false;
//   String? _emailError;
//   String? _emailSuccess;

//   @override
//   void dispose() {
//     _newEmailCtrl.dispose();
//     _emailCodeCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _handleRequestEmailChange() async {
//     final newEmail = _newEmailCtrl.text.trim();
//     if (!newEmail.contains('@')) {
//       setState(() => _emailError = 'Enter a valid email.');
//       return;
//     }
//     setState(() {
//       _isSendingEmail = true;
//       _emailError     = null;
//       _emailSuccess   = null;
//     });
//     await context.read<ProfileCubit>().changeEmail(newEmail: newEmail);
//     if (mounted) setState(() => _isSendingEmail = false);
//   }

//   Future<void> _handleConfirmEmailChange() async {
//     final code = _emailCodeCtrl.text.replaceAll(RegExp(r'\s+'), '').trim();
//     if (code.isEmpty) {
//       setState(() => _emailError = 'Enter the verification code.');
//       return;
//     }
//     setState(() {
//       _isConfirmingEmail = true;
//       _emailError        = null;
//       _emailSuccess      = null;
//     });

//     final id = context.read<ProfileCubit>().currentProfile?.id ?? '';

//     await context.read<ProfileCubit>().confirmChangeEmail(
//       id:       id,
//       newEmail: _newEmailCtrl.text.trim().toLowerCase(),
//       code:     code,
//     );
//     if (mounted) setState(() => _isConfirmingEmail = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profile = context.read<ProfileCubit>().currentProfile;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F3FF),
//       body: BlocConsumer<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ChangeEmailSuccess) {
//             setState(() {
//               _isEmailStep2 = true;
//               _emailSuccess = 'Code sent! Check your new email.';
//               _emailError   = null;
//             });
//           }
//           if (state is ChangeEmailFailure) {
//             setState(() => _emailError = state.errMessage);
//           }
//           if (state is ConfirmChangeEmailSuccess) {
//             setState(() {
//               _isEmailStep2 = false;
//               _emailSuccess = 'Email changed successfully!';
//               _newEmailCtrl.clear();
//               _emailCodeCtrl.clear();
//               _emailError   = null;
//             });
//             // رجع للبروفايل بعد ثانية
//             Future.delayed(const Duration(seconds: 1), () {
//               if (mounted) context.pop();
//             });
//           }
//           if (state is ConfirmChangeEmailFailure) {
//             setState(() => _emailError = state.errMessage);
//           }
//         },
//         builder: (context, state) {
//           return SafeArea(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   // ── Top Bar ──
//                   Row(
//                     children: [
//                       GestureDetector(
//                           onTap: () => context.pop(), child: backBtn()),
//                       const SizedBox(width: 14),
//                       Text('Change Email',
//                           style: GoogleFonts.poppins(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               color: const Color(0xFF1E0F5C))),
//                     ],
//                   ),
//                   const SizedBox(height: 32),

//                   // ── Icon ──
//                   Center(
//                     child: Container(
//                       width: 80, height: 80,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF6C3FC8).withOpacity(0.35),
//                             blurRadius: 20,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(Icons.alternate_email_rounded,
//                           color: Colors.white, size: 34),
//                     ),
//                   ),
//                   const SizedBox(height: 28),

//                   // ── Card ──
//                   SectionCard(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         sectionTitle('Change Email'),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Current: ${profile?.email ?? ''}',
//                           style: GoogleFonts.poppins(
//                               fontSize: 11,
//                               color: const Color(0xFF8A84A3)),
//                         ),
//                         const SizedBox(height: 16),

//                         if (_emailError != null) ...[
//                           InfoBanner(message: _emailError!, isError: true),
//                           const SizedBox(height: 14),
//                         ],
//                         if (_emailSuccess != null) ...[
//                           InfoBanner(message: _emailSuccess!, isError: false),
//                           const SizedBox(height: 14),
//                         ],

//                         // Step 1 — New Email
//                         _buildField(
//                           label: 'New Email Address',
//                           controller: _newEmailCtrl,
//                           hint: 'new@example.com',
//                           icon: Icons.email_outlined,
//                           keyboardType: TextInputType.emailAddress,
//                           enabled: !_isEmailStep2,
//                         ),
//                         const SizedBox(height: 14),

//                         if (!_isEmailStep2)
//                           ProfileGradientButton(
//                             label: 'Send Verification Code',
//                             isLoading: _isSendingEmail ||
//                                 state is ChangeEmailLoading,
//                             onTap: _handleRequestEmailChange,
//                           )
//                         else ...[
//                           // Step 2 — Code
//                           _buildField(
//                             label: 'Verification Code',
//                             controller: _emailCodeCtrl,
//                             hint: 'Paste code from your new email',
//                             icon: Icons.pin_outlined,
//                             keyboardType: TextInputType.number,
//                           ),
//                           const SizedBox(height: 14),
//                           ProfileGradientButton(
//                             label: 'Confirm Email Change',
//                             isLoading: _isConfirmingEmail ||
//                                 state is ConfirmChangeEmailLoading,
//                             onTap: _handleConfirmEmailChange,
//                           ),
//                           const SizedBox(height: 12),
//                           Center(
//                             child: GestureDetector(
//                               onTap: () => setState(() {
//                                 _isEmailStep2 = false;
//                                 _emailError   = null;
//                                 _emailSuccess = null;
//                                 _emailCodeCtrl.clear();
//                               }),
//                               child: Text(
//                                 'Use a different email',
//                                 style: GoogleFonts.poppins(
//                                     fontSize: 12,
//                                     color: const Color(0xFF7C5CBF),
//                                     decoration: TextDecoration.underline,
//                                     decorationColor: const Color(0xFF7C5CBF)),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildField({
//     required String label,
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType? keyboardType,
//     bool enabled = true,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: GoogleFonts.poppins(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF8A84A3))),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           enabled: enabled,
//           style: GoogleFonts.poppins(
//               fontSize: 14, color: const Color(0xFF1E0F5C)),
//           decoration:
//               inputDecoration(hint: hint, icon: icon, enabled: enabled),
//         ),
//       ],
//     );
//   }
// }