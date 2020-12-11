public class DAOOpportunity {
    public static Opportunity getOpportunityById(String Id) {
        return [SELECT
                Id,
                Agendamento_Retorno__c,
                Contato_da_oportunidade__r.Documento_de_Identificacao__c,
                Contato_da_oportunidade__r.Email,
                Contato_da_oportunidade__r.Nivel_Hierarquico__c,
                Contato_da_oportunidade__r.Sexo__c,
                Contato_da_oportunidade__r.Codigo_do_Tipo_de_Contato__c,
                Contato_da_oportunidade__r.Phone,
                Contato_da_oportunidade__r.Name,
                Contato_da_oportunidade__r.CPF__c,
                Contato_da_oportunidade__c,
                Contato_da_oportunidade__r.Data_de_Nascimento__c,
                Contato_da_oportunidade__r.MailingCity,
                Contato_da_oportunidade__r.Complemento__c,
                Contato_da_oportunidade__r.Numero__c,
                Contato_da_oportunidade__r.Bairro__c,
                Contato_da_oportunidade__r.MailingPostalCode,
                Contato_da_oportunidade__r.MailingStreet,
                Contato_da_oportunidade__r.Estado__c,
                Contato_da_oportunidade__r.Department,
                Contato_da_oportunidade__r.DDD__c,
                Contato_da_oportunidade__r.Telefone__c,
                Contato_da_oportunidade__r.Tipo__c,
                Contato_da_oportunidade__r.Celular__c,
                Contato_da_oportunidade_2__r.Documento_de_Identificacao__c,
                Contato_da_oportunidade_2__r.Email,
                Contato_da_oportunidade_2__r.Sexo__c,
                Contato_da_oportunidade_2__r.Codigo_do_Tipo_de_Contato__c,
                Contato_da_oportunidade_2__r.Phone,
                Contato_da_oportunidade_2__r.Nivel_Hierarquico__c,
                Contato_da_oportunidade_2__r.Name,
                Contato_da_oportunidade_2__r.CPF__c,
                Contato_da_oportunidade_2__c,
                Contato_da_oportunidade_2__r.Data_de_Nascimento__c,
                Contato_da_oportunidade_2__r.MailingCity,
                Contato_da_oportunidade_2__r.Complemento__c,
                Contato_da_oportunidade_2__r.Numero__c,
                Contato_da_oportunidade_2__r.Bairro__c,
                Contato_da_oportunidade_2__r.MailingPostalCode,
                Contato_da_oportunidade_2__r.MailingStreet,
                Contato_da_oportunidade_2__r.Estado__c,
                Contato_da_oportunidade_2__r.Department,
                Contato_da_oportunidade_2__r.DDD__c,
                Contato_da_oportunidade_2__r.Telefone__c,
                Contato_da_oportunidade_2__r.Tipo__c,
                Contato_da_oportunidade_3__c,
                //Contato_da_oportunidade_4__c,
                Contato_da_oportunidade_4__r.Documento_de_Identificacao__c,
                Contato_da_oportunidade_4__r.Email,
                Contato_da_oportunidade_4__r.Sexo__c,
                Contato_da_oportunidade_4__r.Codigo_do_Tipo_de_Contato__c,
                Contato_da_oportunidade_4__r.Phone,
                Contato_da_oportunidade_4__r.Nivel_Hierarquico__c,
                Contato_da_oportunidade_4__r.Name,
                Contato_da_oportunidade_4__r.CPF__c,
                Contato_da_oportunidade_4__c,
                Contato_da_oportunidade_4__r.Data_de_Nascimento__c,
                Contato_da_oportunidade_4__r.MailingCity,
                Contato_da_oportunidade_4__r.Complemento__c,
                Contato_da_oportunidade_4__r.Numero__c,
                Contato_da_oportunidade_4__r.Bairro__c,
                Contato_da_oportunidade_4__r.MailingPostalCode,
                Contato_da_oportunidade_4__r.MailingStreet,
                Contato_da_oportunidade_4__r.Estado__c,
                Contato_da_oportunidade_4__r.Department,
                Contato_da_oportunidade_4__r.DDD__c,
                Contato_da_oportunidade_4__r.Telefone__c,
                Contato_da_oportunidade_4__r.Tipo__c,
                Nome_no_cartao__c,
                Canal_Propostas_Receptivo__c,
                Quantidade_Total_de_Usuarios_Prevista__c,
                Account.Name,
                Account.BillingCity,
                Account.Id,
                Account.CPF_CNPJ__c,
                Account.Razao_Social__c,
                Account.Nome_Fantasia__c,
                Account.Quantidade_de_Funcionarios__c,
                Account.Faturamento__c,
                Account.Secao_Ramo_de_Atividade__c,
                Account.Divisao_Ramo_de_Atividade__c,
                Account.Parent.Id, 
                Account.Forma_de_Constituicao__c,
                Account.Data_da_Constituicao__c,
                Responsavel_Legal__r.Name,
                Responsavel_Legal__r.CPF__c,
                Responsavel_Legal_2__r.Name,
                Responsavel_Legal_2__r.CPF__c,
                E_mail_Enviado__c,
                Codigo_do_Banco__c,
                StageName,
                RecordType.DeveloperName,
                Campanha__c,
                OwnerId,
                Implantador_Atribuido__c,
                Implantador_Atribuido__r.Name,
                Owner.CPF__c,
                //Account.Cidade__c,
                Numero_Agencia__c,
                //Conta__c,
                //Codigo_do_Vendedor__c,
                TelefoneVendedor__c,
                CloseDate,
                Total_Fidelizado__c,
                Tipo_de_Fila_Consolidado__c,
                Tabulacao_OLOS_para_Implantacao__c,
                Processo_Implantacao__c,
                Telefone_Decisor__c,
                Telefone_Operacional__c,
                Motivo_Detalhado__c,
                Flag_Tabulacao__c,
                NomeDoVendedorPREPAGO__c,
                Conta__c,
                Codigo_do_Vendedor__c,
                Nome_do_Vendedor__c,
                (Select
                 Id,
                 Name,
                 Numero_do_Contrato__c, 
                 Valor_Unitario__c,
                 Numero_de_Filiais__c,
                 F_Valor_Total__c,
                 Quantidade_de_Recarga_Prevista__c,
                 Nome_Empresa_Gravacao_Cartao__c,
                 Quantidade_de_Cartoes__c,			
                 Data_Faseada__c,
                 Valor_Faseado__c,			
                 Qtd_Dias_para_Pagamento__c,
                 Banco__c,
                 Faturamento__c,
                 Agencia_Digito__c, 
                 Data_Faturamento__c,
                 Tabulacao_Pai_Implantacao__c,
                 Numero_de_Pedido__c,
                 Tabulacao_Filho_Implantacao__c,
                 Agendamento_Retorno_Implanta_o__c, 
                 Tabulacao_Neto_Implantacao__c,
                 Valor_Implantado__c,
                 Observacao_Implantacao2__c,
                 Data_Hora_Tabulacao__c,
                 Retorno_RW__c,
                 Codigo_CAB__c,
                 Data_Hora_Auditoria__c,
                 FormaPagamento__c,
                 Data_do_pedido__c
                 FROM
                 Produtos_Alelo__r)
                FROM 
                Opportunity
                WHERE
                Id = :Id];
    }
    
    public static List<Opportunity> getOpportunityIndicacaoBanco(String codigoBanco) {
        return [SELECT
                Id,
                Name,
                Codigo_do_Banco__c,
                Agendamento_Retorno__c,
                Codigo_Banco_Retorno_Bancos__c,
                //Motivo_Retorno_Banco__c,
                //Status_Retorno_Banco__c,
                Codigo_Indicacao__c,
                Retorno_Servico_Bancos__c,
                Canal_Propostas_Receptivo__c,
                Campanha__c
                FROM
                Opportunity
                WHERE
                Codigo_Indicacao__c != null
                AND
                Data_Hora_Atualizacao_Bancos__c = TODAY
                AND
                Codigo_do_Banco__c =: codigoBanco LIMIT 50];
    }
    
    public static List<Opportunity> getOpportunityForAccount(Id idAccount) {
        return [SELECT
                Id,
                Name,
                AccountId,
                Account.Name,
                Account.CPF_CNPJ__c,
                Contato_da_oportunidade__c,
                Contato_da_oportunidade__r.Name,
                StageName,
                CloseDate,
                OwnerId,
                Owner.Name,
                Campanha__c,
                Total_Fidelizado__c,
                Implantador_Atribuido__c,
                Tipo_de_Fila_Consolidado__c,
                Processo_Implantacao__c,
                Tabulacao_OLOS_para_Implantacao__c,
                Canal_Propostas_Receptivo__c,
                (SELECT
                 Id,
                 Name,
                 Numero_do_Contrato__c,
                 Valor_Unitario__c,
                 Numero_de_Filiais__c,
                 F_Valor_Total__c,
                 Quantidade_de_Recarga_Prevista__c,
                 Nome_Empresa_Gravacao_Cartao__c,
                 Quantidade_de_Cartoes__c,						
                 Qtd_Dias_para_Pagamento__c,
                 Banco__c,
                 Faturamento__c,
                 Agencia_Digito__c,
                 Data_Faseada__c,
                 Valor_Faseado__c,
                 Data_Faturamento__c,
                 Tabulacao_Pai_Implantacao__c,
                 Numero_de_Pedido__c,
                 Tabulacao_Filho_Implantacao__c,
                 Agendamento_Retorno_Implanta_o__c, 
                 Tabulacao_Neto_Implantacao__c,
                 Valor_Implantado__c,
                 Observacao_Implantacao2__c,
                 Data_Hora_Tabulacao__c,
                 FormaPagamento__c,
                 Data_do_pedido__c
                 FROM
                 Produtos_Alelo__r)
                FROM
                Opportunity
                WHERE
                AccountId = :idAccount];
    }
    
    public static List<Opportunity> getOpportunityForAccountProdutoAlelo(Id idAccount) {
        return [SELECT
                Id,
                Name,
                AccountId,
                Account.Name,
                Account.CPF_CNPJ__c,
                Contato_da_oportunidade__c,
                Contato_da_oportunidade__r.Name,
                StageName,
                CloseDate,
                OwnerId,
                Owner.Name,
                Campanha__c,
                Total_Fidelizado__c,
                Implantador_Atribuido__c,
                Tipo_de_Fila_Consolidado__c,
                Processo_Implantacao__c,
                Tabulacao_OLOS_para_Implantacao__c,
                Canal_Propostas_Receptivo__c,
                (SELECT
                 Id,
                 Name,
                 Numero_do_Contrato__c,
                 Valor_Unitario__c,
                 Numero_de_Filiais__c,
                 F_Valor_Total__c,
                 Quantidade_de_Recarga_Prevista__c,
                 Nome_Empresa_Gravacao_Cartao__c,
                 Quantidade_de_Cartoes__c,						
                 Qtd_Dias_para_Pagamento__c,
                 Banco__c,
                 Faturamento__c,
                 Agencia_Digito__c,
                 Data_Faseada__c,
                 Valor_Faseado__c,
                 Data_Faturamento__c,
                 Tabulacao_Pai_Implantacao__c,
                 FTabulacaoPAIImplantacao__c,
                 Numero_de_Pedido__c,
                 Tabulacao_Filho_Implantacao__c,
                 FTabulacaoFilhoImplantado__c,
                 Agendamento_Retorno_Implanta_o__c, 
                 Tabulacao_Neto_Implantacao__c,
                 Valor_Implantado__c,
                 Observacao_Implantacao2__c,
                 Data_Hora_Tabulacao__c,
                 ImplantaFora__c,
                 FormaPagamento__c,
                 Data_do_pedido__c
                 FROM
                 Produtos_Alelo__r
                 WHERE
                 ImplantaFora__c = false)
                FROM
                Opportunity
                WHERE
                AccountId = :idAccount];
    }
    
    public static List<Opportunity> getOpportunityForSetId(Set<Id> setId) {
        return [SELECT
                Id,
                Total_Fidelizado__c,
                Tipo_de_Fila_Consolidado__c,
                Implantador_Atribuido__c,
                Processo_Implantacao__c,
                Processo_Implantacao__r.Id,
                Processo_Implantacao__r.OwnerId,
                Canal_Propostas_Receptivo__c,
                Sistema_de_Pedidos__c
                FROM 
                Opportunity
                WHERE
                Id IN :setId];
    }
    
    public static List<Opportunity> getOpportunityForSetIdLIM2K(Set<Id> setId) {
        return [SELECT
                Id,
                Total_Fidelizado__c,
                Tipo_de_Fila_Consolidado__c,
                Implantador_Atribuido__c,
                Processo_Implantacao__c,
                Processo_Implantacao__r.Id,
                Processo_Implantacao__r.OwnerId,
                Canal_Propostas_Receptivo__c
                FROM 
                Opportunity
                WHERE
                Id IN :setId
                LIMIT 2000];
    }
    
    public static String getQueryIndicacaoBanco(Integer codigoBanco) {
        String query = null;
        
        query = 'SELECT Id, Name, Canal_Propostas_Receptivo__c, Codigo_do_Banco__c, DataVendaConfirmada__c, Agendamento_Retorno__c, Codigo_Banco_Retorno_Bancos__c, ';
        query += 'Motivo_Retorno_Banco__c, Status_Retorno_Banco__c, Codigo_Indicacao__c, Retorno_Servico_Bancos__c,(SELECT Id, Name, Numero_do_Contrato__c, Codigo_de_Produtos__c, Valor_Total__c, Quantidade_de_Cartoes__c, FormaPagamento__c FROM Produtos_Alelo__r) ';
        // query += 'FROM Opportunity WHERE Codigo_Indicacao__c != null AND Data_Hora_Atualizacao_Bancos__c = TODAY ';
        query += 'FROM Opportunity WHERE Codigo_Indicacao__c != null ';
        query += 'AND Status_Retorno_Banco__c != null AND Motivo_Retorno_Banco__c != null ';
        query += 'AND Atualizacao_Bancos__c = false AND Codigo_do_Banco__c = \'' + codigoBanco + '\'';
        
        return query;
    }
    
    public static String getQueryIndicacaoBancos(Integer codigoBanco, Integer codigoBanco2, Integer codigoBanco3) {
        String query = null;
        
        query = 'SELECT Id, Name, Canal_Propostas_Receptivo__c, Codigo_do_Banco__c, DataVendaConfirmada__c, Agendamento_Retorno__c, Codigo_Banco_Retorno_Bancos__c, ';
        query += 'Motivo_Retorno_Banco__c, Status_Retorno_Banco__c, Codigo_Indicacao__c, Retorno_Servico_Bancos__c,(SELECT Id, Name, Numero_do_Contrato__c, Codigo_de_Produtos__c, Valor_Total__c, Quantidade_de_Cartoes__c, FormaPagamento__c FROM Produtos_Alelo__r) ';
        // query += 'FROM Opportunity WHERE Codigo_Indicacao__c != null AND Data_Hora_Atualizacao_Bancos__c = TODAY ';
        query += 'FROM Opportunity WHERE Codigo_Indicacao__c != null ';
        query += 'AND Status_Retorno_Banco__c != null AND Motivo_Retorno_Banco__c != null ';
        query += 'AND Atualizacao_Bancos__c = false AND (Codigo_do_Banco__c = \'' + codigoBanco + '\' OR Codigo_do_Banco__c = \'' + codigoBanco2 + '\' OR Codigo_do_Banco__c = \'' + codigoBanco3 + '\')';
        
        return query;
    }
    
    public static List<Opportunity> getOpportunityFromConsultaCliente(String cnpj, String razaoSocial, List<String> IdOportunidades) {
        List<Opportunity> retorno = new List<Opportunity>();
        String query = 'Select Name, Canal_Propostas_Receptivo__c, Contato_da_oportunidade__r.Name, Contato_da_oportunidade__c, Implantador_Atribuido__c, ';
        query += 'Account.CPF_CNPJ__c, Account.Name, AccountId, StageName, (Select Id, Name,Tabulacao_Pai_Implantacao__c,Data_Hora_Tabulacao__c,Tabulacao_Filho_Implantacao__c,Tabulacao_Neto_Implantacao__c, FormaPagamento__c From Produtos_Alelo__r), ';
        query += '(Select Id, Name, OrderNumber, Status, EffectiveDate From Orders) From Opportunity';
        query += ' WHERE Id != null'; 
        
        if(cnpj != null && cnpj.replaceAll(' ', '') != '') {
            query += ' AND Account.CPF_CNPJ__c LIKE \'' + cnpj + '\'';
        }
        
        if(razaoSocial != null && razaoSocial.replaceAll(' ', '') != '') {
            query += ' AND Account.Razao_Social__c LIKE \'' + razaoSocial + '\'';
        }
        
        if(IdOportunidades != null && IdOportunidades.size() > 0) {
            query += ' AND Id IN (';
            String listOppString = '';
            for(String idOpp : IdOportunidades) {
                listOppString += '\'' + idOpp + '\' ,';
            }
            listOppString = listOppString.replaceAll(', *$', '');
            
            query += listOppString + ')';
        }
        
        system.debug('query: ' + query);
        
        Database.QueryLocator q = Database.getQueryLocator(query);
        Database.QueryLocatorIterator it =  q.iterator();
        
        while (it.hasNext())
        {
            Opportunity o = (Opportunity)it.next();
            retorno.add(o);
        }
        
        return retorno;
    }
    
    public static List<Opportunity> getOpportunityFromConsultaCliente(String cnpj, String razaoSocial, Set<String> IdOportunidades) {
        List<String> lista = new List<String>();
        if(IdOportunidades != null && IdOportunidades.size() > 0) {
            lista.addAll(IdOportunidades);
        }
        return getOpportunityFromConsultaCliente(cnpj, razaoSocial, lista);
    }
    
    public static List<Opportunity> getOpportunityForEstrategia(String idEstrategia) {
        return [SELECT
                Id,
                Total_Fidelizado__c,
                Tipo_de_Fila_Consolidado__c,
                Implantador_Atribuido__c,
                Processo_Implantacao__c,
                Processo_Implantacao__r.Id,
                Processo_Implantacao__r.OwnerId,
                Canal_Propostas_Receptivo__c,
                OwnerId
                FROM 
                Opportunity
                WHERE
                Estrategia_Implantacao__c = :idEstrategia];
    }
    
    public static List<Opportunity> updateListOpportunity(List<Opportunity> listOpportunity){
        
        try{
            
            update listOpportunity;
            
        }catch (Exception e){
            
            return null;
            
        }
        
        return listOpportunity;
        
    }
    
    public static List<Opportunity> getOpportunityForAccountProdutoAleloByCobranca(Id IdAccount, Id IdOportunidade) {
        return [SELECT
                Id,
                Name,
                AccountId,
                Account.Name,
                Account.CPF_CNPJ__c,
                Contato_da_oportunidade__c,
                Contato_da_oportunidade__r.Name,
                StageName,
                OwnerId,
                Owner.Name,
                Campanha__c,
                Implantador_Atribuido__c,
                Canal_Propostas_Receptivo__c,
                (SELECT
                 Id,
                 Name,
                 Numero_do_Contrato__c,
                 Valor_Unitario__c,
                 Numero_de_Filiais__c,
                 F_Valor_Total__c,
                 Quantidade_de_Recarga_Prevista__c,
                 Nome_Empresa_Gravacao_Cartao__c,
                 Quantidade_de_Cartoes__c,
                 Qtd_Dias_para_Pagamento__c,
                 Banco__c,
                 Faturamento__c,
                 Agencia_Digito__c,
                 Data_Faturamento__c,
                 Tem_Cobranca__c,
                 Oportunidade__c,
                 FormaPagamento__c,
                 Data_do_pedido__c
                 FROM
                 Produtos_Alelo__r
                 WHERE
                 Tabulacao_Pai_Implantacao__c = 'Implantado' AND
                 Tem_Cobranca__c = true)
                FROM
                Opportunity
                WHERE
                AccountId = :IdAccount AND
                id =: idOportunidade];
    }
    
    public static Opportunity getOpportunityApprovalStatusForById(Id IdOportunidade) {
        return [SELECT
                Id,
                Nivel__c,
                Aprovada__c
                FROM
                Opportunity
                WHERE
                Id =: idOportunidade LIMIT 1];
    }
    
    public static Opportunity getOpportunityValidaBKOById(Id IdOportunidade) {
        return [SELECT
                Id,
                Valida_BKO__c
                FROM
                Opportunity
                WHERE
                Id =: idOportunidade LIMIT 1];
    }
    
}