import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;
Future<void> initServiceLocator() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: serviceLocator()));
}
