import 'package:flutter/material.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/enum/status_table.dart';
import 'package:mobile_comanda/util/utils.dart';

class CardTable extends StatefulWidget {
  final String tableNumber;
  final int chairsAvailable;
  final StatusTable status;

  const CardTable({
    super.key,
    required this.tableNumber,
    required this.chairsAvailable,
    required this.status,
  });

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  bool _isPressed = false;

  void _handleTap() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isPressed = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _isPressed = false;
      });

      Navigator.of(context).pushNamed(AppRoutes.order);
    }
  }

  _TableStyle _getStatusColor(StatusTable status) {
    switch (status) {
      case StatusTable.available:
        return _TableStyle(
          borderColor: Utils.hexToColor('BBF7D0'),
          backgroundColor: Utils.hexToColor('EDFDF3'),
          iconColor: Utils.hexToColor('22C55E'),
          textColor: Utils.hexToColor('358053'),
        );
      case StatusTable.occupied:
        return _TableStyle(
          borderColor: Utils.hexToColor('BFDBFE'),
          backgroundColor: Utils.hexToColor('F0F9FF'),
          iconColor: Utils.hexToColor('3B82F6'),
          textColor: Utils.hexToColor('1D4EDF'),
        );
      case StatusTable.reserved:
        return _TableStyle(
          borderColor: Utils.hexToColor('FED7AA'),
          backgroundColor: Utils.hexToColor('FFF7ED'),
          iconColor: Utils.hexToColor('F59E0B'),
          textColor: Utils.hexToColor('C94F25'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.42;
    const double cardHeight = 200.0;
    final _TableStyle statusStyle = _getStatusColor(widget.status);

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: statusStyle.borderColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutQuart,
                top: _isPressed ? 0 : -60,
                right: _isPressed ? 0 : -70,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutQuart,
                  width: _isPressed ? 500 : 150,
                  height: _isPressed ? 500 : 150,
                  decoration: BoxDecoration(
                    color: statusStyle.backgroundColor,
                    borderRadius: BorderRadius.circular(_isPressed ? 0 : 100),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.tableNumber,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _isPressed
                                ? Colors.white
                                : statusStyle.iconColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.check,
                            color: _isPressed
                                ? statusStyle.iconColor
                                : Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Utils.hexToColor('A3A3A3'),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.chairsAvailable} Pessoas',
                          style: TextStyle(
                            color: Utils.hexToColor('A3A3A3'),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Divider(
                      color: _isPressed
                          ? Colors.grey[300]
                          : Utils.hexToColor('F5F6F8'),
                      thickness: 1,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _isPressed
                            ? Colors.white
                            : statusStyle.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.status.description,
                        style: TextStyle(
                          color: statusStyle.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableStyle {
  final Color borderColor;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  _TableStyle({
    required this.borderColor,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });
}
