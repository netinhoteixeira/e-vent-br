<?php
require_once(PERSISTENCIAS.'PersistenciaConectorBD.php');
require_once (CLASSES . 'UsuarioSessao.php');
require_once (CLASSES . 'InstanciaUnica.php');
/*
 * 
 */
class PersistenciaPagamento extends InstanciaUnica implements IPersistenciaPagamento {

    public function confirmarPagamentoInscricao($cod_inscricao){
        $sql = "UPDATE Inscricao SET status = 'Confirmada' WHERE cod_inscricao = '" . $cod_inscricao . "' AND status ='Andamento'";
        
        return FachadaConectorBD::getInstancia()->atualizar($sql);
    }
    
    public function cancelarPagamentoInscricao($cod_inscricao){
        $sql = "UPDATE Inscricao SET status = 'Cancelada' WHERE cod_inscricao = '" . $cod_inscricao . "'";
        
        return FachadaConectorBD::getInstancia()->atualizar($sql);
    }
}
?>