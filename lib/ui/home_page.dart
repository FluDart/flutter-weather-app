import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherflut/data/repository/api_repository.dart';
import 'package:weatherflut/data/repository/store_repository.dart';
import 'package:weatherflut/ui/cities/cities_page.dart';
import 'package:weatherflut/ui/common/loader_widget.dart';
import 'package:weatherflut/ui/home/empty_widget.dart';
import 'package:weatherflut/ui/home/weathers_widget.dart';
import 'package:weatherflut/ui/home_bloc.dart';
import 'package:weatherflut/ui/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeBloc bloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      bloc.loadCities();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    bloc = HomeBloc(
      apiService: context.read<ApiRepository>(),
      storage: context.read<StoreRepository>(),
    );
    bloc.loadCities();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void handleNavigateToCities(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CitiesPage()),
    );
    bloc.loadCities();
  }

  void handleNavigateToSettings(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage()),
    );
    bloc.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bloc,
      builder: (context, child) {
        return Scaffold(
          body: bloc.cities.isEmpty
              ? bloc.loading
                  ? Center(child: LoaderWidget())
                  : EmptyWidget(
                      onTap: () => handleNavigateToCities(context),
                    )
              : WeathersWidget(
                  cities: bloc.cities,
                  settings: bloc.settings,
                  onTap: () => handleNavigateToCities(context),
                  onSetting: () => handleNavigateToSettings(context),
                ),
        );
      },
    );
  }
}
