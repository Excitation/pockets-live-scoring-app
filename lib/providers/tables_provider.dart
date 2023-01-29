import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pocketslivescoringapp/models/table.dart';
import 'package:pocketslivescoringapp/utils/api_utils.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// Table provider that is used to get the table from the api.
final tablesProvider = FutureProvider<List<Table>>((ref) async {
  /// Mock data for the table.
  await Future<void>.delayed(const Duration(seconds: 2));
  return <Table>[
    Table(id: 1, name: 'Table 1'),
    Table(id: 2, name: 'Table 2'),
    Table(id: 3, name: 'Table 3'),
    Table(id: 4, name: 'Table 4'),
    Table(id: 5, name: 'Table 5'),
    Table(id: 6, name: 'Table 6')
  ];

  /// Actual API call to get the table.
  // ignore: dead_code
  final response = await http.get(ApiUtils.getUrl(AppConstants.tablesEndpoint));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body) as List<dynamic>;
    final tables = body
        .map((dynamic item) => Table.fromJson(item as Map<String, dynamic>))
        .toList();
    return tables;
  } else {
    throw Exception('Failed to load table');
  }
});
