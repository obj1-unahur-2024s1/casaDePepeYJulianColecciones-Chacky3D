import cosas.* //obviamente, vamos a usar los objetos del archivo cosas ;-)

object casaDePepeYJulian {
	const cosas = []
	const cuentaBancaria = cuentaCombinada
	
	method comprar(cosa){
		cosas.addAll(if (!cosa.equals(packComida)) [cosa] else cosa.platoYAderezo())
		self.gastar(cosa.precio())
	}
	method cantidadDeCosasCompradas(){
		return cosas.size()
	}
	method tieneComida(){
		return cosas.any({ cosa => cosa.esComida()})
	}
	method vieneDeEquiparse(){
		return cosas.last().esElectrodomestico() or cosas.last().precio() > 50000
	}
	method esDerrochona(){
		return cosas.fold(0, {acum, item => acum + item.precio()}) >= 90000
	}
	method compraMasCara(){
		return cosas.fold(cosas.anyOne(), {maxItem, item => if(maxItem.precio() < item.precio()) item else maxItem})
	}
	method electrodomesticosComprados(){
		return cosas.filter({ cosa => cosa.esElectrodomestico()})
	}
	method malaEpoca(){
		return cosas.all({ cosa => cosa.esComida()})
	}
	method queFaltaComprar(lista){
		return lista.asSet().difference(cosas.asSet())
	}
	method faltaComida(){
		return cosas.count({ cosa => cosa.esComida()}) < 2
	}
	method gastar(importe){
		cuentaBancaria.extraer(importe)
	}
	method dineroDisponible() { return cuentaBancaria.saldo() }
}

object cuentaCorriente{
	 var saldo = 30000
	 
	 method saldo() { return saldo }
	 method depositar(importe) { saldo = saldo + importe }
	 method extraer(importe){ 
	 	const dineroFaltante = saldo - importe
	 	saldo = 0.max(saldo - importe)
	 	return if(dineroFaltante < 0) dineroFaltante.abs() else 0
	 }
}

object cuentaConGastos{
	var saldo = 2000000
	
	method saldo() { return saldo }
	method depositar(importe) { saldo = saldo + importe - 200 }
	method extraer(importe){ 
		saldo = if(importe <= 10000) saldo - importe - 200 else saldo - importe - importe * 0.02
	}
}

object cuentaCombinada{
	method saldo() { return cuentaCorriente.saldo() + cuentaConGastos.saldo() }
	method depositar(importe) { cuentaCorriente.depositar(importe) }
	method extraer(importe){
		cuentaConGastos.extraer(cuentaCorriente.extraer(importe))
	}
}