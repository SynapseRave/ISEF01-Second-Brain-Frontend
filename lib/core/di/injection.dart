import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/di/injection.config.dart';

/// Globale GetIt-Instanz — einzige Stelle, über die Abhängigkeiten
/// angefragt werden. Greife nie direkt auf `GetIt.instance` zu,
/// sondern immer über [sl] oder [ServiceLocator].
final GetIt sl = GetIt.instance;

/// Initialisiert den DI-Container.
///
/// Muss einmalig in [main] aufgerufen werden, bevor [runApp] gestartet wird:
/// ```dart
/// await configureDependencies();
/// runApp(SecondBrainApp(...));
/// ```
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => sl.init();

/// Typsicherer Wrapper um [GetIt].
///
/// Statt `sl<MyService>()` kann auch `ServiceLocator.get<MyService>()` genutzt
/// werden — lesbarer in komplexen Ausdrücken.
abstract final class ServiceLocator {
  static T get<T extends Object>() => sl<T>();
}
