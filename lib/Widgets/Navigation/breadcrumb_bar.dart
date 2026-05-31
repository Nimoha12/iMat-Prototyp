import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/home_page.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Widgets/imat_link_text.dart';

class BreadcrumbBar extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbBar({
    super.key,
    required this.items,
  });

  static const _linkStyle = TextStyle(
    fontWeight: FontWeight.w700,
  );

  static const _linkPadding = EdgeInsets.symmetric(vertical: 8);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IMatLinkText(
          text: 'Hem',
          style: IMatText.bodyL.merge(_linkStyle),
          padding: _linkPadding,
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
        ),

        ...items.map((item) {
          final bool isLast = item == items.last;
          final bool isClickable = item.onTap != null && !isLast;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: IMatColors.textSecondary,
                ),
              ),

              if (isClickable)
                IMatLinkText(
                  text: item.label,
                  style: IMatText.bodyL.merge(_linkStyle),
                  padding: _linkPadding,
                  onTap: item.onTap!,
                )
              else
                Padding(
                  padding: _linkPadding,
                  child: Text(
                    item.label,
                    style: IMatText.bodyL.copyWith(
                      color: IMatColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

/// Breadcrumbs for [SearchPage]: [prefix…, Sök]. Tapping a prefix segment pops
/// back through routes that were open before search was opened.
List<BreadcrumbItem> buildSearchBreadcrumbs(
  BuildContext context,
  List<BreadcrumbItem> prefix,
) {
  return [
    for (var i = 0; i < prefix.length; i++)
      BreadcrumbItem(
        label: prefix[i].label,
        onTap: () {
          final pops = prefix.length - i;
          final navigator = Navigator.of(context);
          for (var p = 0; p < pops && navigator.canPop(); p++) {
            navigator.pop();
          }
        },
      ),
    BreadcrumbItem(label: 'Sök'),
  ];
}
