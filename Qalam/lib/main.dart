import 'package:flutter/material.dart';

import 'app/qalam_app.dart';
import 'features/mushaf/data/datasources/mushaf_local_storage.dart';
import 'features/mushaf/data/repositories/mushaf_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    QalamApp(mushafRepository: MushafRepositoryImpl(MushafLocalStorage())),
  );
}
