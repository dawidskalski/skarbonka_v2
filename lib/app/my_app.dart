import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skarbonka_v2/app/cubit/root_cubit.dart';
import 'package:skarbonka_v2/app/features/home/home_page.dart';
import 'package:skarbonka_v2/app/features/login/login_page.dart';
import 'package:skarbonka_v2/app/my_app/services/theme_services.dart';
import 'package:skarbonka_v2/app/my_app/themes/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void main() {}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().getTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl'), // English
      ],
      home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RootCubit()..start(),
      child: BlocBuilder<RootCubit, RootState>(
        builder: (context, state) {
          final user = state.user;
          //Logowanie
          if (user == null) {
            return LoginPage();
          }

          //Jesteś zalogowany
          return HomePage(user: user);
        },
      ),
    );
  }
}
