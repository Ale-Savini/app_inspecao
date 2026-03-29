import 'package:flutter/material.dart';

import '../models/subestacao.dart';
import '../models/equipamento.dart';
import '../models/inspecao.dart';

import '../screens/login_screen.dart';
import '../screens/subestacoes_screen.dart';
import '../screens/equipamentos_lista_screen.dart';
import '../screens/equipamento_detalhe_screen.dart';
import '../screens/cadastrar_equipamento_screen.dart';
import '../screens/nova_inspecao_screen.dart';
import '../screens/historico_inspecao_screen.dart';
import '../screens/detalhe_inspecao_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String subestacoes = '/';
  static const String equipamentos = '/equipamentos';
  static const String equipamentoDetalhe = '/equipamento_detalhe';
  static const String cadastrarEquipamento = '/cadastrar_equipamento';
  static const String novaInspecao = '/nova_inspecao';
  static const String historico = '/historico';
  static const String detalheInspecao = '/detalhe_inspecao';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case subestacoes:
        return MaterialPageRoute(
          builder: (_) => const SubestacoesScreen(),
        );

      case equipamentos:
        final subestacao = settings.arguments as Subestacao;
        return MaterialPageRoute(
          builder: (_) => EquipamentosListaScreen(subestacao: subestacao),
        );

      case equipamentoDetalhe:
        final equipamento = settings.arguments as Equipamento;
        return MaterialPageRoute(
          builder: (_) => EquipamentoDetalheScreen(equipamento: equipamento),
        );

      case cadastrarEquipamento:
        final subestacao = settings.arguments as Subestacao;
        return MaterialPageRoute(
          builder: (_) => CadastrarEquipamentoScreen(subestacao: subestacao),
        );

      case novaInspecao:
        final equipamento = settings.arguments as Equipamento;
        return MaterialPageRoute(
          builder: (_) => NovaInspecaoScreen(equipamento: equipamento),
        );

      case historico:
        final equipamento = settings.arguments as Equipamento;
        return MaterialPageRoute(
          builder: (_) => HistoricoInspecaoScreen(equipamento: equipamento),
        );

      case detalheInspecao:
        final inspecao = settings.arguments as Inspecao;
        return MaterialPageRoute(
          builder: (_) => DetalheInspecaoScreen(inspecao: inspecao),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SubestacoesScreen(),
        );
    }
  }
}