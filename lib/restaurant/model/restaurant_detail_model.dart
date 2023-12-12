import 'package:actual/common/utils/data_utils.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

// 어노테이션
@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  // @JsonSerializable() 하는데, 클래스의 속성중에 클래스가 있다면 그 클래스안에 속성도
  // fromjson 메소드가 필요하다.
  final List<RestaurantProductModel> products;
  // 이렇게 할 수도 있지만 맵을 사용해가지고 키값이 뭔지 모르는 문제가 생김.
  // final List<Map<String, dynamic>> products;
  // 그래서 products에 해당하는 모델을 만듦
  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RestaurantDetailModelFromJson(json);

  // 이 과정을 jsonSerializable이 해준다.
  // factory RestaurantDetailModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantDetailModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: "http://$ip${json['thumbUrl']}",
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere(
  //       (e) => e.name == json['priceRange'],
  //     ),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //     detail: json['detail'],
  //     products: json['products']
  //         // 제너릭을 넣어주지 않으면 다이나믹 타입이 자동으로 들어간걸로 가정이된다.
  //         // 그래서 타입을 넣어서 매핑해준다.
  //         .map<RestaurantProductModel>(
  //           (x) => RestaurantProductModel.fromJson(
  //             json: x,
  //           ),
  //         )
  //         // 꼭 리스트로 반환해줘야 한다.
  //         .toList(),
  //   );
  // }
}

@JsonSerializable()
// @JsonSerializable() 하는데, 클래스의 속성중에 클래스가 있다면 그 클래스안에 속성도
// fromjson 메소드가 필요하다. -> 반드시 까먹지 말자.
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RestaurantProductModelFromJson(json);
  // factory RestaurantProductModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantProductModel(
  //     id: json['id'],
  //     name: json['name'],
  //     imgUrl: "http://$ip${json['imgUrl']}",
  //     detail: json['detail'],
  //     price: json['price'],
  //   );
  // }
}
