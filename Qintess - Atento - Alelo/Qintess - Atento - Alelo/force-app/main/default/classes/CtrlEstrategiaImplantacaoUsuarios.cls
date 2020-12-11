global with sharing class CtrlEstrategiaImplantacaoUsuarios {
    
    public boolean displayModalNova {get; set;}
    public boolean displayModalAtivado {get; set;}
    public boolean validaBotaoAtivar {get; set;}


    public String idEstrategia {get; set;}
    public String estrategiaNovosDeveloperName {get; set;}
    public String estrategiaAgendadoDeveloperName {get; set;}
    public String estrategiaSemContatoDeveloperName {get; set;}
  
    public String estrategiaNovosName {get; set;}
    public String estrategiaAgendadoName {get; set;}
    public String estrategiaSemContatoName {get; set;}

    public String idEstrategiaNovos {get; set;}
    public String idEstrategiaAgendado {get; set;}
    public String idEstrategiaSemContato {get; set;}
    public String nomeEstrategiaNovos {get; set;}
    public String nomeEstrategiaAgendado {get; set;}
    public String nomeEstrategiaContato {get; set;}


    public List<String> selectedUserIds { get; set; }
    public List<String> removedUserIds { get; set; }
    public Map<id,String> mapIdsQueueRouting { get; set; }
    public String whereClause { get; set; }
    
     private Map<Id, String> availableUsersMap;
    @TestVisible private Map<Id, String> selectedUsersMap;
     private Map<Id, String> mapaUsuarios;
    

    public final String implantacao = 'Implantação';
    public final String novosPedidos = 'Roteamento_Novos_Pedidos2';
    public final String contatoPedidos = 'Roteamento_N_o_consegue_contato_Pedidos2';
    public final String contatoAgendado = 'Roteamento_Contato_Agendado_Pedidos2';

    public final String implantacaoDeveloperName = 'ImplantacoEstrategica';
    public final String implantacaoName = 'ImplantaçãoEstratégica';
    public final String typeQueue = 'Queue';
    public final String sObjType = 'Order';

    public final String comecoDaFila = '00001';


    public CtrlEstrategiaImplantacaoUsuarios() {
        initializeCollections();
        getUsers();
    }
    
    private void initializeCollections() {
        selectedUserIds = new List<String>();
        removedUserIds = new List<String>();
        availableUsersMap = new Map<Id, String>();
        selectedUsersMap = new Map<Id, String>();
    }
    
    private void getUsers() {
        
        List<Profile> listaPerfis = DAOProfile.getProfileByContainsName(implantacao);
        List<User> userLista = DAOUser.getUserIsActiveByProfile( listaPerfis);
        for (User u : userLista) {
            availableUsersMap.put(u.Id, u.Name);
        }
    }
    
    public void add() {
        if (!selectedUserIds.isEmpty()) {
            for (String userId : selectedUserIds) {
                System.debug('USUARIOS ADD : ' + selectedUserIds);
                System.debug('MAP + ' + availableUsersMap.get(userId));
                selectedUsersMap.put(userId, availableUsersMap.get(userId));
                System.debug('Selected map : ' + selectedUsersMap);
                availableUsersMap.remove(userId);
            }
        }
    }
    
    public void remove() {
        if (!removedUserIds.isEmpty()) {
            for (String userId : removedUserIds) {
                availableUsersMap.put(userId, selectedUsersMap.get(userId));
                selectedUsersMap.remove(userId);
                
            }
        }
    }
    
    public List<SelectOption> getAvailableUsers() {
        List<SelectOption> availableUsers = new List<SelectOption>();
        for (Id userId : availableUsersMap.keySet()) {
            availableUsers.add(new SelectOption(userId, availableUsersMap.get(userId)));
        }
        return availableUsers;
    }
    
    public List<SelectOption> getSelectedUsers() {
        List<SelectOption> selectedUsers = new List<SelectOption>();
        for (String userId : selectedUsersMap.keySet()) {
            System.debug('user ID ' + selectedUsersMap.keySet());
            selectedUsers.add(new SelectOption(userId, selectedUsersMap.get(userId)));
        }
        System.debug('select  = ' + selectedUsers);
        return selectedUsers;
    }
    
    public void filterAvailableOptions() {
       
        availableUsersMap = new Map<Id, String>();


        System.debug('AVAIBLE USERMAPS : ' +availableUsersMap);
        selectedUserIds = new List<String>();
        String likeClause = '%' + whereClause + '%';

        List<Profile> listaPerfis = DAOProfile.getProfileByContainsName(implantacao);
        List<User> userLista = DAOUser.getUserByName(likeClause, listaPerfis);
        System.debug('lista users : ' + userLista);


        for (User u : userLista) {
              if (!selectedUsersMap.containsKey(u.Id)) {  
                   availableUsersMap.put(u.Id, u.Name);
              }
        }     
    }
    
    
    public PageReference closeModalUser(){
        System.debug('chegou no closeModal');
        
        PageReference  page = null;
        page = new PageReference('/apex/GestaoEstrategiaImplantacao'); 
        page.setRedirect(true);
        
        return page;
    }
    
    
    public  void updateEstrategia(){
        
        Estrategia_Implantacao__c estrategiaImplantacao = new Estrategia_Implantacao__c();
        estrategiaImplantacao.id = id.valueOf(idEstrategia);
        System.debug('estrategia implantacao = ' + estrategiaImplantacao.id);
        estrategiaImplantacao.Fila_Nova__c = idEstrategiaNovos;
        estrategiaImplantacao.Fila_Agendado__c = idEstrategiaAgendado;
        estrategiaImplantacao.Fila_Contatado__c = idEstrategiaSemContato;
        estrategiaImplantacao.Ativado__c = true;
        estrategiaImplantacao.Nome_Fila_Estrategia_Nova__c = nomeEstrategiaNovos;
        estrategiaImplantacao.Nome_Fila_Estrategia_Contato__c = nomeEstrategiaContato;
        estrategiaImplantacao.Nome_Fila_Estrategia_Agendado__c = nomeEstrategiaAgendado;
        
        
        String estrat = JSON.serialize(estrategiaImplantacao);
        
        AuxiliarUpdateEstrategiaImplantacao.updateEstrategiaImplant(estrat);
        
    }

    public PageReference atualizaEstrategiaImplantacao(){
        PageReference  page = null;
        
        if(!selectedUsersMap.keySet().isEmpty()){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'SUCCESS'));
            
            getNomesSoma();
            updateEstrategia();
            
            page = new PageReference('/apex/GestaoEstrategiaImplantacao'); 
            page.setRedirect(true);
            
            return page;
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'ERROR'));
            return null;
        }
        
        
    }


    /* DATA CRIAÇÃO : 24/11/2017.
     * AUTOR: FABIANO ALBINO FERREIRA.
     * NOME : getNomesSoma.
     * OBJETIVO : Obter o valor numerico do DeveloperName e atribuir + 1 a cada vez que for inserido.
     */

    public void getNomesSoma(){
        
        Group groupNameAndDeveloper = DAOGroup.getDeveloperNameGroup(implantacaoDeveloperName,typeQueue);
        String resultName = '';
        
        if(groupNameAndDeveloper == null){
            
            resultName = comecoDaFila;
            
        }
        else{
            
            String groupDeveloperNames = groupNameAndDeveloper.DeveloperName;
            String developerNameString = groupDeveloperNames.substring(21,26);
            
            String groupName = groupNameAndDeveloper.Name;
            
            Integer groupNamesInteger = integer.valueOf(developerNameString);
            groupNamesInteger++;
            
            String zerosEsquerda = '0000';
            String groupNamesConvert = String.valueOf(groupNamesInteger);
            resultName = groupNamesConvert.leftPad(5,zerosEsquerda); 
            
        }
        
        estrategiaNovosDeveloperName = implantacaoDeveloperName + resultName + '_Novos';
        estrategiaAgendadoDeveloperName = implantacaoDeveloperName + resultName + '_Agendado';
        estrategiaSemContatoDeveloperName = implantacaoDeveloperName + resultName + '_SemContato';
        
        estrategiaNovosName = implantacaoName+resultName + ' - Novos';
        estrategiaAgendadoName = implantacaoName+resultName + ' - Agendado';
        estrategiaSemContatoName  = implantacaoName+resultName + ' - SemContato';
        
        criaGroup(estrategiaNovosDeveloperName, estrategiaAgendadoDeveloperName, estrategiaSemContatoDeveloperName,
                  estrategiaNovosName,estrategiaAgendadoName,estrategiaSemContatoName);       
        
    }

    public Map<String,QueueRoutingConfig> getIdsQueueRouting(){
        Map<String,QueueRoutingConfig> mapIdsQueueRouting = DAOQueueRoutingConfig.getQueueRoutingByListDeveloperName(novosPedidos,contatoPedidos,contatoAgendado);
        
        return mapIdsQueueRouting;
    }

    /* DATA CRIAÇÃO : 24/11/2017.
     * AUTOR: FABIANO ALBINO FERREIRA.
     * NOME : criaGroup;
     * OBJETIVO : Criar GROUP utilizando DeveloperName e Name recebedidos por parametro e atribuidos aos campos
     * NAME e DEVELOPERNAME.
     */
    public void criaGroup(String devNovoName,String devAgendadoName,String devSemContatoName,
                          String nameNovos,String nameAgendado,String nameSemContato)
    {
        
        Map<String,QueueRoutingConfig> idsQueueRouting = getIdsQueueRouting();
        
        QueueRoutingConfig idNovos = idsQueueRouting.get(novosPedidos);
        QueueRoutingConfig idAgendado = idsQueueRouting.get(contatoAgendado);
        QueueRoutingConfig idSemContato = idsQueueRouting.get(contatoPedidos);
        
        // Criando fila para NOVOS.
        Group novoGroup = new Group();
        
        novoGroup.Name = nameNovos;
        novoGroup.DeveloperName = devNovoName;
        novoGroup.Type = typeQueue;
        novoGroup.QueueRoutingConfigId = idNovos.id;
        novoGroup = DAOGroup.insereGroup(novoGroup);
        System.debug('###### NOVOS GROUP : ' + novoGroup);
        
        
        //Criando fila para agendado.
        Group agendadoGroup = new Group();
        
        agendadoGroup.Name = nameAgendado;
        agendadoGroup.DeveloperName = devAgendadoName;
        agendadoGroup.Type = typeQueue;
        agendadoGroup.QueueRoutingConfigId = idAgendado.id;
        agendadoGroup = DAOGroup.insereGroup(agendadoGroup);
        System.debug('######### Agendado Group : ' + agendadoGroup);
        
        
        //Criando fila (sem contato).
        Group semContatoGroup = new Group();
        
        semContatoGroup.Name = nameSemContato;
        semContatoGroup.DeveloperName = devSemContatoName;
        semContatoGroup.Type = typeQueue;
        semContatoGroup.QueueRoutingConfigId = idSemContato.id;
        
        semContatoGroup = DAOGroup.insereGroup(semContatoGroup);
        System.debug('######## Sem Contato : ' + semContatoGroup);
        
        
        idEstrategiaNovos = String.valueOf(novoGroup.id);
        idEstrategiaAgendado = String.valueOf(agendadoGroup.id);
        idEstrategiaSemContato = String.valueOf(semContatoGroup.id);
        nomeEstrategiaNovos = novoGroup.Name;
        nomeEstrategiaAgendado = agendadoGroup.Name;
        nomeEstrategiaContato = semContatoGroup.Name;
        
        
        criaQueueSobject(novoGroup.id, agendadoGroup.id, semContatoGroup.id);
        criaGroupMember(novoGroup.id,agendadoGroup.id, semContatoGroup.id);
        
    }

    /* DATA CRIAÇÃO : 27/11/2017.
     * AUTOR: FABIANO ALBINO FERREIRA.
     * NOME: criaQueueSobject.
     * OBJETIVO : Criar QueueSobject atribuindo id das filas recebidas por parametro
     * no campo QUEUEID.
     */
    public void criaQueueSobject (id novoGroup, id agendadoGroup, id semContatoGroup){
        System.debug('id novo group = ' + novoGroup);
        
        List<QueueSobject> listQueueSobject =  new List<QueueSobject>();
        
        
        QueueSobject queueObjNovo = new QueueSobject();
        queueObjNovo.QueueId = novoGroup;
        queueObjNovo.SobjectType = sObjType;
        
        QueueSobject queueObjAgendado = new QueueSobject();
        queueObjAgendado.QueueId = agendadoGroup;
        queueObjAgendado.SobjectType = sObjType;
        
        QueueSobject queueObjSemContato = new QueueSobject();
        queueObjSemContato.QueueId = semContatoGroup;
        queueObjSemContato.SobjectType = sObjType;
        
        listQueueSobject.add(queueObjNovo);
        listQueueSobject.add(queueObjAgendado);
        listQueueSobject.add(queueObjSemContato);
        
        DAOQueueSObject.insereQueueSobject(listQueueSobject);
        
    }

    /* DATA CRIAÇÃO : 27/11/2017.
     * AUTOR: FABIANO ALBINO FERREIRA.
     * NOME: criaQueueSobject.
     * OBJETIVO : Criar GroupMember atribuindo id das filas recebidas por parametro
     * no campo GroupId e inserindo ID dos usuários selecionados ao campo UserOrGroupId..
     */

    public void criaGroupMember(id novoGroup, id agendadoGroup, id semContatoGroup){
        
        System.debug('selectedUsersMap.keySet()) : ' + selectedUsersMap.keySet());
        List<GroupMember> listMembergr = new List<GroupMember>();
        
        
        for(String idsGroup : selectedUsersMap.keySet()){

            System.debug('selectedUsersMap.keySet()) : ' + selectedUsersMap.keySet());

            System.debug('ids Group : ' + idsGroup);


            GroupMember membergrNovo = new GroupMember();
            membergrNovo.UserOrGroupId = idsGroup;
            membergrNovo.GroupId = novoGroup;
            
            System.debug('membergrNovo = ' +membergrNovo );
            
            GroupMember membergrAgendado = new GroupMember();
            membergrAgendado.UserOrGroupId = idsGroup;
            membergrAgendado.GroupId = agendadoGroup;
            
            System.debug('membergrNovo = ' + membergrAgendado );
            
            GroupMember membergrSemContato = new GroupMember();
            membergrSemContato.UserOrGroupId = idsGroup;
            membergrSemContato.GroupId = semContatoGroup;
            
            System.debug('membergrNovo = ' + membergrSemContato );
            
            listMembergr.add(membergrNovo);
            listMembergr.add(membergrAgendado);
            listMembergr.add(membergrSemContato);
            

        }

          List<GroupMember> listRetornoGroupMember = DAOGroupMember.getInstance().insereGroupMember(listMembergr);
            System.debug('Lista  : ' + listRetornoGroupMember);
        
        
    }
    
}