import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// context.go() →
// يمسح الـ stack وينتقل مباشرة  (يُستخدم للشاشات الرئيسية زي Home)
void navigateTo(BuildContext context, String routeName, {Object? extra}) {
  context.go(routeName, extra: extra);
}

// context.push() →
// يضيف شاشة جديدة فوق الـ stack (مثالي للتنقلات داخل التطبيق مثل تفاصيل عنصر).
void pushTo(BuildContext context, String routeName, {Object? extra}) {
  context.push(routeName, extra: extra);
}

void pop(BuildContext context) {
  context.pop();
}
