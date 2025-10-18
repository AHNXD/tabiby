import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tabiby/features/user_app/home/presentation/view/home_screen.dart';
import 'core/locale/locale_cubit.dart';
import 'core/utils/app_localizations.dart';
import 'core/utils/cache_helper.dart';
import 'core/utils/colors.dart';
import 'core/utils/constats.dart';
import 'core/utils/functions.dart';
import 'core/utils/routs.dart';
import 'core/utils/services_locater.dart';
import 'core/utils/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocatorServices();
  enableScreenshot();
  // await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()..getSaveLanguage()),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            locale: state.locale,
            // locale: Locale("ar"),
            supportedLocales: const [Locale("en"), Locale("ar")],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocal, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocal != null &&
                    deviceLocal.languageCode == locale.languageCode) {
                  return deviceLocal;
                }
              }
              return supportedLocales.first;
            },
            title: 'Tabiby',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.backgroundColor,
                scrolledUnderElevation: 0,
                centerTitle: true,
                elevation: 0,
                titleTextStyle: Styles.textStyle18.copyWith(
                  color: AppColors.backgroundColor,
                ),
              ),
              fontFamily: "cocon-next-arabic",
              scaffoldBackgroundColor: AppColors.backgroundColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColors,
              ),
              useMaterial3: true,
            ),
            initialRoute: HomeScreen.routeName,
            routes: Routes.routes,
          );
        },
      ),
    );
  }
}
