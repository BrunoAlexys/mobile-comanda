import 'package:flutter/material.dart';

enum OrderStatus { cancelled, pending, preparing, ready, delivered }

class CustomOrderStatus {
  CustomOrderStatus._();

  static String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.cancelled:
        return 'Cancelado';
      case OrderStatus.pending:
        return 'Aguardando';
      case OrderStatus.preparing:
        return 'Preparando';
      case OrderStatus.ready:
        return 'Pronto';
      case OrderStatus.delivered:
        return 'Delivery';
    }
  }

  static Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.red;
    }
  }

  static Widget buildStatusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
