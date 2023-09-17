import 'package:accustox/enumerated_values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers.dart';
import 'models.dart';

final initialRouteProvider = FutureProvider<String>((ref) async {
  return appController.getInitialRoute();
});

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());

final StreamProvider<User?> _userProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final StreamProvider<User?> userStateProvider = StreamProvider<User?>((ref) {
  ref.watch(_userProvider);
  return userController.streamAuthStateChanges();
});

final StreamProvider<UserProfile> userProfileProvider =
    StreamProvider<UserProfile>((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return userController.streamUserProfile(uid: uid);
});

StreamProvider<List<Salesperson>> salespersonListStreamProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return userController.streamSalespersonList(uid: uid);
});

final asyncCategoryFilterListProvider = AsyncNotifierProvider<
    AsyncCategoryFilterListNotifier, List<CategoryFilter>>(() {
  return AsyncCategoryFilterListNotifier();
});

final categoryIDProvider = StateNotifierProvider<CategoryIDNotifier, String?>(
  (ref) => CategoryIDNotifier(),
);

final streamItemsListByCategoryFilterProvider =
    StreamProvider.autoDispose<List<Item>>((ref) {
  ref.watch(_userProvider);
  final user = ref.watch(userProfileProvider);
  String? uid = user.asData!.value.uid;
  var categoryID = ref.watch(categoryIDProvider);

  if (categoryID == 'All') {
    // Return the unfiltered list of items
    var list = itemController.streamItemDataList(uid: uid);
    return list;
  } else {
    // Return the filtered list of items by categoryID
    var list = itemController.getFilteredItemsStreamByCategory(
        uid: uid, categoryID: categoryID!);
    return list;
  }
});

StreamProvider<List<Category>> streamCategoryListProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return categoryController.streamCategoryDataList(uid: uid);
});

final inventoryLocationTypeProvider = StateProvider<InventoryLocationType>(
  (ref) => InventoryLocationType.warehouse,
);

StreamProvider<List<StockLocation>> streamLocationListProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return stockLocationController.streamParentLocationDataList(uid: uid);
});

final streamSubLocationListProvider =
    StreamProvider.autoDispose.family<List<StockLocation>, String>((ref, path) {
  return stockLocationController.streamSubLocationDataList(path: path);
});
