import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imat_repo/Widgets/Profile_Parts/profile_constants.dart';

const String profileSaveTooltip = 'Spara ändring';
const String profileEditHint = 'Klicka för att redigera';
const String profileSavedMessage = 'Sparat';

class ProfileEditableField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onSave;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? helperText;

  const ProfileEditableField({
    super.key,
    required this.label,
    required this.controller,
    this.helperText,
    required this.onSave,
    this.keyboardType,
    this.maxLength,
  });

  @override
  State<ProfileEditableField> createState() => _ProfileEditableFieldState();
}

class _ProfileEditableFieldState extends State<ProfileEditableField> {
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;
  late String _savedValue;

  @override
  void initState() {
    super.initState();
    _savedValue = widget.controller.text;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant ProfileEditableField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _savedValue = widget.controller.text;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _save();
    }
  }

  void _startEditing() {
    if (_editing) {
      return;
    }

    setState(() {
      _editing = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _focusNode.requestFocus();
      widget.controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.controller.text.length,
      );
    });
  }

  void _save() {
    final nextValue = widget.controller.text.trim();
    if (widget.controller.text != nextValue) {
      widget.controller.text = nextValue;
      widget.controller.selection = TextSelection.collapsed(
        offset: nextValue.length,
      );
    }

    if (nextValue != _savedValue) {
      widget.onSave(nextValue);
      _savedValue = nextValue;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${widget.label}: $profileSavedMessage'),
            duration: const Duration(milliseconds: 1200),
          ),
        );
    }

    if (mounted) {
      setState(() {
        _editing = false;
      });
    }
  }

  void _cancel() {
    widget.controller.text = _savedValue;
    widget.controller.selection = TextSelection.collapsed(
      offset: _savedValue.length,
    );
    setState(() {
      _editing = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: '${widget.label}. $profileEditHint',
      child: SizedBox(
        width: profileFieldWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: profileFieldLabelStyle),
            const SizedBox(height: 8),
            Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.escape): _CancelEditIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  _CancelEditIntent: CallbackAction<_CancelEditIntent>(
                    onInvoke: (_) {
                      _cancel();
                      return null;
                    },
                  ),
                },
                child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: !_editing,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      textInputAction: TextInputAction.done,
      onTap: _startEditing,
      onSubmitted: (_) => _save(),
      style: profileFieldTextStyle,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: _editing
            ? profileSurfaceColor
            : profilePrimaryLightColor.withValues(alpha: 0.55),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        suffixIcon: IconButton(
          tooltip: _editing
              ? profileSaveTooltip
              : profileEditHint,
          onPressed: _editing ? _save : _startEditing,
          icon: Icon(
            _editing
                ? Icons.check
                : Icons.edit,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            profileCardRadius,
          ),
          borderSide: const BorderSide(
            color: profileBorderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            profileCardRadius,
          ),
          borderSide: const BorderSide(
            color: profilePrimaryColor,
            width: 3,
          ),
        ),
      ),
    ),

    if (widget.helperText != null) ...[
      const SizedBox(height: 6),

      Text(
        widget.helperText!,
        style: profileHelperTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  ],
),
              
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelEditIntent extends Intent {
  const _CancelEditIntent();
}
