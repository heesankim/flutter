import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/component/restaurant_card_widget.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  // futureBuilder를 쓰려면 future함수가 필요하다.

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(
      scrollListener,
    );
  }

  void scrollListener() {
    print("스크롤중~~~");
    // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면 새로운 데이터를 추가 요청 한다.
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      print("추가로 데이터 가져옴");
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);
    // if (data.length == 0) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    // 진짜 로딩중일때;
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text('Error: ${data.message}'),
      );
    }

    // CursorPagination
    // CursorPaginationRefetching
    // CursorPaginationFetchingMore
    // CursorPaginationError
    // CursorPaginationLoading

    final cp = data as CursorPagination;

    // return Container(
    // child: Center(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     child: FutureBuilder<CursorPagination<RestaurantModel>>(
    //       // future 함수를 그릴 때 사용한다.
    //       future: ref.watch(restaurantRepositoryProvider).paginate(),
    //       builder: (context,
    //           AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
    //         if (snapshot.hasError) {
    //           // 에러 발생시 에러 메시지를 보여준다.
    //           return Center(
    //             child: Text('Error: ${snapshot.error}'),
    //           );
    //         }

    //         if (!snapshot.hasData) {
    //           return const Center(
    //             // 데이터가 로드 될때까지 indicator를 보여준다.
    //             child: CircularProgressIndicator(),
    //           );
    //         }

    //         // ListView.builder -> 항목의 수가 무한하거나, 실제 항목의 수를 알 수 없을때 유용함
    //         // 각 항목이 화면에 표시될 때만 위젯을 생성함으로써 메모리를 효율적으로 사용
    //         return ListView.separated(
    //           // ListView.builder 기능의 확장
    //           // separated는 항목과 항목 사이에 위젯(ex.구분선)을 삽입할 수 있다.
    //           // snapshot.data 에는 List 가 들어있는데 이걸 리스트뷰로 구현하려면
    //           // 몇개의 item이 있는지 넣어주면, 몇개의 아이템을 렌더링 할지 결정할 수 있다.
    //           // 각각 렌더링 할 때마다 각 순서에 해당이 되는 아이템을 넣어준다.
    //           itemCount: snapshot.data!.data.length,
    //           itemBuilder: (_, index) {
    //             // final Map<String, dynamic> item = snapshot.data![index];
    //             // 이렇게 하지 않고
    //             final pItem = snapshot.data!.data[index];
    //             // Why? Dart에서는 타입 추론이 가능. -> 명시적 선언 굳이 필요x
    //             // and snapshot.data와 같이 FutureBuilder 또는 StreamBuilder와 같은 일부 비동기 데이터 소스에서 오는 경우
    //             // 타입이 Map<String, Dynamic>임을 추론하기 때문에 명시적으로 안해줘도 됨

    //             // parsed
    //             // 데이터를 가져와서 무조건 클래스의 인스턴스로 변환을 해야지만,
    //             // 자동완성이랑 실수를 줄일 수 있다.
    //             // 하지만 반복적인 작업을 줄여보자...

    //             // 원래는 인스턴스화 해서 아이템에 해당하는 데이터들을 전부 맵핑해줬어야 했는데
    //             // 이 과정을 모델 클래스의 factory Constructor 에다가 정의를 했다. ->
    //             //fromJson 사용

    //             // 데이터 모델링을 해놓으면 데이터를 사용하는 스크린에서 반복적인 작업을 할 필요x

    //             // final pItem = RestaurantModel(
    //             //   id: item['id'],
    //             //   name: item['name'],
    //             //   thumbUrl: "http://$ip${item['thumbUrl']}",
    //             //   tags: List<String>.from(item['tags']),
    //             //   priceRange: RestaurantPriceRange.values.firstWhere(
    //             //     (e) => e.name == item['priceRange'],
    //             //   ),
    //             //   ratings: item['ratings'],
    //             //   ratingsCount: item['ratingsCount'],
    //             //   delieveryTime: item['deliveryTime'],
    //             //   deliveryFee: item['deliveryFee'],
    //             // );

    //             return GestureDetector(
    //               onTap: () {
    //                 Navigator.of(context).push(
    //                   MaterialPageRoute(
    //                     builder: (_) => RestaurantDetailScreen(
    //                       id: pItem.id,
    //                     ),
    //                   ),
    //                 );
    //               },
    //               child: RestaurantCard.fromModel(
    //                 // 모델링이 된 RestaurantCard를 리턴해준다.
    //                 model: pItem,
    //               ),
    //             );
    //           },
    //           // separatorBuilder는 각각의 아이템 사이에 들어가는 것을 빌드해주는 방법
    //           separatorBuilder: (_, index) {
    //             // 콜백함수로 index 사이사이에 위젯이나, 함수를 넣을 수 있다.
    //             return const SizedBox(
    //               height: 16.0,
    //             );
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // ),

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemBuilder: (_, index) {
          final pItem = cp.data[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: pItem.id,
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: pItem,
            ),
          );
        },
        separatorBuilder: (_, index) => const SizedBox(
          height: 16.0,
        ),
        itemCount: cp.data.length,
      ),
    );
  }
}
