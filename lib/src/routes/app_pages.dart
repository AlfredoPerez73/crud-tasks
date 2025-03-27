import 'package:get/get.dart';
import '../presentation/pages/todo_list_page.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const TodoListPage(),
    ),
  ];
}
