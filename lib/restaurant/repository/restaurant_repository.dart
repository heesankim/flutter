import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';

import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  // provider안에서는 watch를 쓰는게 좋다. dio가 변경될리는 없겠지만
  // 만일 변경된다면 다시 build 해야 하기 때문
  final repository = RestaurantRepository(
    dio,
    baseUrl: 'http://$ip/restaurant',
  );

  return repository;
});

// 인스턴스화가 되지 않게 abstarct를 붙여준다.
@RestApi()
abstract class RestaurantRepository {
  // 여러 개의 레포지토리에서 같은 DIO 인스턴스를 공유해야 하는 이유가 있다.
  // 그래서 DIO를 생성자로 받아서 사용한다.그리고 baseUrl을 받아서 사용한다.
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'Content-Type': 'application/json',
    'accessToken': 'true',
  })
  // accessToken을 true라고 전환(없다고표시)만 해놓으면 interceptor에서 알아서
  // onRequest 함수를 통해서 잘 추가 한다.
  // Future<List<RestaurantModel>> paginate();
  Future<CursorPagination<RestaurantModel>> paginate({
    // 첫번째 요청에는 param이 필요없지만 두번째 요청부터는 param이 필요하다.

    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // 반환타입이 저게 아니다. -> 전체를 구성해줘야 한다.

  // http://$ip/restaurant/{id}
  @GET('/{id}')
  @Headers({
    'Content-Type': 'application/json',
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
