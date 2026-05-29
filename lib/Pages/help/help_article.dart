import 'package:flutter/services.dart';

class HelpArticle {
  final String title;
  final String category;
  final String body;

  const HelpArticle({
    required this.title,
    required this.category,
    required this.body,
  });

  String get preview {
    final compact = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (compact.length <= 170) {
      return compact;
    }

    return '${compact.substring(0, 170).trim()}...';
  }
}

class HelpCategory {
  final String title;
  final List<HelpArticle> articles;

  const HelpCategory({required this.title, required this.articles});
}

class HelpArticleRepository {
  static const _articlePathPrefix = 'assets/help_articles/';

  Future<List<HelpCategory>> loadCategories() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final articlePaths =
        manifest
            .listAssets()
            .where(
              (path) =>
                  path.startsWith(_articlePathPrefix) &&
                  (path.endsWith('.txt') || path.endsWith('.md')),
            )
            .toList()
          ..sort();

    final grouped = <String, List<HelpArticle>>{};

    for (final path in articlePaths) {
      final rawText = await rootBundle.loadString(path);
      final article = _parseArticle(path, rawText);
      grouped.putIfAbsent(article.category, () => []).add(article);
    }

    final categories =
        grouped.entries
            .map(
              (entry) => HelpCategory(
                title: entry.key,
                articles: entry.value
                  ..sort((a, b) => a.title.compareTo(b.title)),
              ),
            )
            .toList()
          ..sort((a, b) => a.title.compareTo(b.title));

    return categories;
  }

  HelpArticle _parseArticle(String path, String rawText) {
    final lines = rawText.replaceAll('\r\n', '\n').split('\n');
    String? category;
    String? title;
    var bodyStartIndex = 0;

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim();

      if (line.isEmpty) {
        bodyStartIndex = index + 1;
        break;
      }

      final separatorIndex = line.indexOf(':');
      if (separatorIndex == -1) {
        break;
      }

      final key = line.substring(0, separatorIndex).trim().toLowerCase();
      final value = line.substring(separatorIndex + 1).trim();

      if (key == 'kategori' && value.isNotEmpty) {
        category = value;
      } else if ((key == 'titel' || key == 'rubrik') && value.isNotEmpty) {
        title = value;
      } else {
        break;
      }

      bodyStartIndex = index + 1;
    }

    final bodyLines = lines.skip(bodyStartIndex).toList();
    final firstHeadingIndex = bodyLines.indexWhere(
      (line) => line.trim().startsWith('# '),
    );

    if (title == null && firstHeadingIndex != -1) {
      title = bodyLines[firstHeadingIndex].trim().substring(2).trim();
      bodyLines.removeAt(firstHeadingIndex);
    }

    final fallbackTitle = path
        .split('/')
        .last
        .replaceAll(RegExp(r'\.(txt|md)$'), '')
        .replaceAll(RegExp(r'[_-]+'), ' ');

    return HelpArticle(
      title: title ?? _capitalizeWords(fallbackTitle),
      category: category ?? 'Övrigt',
      body: bodyLines.join('\n').trim(),
    );
  }

  String _capitalizeWords(String text) {
    return text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
