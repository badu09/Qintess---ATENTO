public with sharing class CtrlEnvioEmailModeloProposta {
    public Id idOpportunity { get; set; }
    public Opportunity objOportunidade { get; set; }
    public Task task { get; set; }
    public Boolean isException { get; set; }
    public Boolean isSucess { get; set; }
    public List<Contact> listContact { get; set; }
    public SelectOption[] selectedContacts { get; set; }
    public SelectOption[] allContacts { get; set; }
    public List<String> addContacts { get; set; }
    public String addEmails { get; set; }
    public List<OrgWideEmailAddress> listOrgWideEmailAddress { get; set; }
    public SelectOption[] selectedContactFrom { get; set; }
    public String contactFrom { get; set; }
    public List<Attachment> listAttachment { get; set; }
    public SelectOption[] selectedAttachments { get; set; }
    public SelectOption[] allAttachments { get; set; }
    private enum cartao {Refeicao, Alimentacao, Transporte, FlexCar, Cultura, NatalAlimentacao, Mobilidade}
    public Boolean callTest { get; set; }
    public Boolean showIframe { get; set; }
    public String emailBody { get; set; }

    public CtrlEnvioEmailModeloProposta() {
        init();
    }

    public CtrlEnvioEmailModeloProposta(ApexPages.StandardController controller) {
        init();
    }

    public void init() {
        this.addContacts = new List<String>();
        this.addEmails = JSON.serializePretty(this.addContacts);
        this.idOpportunity = ApexPages.currentPage().getParameters().get('id');
        String showIframeStr = ApexPages.currentPage().getParameters().get('showIframe');
        if(showIframeStr != null && showIframeStr == 'true') {
        	showIframe = true;
        }
        else {
        	showIframe = false;
        }
        this.objOportunidade = DAOOpportunity.getOpportunityById(this.idOpportunity);
        this.isException = false;
        this.loadContact();
        this.loadContactFrom();
        this.loadAttachment();
        this.callTest = false;
    }

    public void loadContactFrom() {
        this.selectedContactFrom = new List<SelectOption>();
        this.listOrgWideEmailAddress = DAOOrgWideEmailAddress.getEmailAddress();

        for (OrgWideEmailAddress c : listOrgWideEmailAddress) {
            this.selectedContactFrom.add(new SelectOption(c.Id, c.Address));
        }
    }

    public void loadAttachment() {
        this.selectedAttachments = new List<SelectOption>();
        this.allAttachments = new List<SelectOption>();
        this.listAttachment = DAOAttachment.getAttachmentByParentId(this.objOportunidade.Id);

        for (Attachment attach : this.listAttachment) {
            allAttachments.add(new SelectOption(attach.Id, attach.Name));
        }
    }

    private List<Id> getAttachmentAdd() {
        List<Id> listRetorno = new List<Id>();

        system.debug('this.selectedAttachments 1: ' + this.selectedAttachments);

        for (SelectOption so : this.selectedAttachments) {
            listRetorno.add(so.getValue());
        }

        return listRetorno;
    }

    public void loadContact() {
        this.selectedContacts = new List<SelectOption>();
        this.allContacts = new List<SelectOption>();
        this.listContact = DAOContact.getContactByAccountId(this.objOportunidade.Account.Id);

        for (Contact c : listContact) {
            allContacts.add(new SelectOption(c.Id, c.Name));
        }
    }

    private List<Id> getContactEmailAdd() {
        List<Id> listRetorno = new List<Id>();

        system.debug('this.selectedContacts 1: ' + this.selectedContacts);

        for (SelectOption so : this.selectedContacts) {
            listRetorno.add(so.getValue());
        }

        return listRetorno;
    }

    private List<Id> getContactEmail() {
        List<Id> listRetorno = this.getContactEmailAdd();
        listRetorno.add(this.objOportunidade.Contato_da_oportunidade__r.Id);

        return listRetorno;
    }

    private Attachment getAttachment() {
        PageReference objPageReference = new PageReference('/apex/ModeloPropostaPDF?id=' + this.idOpportunity);
        Attachment objAttachment = new Attachment();

        objAttachment.Name = 'Proposta_' + this.objOportunidade.Account.Name + '.pdf';
        objAttachment.ContentType = 'application/pdf';
        objAttachment.Body = objPageReference.getContentAsPDF();

        return objAttachment;
    }

    private List<Attachment> getAllAtachment() {
        List<Attachment> listRetorno = new List<Attachment>();
        List<Id> listAttachmentAdd = this.getAttachmentAdd();

        if(!this.callTest && this.showIframe)
            listRetorno.add(this.getAttachment());

        for (Attachment aAll : this.listAttachment) {
            for(Id atachmentId : listAttachmentAdd) {

                system.debug('aAll.Id' + aAll.Id);
                system.debug('atachmentId' + atachmentId);

                if(aAll.Id == atachmentId)
                    listRetorno.add(aAll);
            }
        }

        return listRetorno;
    }

    private List<String> getContactEmailCC() {
        List<String> listaRetorno = (List<String>)JSON.deserialize(this.addEmails, List<String>.class);
        EmailServicesAddress objEmailServicesAddress = DAOEmailServicesAddress.getByLocalPart('emailopportunityprocess');

        if(objEmailServicesAddress != null)
            listaRetorno.add('emailopportunityprocess@' + objEmailServicesAddress.EmailDomainName);

        return listaRetorno;
    }

    private String generateBodyEmail() {
        String htmlBody = null;
        CtrlModeloPropostaPDF objModeloPropostaPDF = new CtrlModeloPropostaPDF(this.idOpportunity);

        // System.debug('this.objOportunidade.Codigo_do_Banco__c: ' + this.objOportunidade.Codigo_do_Banco__c);

        if(this.objOportunidade.Codigo_do_Banco__c == '237') {
            htmlBody = DAOEmailTemplate.obterTemplatePorNome('Proposta_Bradesco').HtmlValue;
        } else if(this.objOportunidade.Codigo_do_Banco__c == '1') {
            htmlBody = DAOEmailTemplate.obterTemplatePorNome('Proposta_Banco_do_Brasil').HtmlValue;
        } else if(this.objOportunidade.Codigo_do_Banco__c == '33') {
            htmlBody = DAOEmailTemplate.obterTemplatePorNome('Proposta_Santander').HtmlValue;
        } else {
            htmlBody = DAOEmailTemplate.obterTemplatePorNome('Proposta_Alelo_1140033663').HtmlValue;
        }

        //Valores dos cartões
        //htmlBody = htmlBody.replace('#alelo-contato-name', this.objOportunidade.Contato_da_oportunidade__r.Name);
        //htmlBody = htmlBody.replace('#alelo-conta-cpf-cnpj', Util.formatCPFCNPJ(this.objOportunidade.Account.CPF_CNPJ__c));
        //htmlBody = htmlBody.replace('#alelo-cartao-refeicao', this.generateHtmlCartao(objModeloPropostaPDF.aleloRefeicao, cartao.Refeicao));
        //htmlBody = htmlBody.replace('#alelo-cartao-alimentacao', this.generateHtmlCartao(objModeloPropostaPDF.aleloAlimentacao, cartao.Alimentacao));
        //htmlBody = htmlBody.replace('#alelo-cartao-transporte', this.generateHtmlCartao(objModeloPropostaPDF.aleloNatalAlimentacao, cartao.NatalAlimentacao));
        //htmlBody = htmlBody.replace('#alelo-cartao-flex-car', this.generateHtmlCartao(objModeloPropostaPDF.aleloValeTransporte, cartao.Transporte));
        //htmlBody = htmlBody.replace('#alelo-cartao-cultura', this.generateHtmlCartao(objModeloPropostaPDF.aleloFlexCar, cartao.FlexCar));
        //htmlBody = htmlBody.replace('#alelo-cartao-natal-alimentacao', this.generateHtmlCartao(objModeloPropostaPDF.aleloCultura, cartao.Cultura));
        htmlBody = htmlBody.replace('#alelo-contato-name', this.objOportunidade.Contato_da_oportunidade__r.Name);
        htmlBody = htmlBody.replace('#alelo-conta-cpf-cnpj', Util.formatCPFCNPJ(this.objOportunidade.Account.CPF_CNPJ__c));
        htmlBody = htmlBody.replace('#alelo-cartao-refeicao', this.generateHtmlCartao(objModeloPropostaPDF.aleloRefeicao, cartao.Refeicao));
        htmlBody = htmlBody.replace('#alelo-cartao-alimentacao', this.generateHtmlCartao(objModeloPropostaPDF.aleloAlimentacao, cartao.Alimentacao));
        htmlBody = htmlBody.replace('#alelo-cartao-transporte', this.generateHtmlCartao(objModeloPropostaPDF.aleloValeTransporte, cartao.Transporte));
        htmlBody = htmlBody.replace('#alelo-cartao-flex-car', this.generateHtmlCartao(objModeloPropostaPDF.aleloFlexCar, cartao.FlexCar));
        htmlBody = htmlBody.replace('#alelo-cartao-mobilidade', this.generateHtmlCartao(objModeloPropostaPDF.aleloMobilidade, cartao.Mobilidade));
        htmlBody = htmlBody.replace('#alelo-cartao-cultura', this.generateHtmlCartao(objModeloPropostaPDF.aleloCultura, cartao.Cultura));
        htmlBody = htmlBody.replace('#alelo-cartao-natal-alimentacao', this.generateHtmlCartao(objModeloPropostaPDF.aleloNatalAlimentacao, cartao.NatalAlimentacao));
        htmlBody = htmlBody.replaceAll('#alelo-canal-proposta', this.objOportunidade.Canal_Propostas_Receptivo__c);

        //Descontos dos cartões
        htmlBody = htmlBody.replace('#alelo-desconto-refeicao', '&nbsp;');
        htmlBody = htmlBody.replace('#alelo-desconto-alimentacao', '&nbsp;');
        // system.debug('htmlBody: ' + JSON.serialize(htmlBody));
        return htmlBody;
    }

    private String generateHtmlCartao(Produtos_Alelo__c product, cartao gerar) {
        String retorno = '';

        if(product == null)
            product = new Produtos_Alelo__c();

        if(gerar == cartao.Refeicao || gerar == cartao.Alimentacao || gerar == cartao.NatalAlimentacao) {
        	if(product.Quantidade_de_Cartoes__c == null || product.Quantidade_de_Cartoes__c <= 0)
        		return '';
            retorno = this.generateHtmlCartao('Quantidade de cartões', String.valueOf((product.Quantidade_de_Cartoes__c == null ? 0 : product.Quantidade_de_Cartoes__c)));
            retorno = retorno + this.generateHtmlCartao('Valor Mensal por Cartão', Util.formatCurrency(product.Valor_Unitario__c));
            System.debug('product.Tarifas_Carrinhos__r: ' + JSON.serialize(product.Tarifas_Carrinhos__r));
            for(Tarifas_Carrinho__c tc : product.Tarifas_Carrinhos__r) {
                if(tc.Codigo_da_Tarifa__c==5 || tc.Codigo_da_Tarifa__c==7 || tc.Codigo_da_Tarifa__c==1 ||
                    tc.Codigo_da_Tarifa__c==4 || tc.Codigo_da_Tarifa__c==2) {
                    	if((tc.Codigo_da_Tarifa__c==4 || tc.Codigo_da_Tarifa__c==2) || (tc.Valor_Unitario__c != null && tc.Valor_Unitario__c > 0))
                        	retorno = retorno + generateHtmlCartao(tc.Nome_da_Tarifa__c, Util.formatCurrency(tc.Valor_Unitario__c));
                    }
            }
        } else if(gerar == cartao.Transporte) {
        	if((product.Quantidade_de_usuarios_VT_papel__c == null || product.Quantidade_de_usuarios_VT_papel__c <= 0)
        		&& (product.Quantidade_de_usuarios_VT_cartao__c == null || product.Quantidade_de_usuarios_VT_cartao__c <= 0))
        		return '';
            retorno = this.generateHtmlCartao('Quantidade de usuários VT papel', String.valueOf((product.Quantidade_de_usuarios_VT_papel__c == null ? 0 : product.Quantidade_de_usuarios_VT_papel__c)));
            retorno = retorno + this.generateHtmlCartao('Quantidade de usuários VT cartão', String.valueOf((product.Quantidade_de_usuarios_VT_cartao__c == null ? 0 : product.Quantidade_de_usuarios_VT_cartao__c)));
            retorno = retorno + this.generateHtmlCartao('Valor médio mensal de compra', Util.formatCurrency(product.Valor_medio_mensal_de_compra__c));
            retorno = retorno + this.generateHtmlCartao('Quantidade de pontos de entrega', String.valueOf((product.Quantidade_de_pontos_de_entrega__c == null ? 0 : product.Quantidade_de_pontos_de_entrega__c)));
            retorno = retorno + this.generateHtmlCartao('Taxa de serviço', String.valueOf((product.Taxa_de_servico__c == null ? 0 : product.Taxa_de_servico__c)));
            retorno = retorno + this.generateHtmlCartao('Tarifa de atendimento', String.valueOf((product.Tarifa_de_atendimento__c == null ? 0 : product.Tarifa_de_atendimento__c)));
            retorno = retorno + this.generateHtmlCartao('Tarifa de Gerenciamento', String.valueOf((product.Tarifa_de_Gerenciamento__c == null ? 0 : product.Tarifa_de_Gerenciamento__c)));

            for(Tarifas_Carrinho__c tc : product.Tarifas_Carrinhos__r) {
                if(tc.Codigo_da_Tarifa__c==5 || tc.Codigo_da_Tarifa__c==2) {
                		if(tc.Valor_Unitario__c != null && tc.Valor_Unitario__c > 0)
                        	retorno = retorno + generateHtmlCartao(tc.Nome_da_Tarifa__c, Util.formatCurrency(tc.Valor_Unitario__c));
                    }
            }
        } else if(gerar == cartao.FlexCar || gerar == cartao.Mobilidade) {
        	if(product.Quantidade_de_Cartoes__c == null || product.Quantidade_de_Cartoes__c <= 0)
        		return '';
            retorno = this.generateHtmlCartao('Quantidade de cartões', String.valueOf((product.Quantidade_de_Cartoes__c == null ? 0 : product.Quantidade_de_Cartoes__c)));
            retorno = retorno + this.generateHtmlCartao('Valor Mensal por Cartão', Util.formatCurrency(product.Valor_Unitario__c));

            for(Tarifas_Carrinho__c tc : product.Tarifas_Carrinhos__r) {
                if(tc.Codigo_da_Tarifa__c==5 || tc.Codigo_da_Tarifa__c==7 || tc.Codigo_da_Tarifa__c==3 || tc.Codigo_da_Tarifa__c==14) {
                		if(tc.Valor_Unitario__c != null && tc.Valor_Unitario__c > 0)
                        	retorno = retorno + generateHtmlCartao(tc.Nome_da_Tarifa__c, Util.formatCurrency(tc.Valor_Unitario__c));
                    }
            }
        } else if(gerar == cartao.Cultura) {
        	if(product.Quantidade_de_Cartoes__c == null || product.Quantidade_de_Cartoes__c <= 0)
        		return '';
            retorno = this.generateHtmlCartao('Quantidade de cartões', String.valueOf((product.Quantidade_de_Cartoes__c == null ? 0 : product.Quantidade_de_Cartoes__c)));

            if(product.Disponibilizacao_mensal__c != null && product.Disponibilizacao_mensal__c > 0)
            	retorno = retorno + this.generateHtmlCartao('Disponibilização mensal', Util.formatCurrency(product.Disponibilizacao_mensal__c));

            for(Tarifas_Carrinho__c tc : product.Tarifas_Carrinhos__r) {
                if(tc.Codigo_da_Tarifa__c==5 || tc.Codigo_da_Tarifa__c==7 || tc.Codigo_da_Tarifa__c==2 || tc.Codigo_da_Tarifa__c==4 || tc.Codigo_da_Tarifa__c==2) {
                		if((tc.Codigo_da_Tarifa__c==4 || tc.Codigo_da_Tarifa__c==2) || (tc.Valor_Unitario__c != null && tc.Valor_Unitario__c > 0))
                        	retorno = retorno + generateHtmlCartao(tc.Nome_da_Tarifa__c, Util.formatCurrency(tc.Valor_Unitario__c));
                    }
            }
        }

        return retorno;
    }

    private String generateHtmlCartao(String label, String value) {
        String retorno = null;

        retorno = '<tr>';
        retorno = retorno + '   <td width="419" align="left" bgcolor="#f5f5f1" style="font-family:Arial, Helvetica, sans-serif; font-size:15px; color:#666666; line-height:20px; padding-left:20px">{0}</td>';
        retorno = retorno + '   <td width="127" align="left" bgcolor="#f5f5f1" style="font-family:Arial, Helvetica, sans-serif; font-size:15px; color:#666666; line-height:20px; padding-left:20px; font-weight:bold">{1}</td>';
        retorno = retorno + '</tr>';
        retorno = String.format(retorno, new List<String>{label, value});

        return retorno;
    }

    public void enviarEmail() {
        Id templateId = null;
        String htmlBody = null;
        List<Id> listContactEmail = null;
        List<string> listContactEmailCC = null;
        Blob objBlobAttach = null;
        List<Attachment> listAttachment = null;
        String subject;
        if(showIframe) {
        	subject = 'PROPOSTA COMERCIAL ALELO [ref:' + this.idOpportunity + ']';
        }
        else {
        	subject = 'Contra Proposta - ' + this.objOportunidade.Account.Razao_Social__c + ' [ref:' + this.idOpportunity + ']';
        }

        system.debug('enviarEmail');

        try
        {
            /*if(this.oportunidade.StatusAprovacao__c != 'Aprovado pelo planejamento'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Para enviar essa proposta o Status da Aprovação deve ser "Aprovado pelo planejamento".'));
                return;
            }*/

            if(this.objOportunidade.Contato_da_oportunidade__r == null || this.objOportunidade.Contato_da_oportunidade__r.Email == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Contato não identificado.'));
                return;
            }

            listContactEmail = this.getContactEmail();
            listContactEmailCC = getContactEmailCC();
            if(!showIframe) {
            	htmlBody = this.emailBody;
            }
            else {
	            if(this.objOportunidade.RecordType.DeveloperName != 'Vendas_PREPAX')
	                htmlBody = generateBodyEmail();
	            else
	                templateId = DAOEmailTemplate.obterTemplatePorNome('Prepax').id;
            }

        	listAttachment = this.getAllAtachment();

            // system.debug('showIframe: ' + showIframe);
            system.debug('listContactEmail: ' + listContactEmail);
            system.debug('listContactEmailCC: ' + listContactEmailCC);
            system.debug('templateId: ' + templateId);
            system.debug('listAttachment: ' + listAttachment);

            this.isSucess = Util.sendEmailAttach(listAttachment, listContactEmail, listContactEmailCC, htmlBody, templateId, true, false, this.idOpportunity, subject, contactFrom);

            system.debug('this.isException: ' + this.isException);

            if(this.isSucess) {
                this.objOportunidade.E_mail_Enviado__c = true;
                update this.objOportunidade;

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Email enviado.'));
            }
        }
        catch(EmailException ex)
        {
            system.debug('EmailException: ' + ex + '\n' + ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro: Conta de e-mail inválida.'));
        }
        catch(Exception ex)
        {
            system.debug('Exception: ' + ex + '\n' + ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro:' + ex.getMessage()));
        }
    }
}