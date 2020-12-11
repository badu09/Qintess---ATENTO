trigger ProdutosAlelo_Before on Produtos_Alelo__c (before update, before insert) 
{
    
    System.debug('#ProdutosAlelo_Before - Início');

    // CHAMADA DA BACTH QUE ARMAZENA O CÓDIDO DO PRODUTO ALELO
//    Database.executeBatch(new BatchArmazenaCodProdutoAlelo(Trigger.new));

    for (Produtos_Alelo__c produto : Trigger.New)
    {
        //Se Estratégia, contabilizar contadores quando ocorrer tabulação
        if (String.isNotBlank(produto.Estrategia_Implantacao__c) && 
            produto.Tabulacao_Pai_Implantacao__c != null && 
            produto.Tabulacao_Filho_Implantacao__c != null &&
            TriggerUtils.isChanged(produto, Produtos_Alelo__c.Data_Hora_Tabulacao__c))
        {
            //Quantidade total de tabulações do produto
            produto.Quantidade_Total_Estrategia__c = TriggerUtils.somarUm(produto.Quantidade_Total_Estrategia__c);
            
            if (produto.Tabulacao_Filho_Implantacao__c == 'TELEFONE OCUPADO OU NÃO ATENDE')
            {
                produto.Insucesso_TelefoneNaoAtende__c = TriggerUtils.somarUm(produto.Insucesso_TelefoneNaoAtende__c);
                produto.Quantidade_Insucesso_Estrategia__c = TriggerUtils.somarUm(produto.Quantidade_Insucesso_Estrategia__c);
            }
            if (produto.Tabulacao_Filho_Implantacao__c == 'TELEFONE ERRADO')
            {
                produto.Insucesso_TelefoneErrado__c = TriggerUtils.somarUm(produto.Insucesso_TelefoneErrado__c);
                produto.Quantidade_Insucesso_Estrategia__c = TriggerUtils.somarUm(produto.Quantidade_Insucesso_Estrategia__c);
            }
            if (produto.Tabulacao_Pai_Implantacao__c == 'EM IMPLANTAÇÃO' ||
                produto.Tabulacao_Pai_Implantacao__c == 'CONTATO AGENDADO')
            {
                produto.Quantidade_Agendadas_Estrategia__c = TriggerUtils.somarUm(produto.Quantidade_Agendadas_Estrategia__c);
            }
            System.debug('qtde insuc - before: '+produto.Quantidade_Insucesso_Estrategia__c);
            
        }
        
    }
    
    System.debug('#ProdutosAlelo_Before - Fim');

    if (Trigger.isUpdate){
        //AlteraProcessoRoteamento.atualizaRoteamentoTabulacaoAlelo(Trigger.new);
    }
    
}