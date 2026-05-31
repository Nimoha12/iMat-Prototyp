import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/help/help_article.dart';
import 'package:imat_repo/Pages/help/help_article_overlay.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/Navigation/breadcrumb_bar.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/CloseProfile_Button.dart';
import 'package:imat_repo/Widgets/product/lazy_product_grid.dart';
import 'package:imat_repo/layout/imat_scaffold.dart';

const helpArticleGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  crossAxisSpacing: 24,
  mainAxisSpacing: 24,
  mainAxisExtent: 240,
);

class HelpPage extends StatefulWidget {
  static const routeName = '/help';

  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final ScrollController _scrollController = ScrollController();
  final HelpArticleRepository _repository = HelpArticleRepository();

  late Future<List<HelpCategory>> _categoriesFuture;
  HelpCategory? _selectedCategory;
  bool showScrollButton = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _repository.loadCategories();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !showScrollButton) {
        setState(() => showScrollButton = true);
      } else if (_scrollController.offset <= 300 && showScrollButton) {
        setState(() => showScrollButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = [
      BreadcrumbItem(
        label: 'Hjälp',
        onTap: _selectedCategory == null
            ? null
            : () {
                setState(() {
                  _selectedCategory = null;
                });
              },
      ),
      if (_selectedCategory != null)
        BreadcrumbItem(label: _selectedCategory!.title),
    ];

    return IMatScaffold(
      activePage: NavbarPage.help,
      breadcrumbContext: breadcrumbs,
      body: Stack(
    children: [FutureBuilder<List<HelpCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState != ConnectionState.done;
          final categories = snapshot.data ?? [];

          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BreadcrumbBar(items: breadcrumbs),
                            const SizedBox(height: 24),
                            Text(
                              _selectedCategory?.title ?? 'Hjälp',
                              style: IMatText.h2,
                            ),
                            if (_selectedCategory == null) ...[
                              const SizedBox(height: 18),
                              const _SupportContactCard(),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      if (isLoading)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (categories.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'Det finns inga hjälpartiklar ännu.',
                              style: IMatText.bodyL,
                            ),
                          ),
                        )
                      else if (_selectedCategory == null)
                        SliverGrid(
                          gridDelegate: productGridDelegate,
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final category = categories[index];
                            return _HelpCategoryCard(
                              category: category,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                _scrollController.jumpTo(0);
                              },
                            );
                          }, childCount: categories.length),
                        )
                      else
                        SliverGrid(
                          gridDelegate: helpArticleGridDelegate,
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final article = _selectedCategory!.articles[index];
                            return _HelpArticleCard(
                              article: article,
                              onTap: () => _openArticle(article),
                            );
                          }, childCount: _selectedCategory!.articles.length),
                        ),
                    ],
                  ),
                ),
              ),
              if (showScrollButton)
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: FloatingActionButton(
                    backgroundColor: IMatColors.green,
                    onPressed: () => _scrollController.jumpTo(0),
                    child: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
      const Positioned(
        top: 12,
        right: 16,
        child: CloseProfileButton(),
      )
    ]
      )
    );
  }

  void _openArticle(HelpArticle article) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (_, _, _) => HelpArticleOverlay(article: article),
      ),
    );
  }
}

class _SupportContactCard extends StatelessWidget {
  const _SupportContactCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1396,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: IMatColors.white,
        border: Border.all(color: IMatColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 32,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Behöver du hjälp?',
            style: IMatText.h3.copyWith(fontWeight: FontWeight.w800),
          ),
          _SupportContactItem(
            icon: Icons.phone_outlined,
            label: '010-123 45 67',
          ),
          _SupportContactItem(
            icon: Icons.mail_outline,
            label: 'support@imat.se',
          ),
        ],
      ),
    );
  }
}

class _SupportContactItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SupportContactItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: IMatColors.green, size: 32),
        const SizedBox(width: 10),
        Text(
          label,
          style: IMatText.bodyL.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _HelpCategoryCard extends StatelessWidget {
  final HelpCategory category;
  final VoidCallback onTap;

  const _HelpCategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: IMatColors.green,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: IMatColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                _iconForCategory(category.title),
                color: IMatColors.white,
                size: 48,
              ),
              const Spacer(),
              Text(
                category.title,
                style: IMatText.h3.copyWith(
                  color: IMatColors.white,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                '${category.articles.length} artiklar',
                style: IMatText.bodyM.copyWith(
                  color: IMatColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpArticleCard extends StatelessWidget {
  final HelpArticle article;
  final VoidCallback onTap;

  const _HelpArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: IMatColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: IMatColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: IMatColors.greenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.article_outlined,
                  color: IMatColors.green,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                article.title,
                style: IMatText.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconForCategory(String category) {
  final lower = category.toLowerCase();
  if (lower.contains('varukorg') || lower.contains('kundvagn')) {
    return Icons.shopping_cart_outlined;
  }
  if (lower.contains('login') || lower.contains('logga')) {
    return Icons.account_circle_outlined;
  }
  if (lower.contains('checkout') || lower.contains('betala')) {
    return Icons.payment_outlined;
  }
  if (lower.contains('favorit')) {
    return Icons.favorite_border;
  }
  if (lower.contains('sök')) {
    return Icons.search;
  }

  return Icons.help_outline;
}
