class ControlPedido {
  // Esta función recibe el nombre del pedido y lo que el jugador preparó
  static bool verificarPedido(String pedidoDelCliente, String pedidoPreparado) {
    if (pedidoDelCliente == pedidoPreparado) {
      return true;
    } else {
      return false;
    }
  }
}
