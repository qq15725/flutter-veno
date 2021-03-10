import 'package:veno/veno.dart';
import 'widgets/pages/home_page.dart';

VenoRouter router = VenoRouter(routes: [
  VenoRoute(
    path: '/',
    builder: (_, __, ___) => HomePage(title: 'Hello Veno'),
  ),
]);
