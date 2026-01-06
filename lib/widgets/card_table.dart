import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/utils.dart';

class CardTable extends StatefulWidget {
  const CardTable({super.key});

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  bool _isPressed = false;

  void _handleTap() async {
    setState(() {
      _isPressed = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.42;
    const double cardHeight = 200.0;

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFBBF7D0), width: 2),
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
                    color: Utils.hexToColor('EDFDF3'),
                    borderRadius: BorderRadius.circular(_isPressed ? 0 : 100),
                  ),
                ),
              ),

              // CONTEÚDO
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '01',
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
                                : const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.check,
                            color: _isPressed
                                ? const Color(0xFF22C55E)
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
                          '4 Pessoas',
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
                            : Utils.hexToColor('DCFCE7'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Disponível',
                        style: TextStyle(
                          color: Utils.hexToColor('358053'),
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
