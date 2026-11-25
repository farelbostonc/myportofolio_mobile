import 'package:provider/provider.dart';

import 'screens/project_list.dart';
import 'services/api_client.dart';
import 'services/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.apiClient});

  final ApiClient? apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => apiClient ?? ApiClient(),
          dispose: (_, api) => api.close(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthState(context.read<ApiClient>()),
        ),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.amber[700],
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
        routes: {
          ProjectListPage.routeName: (_) => const ProjectListPage(),
          ProjectFormPage.routeName: (_) => const ProjectFormPage(),
          EducationFormPage.routeName: (_) => const EducationFormPage(),
        },
      ),
    );
  }
}
