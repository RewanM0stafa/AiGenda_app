import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// تعريف الألوان للتصميم
const Color kPrimaryColor = Color(0xFF9D64FC);
const Color kBackgroundColor = Colors.white;
const Color kHeaderTextColor = Color(0xFF6A31B8);
const Color kSecondaryTextColor = Colors.grey;
const Color kVerifiedColor = Color(0xFF43D17C);
const Color kGradientStart = Color(0xFFE0C3FC);
const Color kGradientEnd = Color(0xFF8EC5FC);
const Color kShadowColor = Colors.black12;

void main() {
  runApp(const HomeScreen());
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/*

  runApp(const ProfilePageApp());

class ProfilePageApp extends StatelessWidget {
  const ProfilePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page UI',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLightMode = true; // حالة مفتاح تبديل الوضع الفاتح

  @override
  Widget build(BuildContext context) {
    // تحديد حواف الشاشة بشكل مستدير في الأعلى
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileCard(),
                const SizedBox(height: 40),
                _buildSettingsListCard(),
                const SizedBox(height: 100), // مساحة لشريط التنقل السفلي
              ],
            ),
          ),
          _buildEditFloatingButton(), // زر التعديل العائم المتداخل
          _buildBottomNavBar(), // شريط التنقل السفلي المخصص
        ],
      ),
    );
  }

  // بناء شريط التطبيق (AppBar)
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.chevron_left, color: kPrimaryColor, size: 28),
        onPressed: () {
          // التعامل مع الضغط على زر العودة
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Profile',
        style: TextStyle(color: kHeaderTextColor, fontSize: 26, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        _buildElevatedSettingsIcon(), // أيقونة الإعدادات المرتفعة
        const SizedBox(width: 16),
      ],
    );
  }

  // أيقونة إعدادات مرتفعة داخل حاوية مستديرة
  Widget _buildElevatedSettingsIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: kShadowColor, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(CupertinoIcons.gear, color: kPrimaryColor, size: 22),
          ),
        ),
      ),
    );
  }

  // بناء بطاقة الملف الشخصي (الاسم، البريد الإلكتروني، الحالة)
  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: kShadowColor, blurRadius: 15, offset: Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            _buildProfileAvatarWithBadge(), // صورة الملف الشخصي مع الشارة
            const SizedBox(width: 24),
            _buildProfileInfo(), // معلومات النص (الاسم، البريد)
          ],
        ),
      ),
    );
  }

  // صورة ملف شخصي دائري مع شارة صغيرة وشمول صفراء
  Widget _buildProfileAvatarWithBadge() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFD166), width: 3), // حدود صفراء
          ),
          child: const ClipOval(
            child: Icon(CupertinoIcons.person_solid, size: 90, color: kSecondaryTextColor), // Placeholder
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: kShadowColor, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: const Icon(CupertinoIcons.camera_fill, color: Color(0xFF5D5D5D), size: 16), // أيقونة كاميرا صغيرة
        ),
      ],
    );
  }

  // معلومات الملف الشخصي النصية وحالة التحقق
  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '@User-Name',
          style: TextStyle(color: kHeaderTextColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'user@email.com',
          style: TextStyle(color: kSecondaryTextColor, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: kVerifiedColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Verified',
            style: TextStyle(color: kVerifiedColor, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // زر التعديل العائم المتداخل مع بطاقة الملف الشخصي
  Widget _buildEditFloatingButton() {
    return Positioned(
      top: 170, // تعديل الموضع الرأسي لتداخله بشكل صحيح
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kGradientStart, kGradientEnd], // تدرج لزر التعديل
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: kShadowColor, blurRadius: 10, offset: Offset(0, 5)),
              ],
            ),
            child: const Icon(CupertinoIcons.pen, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }

  // بناء بطاقة قائمة الإعدادات (البطاقة الكبيرة في الأسفل)
  Widget _buildSettingsListCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), // حواف مستديرة في الأعلى
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: const [
            BoxShadow(color: kShadowColor, blurRadius: 20, offset: Offset(0, 10)),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSettingsTile(icon: CupertinoIcons.person_solid, title: 'Accounts', subtitle: 'Manage your accounts'),
            _buildSettingsTile(icon: CupertinoIcons.folder_solid, title: 'Language', subtitle: 'You can change the app language'),
            _buildSettingsTile(icon: CupertinoIcons.lock_open_fill, title: 'Screen Lock', subtitle: 'Manage Touch ID or Face ID'),
            _buildLightModeTile(), // مفتاح تبديل الوضع الفاتح
            _buildRateTile(), // نص Rate Algenda
            _buildLogOutTile(), // خروج
            const SizedBox(height: 30),
            _buildPoweredByByteVerse(), // نص "Powered by ByteVerse"
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // عنصر قائمة إعدادات نموذجي (أيقونة، عنوان، وصف فرعي، سهم يمين)
  Widget _buildSettingsTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: _buildSettingIcon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: kSecondaryTextColor, fontSize: 13)),
      trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.grey, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: () {},
    );
  }

  // أيقونة إعدادات مستديرة ناعمة
  Widget _buildSettingIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: kPrimaryColor, size: 20),
    );
  }

  // عنصر قائمة الإعدادات لمفتاح تبديل الوضع الفاتح
  Widget _buildLightModeTile() {
    return ListTile(
      leading: _buildSettingIcon(CupertinoIcons.fader),
      title: const Text('Light Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: const Text('Switch between light & dark mode', style: TextStyle(color: kSecondaryTextColor, fontSize: 13)),
      trailing: _buildGradientSwitch(), // مفتاح التبديل المتدرج
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  // مفتاح تبديل (Switch) عادي مع حاوية خلفية تدرج لمحاكاة التأثير
  Widget _buildGradientSwitch() {
    return Container(
      width: 50,
      height: 30,
      decoration: BoxDecoration(
        gradient: isLightMode
            ? const LinearGradient(colors: [kGradientStart, kGradientEnd]) // تدرج عند التفعيل
            : null,
        color: !isLightMode ? Colors.grey[300] : null, // لون عند الإيقاف
        borderRadius: BorderRadius.circular(15),
      ),
      child: Switch(
        value: isLightMode,
        onChanged: (value) {
          setState(() {
            isLightMode = value;
          });
        },
        activeColor: Colors.transparent, // شفاف لمحاكاة التدرج في الخلفية
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.transparent,
      ),
    );
  }

  // عنصر قائمة الإعدادات لتقييم Algenda
  Widget _buildRateTile() {
    return ListTile(
      leading: _buildSettingIcon(CupertinoIcons.star),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          children: <TextSpan>[
            const TextSpan(text: 'Rate '),
            TextSpan(text: 'Algenda', style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.grey, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: () {},
    );
  }

  // عنصر قائمة الإعدادات للخروج مع زر طاقة إضافي
  Widget _buildLogOutTile() {
    return ListTile(
      leading: _buildSettingIcon(CupertinoIcons.square_arrow_right),
      title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: _buildLogOutPowerIcon(), // أيقونة طاقة مستديرة على اليمين
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: () {},
    );
  }

  // أيقونة طاقة خروج مستديرة ناعمة
  Widget _buildLogOutPowerIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: kShadowColor, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(CupertinoIcons.power, color: kPrimaryColor, size: 20),
          ),
        ),
      ),
    );
  }

  // نص شعار ByteVerse الأرجواني المتدرج في الأسفل
  Widget _buildPoweredByByteVerse() {
    return Column(
      children: [
        const Text(
          'Powered by',
          style: TextStyle(color: kSecondaryTextColor, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(CupertinoIcons.brightness, color: kPrimaryColor, size: 30), // Placeholder شعار
          // يمكنك استبدال Icon بـ Image.asset للشعار الفعلي
        ),
        const SizedBox(height: 6),
        const Text(
          'ByteVerse',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  // بناء شريط التنقل السفلي المخصص مع أيقونة مرتفعة
  Widget _buildBottomNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 90,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(color: kShadowColor, blurRadius: 15, offset: Offset(0, -5)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavBarItem(icon: CupertinoIcons.pie_chart, label: 'Trans.'),
                _buildNavBarItem(icon: CupertinoIcons.list_bullet, label: 'Feeds'),
                _buildNavBarItem(icon: CupertinoIcons.house, label: 'Home'),
                _buildNavBarItem(icon: CupertinoIcons.creditcard, label: 'Wallet'),
                const SizedBox(width: 80), // مساحة للأيقونة المرتفعة
              ],
            ),
          ),
          _buildRaisedProfileNavItem(), // أيقونة الملف الشخصي المرتفعة في الدائرة
        ],
      ),
    );
  }

  // أيقونة شريط التنقل السفلي العادية
  Widget _buildNavBarItem({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kPrimaryColor, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: kPrimaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // أيقونة الملف الشخصي المرتفعة والمسدسة
  Widget _buildRaisedProfileNavItem() {
    return Positioned(
      top: 0, // رفع الدائرة قليلاً فوق شريط التنقل
      right: 32, // تحديد الموضع الأفقي
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: kShadowColor, blurRadius: 10, offset: Offset(0, 5)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(35),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Icon(CupertinoIcons.person_solid, color: kPrimaryColor, size: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 */