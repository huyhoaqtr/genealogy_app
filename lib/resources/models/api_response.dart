class ApiResponse<T> {
  final int? statusCode;
  final String? message;
  final T? data;

  ApiResponse({this.statusCode, this.message, this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data != null ? toJsonT(data!) : null,
    };
  }
}

class PagingResponse<T> {
  final int? statusCode;
  final String? message;
  final PagingResponseType<T>? data;

  PagingResponse({this.statusCode, this.message, this.data});

  factory PagingResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PagingResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? PagingResponseType.fromJson(json['data'], fromJsonT)
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(toJsonT),
    };
  }
}

class PagingResponseType<T> {
  Meta? meta;
  List<T>? data;

  PagingResponseType({this.meta, this.data});

  factory PagingResponseType.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagingResponseType(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List).map((e) => fromJsonT(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (meta != null) {
      result['meta'] = meta!.toJson();
    }
    if (data != null) {
      result['data'] = data!.map((v) => toJsonT(v)).toList();
    }
    return result;
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}
