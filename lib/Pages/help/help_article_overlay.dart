import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/help/help_article.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';

class HelpArticleOverlay extends StatelessWidget {
  final HelpArticle article;

  const HelpArticleOverlay({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.48),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelWidth = math.min(constraints.maxWidth - 32, 860.0);
            final panelHeight = math.min(constraints.maxHeight - 32, 700.0);

            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: panelWidth,
                    height: panelHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Material(
                            color: IMatColors.white,
                            elevation: 18,
                            shadowColor: Colors.black.withValues(alpha: 0.28),
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                40,
                                38,
                                40,
                                34,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(article.title, style: IMatText.h2),
                                  const SizedBox(height: 8),
                                  Text(
                                    article.category,
                                    style: IMatText.bodyM.copyWith(
                                      color: IMatColors.green,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        article.body,
                                        style: IMatText.bodyL.copyWith(
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Semantics(
                            button: true,
                            label: 'Stäng hjälpartikel',
                            child: IconButton.filled(
                              onPressed: () => Navigator.of(context).pop(),
                              style: IconButton.styleFrom(
                                backgroundColor: IMatColors.white,
                                foregroundColor: IMatColors.black,
                                fixedSize: const Size(56, 56),
                                side: const BorderSide(
                                  color: IMatColors.border,
                                ),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(Icons.close, size: 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
