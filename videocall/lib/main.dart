import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/data_center.dart';
import 'pages/first_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataCenter = DataCenter();
  await dataCenter.loadUsers();
  runApp(MyApp(dataCenter: dataCenter));
}

class MyApp extends StatelessWidget {
  final DataCenter dataCenter;

  const MyApp({super.key, required this.dataCenter});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DataCenter>.value(value: dataCenter),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FirstPage(),
      ),
    );
  }
}
