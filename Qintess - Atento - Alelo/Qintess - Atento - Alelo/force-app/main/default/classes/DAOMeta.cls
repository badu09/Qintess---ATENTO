public class DAOMeta {
	public static Boolean hasMeta(Integer month, Integer year) {
		Date inicio = Date.newInstance(year, month, 1);
		Date fim = Date.newInstance(year, month + 1, 1).addDays(-1);
		try {
			List<Meta__c> metas =
			[SELECT ID FROM META__C WHERE DataInicioVigencia__c >= :inicio AND DataInicioVigencia__c <= :fim];
			if (metas != null && !metas.isEmpty())
				return true;
			return false;
		}
		catch(DmlException e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
			return false;
		}
	}

	public static List<Meta__c> getMetasImplantacao(Integer month, Integer year) {
		Date inicio = Date.newInstance(year, month, 1);
		Date fim = Date.newInstance(year, month + 1, 1).addDays(-1);
		try {
			return [SELECT Id,
					Supervisor__c,
					Operador__c,
					ParametroMeta__r.RecordType.DeveloperName
					FROM Meta__c
					WHERE DataInicioVigencia__c >= :inicio
			AND DataInicioVigencia__c <= :fim
			AND ParametroMeta__r.RecordType.DeveloperName LIKE '%implanta%'];
		}
		catch(DmlException e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
			return null;
		}
	}

	public static List<Meta__c> getMetasVendas(Integer month, Integer year) {
		Date inicio = Date.newInstance(year, month, 1);
		Date fim = Date.newInstance(year, month + 1, 1).addDays(-1);
		try {
			return [SELECT Id,
					Supervisor__c,
					Operador__c,
					ParametroMeta__r.RecordType.DeveloperName
					FROM Meta__c
					WHERE DataInicioVigencia__c >= :inicio
			AND DataInicioVigencia__c <= :fim
			AND ParametroMeta__r.RecordType.DeveloperName LIKE '%venda%'];
		}
		catch(DmlException e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
			return null;
		}
	}
}