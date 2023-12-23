import 'package:flutter/material.dart';
import 'package:news_app/screens/search_result.dart';
import '../model/suggestion_list.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: Color.fromRGBO(239, 83, 80, 1),
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(
              color: Color.fromRGBO(239, 83, 80, 1),
            )),
        fillColor: Colors.white,
        filled: true,
        hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        splashColor: Colors.white,
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          }
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashColor: Colors.white,
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];

    for (final item in searchTerms.reversed) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            query = matchQuery[index];
            showResults(context);
          },
          title: Text(matchQuery[index]),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return SearchResult(searchTerm: query);
    } else {
      return const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.search), Text('No Results.')],
        ),
      );
    }
  }
}
