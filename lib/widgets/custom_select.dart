import 'package:flutter/material.dart';

class CustomSelect<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? label;
  final bool allowClear;
  final FormFieldValidator<T?>? validator;

  final double? menuMaxHeight;
  final EdgeInsetsGeometry? itemPadding;

  const CustomSelect({
    Key? key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.hint,
    this.label,
    this.allowClear = false,
    this.validator,
    this.menuMaxHeight,
    this.itemPadding,
  }) : super(key: key);

  @override
  State<CustomSelect<T>> createState() => _CustomSelectState<T>();
}

class _CustomSelectState<T> extends State<CustomSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _actionKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (!mounted) return;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _actionKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;
    final top = position.dy + size.height;
    final availableBelow = screenHeight - top - 8.0;

    final double maxHeight = widget.menuMaxHeight != null
        ? widget.menuMaxHeight!.clamp(0.0, availableBelow)
        : (availableBelow > 100 ? availableBelow : availableBelow);

    return OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _removeOverlay,
                behavior: HitTestBehavior.translucent,
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight > 0 ? maxHeight : 200,
                      minWidth: size.width,
                      maxWidth: size.width,
                    ),
                    child: _buildMenu(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Stack(
      children: [
        // Detect taps outside to close
        Positioned.fill(
          child: GestureDetector(
            onTap: _removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.shrink(),
          ),
        ),
        // Menu content
        Material(
          color: Theme.of(context).cardColor,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return InkWell(
                onTap: () {
                  widget.onChanged?.call(item);
                  _removeOverlay();
                },
                child: Padding(
                  padding:
                      widget.itemPadding ??
                      const EdgeInsets.only(
                        left: 16,
                        right: 10,
                        top: 10,
                        bottom: 10,
                      ),
                  child: Text(widget.itemLabel(item)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.value,
      validator: widget.validator,
      builder: (field) {
        final errorText = field.errorText;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompositedTransformTarget(
              link: _layerLink,
              child: GestureDetector(
                key: _actionKey,
                onTap: _toggleDropdown,
                child: InputDecorator(
                  isEmpty: widget.value == null,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.hint,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.allowClear && widget.value != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              widget.onChanged?.call(null);
                              field.didChange(null);
                            },
                            tooltip: 'Limpar seleção',
                          ),
                        Icon(
                          _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    widget.value != null
                        ? widget.itemLabel(widget.value as T)
                        : '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
