import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jasaku/features/home/data/repositories/home_repository_impl.dart';
import 'package:jasaku/features/home/domain/entities/service_entity.dart';

final serviceListProvider = FutureProvider<List<ServiceEntity>>((ref) async {
  final result = await ref.read(homeUsecaseProvider).getServices();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (services) => services,
  );
});
