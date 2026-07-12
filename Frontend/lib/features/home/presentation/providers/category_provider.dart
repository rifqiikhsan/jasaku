import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jasaku/features/home/data/repositories/home_repository_impl.dart';
import '../../domain/entities/category_entity.dart';

final categoryListProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final result = await ref.read(homeUsecaseProvider).getCategory();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
});
