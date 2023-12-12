// import 'package:json_annotation/json_annotation.dart';

// part 'cursor_pagination_model.g.dart';

// // 상태를 클래스로 나눈다.
// // 클래스들을 만들어서 상태를 표현할 수 있다.
// abstract class CursorPaginationBase {}

// // 에러가 난 경우
// class CursorPaginationError extends CursorPaginationBase {
//   final String message;

//   CursorPaginationError({
//     required this.message,
//   });
// }

// // 로딩 중인 경우
// class CursorPaginationLoading extends CursorPaginationBase {
//   // 실제 어떤 값이 들어있는지는 아무 상관이 없고,
//   // 이 클래스의 인스턴스인지 아닌지만 확인하면 로딩중인지 아닌지 알 수 있다.
// }

// @JsonSerializable(
//   genericArgumentFactories: true,
// )
// class CursorPagination<T> extends CursorPaginationBase {
//   // extends 하는 거랑 안하는 거랑 같지 않나?
//   // extends 하는 이유는 CursorPaginationBase 를 상속받아서
//   // CursorPaginationBase 타입으로 사용할 수 있게 하기 위해서이다.
//   final CursorPaginationMeta meta;
//   final List<T> data;

//   CursorPagination({
//     required this.meta,
//     required this.data,
//   });

//   // create copywith
//   CursorPagination<T> copyWith({
//     CursorPaginationMeta? meta,
//     List<T>? data,
//   }) {
//     return CursorPagination<T>(
//       meta: meta ?? this.meta,
//       data: data ?? this.data,
//     );
//   }

//   factory CursorPagination.fromJson(
//     Map<String, dynamic> json,
//     T Function(Object? json) fromJsonT,
//   ) =>
//       _$CursorPaginationFromJson(json, fromJsonT);
// }

// @JsonSerializable()
// class CursorPaginationMeta {
//   // 받아온 데이터가 null 일 수는 없다.
//   final int count;
//   final bool hasMore;

//   CursorPaginationMeta({
//     required this.count,
//     required this.hasMore,
//   });

//   // create copywith
//   CursorPaginationMeta copyWith({
//     int? count,
//     bool? hasMore,
//   }) {
//     return CursorPaginationMeta(
//       count: count ?? this.count,
//       hasMore: hasMore ?? this.hasMore,
//     );
//   }

//   factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
//       _$CursorPaginationMetaFromJson(json);
// }

// // 새로고침 할때
// class CursorPaginationReFetching<T> extends CursorPagination {
//   // CursorPagination를 상속받는 이유는
//   // 새로고침을 하기 위해서는 기존의 데이터를 유지해야 하기 때문이다.
//   // 그리고 CursorPagination은 CursorPaginationBase 를 상속받기 때문에
//   // CursorPaginationRefetching 또한 CursorPaginationBase 를 상속받는다.
//   // instance is CursorPagination ==> true
//   // instance is CursorPaginationBase ==> true
//   CursorPaginationReFetching({
//     // 그대로 가져오기 위해서 super를 사용한다.
//     required super.meta,
//     required super.data,
//   });
// }

// // 리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중...
// class CursorPaginationFetchingMore<T> extends CursorPagination {
//   // 이떄 우리가 왜 CursorPaginateionLoading 을 사용하지 않는가?
//   // meta,data가 없기 때문에 CursorPaginateionLoading 을 사용하면 안된다.
//   CursorPaginationFetchingMore({
//     required super.meta,
//     required super.data,
//   });
// }

import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 새로고침 할때
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
