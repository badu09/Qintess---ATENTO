public with sharing class CtrlDesdobramentoMetaUsuario {
    public String nomeDesdobramento { get; set; }
	public String mensagem { get; set; }
	public List<User> listUser { get; set; }
	public SelectOption[] selectOptionSupervisor { get; set; }
    public SelectOption[] selectedUsers { get; set; }
    public SelectOption[] allUsers { get; set; }
    public List<String> addUsers { get; set; }
    public Id idDesdobramento { get; set; }
    public Id idSupervisor { get; set; }
    public Desdobramento__c desdobramento { get; set; }
    public List<Desdobramento_Usuario__c> listDesdobramentoUsuarioDesdobramento { get; set; }
    public List<Desdobramento_Usuario__c> listDesdobramentoUsuarioSupervisor { get; set; }
    public List<Desdobramento_Usuario__c> listSelectedDesdobramentoUsuario { get; set; }
    public List<Desdobramento_Usuario__c> listDeletedDesdobramentoUsuario { get; set; }
    public map<Id, Integer> mapUser { get; set; }
    public map<String, Desdobramento_Usuario__c> mapDesdobramentoUsuario { get; set; }

	public CtrlDesdobramentoMetaUsuario(ApexPages.StandardController standardController) {
		this.init();
	}
	
	public void init() {
		try {
			this.listSelectedDesdobramentoUsuario = new List<Desdobramento_Usuario__c>();
			this.listDeletedDesdobramentoUsuario = new List<Desdobramento_Usuario__c>();
			this.idDesdobramento = ApexPages.currentPage().getParameters().get('idDesdobramentoMeta');
			this.desdobramento = DAODesdobramento.getById(this.idDesdobramento);
			this.idDesdobramento = this.desdobramento.Id;
			this.idSupervisor = null;
	        this.addUsers = new List<String>();
	        this.allUsers = new List<SelectOption>();
	        this.selectedUsers = new List<SelectOption>();
	        this.mapDesdobramentoUsuario = new map<String, Desdobramento_Usuario__c>();
	        this.loadSupervisor();
	        this.loadPageblockTableDesdobramento();
		}
        catch(Exception ex)
        {
            system.debug('Exception: ' + ex + '\n' + ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro:' + ex.getMessage()));
        }
    }
    
    private void loadSupervisor() {
		this.selectOptionSupervisor = new List<SelectOption>();
		this.selectOptionSupervisor.add(new SelectOption('', 'Selecione um Supervisor'));
		this.listUser = DAOUser.getUserByProfile(DAOProfile.getProfileByContainsName('supervisor'));

		for (User u : this.listUser) {
			this.selectOptionSupervisor.add(new SelectOption(u.Id, u.Name));
		}
	}
	
	public void loadUser() {
		try {
	        this.loadAvailableUser();
	        this.loadSelectedUser();
	        this.loadPageblockTableSupervisor();
        }
		catch(Exception ex)
        {
            system.debug('Exception: ' + ex + '\n' + ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro:' + ex.getMessage()));
        }
    }
	
    private void loadAvailableUser() {
    	this.allUsers = new List<SelectOption>();
    	this.mapUser = new map<Id, Integer>();
    	Integer index = 0;
    	
    	if(this.desdobramento.Area__c == 'Implantação')
        	this.listUser = DAOUser.getBySupervisorProfile(this.idSupervisor, DAOProfile.getProfileByContainsName('Implantação'));
        else
        	this.listUser = DAOUser.getBySupervisorProfileSale(this.idSupervisor, DAOProfile.getProfileByContainsName('Vendas'));

        for (User u : listUser) {
            this.allUsers.add(new SelectOption(u.Supervisor__r.Id + ';' + u.Id, u.Name));
            this.mapUser.put(u.Id, index);
            index++;
        }
    }
    
    private void loadSelectedUser() {
    	this.selectedUsers = new List<SelectOption>();
        List<Desdobramento_Usuario__c> listDesdobramentoUsuario = DAODesdobramentoUsuario.getByDesdobramentoSupervisor(this.idDesdobramento, this.idSupervisor);
        this.listDeletedDesdobramentoUsuario.addAll(listDesdobramentoUsuario);

        for (Desdobramento_Usuario__c d : listDesdobramentoUsuario) {
            this.selectedUsers.add(new SelectOption(d.Supervisor__r.Id + ';' + d.Operador__r.Id, d.Operador__r.Name));
            
            if(this.mapUser.containsKey(d.Operador__r.Id))
            	this.allUsers.remove(this.mapUser.get(d.Operador__r.Id));
        }
        
        this.getSelectedUser();
    }
    
    private void loadPageblockTableDesdobramento() {
    	this.listDesdobramentoUsuarioDesdobramento = DAODesdobramentoUsuario.getByDesdobramento(this.idDesdobramento);
    }
    
    private void loadPageblockTableSupervisor() {
    	this.listDesdobramentoUsuarioSupervisor = DAODesdobramentoUsuario.getBySupervisor(this.idSupervisor);
    }
    
    private List<Desdobramento_Usuario__c> getSelectedUser() {
        Desdobramento_Usuario__c objDesdobramentoUsuario = null;
        String[] idSupervisorOperador = null;

        system.debug('this.selectedUsers: ' + this.selectedUsers);

        for (SelectOption so : this.selectedUsers) {
        	idSupervisorOperador = so.getValue().split(';');
        	objDesdobramentoUsuario = new Desdobramento_Usuario__c();
        	objDesdobramentoUsuario.Name = so.getLabel();
        	objDesdobramentoUsuario.Desdobramento__c = this.idDesdobramento;
        	objDesdobramentoUsuario.Supervisor__c = idSupervisorOperador[0];
        	objDesdobramentoUsuario.Operador__c = idSupervisorOperador[1];
        	
            this.mapDesdobramentoUsuario.put(so.getValue(), objDesdobramentoUsuario);	
        }
        
        for (SelectOption so : this.allUsers) {
        	this.mapDesdobramentoUsuario.remove(so.getValue());
        }

        return this.listSelectedDesdobramentoUsuario;
    }
    
    private List<Desdobramento_Usuario__c> getSelectedUserFinal() {
        for (String idSupervisorOperador : this.mapDesdobramentoUsuario.keySet()) {
	     	this.listSelectedDesdobramentoUsuario.add(this.mapDesdobramentoUsuario.get(idSupervisorOperador));
        }

        return this.listSelectedDesdobramentoUsuario;
    }
    
    public void salvar() {
    	try {
    		if(this.idSupervisor == null){
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Selecione um Supervisor.'));
    			return;
    		}
    			
    		if(this.listDeletedDesdobramentoUsuario.size() > 0)
    			delete this.listDeletedDesdobramentoUsuario;
    		
    		this.getSelectedUser();
			insert this.getSelectedUserFinal();
			this.init();
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Vínculo de Desdobramento de Metas com Operador salvo com sucesso.'));
    	}
		catch(Exception ex)
        {
            system.debug('Exception: ' + ex + '\n' + ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro:' + ex.getMessage()));
        }
	}
	
	public PageReference voltar() {
    	PageReference pageReference = Page.DesdobramentoMetas;
    	
    	pageReference.setRedirect(true);
    	
    	return pageReference;
    }
}