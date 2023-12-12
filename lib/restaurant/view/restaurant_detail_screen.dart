import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card_widget.dart';
import 'package:actual/restaurant/component/restaurant_card_widget.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
    // final dio = ref.watch(dioProvider);
    // // 이 반환받은 dio는 맨 처음 프로젝트가 실행할때 한번 생성된 커스텀한 dio 인스턴스이다.
    // final repository =
    //     RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    // // RestaurantDetailModel 이라는 모델로 맵핑이 돼가지고 결과값이 응답이 올거다.
    // // 어떻게? .g.dart 파일에서 맵핑하는 로직이 있기 때문에
    // // 그래서 이렇게 하면 된다.
    // return repository.getRestaurantDetail(id: id);
    return ref.watch(restaurantRepositoryProvider).getRestaurantDetail(
          id: id,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(ref),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            // Handle the error state
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // final item = RestaurantDetailModel.fromJson(json: snapshot.data!);
          // retrofit 사용함으로써 이제 snapshot.data에서 맵핑된 데이터가 나오기때문에 필요 x
          // final item = RestaurantDetailModel.fromJson(snapshot.data!);

          return CustomScrollView(
            // 슬리버를 넣을 수도 있고 일반 위젯을 넣을 수도 있는데 일반 위젯을 넣으려면
            // SliverToBoxAdapter() 를 넣어야 한다.
            slivers: [
              renderTop(model: snapshot.data!),
              renderLable(),
              renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
        // image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
        // name: '불타는 떡볶이',
        // tags: const ["떡볶이", "맛있음", "치즈"],
        // ratingsCount: 100,
        // deliveryTime: 30,
        // deliveryFee: 3000,
        // ratings: 4.76,
        // isDetail: true,
        // detail: '맛있는 떡볶이',
      ),
    );
  }

  SliverPadding renderLable() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          "메뉴",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 48.0,
      ),
      sliver: SliverList(
        // SliverList 위젯에 패딩을 줄때는 SliverPadding을 사용한다.
        delegate: SliverChildBuilderDelegate(
          // SliverChildBuilderDelegate : 리스트의 아이템 갯수만큼 위젯을 동적으로 생성
          // 스크롤 성능 최적화
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
          childCount: products.length,
          // childCount: 10, // 왜 에러가 나지?
        ),
      ),
    );
  }
}
