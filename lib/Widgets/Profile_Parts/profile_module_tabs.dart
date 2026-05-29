import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/profile_constants.dart';

const String profileTabsSemanticsLabel = 'Profilsektioner';
const String profileSectionSemanticsLabel = 'Profiluppgifter';

class ProfileModuleTab {
  final String title;
  final IconData icon;
  final Widget child;

  const ProfileModuleTab({
    required this.title,
    required this.icon,
    required this.child,
  });
}

class ProfileFieldGroup {
  final String? title;
  final List<Widget> fields;

  const ProfileFieldGroup({this.title, required this.fields});
}

class ProfileModuleTabs extends StatefulWidget {
  final List<ProfileModuleTab> tabs;

  const ProfileModuleTabs({super.key, required this.tabs});

  @override
  State<ProfileModuleTabs> createState() => _ProfileModuleTabsState();
}

class _ProfileModuleTabsState extends State<ProfileModuleTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: profileTabsSemanticsLabel,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 820;
              final tabButtons = [
                for (var index = 0; index < widget.tabs.length; index++)
                  _ProfileTabButton(
                    tab: widget.tabs[index],
                    selected: index == _selectedIndex,
                    onPressed: () => setState(() => _selectedIndex = index),
                  ),
              ];

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0; index < tabButtons.length; index++) ...[
                      tabButtons[index],
                      if (index != tabButtons.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  for (var index = 0; index < tabButtons.length; index++) ...[
                    Expanded(child: tabButtons[index]),
                    if (index != tabButtons.length - 1)
                      const SizedBox(width: 12),
                  ],
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: widget.tabs[_selectedIndex].child,
          ),
        ),
      ],
    );
  }
}

class ProfileModuleSurface extends StatelessWidget {
  final String title;
  final String helperText;
  final IconData icon;
  final List<ProfileFieldGroup> groups;

  const ProfileModuleSurface({
    super.key,
    required this.title,
    required this.helperText,
    required this.icon,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$profileSectionSemanticsLabel: $title',
      child: Container(
        decoration: BoxDecoration(
          color: profileSurfaceColor,
          borderRadius: BorderRadius.circular(profileCardRadius),
          border: Border.all(color: profileBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: profilePrimaryLightColor,
                    borderRadius: BorderRadius.circular(profileCardRadius),
                  ),
                  child: Icon(icon, color: profilePrimaryColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: profileModuleTitleStyle),
                      const SizedBox(height: 6),
                      Text(helperText, style: profileHelperTextStyle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            for (var index = 0; index < groups.length; index++) ...[
              _ProfileFieldGroupView(group: groups[index]),
              if (index != groups.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: profileSectionGap),
                  child: Divider(height: 1, color: profileBorderColor),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileFieldGroupView extends StatelessWidget {
  final ProfileFieldGroup group;

  const _ProfileFieldGroupView({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.title != null) ...[
          Text(group.title!, style: profileSectionTitleStyle),
          const SizedBox(height: 16),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final columnWidth = isWide
                ? (constraints.maxWidth - 26) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 26,
              runSpacing: 18,
              children: [
                for (final field in group.fields)
                  SizedBox(
                    width: columnWidth,
                    child: Align(alignment: Alignment.centerLeft, child: field),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  final ProfileModuleTab tab;
  final bool selected;
  final VoidCallback onPressed;

  const _ProfileTabButton({
    required this.tab,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: profileTabButtonStyle(selected: selected),
      icon: Icon(tab.icon, size: 24),
      label: Text(tab.title, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
