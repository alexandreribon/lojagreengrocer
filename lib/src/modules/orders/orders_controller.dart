import 'package:get/get.dart';
import 'package:greengrocer/src/core/mixins/loader_mixin.dart';
import 'package:greengrocer/src/core/services/auth_service.dart';
import 'package:greengrocer/src/core/services/utils_service.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/repositories/orders/orders_repository.dart';

class OrdersController extends GetxController with LoaderMixin {
  final OrdersRepository _ordersRepository;
  final AuthService _authService;
  final UtilsService _utilsService;

  OrdersController({
    required OrdersRepository ordersRepository,
    required AuthService authService,
    required UtilsService utilsService,
  })  : _ordersRepository = ordersRepository,
        _authService = authService,
        _utilsService = utilsService;

  final _isLoading = false.obs;
  final _orders = <OrderModel>[].obs;

  @override
  void onInit() {
    loaderListener(_isLoading);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getAllOrders();
  }

  List<OrderModel> get orders => _orders;

  Future<void> getAllOrders() async {
    _isLoading(true);

    var result = await _ordersRepository.getAllOrders(
      token: _authService.user!.token!,
      userId: _authService.user!.id!,
    );

    //await 600.milliseconds.delay();

    _isLoading(false);

    result.when(
      success: (data) {
        _orders.assignAll(
          data..sort(((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!))),
        );
      },
      error: (message) {
        _utilsService.showToast(message: message, isError: true);
      },
    );
  }
}
