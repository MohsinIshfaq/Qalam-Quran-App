import 'package:get/get.dart';

import '../../features/mushaf/data/datasources/mushaf_local_storage.dart';
import '../../features/mushaf/data/repositories/mushaf_repository_impl.dart';
import '../../features/mushaf/domain/repositories/mushaf_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MushafLocalStorage>(MushafLocalStorage.new, fenix: true);
    Get.lazyPut<MushafRepository>(
      () => MushafRepositoryImpl(Get.find<MushafLocalStorage>()),
      fenix: true,
    );
  }
}
