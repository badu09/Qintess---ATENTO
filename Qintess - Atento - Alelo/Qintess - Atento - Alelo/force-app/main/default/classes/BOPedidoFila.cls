public with sharing class BOPedidoFila {


	@InvocableMethod(label='Atribuir Fila Fideliazada' description='Atribui fila individual para tratamento de oportunidades com agendamento fidelizado')
	public static void atribuirFilaFidelizada(List<Id> lId) {
		if(lId != null) {
			Set<Id> setId = new Set<Id>(lId);

			executar(setId);
		}
	}

	public static void validarFilaUsuario(Set<Id> setIdUsuario) {

		try {

			Map<String, Id> mapFilaUsuario = carregarFila(setIdUsuario);

			Set<Id> setIdUsuarioSemFila = new Set<Id>();

			for(Id item : setIdUsuario) {
				String chave = 'Fidelizado_' + item;

				if(!mapFilaUsuario.containsKey(chave)) {
					setIdUsuarioSemFila.add(item);
				}
			}

			if(!setIdUsuarioSemFila.isEmpty()) {
				gerarFila(setIdUsuarioSemFila);
			}
		}
		catch(DmlException ex) {
			system.debug('DmlException: ' + ex.getLineNumber());
			system.debug('DmlException: ' + ex.getStackTraceString());
			system.debug('DmlException: ' + ex.getTypeName());
			system.debug('DmlException: ' + ex.getCause());
			system.debug('DmlException: ' + ex.getMessage());
		}
		catch(Exception ex) {
			system.debug('Exception: ' + ex.getLineNumber());
			system.debug('Exception: ' + ex.getStackTraceString());
			system.debug('Exception: ' + ex.getTypeName());
			system.debug('Exception: ' + ex.getCause());
			system.debug('Exception: ' + ex.getMessage());
		}
	}

	private static void executar(Set<Id> setId) {

		try {
			System.debug('setId: ' + JSON.serialize(setId));
			List<Order> lPedido = DAOOrder.getOrderBySetId(setId);

			system.debug('lPedido: ' + json.serialize(lPedido));

			Set<Id> setIdUsuario = new Set<Id>();

			for(Order item : lPedido) {
				RecordType tipoRegistro = DAORecordType.obterPorId(item.RecordTypeId, 'Order');
				if (tipoRegistro.DeveloperName.equalsIgnoreCase('Vendas')) {
					if (item.LastModifiedById != null) {
						setIdUsuario.add(item.LastModifiedById);
					}
				}
				else {
					if (item.Opportunity != null && item.Opportunity.Implantador_Atribuido__c != null) {
						setIdUsuario.add(item.Opportunity.Implantador_Atribuido__c);
					}
				}
			}

			Map<String, Id> mapFilaUsuario = carregarFila(setIdUsuario);

			List<Order> lPedidoImplantacao = new List<Order>();

			for(Order item : lPedido) {
                // Desconsiderar quando Estratégia / Vigente com Fidelização
                if ( item.Implantacao_Fidelizada_Estrategia__c == null ||
                     !item.Implantacao_Fidelizada_Estrategia__c.equals('Vigente Sem Fidelização') )
                {
                    RecordType tipoRegistro = DAORecordType.obterPorId(item.RecordTypeId, 'Order');
                    if (tipoRegistro.DeveloperName.equalsIgnoreCase('Vendas')) {
                        if (item.LastModifiedById != null) {
                            String chave = 'Fidelizado_' + item.LastModifiedById;
                            
                            if (mapFilaUsuario.containsKey(chave)) {
                                Order pedidoImplantacao = new Order();
                                
                                pedidoImplantacao.Id = item.Id;
                                pedidoImplantacao.OwnerId = mapFilaUsuario.get(chave);
                                
                                lPedidoImplantacao.add(pedidoImplantacao);
                            }
                        }
                    }
                    else {
                        if (item.Opportunity != null && item.Opportunity.Implantador_Atribuido__c != null) {
                            String chave = 'Fidelizado_' + item.Opportunity.Implantador_Atribuido__c;
                            
                            if (mapFilaUsuario.containsKey(chave)) {
                                Order pedidoImplantacao = new Order();
                                
                                pedidoImplantacao.Id = item.Id;
                                pedidoImplantacao.OwnerId = mapFilaUsuario.get(chave);
                                
                                lPedidoImplantacao.add(pedidoImplantacao);
                            }
                        }
                    }
                }
			}

			system.debug('lPedidoImplantacao: ' + json.serialize(lPedidoImplantacao));

			if(!lPedidoImplantacao.isEmpty()) {
				update lPedidoImplantacao;
			}
		}
		catch(DmlException ex) {
			system.debug('DmlException: ' + ex.getLineNumber());
			system.debug('DmlException: ' + ex.getStackTraceString());
			system.debug('DmlException: ' + ex.getTypeName());
			system.debug('DmlException: ' + ex.getCause());
			system.debug('DmlException: ' + ex.getMessage());
		}
		catch(Exception ex) {
			system.debug('Exception: ' + ex.getLineNumber());
			system.debug('Exception: ' + ex.getStackTraceString());
			system.debug('Exception: ' + ex.getTypeName());
			system.debug('Exception: ' + ex.getCause());
			system.debug('Exception: ' + ex.getMessage());
		}
	}

	private static Map<String, Id> carregarFila(Set<Id> setIdUsuario) {
		Set<String> setDeveloperName = new Set<String>();

		for(Id item : setIdUsuario) {
			setDeveloperName.add('Fidelizado_' + item);
		}

		List<QueueSobject> lFila = DAOQueueSobject.getGroupMemberByDeveloperName(setDeveloperName);

		Map<String, Id> mapFilaUsuario = new Map<String, Id>();

		for(QueueSobject item : lFila) {
			mapFilaUsuario.put(item.Queue.DeveloperName, item.QueueId);
		}

		return mapFilaUsuario;
	}

	private static void gerarFila(Set<Id> setIdUsuario) {

		QueueRoutingConfig queueRoutingConfig = DAOQueueRoutingConfig.getByDeveloperName('Roteamento_Agendamento');

		List<Group> lGrupo = new List<Group>();

		for(User item : DAOUser.getUserBySetId(setIdUsuario)) {
			Group grupo = new Group();

			grupo.Name = 'Fidelizado - ' + item.FirstName;
			grupo.DeveloperName = 'Fidelizado_' + item.Id;
			grupo.Type = 'Queue';
			grupo.QueueRoutingConfigId = queueRoutingConfig.Id;

			lGrupo.add(grupo);
		}

		insert lGrupo;

		List<GroupMember> lMembroGrupo = new List<GroupMember>();
		List<QueueSobject> lQueueSobject = new List<QueueSobject>();

		for(Group item : lGrupo) {

			GroupMember membroGrupo = new GroupMember();

			membroGrupo.GroupId = item.Id;
			membroGrupo.UserOrGroupId = item.DeveloperName.split('_')[1];

			lMembroGrupo.add(membroGrupo);


			QueueSobject queueSobject = new QueueSobject();

			queueSobject.QueueId = item.Id;
			queueSobject.SobjectType = 'Order';

			lQueueSobject.add(queueSobject);
		}

		insert lMembroGrupo;
		insert lQueueSobject;
	}
}