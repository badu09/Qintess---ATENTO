trigger ConverterImplantacao on Implantacao__c (after insert) {


	system.debug('Inicio: ConverterImplantacao');

//		BOImplantacao.convertImplantacao(Trigger.newMap);
	//Database.executeBatch(new BatchImplantacao(Trigger.newMap.keySet()), 1);
	Integer i = 0;

	system.debug('Fim: ConverterImplantacao');

}