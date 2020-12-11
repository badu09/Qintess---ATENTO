@isTest
public class DadosEstrategiaTest
{

    @TestVisible public static Estrategia_Implantacao__c criaEstrategiaAtiva() 
    {
        Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();
        
        estrategia.Ativado__c = true;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(+1);
        estrategia.Data_Fim_Vigencia__c = System.today().addDays(+2);
        estrategia.Quantidade_Maxima_Tentativas__c = 10;
        estrategia.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrategia.Id_Relatorio_Estrategia__c = getReportId();
        
        FilasCriadas filasCriadas = getFilas();
        estrategia.Fila_Nova__c = filasCriadas.filaNovos.Id;
        estrategia.Fila_Agendado__c = filasCriadas.filaAgendado.Id;
        estrategia.Fila_Contatado__c = filasCriadas.filaSemContato.Id;
        
        return estrategia;
    }
    
    @TestVisible public static Estrategia_Implantacao__c criaEstrategiaVencida() 
    {
        Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();
        
        estrategia.Ativado__c = true;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(+1);
        estrategia.Data_Fim_Vigencia__c = System.today().addDays(+2);
        estrategia.Quantidade_Maxima_Tentativas__c = 10;
        estrategia.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrategia.Id_Relatorio_Estrategia__c = getReportId();
        
        // Fila fixa, para testar relacionamento com oportunidades
        Group fila = [SELECT Id from Group LIMIT 1];
        estrategia.Fila_Nova__c = fila.Id;
        estrategia.Fila_Agendado__c = fila.Id;
        estrategia.Fila_Contatado__c = fila.Id;
        
        insert estrategia;
        
        return estrategia;
    }
    
    @TestVisible public static String getReportId() {

        BatchEstrategiaNaoProcessadas batch = new BatchEstrategiaNaoProcessadas();

        List <Report> reportList = DAOReport.getReportByFolder('Implantação - Gestão de Estratégia');
        String reportId = '';
        
        for (Report report :reportList)
        {
            Set<Id> setOpp = batch.getOppsByReport(report.Id);
            if ( !setOpp.isEmpty() && setOpp.size() > 0 )
            {
                System.debug('#ACHOU Relat teste');
                reportId = String.valueOf(report.Id);
                break;
            }
        }

        return reportId;
        
    }
    
    @TestVisible public static FilasCriadas getFilas() 
    {
        FilasCriadas filasCriadas = new FilasCriadas();
        
        String estrategiaNovosDeveloperName = 'Test99997' + '_Novos';
        String estrategiaAgendadoDeveloperName = 'Test99997' + '_Agendado';
        String estrategiaSemContatoDeveloperName = 'Test99997'  + '_SemContato';
        
        String estrategiaNovosName = estrategiaNovosDeveloperName;
        String estrategiaAgendadoName = estrategiaAgendadoDeveloperName;
        String estrategiaSemContatoName = estrategiaSemContatoDeveloperName;
        
        CtrlEstrategiaImplantacaoUsuarios ctrl = new CtrlEstrategiaImplantacaoUsuarios();
        
         Map<String,QueueRoutingConfig> idsQueueRouting = ctrl.getIdsQueueRouting();
        
         String novosPedidos = 'Roteamento_Novos_Pedidos2';
         String contatoPedidos = 'Roteamento_N_o_consegue_contato_Pedidos2';
         String contatoAgendado = 'Roteamento_Contato_Agendado_Pedidos2';
        
         QueueRoutingConfig idNovos = idsQueueRouting.get(novosPedidos);
         QueueRoutingConfig idAgendado = idsQueueRouting.get(contatoAgendado);
         QueueRoutingConfig idSemContato = idsQueueRouting.get(contatoPedidos);
        
        Group novoGroup = new Group();
        
        novoGroup.Name = estrategiaNovosName;
        novoGroup.DeveloperName = estrategiaNovosDeveloperName;
        novoGroup.Type = 'Queue';
        novoGroup.QueueRoutingConfigId = idNovos.id;
        insert novoGroup;
        //System.debug('filasCriadas : ' + filasCriada);
          
        //Criando fila para agendado.
        Group agendadoGroup = new Group();
        
        agendadoGroup.Name = estrategiaAgendadoName;
        agendadoGroup.DeveloperName = estrategiaAgendadoDeveloperName;
        agendadoGroup.Type = 'Queue';
        agendadoGroup.QueueRoutingConfigId = idAgendado.id;
        insert agendadoGroup;
        //Criando fila (sem contato).
        Group semContatoGroup = new Group();
        
        semContatoGroup.Name = estrategiaSemContatoName;
        semContatoGroup.DeveloperName = estrategiaSemContatoDeveloperName;
        semContatoGroup.Type = 'Queue';
        semContatoGroup.QueueRoutingConfigId = idSemContato.id;
        insert semContatoGroup;
        
        filasCriadas.filaNovos = novoGroup;
        filasCriadas.filaAgendado = agendadoGroup;
        filasCriadas.filaSemContato = semContatoGroup;
        
        System.debug('filas criadas : ' + filasCriadas);
        
        
        //List<Group> filasCriadas = new List<Group>();
        
        
        
        
        
       /* ctrl.criaGroup(estrategiaNovosDeveloperName, estrategiaAgendadoDeveloperName, estrategiaSemContatoDeveloperName,
                  estrategiaNovosName,estrategiaAgendadoName,estrategiaSemContatoName);
        
        filasCriadas.filaNovos = DAOGroup.getDeveloperNameGroup(estrategiaNovosDeveloperName, 'Queue');
        filasCriadas.filaAgendado = DAOGroup.getDeveloperNameGroup(estrategiaAgendadoDeveloperName, 'Queue');
        filasCriadas.filaSemContato = DAOGroup.getDeveloperNameGroup(estrategiaSemContatoDeveloperName, 'Queue');*/
        
        
        return filasCriadas;
    }

