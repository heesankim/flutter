import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key,
  }) : super(key: key);

  // 데이터를 받아와서 모델링해서 현재 이 위젯에 뿌린다.
  // 데이터 모델링은 Model 클래스에서 되고 있다.
  factory ProductCard.fromModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      // IntrinsicHeight -> 자식들의 높이를 최대로 맞춰준다.
      // Row안에 Column이 있을때 Column의 높이를 최대로 맞춰준다.
      // IntrinsicWidth -> 자식들의 너비를 최대로 맞춰준다.
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          const SizedBox(width: 16.0),
          Expanded(
              // 왜 전체를 차지 못하는가?
              // Row 컴포넌트 안에다가 즉, children안의 값들은 각각의 고유의 높이를 갖게된다.
              // 위젯의 기본값이다.
              // 그래서 이미지를 보여주고 있는 부분이 더 높은 크기를 차지하고 있다 해도
              // 나머지 부분들은 각각 위젯에 알맞는 사이즈를 차지하게 된다.
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                detail,
                overflow: TextOverflow.ellipsis,
                // ...으로 표시
                maxLines: 2,
                style: const TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                  // fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "₩$price",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
