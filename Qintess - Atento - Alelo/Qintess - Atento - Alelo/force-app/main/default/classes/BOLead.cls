public with sharing class BOLead {

    private static String portal;
    private static String codigoAcesso;
    private static String login;
    private static String senha;
    private static String codigoBanco;
    private static String codigoIndicacao;
    private static String codigoStatus;
    private static String codigoMotivo;
    private static String xmlCodigoStatus;
    final private static Integer encryptoBits = 128;
    final private static String encryptoAESBits = 'AES128';
    final private static Blob cryptoKey = EncodingUtil.convertFromHex('62517F712BABCA6B56B31BFA83501318');
    final private static Blob IV = EncodingUtil.convertFromHex('AB1D925753B1C8FE90E80C7D7F904711');

    private static void consultarIndicacaoCBSS(){
        try {
            WSIndicacoes.CBSSIndicacoesSoap service = new WSIndicacoes.CBSSIndicacoesSoap();
            List<Lead> leadsToInsert = new List<Lead>();
            RecordType objRecordType = DAORecordType.obterPorDeveloperName('Banco');

            service.timeout_x = 120000;

            WSIndicacoes.EConsultarIndicacaoResultCripto consultarIndicacaoResultCripto = service.ConsultarIndicacao(codigoAcesso, login, senha, codigoBanco, xmlCodigoStatus);

            System.debug('consultarIndicacaoResultCripto ' + JSON.serialize(consultarIndicacaoResultCripto));
            System.debug('consultarIndicacaoResultCripto.Codigo ' + Util.descriptografarIndicacoes(consultarIndicacaoResultCripto.Codigo));
            System.debug('consultarIndicacaoResultCripto.Mensagem ' + Util.descriptografarIndicacoes(consultarIndicacaoResultCripto.Mensagem));

            //System.debug('consultarIndicacaoResultCripto.Mensagem ' + Util.descriptografarIndicacoes(JSON.serialize(consultarIndicacaoResultCripto.Mensagem)));

            if(Util.descriptografarIndicacoes(consultarIndicacaoResultCripto.Codigo) != '0')
                return;

            if(consultarIndicacaoResultCripto.EIndicacaoCripto != null && consultarIndicacaoResultCripto.EIndicacaoCripto.EIndicacaoRelCripto != null) {
                for(WSIndicacoes.EIndicacaoRelCripto item : consultarIndicacaoResultCripto.EIndicacaoCripto.EIndicacaoRelCripto){
                    System.debug('item: ' + JSON.serialize(item));
                    Lead lead = new Lead();

                    lead.CNPJ__c = Util.descriptografarIndicacoes(item.CNPJIndicacao);
                    // lead.Codigo_Acesso__c = Util.descriptografarIndicacoes(item.CodigoAcesso);
                    lead.Codigo_Banco__c = Util.descriptografarIndicacoes(item.CodigoBanco);
                    /**
                    * campo foi removido dia 23/08/2017 devido ajuste da base de portal
                    */
                    //lead.Codigo_Indicacao__c = Util.descriptografarIndicacoes(item.CodigoIndicacao);
                    lead.Chave_Banco__c = Util.descriptografarIndicacoes(item.CodigoIndicacao);
                    // lead.Codigo_Motivo__c = Util.descriptografarIndicacoes(item.CodigoMotivo);
                    lead.Codigo_Motivo_Atual__c = Util.descriptografarIndicacoes(item.CodigoMotivoAtual);
                    // lead.Codigo_Status__c  = Util.descriptografarIndicacoes(item.CodigoStatus);
                    lead.Codigo_Status_Atual__c = Util.descriptografarIndicacoes(item.CodigoStatusAtual);
                    lead.Codigo_Usuario__c  = Util.descriptografarIndicacoes(item.CodigoUsuario);
                    String name = Util.descriptografarIndicacoes(item.NomeContatoIndicacao);
                    String[] names = name.split(' ');
                    if(names.size() > 0) {
                        lead.Firstname = names[0];
                    }
                    if(names.size() > 1) {
                        String lastName = '';
                        for(Integer i = 1; i < names.size() ; i++) {
                            lastName += ' ' + names[i];
                        }
                        lead.LastName = lastName;
                    }
                    else {
                        lead.LastName = lead.Firstname;
                    }

                    lead.Contato_2__c = Util.descriptografarIndicacoes(item.NomeContato2Indicacao);
                    // lead.Data_do_Cad astro__c  = Util.descriptografarIndicacoes(item.DatadoCadastroIndicacao);
                    // lead.Data_Venda__c = Util.descriptografarIndicacoes(item.DataVenda);
                    lead.Email = Util.descriptografarIndicacoes(item.EmailIndicacao);
                    // lead.Login__c = Util.descriptografarIndicacoes(item.Login);
                    lead.Motivo_Atual__c = Util.descriptografarIndicacoes(item.MotivoAtual);
                    lead.Nome_Fantasia_Banco__c = Util.descriptografarIndicacoes(item.NomeFantasiaBanco);
                    if(item.Observacao != null) {
                        lead.Observacao_Banco__c = Util.descriptografarIndicacoes(item.Observacao);
                    }
                    lead.Nome_Usuario__c  = Util.descriptografarIndicacoes(item.NomeUsuario);
                    lead.Numero_Agencia__c  = Util.descriptografarIndicacoes(item.NumeroAgencia);
                    String qtdeFuncionariosIndicacao = Util.descriptografarIndicacoes(item.QtdeFuncionariosIndicacao);
                    if(qtdeFuncionariosIndicacao != null && qtdeFuncionariosIndicacao != '')
                        lead.Quantidade_de_Funcionarios__c = Decimal.valueOf(qtdeFuncionariosIndicacao);
                    lead.Razao_Social_Banco__c = Util.descriptografarIndicacoes(item.RazaoSocialBanco);
                    //lead.Razao_Social__c = Util.descriptografarIndicacoes(item.RazaoSocialIndicacao);
                    String razaoSocial = Util.descriptografarIndicacoes(item.RazaoSocialIndicacao);
                    if(razaoSocial.length() > 40)
                    {
                        lead.Razao_Social__c = razaoSocial.substring(0, 39);
                    }   
                    else
                    {
                        lead.Razao_Social__c = razaoSocial;                     
                    }
                    lead.Company = Util.descriptografarIndicacoes(item.RazaoSocialIndicacao);
                    // lead.Senha__c = Util.descriptografarIndicacoes(item.Senha);
                    // lead.StatusAtual__c  = Util.descriptografarIndicacoes(item.StatusAtual);
                    if(item.flagBackoffice != null && item.flagBackoffice != '')
                    {
                        lead.flagBackoffice__c = Boolean.valueOf(Util.descriptografarIndicacoes(item.flagBackoffice));
                    }
                    
                    String ddd1 = Util.descriptografarIndicacoes(item.DDDIndicacao);
                    if(ddd1 != null && ddd1.replaceAll(' |\\t', '') != '')
                    {
                        lead.DDD__c = Decimal.valueOf(ddd1.replaceAll(' |\\t', ''));
                        lead.Phone = Decimal.valueOf(ddd1.replaceAll(' |\\t', '')) + ' ' + Util.descriptografarIndicacoes(item.TelefoneIndicacao);
                    }
                    else
                        lead.Phone = Util.descriptografarIndicacoes(item.TelefoneIndicacao);

                    String ddd2 = Util.descriptografarIndicacoes(item.DDD2Indicacao);
                    if(ddd2 != null && ddd2.replaceAll(' |\\t', '') != '')
                    {
                        lead.DDD2__c = Decimal.valueOf(ddd2.replaceAll(' |\\t', ''));
                        lead.Telefone2__c = Decimal.valueOf(ddd2.replaceAll(' |\\t', '')) + ' ' + Util.descriptografarIndicacoes(item.Telefone2Indicacao);
                    }
                    else
                        lead.Telefone2__c = Util.descriptografarIndicacoes(item.Telefone2Indicacao);

                    // lead.XML_Produto_Comercializado__c  = Util.descriptografarIndicacoes(item.XMLProdutoComercializado);

                    if(lead.Codigo_Status_Atual__c == '7'){
                        lead.Description = 'Indicação Atualizada';
                        lead.Status = 'INDICAÇÃO ATUALIZADA (007)';
                    }

                    if(objRecordType != null)
                        lead.RecordTypeId = objRecordType.Id;

                    System.debug('# lead: ' + lead);
                    
                    leadsToInsert.add(lead);
                }
            }
            
            System.debug('leadsToInsert: ' + JSON.serialize(leadsToInsert));

            List<Database.UpsertResult> upsertResult;
            if(leadsToInsert.size() > 0)
            {    
                upsertResult = Database.upsert(leadsToInsert, Lead.Fields.Chave_Banco__c, false);// insert leadsToInsert;
            }
            
            for(Database.UpsertResult theResult : upsertResult)
            {
                if(theResult.isSuccess())
                    continue;
                List<Database.Error> errors = theResult.getErrors();
                for(Database.Error theError : Errors)
                {
                    System.debug('Mensagem Erro: ' + theError.getMessage());
                    System.debug('Campo Erro: ' + theError.getFields());
                    System.debug('Codigo Erro: ' + theError.getStatusCode());
                }
            }    

        }
        catch(Exception e) {
            System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
            throw e;
        }
    }

    private static void atualizarIndicacaoCBSS(List<Lead> listLead, List<Opportunity> listOpportunity){
        try {
            system.debug('INICIO: atualizarIndicacaoCBSS');
            WSIndicacoes.CBSSIndicacoesSoap service = new WSIndicacoes.CBSSIndicacoesSoap();
            //List<Lead> listLead = DAOLead.getLeadIndicacaoBanco(codigoBanco);
            List<Lead> listLeadRetorno = new List<Lead>();
            //List<Opportunity> listOpportunity = DAOOpportunity.getOpportunityIndicacaoBanco(codigoBanco);
            List<Opportunity> listOpportunityRetorno = new List<Opportunity>();

            service.timeout_x = 120000;

            //TODO
            /*if(codigoBanco == '237')
                codigoBanco = '1';
            else if(codigoBanco == '1')
                codigoBanco = '2';
            else if(codigoBanco == '33')
                codigoBanco = '3';*/

            system.debug('listLead: ' + JSON.serialize(listLead));
            system.debug('listOpportunity: ' + JSON.serialize(listOpportunity));

            cryptografarEnvioAtualiza();

            //Tratar Opportunity
            if(listOpportunity != null){
                for(Opportunity item : listOpportunity) {
                    system.debug('item.Id: ' + item.Id);
                    system.debug('item.Status_Retorno_Banco__c: ' + JSON.serialize(item.Status_Retorno_Banco__c));
                    system.debug('item.Motivo_Retorno_Banco__c: ' + JSON.serialize(item.Motivo_Retorno_Banco__c));

                    String status = String.valueof(Integer.valueOf(item.Status_Retorno_Banco__c));
                    String motivo = String.valueof(Integer.valueOf(item.Motivo_Retorno_Banco__c));

                    String xmlProdutoComercializado = '<CODIGOS>';
                    Set<String> codigosProd = new Set<String>();
                    String dataVenda = null;
                    for(Produtos_Alelo__c prod: item.Produtos_Alelo__r){
                        if (item.DataVendaConfirmada__c != null && prod != null && prod.Codigo_de_Produtos__c != null && (prod.Codigo_de_Produtos__c.equalsIgnoreCase('100')
                                || prod.Codigo_de_Produtos__c.equalsIgnoreCase('200')
                                || prod.Codigo_de_Produtos__c.equalsIgnoreCase('202')
                                || prod.Codigo_de_Produtos__c.equalsIgnoreCase('300')
                                || prod.Codigo_de_Produtos__c.equalsIgnoreCase('31'))){
                            codigosProd.add(prod.Codigo_de_Produtos__c);
                            xmlProdutoComercializado += '<CODIGO CODIGO="'+prod.Codigo_de_Produtos__c+'" QTDE_CARTAO_PREV="'+prod.Quantidade_de_Cartoes__c+'" FATURAMENTO_PREV="'+prod.Valor_Total__c+'" />';
                        }
                    }
                    dataVenda = item.DataVendaConfirmada__c != null ? item.DataVendaConfirmada__c.format('yyyy-MM-dd') : null;
                    xmlProdutoComercializado += '</CODIGOS>';
                    String xmlCriptografado = item.DataVendaConfirmada__c != null ? Util.criptografarIndicacoes(xmlProdutoComercializado) : null;
                    String dataVendaCriptografada = dataVenda != null ? Util.criptografarIndicacoes(dataVenda) : null;

                    codigoIndicacao = Util.criptografarIndicacoes(item.Codigo_Indicacao__c);
                    if(status != null)
                        codigoStatus = Util.criptografarIndicacoes(status);
                    if(motivo != null)
                        codigoMotivo = Util.criptografarIndicacoes(motivo);
                    //codigoMotivo = Util.criptografarIndicacoes(String.valueof(77));

                    System.debug('codigoAcesso: ' + codigoAcesso);
                    System.debug('login: ' + login);
                    System.debug('senha: ' + senha);
                    System.debug('codigoBanco: ' + codigoBanco);
                    System.debug('codigoIndicacao: ' + codigoIndicacao);
                    System.debug('codigoStatus: ' + codigoStatus);
                    System.debug('codigoMotivo: ' + codigoMotivo);
                    System.debug('xmlCriptografado: ' + xmlCriptografado);
                    WSIndicacoes.EResultCripto resultCripto = service.AtualizarStatusIndicacaoNovo(codigoAcesso, login, senha, codigoBanco, codigoIndicacao, codigoStatus, codigoMotivo, xmlCriptografado, dataVendaCriptografada);

                    System.debug('resultCripto ' + JSON.serialize(resultCripto));

                    if(resultCripto != null) {
                        item.Retorno_Servico_Bancos__c = Util.descriptografarIndicacoes(resultCripto.Mensagem);
                        item.Atualizacao_Bancos__c = true;
                        listOpportunityRetorno.add(item);
                    }
                }
            }

            update listOpportunityRetorno;

            //Tratar Lead
            if(listLead != null){
                for(Lead item : listLead) {
                    system.debug('item.Id: ' + item.Id);
                    system.debug('item.Status_Retorno_Banco__c: ' + JSON.serialize(item.Status_Retorno_Banco__c));
                    system.debug('item.Motivo_Retorno_Banco__c: ' + JSON.serialize(item.Motivo_Retorno_Banco__c));

                    String status = String.valueof(Integer.valueOf(item.Status_Retorno_Banco__c));
                    String motivo = String.valueof(Integer.valueOf(item.Motivo_Retorno_Banco__c));

                    codigoIndicacao = Util.criptografarIndicacoes(item.Chave_Banco__c);
                    if(status != null)
                        codigoStatus = Util.criptografarIndicacoes(status);
                    if(motivo != null)
                        codigoMotivo = Util.criptografarIndicacoes(motivo);
                    //codigoMotivo = Util.criptografarIndicacoes(String.valueof(77));

                    WSIndicacoes.EResultCripto resultCripto = service.AtualizarStatusIndicacaoNovo(codigoAcesso, login, senha, codigoBanco, codigoIndicacao, codigoStatus, codigoMotivo, null, null);

                    System.debug('resultCripto ' + JSON.serialize(resultCripto));

                    if(resultCripto != null) {
                        item.Retorno_Servico_Bancos__c = Util.descriptografarIndicacoes(resultCripto.Mensagem);
                        item.Atualizacao_Bancos__c = true;
                        listLeadRetorno.add(item);
                    }
                }
            }

            update listLeadRetorno;

            system.debug('FIM: atualizarIndicacaoCBSS');

        } catch(Exception e) {
            System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
            throw e;
        }
    }

    public static void consultarIndicacaoBradesco(){
        indicacaoBradesco();
        gerarXMLCodigoStatus();
        cryptografarEnvioConsulta();
        consultarIndicacaoCBSS();
    }

    public static void consultarIndicacaoBB(){
        indicacaoBB();
        gerarXMLCodigoStatus();
        cryptografarEnvioConsulta();
        consultarIndicacaoCBSS();
    }

    public static void consultarIndicacaoSantander(){
        indicacaoSantander();
        gerarXMLCodigoStatus();
        cryptografarEnvioConsulta();
        consultarIndicacaoCBSS();
    }

    public static void atualizarIndicacaoBradesco(List<Lead> listLead, List<Opportunity> listOpportunity){
        indicacaoBradesco();
        atualizarIndicacaoCBSS(listLead, listOpportunity);
    }

    public static void atualizarIndicacaoBB(List<Lead> listLead, List<Opportunity> listOpportunity){
        indicacaoBB();
        atualizarIndicacaoCBSS(listLead, listOpportunity);
    }

    public static void atualizarIndicacaoSantander(List<Lead> listLead, List<Opportunity> listOpportunity){
        indicacaoSantander();
        atualizarIndicacaoCBSS(listLead, listOpportunity);
    }

    public static void atualizarIndicacao(Integer codBanco, List<Lead> listLead, List<Opportunity> listOpportunity){

        if(codBanco == 1)
            indicacaoBB();
        else if(codBanco == 33)
            indicacaoSantander();
        else if(codBanco == 237)
            indicacaoBradesco();

        atualizarIndicacaoCBSS(listLead, listOpportunity);
    }

    private static void indicacaoBradesco(){
        System.debug('indicacaoBradesco');
        portal = 'Bradesco';
        codigoAcesso = '33B3B87E-AD79-43CD-A19D-2320FC527772';
        login = 'wsportalbradesco';
        //senha = '123456';
        senha = '4f3898';
        codigoBanco = '237';
    }
    private static void indicacaoBB(){
        System.debug('indicacaoBB');
        portal = 'Banco do Brasil';
        codigoAcesso = '6B6D6BA3-AA7F-47F4-93A9-F9BD8EADA113';
        login = 'wsportalbb';
        //senha = '123456';
        senha = '4292ba';
        codigoBanco = '1';
    }

//    private static void indicacaoBB(){
//        portal = 'Banco do Brasil';
//        codigoAcesso = '4225F1507B7EA410BEA0FAAC10FCCFED5CC08DE3433F663812E0BA155DDFD0E835EC7D3A9A670F258C86EDAE4B2B8FE2';
//        login = '5E9B03ABB5CF9854B51BA997195EC638';
//        senha = '7341657425CF41D014551B1FFDC82E7F';
//        codigoBanco = '7C955E7ED81A0489244B125C4B060725';
//        xmlCodigoStatus = '552E3CECDA5B2BE98B30D9D75A89984D4CCDFB33CC037B769C1FE8F5A8B2A88470B4B41F1F379365DB3F9FE8E2D172E64617EAA9E54A160CA8B9F1974D6C451467D7B4E51E0B53E039A85CCBEE8A25DE';
//    }


    private static void indicacaoSantander(){
        System.debug('indicacaoSantander');
        portal = 'Santander';
        codigoAcesso = '5D2CEBBD-DE27-4D45-974A-3915DD9B0F23';
        login = 'Wsportalsantander';
        //senha = '123456';
        senha = '4d88b9 ';
        codigoBanco = '33';
    }

    private static void gerarXMLCodigoStatus(){
        System.debug('gerarXMLCodigogit Status');
        xmlCodigoStatus = '<STATUSCODIGOS><STATUSCODIGO CODIGO="7"></STATUSCODIGO><STATUSCODIGO CODIGO="6"></STATUSCODIGO></STATUSCODIGOS>';
    }

    private static void cryptografarEnvioConsulta(){
        portal = Util.criptografarIndicacoes(portal);
        codigoAcesso = Util.criptografarIndicacoes(codigoAcesso);
        login = Util.criptografarIndicacoes(login);
        senha = Util.criptografarIndicacoes(senha);
        codigoBanco = Util.criptografarIndicacoes(codigoBanco);
        xmlCodigoStatus = Util.criptografarIndicacoes(xmlCodigoStatus);

//        portal = Util.criptografarIndicacoes(portal);
//        codigoAcesso = '4225F1507B7EA410BEA0FAAC10FCCFED5CC08DE3433F663812E0BA155DDFD0E835EC7D3A9A670F258C86EDAE4B2B8FE2';
//        login = '5E9B03ABB5CF9854B51BA997195EC638';
//        senha = '7341657425CF41D014551B1FFDC82E7F';
//        codigoBanco = '7C955E7ED81A0489244B125C4B060725';
//        xmlCodigoStatus = '552E3CECDA5B2BE98B30D9D75A89984D4CCDFB33CC037B769C1FE8F5A8B2A88470B4B41F1F379365DB3F9FE8E2D172E64617EAA9E54A160CA8B9F1974D6C451467D7B4E51E0B53E039A85CCBEE8A25DE';

        System.debug('portal: ' + portal);
        System.debug('codigoAcesso: ' + codigoAcesso);
        System.debug('login: ' + login);
        System.debug('senha: ' + senha);
        System.debug('codigoBanco: ' + codigoBanco);
        System.debug('xmlCodigoStatus: ' + xmlCodigoStatus);
    }

    private static void cryptografarEnvioAtualiza(){
        portal = Util.criptografarIndicacoes(portal);
        codigoAcesso = Util.criptografarIndicacoes(codigoAcesso);
        login = Util.criptografarIndicacoes(login);
        senha = Util.criptografarIndicacoes(senha);
        codigoBanco = Util.criptografarIndicacoes(codigoBanco);
        //codigoIndicacao = Util.criptografarIndicacoes(codigoIndicacao);
        //codigoStatus = Util.criptografarIndicacoes(codigoStatus);
        //codigoMotivo = Util.criptografarIndicacoes(codigoMotivo);
    }

    public static void convertLead(Lead lead) {
        Database.LeadConvert lc = new Database.LeadConvert();
        Account conta = DAOAccount.getAccountByCNPJ(lead.CNPJ__c);
        if(conta != null)
            lc.setAccountId(conta.Id);
        lc.setLeadId(lead.Id);
        lc.setOpportunityName(lead.Company);
        lc.setConvertedStatus(lead.Status);
        lc.setOwnerId(UserInfo.getUserId());
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        System.debug('Conversion Result: ' + JSON.serialize(lcr));
    }

    public static void teste() {
        Http http = new Http();

        HttpRequest httpRequest = new HttpRequest();

        httpRequest.setEndPoint('http://hml.webpartner.com.br/webservice/wscbssindicacoes/indicacoes.asmx');
        httpRequest.setMethod('POST');
        httpRequest.setTimeout(20000);
        httpRequest.setHeader('Content-Type', 'text/xml');

        httpRequest.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:hml="http://hml.webpartner.com.br"><soapenv:Header/><soapenv:Body><hml:ConsultarIndicacao><hml:CodigoAcesso>76c0bce8b3956e3f3090472a31d3cec90ca6ec077390d2eef0b3b579c0c75c69eb994612ace87afce41687cf00e838bb</hml:CodigoAcesso><hml:Login>033965fa3fd713d75c066e1fccaafbe897a3cb76154112f64ede32cea1e85899</hml:Login><hml:Senha>8079c1a9fcf0915f72820954a9977f85</hml:Senha><hml:CodigoBanco>36d2b5aa146f9a7f98dbcba9750b1e60</hml:CodigoBanco><hml:XMLCodigoStatus>53cb3e2f83d0a7c4ed2908463fcc9ae1ecb12d6ad18b91e579491e4214b3793bcddc5f25fac5df6054bebe09f89af5e6ab44e67e6ac19bd30906289b473ca6fbec1dce5aa6878b12e1a9c473cb393dcc</hml:XMLCodigoStatus></hml:ConsultarIndicacao></soapenv:Body></soapenv:Envelope>');

        System.debug('Request: '+ httpRequest);
        System.debug('Request Body: '+ httpRequest.getBody());

        HttpResponse httpResponse = new HttpResponse();

        try
        {
            httpResponse = http.send(httpRequest);

            System.debug('Response: ' + 'Sucesso');
            System.debug('Response: ' + httpResponse.getStatusCode());
            System.debug('Response: ' + httpResponse.getBody());

        }
        catch(Exception e)
        {
            System.debug('Response: ' + 'Erro');
            System.debug('Response: ' + e + '\n' + e.getMessage());
        }
    }
}