    @TestVisible public static String criaOportunidade(String idEstrategia) 
    {
        String filaPedido = '';
        Opportunity opp = new Opportunity();
        List<Opportunity> lstOpp = new List<Opportunity>();
        
        BatchEstrategiaNaoProcessadas batch = new BatchEstrategiaNaoProcessadas();

        List <Report> reportList = DAOReport.getReportByFolder('Implantação - Gestão de Estratégia');
        System.debug('reportList.size: '+reportList.size());

        String reportId = '';
        
        Set<Id> setOpp = new Set<Id>();
        //setOpp = batch.getOppsByReport(reportList[0].Id);
        
        for (Report rep : reportList)
        {
            setOpp = batch.getOppsByReport(rep.Id);
            System.debug('setOpp.size: '+setOpp.size());
            if (setOpp.size() > 0)
            {
                break;
            }
        }
        
        if ( !setOpp.isEmpty() && setOpp.size() > 0 )
        {
            lstOpp = new List<Opportunity>();
            System.debug('Lista todos:');
            for (String idOpp :setOpp)
            {
                System.debug(idOpp);
                opp.Id = idOpp;
                opp.Estrategia_Implantacao__c = idEstrategia;
                lstOpp.add(opp);
            }
        }

        System.debug('lstOpp.size(): '+lstOpp.size());
        if (lstOpp.size() > 0)
        {
            Map<Id, Opportunity> mapUpdOpp = new Map<Id, Opportunity>();
            mapUpdOpp.putAll(lstOpp);
            update mapUpdOpp.values();
            
            //Obter a lista de Oportunidades da Estratégia
            List<Opportunity> lstOpp2 = DAOOpportunity.getOpportunityForSetId(setOpp);
            System.debug('lstOpp2.size: '+lstOpp2.size());
            for (Opportunity opp2 :lstOpp2)
            {
                if (opp2.Processo_Implantacao__r.OwnerId != null)
                {
                    filaPedido = opp2.Processo_Implantacao__r.OwnerId;
                    System.debug('Tem Pedido: '+opp2.Processo_Implantacao__r.OwnerId);
                    break;
                } else
                {
                    System.debug('Não tem Pedido');
                }
            }
            
        }
        return filaPedido;
    }
    
     public class FilasCriadas
    {
        public Group filaNovos {get;set;}
        public Group filaAgendado {get;set;}
        public Group filaSemContato {get;set;}
    }

}