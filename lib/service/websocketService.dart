import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/store/tables_store.mobx.dart';

class WebSocketService {
  late StompClient stompClient;

  void initWebSocket() {
    stompClient = StompClient(
      config: StompConfig(
        // Passar depois via variavel de ambiente
        url: 'ws://192.168.255.180:8080/ws-flutter',
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('❌ Erro WS: $error'),
        onStompError: (dynamic error) => print('❌ Erro STOMP: $error'),
        onDisconnect: (dynamic frame) => print('⚠️ WS Desconectado!'),
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    print('✅ Conectado ao WebSocket do Spring Boot!');
    stompClient.subscribe(
      destination: '/topic/tables',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final Map<String, dynamic> data = json.decode(frame.body!);
          final tablesStore = locator<TablesStore>();
          tablesStore.updateTableStatusWs(data);
        }
      },
    );
  }

  void deactivate() {
    stompClient.deactivate();
  }
}
