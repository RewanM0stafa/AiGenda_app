import '../network/api_keys.dart';

class FilterRequest {
  final int pageNumber;
  final int pageSize;
  final String? searchValue;
  final String? sortColumn;
  final String? sortOrder;

  const FilterRequest({
    this.pageNumber = 1,
    this.pageSize = 10,
    this.searchValue,
    this.sortColumn,
    this.sortOrder = 'asc',
  });

  Map<String, dynamic> toQueryParams() {
    return {
      ApiKeys.pageNumber: pageNumber,
      ApiKeys.pageSize: pageSize,
      if (searchValue != null && searchValue!.isNotEmpty)
        ApiKeys.searchValue: searchValue,
      if (sortColumn != null && sortColumn!.isNotEmpty)
        ApiKeys.sortColumn: sortColumn,
      if (sortOrder != null) ApiKeys.sortOrder: sortOrder,
    };
  }
}
