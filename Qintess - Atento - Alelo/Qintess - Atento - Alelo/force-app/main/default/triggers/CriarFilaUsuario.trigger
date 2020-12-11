trigger CriarFilaUsuario on User (after insert, after update) {
    
    if (Trigger.isAfter) {
    	BOPedidoFila.validarFilaUsuario(Trigger.newMap.keyset());
    }
}