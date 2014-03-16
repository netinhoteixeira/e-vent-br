<?php
require_once ('../../persistencia/PersistenciaEvento.php');

class FachadaEvento extends InstanciaUnica{
	
	public function getListaEventos(){
		return PersistenciaEvento::getInstancia()->getListaEventos();
	}
	
	public function getListaAtividadeEvento($cod_evento){
		return PersistenciaEvento::getInstancia()->getListaAtividadeEvento($cod_evento);
	}
}

?>