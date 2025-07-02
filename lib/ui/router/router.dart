import 'package:bc_phthalmoscopy/ui/pages/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => HomePage())],
);
