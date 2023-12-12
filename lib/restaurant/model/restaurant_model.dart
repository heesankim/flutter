import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

// 데이터 모델링 자동화
@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
      // ignore: avoid_single_cascade_in_expression_statements
      fromJson: DataUtils.pathToUrl
      // toJson: ,
      )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  // @JsonSerializable() 을 사용하면 이러한 맵핑을 다 해준다.

  // Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // factory Constructor 사용해 json 형식으로 오는 데이터를 맵핑함.
  // 여기서 더 편하게 하기 위해 jsonSerializable을 사용해서 자동으로 맵핑되게 함.
  factory RestaurantModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RestaurantModelFromJson(json);
  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: "http://$ip ${json['thumbUrl']}",
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere(
  //       (e) => e.name == json['priceRange'],
  //     ),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //   );
  // }
}
