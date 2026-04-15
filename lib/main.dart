import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'config/dependency_injection.dart';
import 'config/routes/app_routers.dart';
import 'core/constants/app_text_styles.dart';
import 'core/constants/app_values.dart';
import 'core/constants/app_widget_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: AppColors.white,
      ),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.horizontalPadding,
            vertical: AppValues.verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMainProgressCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('WorkSpaces', '6'),
              const SizedBox(height: 16),
              _buildWorkspacesList(),
              const SizedBox(height: 24),
              _buildSectionTitle('Overview', ''),
              const SizedBox(height: 16),
              _buildOverviewList(),
              const SizedBox(height: 24),
              _buildSectionTitle('Today\'s Tasks', ''),
              // هنا يمكن إضافة الـ Date Selector والـ Filter Chips
            ],
          ),
        ),
      ),
    );
  }

  // 1. Header (Profile, Greeting, Icons)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ), // استبدليها بصورة المستخدم
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text('Livia Vaccaro', style: AppTextStyles.headlineMedium),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(Icons.search_rounded),
            const SizedBox(width: 12),
            _buildIconButton(Icons.notifications_none_rounded),
          ],
        ),
      ],
    );
  }

  // أيقونات الهيدر
  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: AppWidgetStyles.socialButton.copyWith(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppValues.radiusIcon),
      ),
      child: Icon(icon, color: AppColors.primary, size: AppValues.iconSize),
    );
  }

  // 2. Main Progress Card (الفيجما: الكارت البنفسجي الكبير)
  Widget _buildMainProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.cardPadding),
      decoration:
          AppWidgetStyles.gradientButton, // استخدام الـ Gradient الخاص بكِ
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your today\'s task\nalmost done!',
                  style: AppTextStyles.authCardTitle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppValues.radiusLg),
                  ),
                  child: Text(
                    'View Task',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // هنا يمكن استخدام حزمة مثل percent_indicator لرسم الدائرة
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 6,
              ),
            ),
            child: Center(
              child: Text(
                '85%',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Section Title Builder (لعناوين الأقسام زي WorkSpaces و Overview)
  Widget _buildSectionTitle(String title, String count) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.gradientPurple, // نفس لون الفيجما
            fontSize: 22,
          ),
        ),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              count,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // 4. Horizontal Workspaces List
  Widget _buildWorkspacesList() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: AppWidgetStyles.regularCard.copyWith(
              color: index == 0 ? AppColors.white : AppColors.cardBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Office Project', style: AppTextStyles.bodySmall),
                    Icon(
                      Icons.work_outline,
                      color: AppColors.instructionPink,
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  'Grocery shopping\napp design',
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                ),
                // Custom Progress Bar
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: AppColors.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.gradientBlue,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 5. Vertical Overview List
  Widget _buildOverviewList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: AppWidgetStyles.regularCard,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.instructionPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.work, color: AppColors.instructionPink),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Office Project', style: AppTextStyles.titleMedium),
                    Text('23 Tasks', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Text(
                '70%',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.instructionPink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
