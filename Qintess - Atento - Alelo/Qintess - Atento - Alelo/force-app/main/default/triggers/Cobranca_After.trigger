trigger Cobranca_After on Cobranca__c (after update, after insert) {


    System.debug('#Cobranca_After - Início');

    Map<String, TentativaPorTabulacao__mdt> mapTentativas = DAOTentativaPorTabulacao.getMapTentativaPorTabulacao('Cobrança');
    List<Cobranca__c> lstCobranca = new List<Cobranca__c>();

    Group filaDescarteCobranca = DAOGroup.getDeveloperNameGroup('Cobranca_Descartados_Cobranca', 'Queue');

    for (Cobranca__c cobranca : Trigger.New)
        {
            system.debug('Entrou Trigger');
            system.debug('cobranca.Status__c : '+cobranca.Status__c );
            //Se Cobrança, verificar estouro dos contadores
            if (String.isNotBlank(cobranca.Tabulacao_Cobranca_Pai__c) && TriggerUtils.isChanged(cobranca, Cobranca__c.Data_Hora_Tabulacao__c))
            {
                system.debug('Status = Cobranca');
                String chaveMap = cobranca.Tabulacao_Cobranca_Pai__c + cobranca.Tabulacao_Cobranca_Filho__c;
                system.debug('chaveMap: ' + chaveMap);
                TentativaPorTabulacao__mdt paramTabulacao = mapTentativas.get(chaveMap);
                system.debug('paramTabulacao: '+paramTabulacao);
                if (paramTabulacao != null && paramTabulacao.Quantidade_Tentativas__c != null)
                {
                    if (cobranca.Tabulacao_Cobranca_Pai__c == 'TELEFONE ERRADO' ||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'TELEFONE OCUPADO OU NÃO ATENDE')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'TELEFONE NÃO PERTENCE A EMPRESA')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'CONTATO AGENDADO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'DESISTIU CONTRATAÇÃO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'REDUÇÃO DE FUNCIONÁRIO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'FECHOU CONTRATO COM CONCORRENTE')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'ENCERROU AS ATIVIDADES')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'SEM PREVISÃO PARA PAGAMENTO DO BOLETO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'REDUÇÃO DE FUNCIONÁRIOS')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'PROBLEMAS FINANCEIROS')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'FATURANDO EM OUTRO BENEFÍCIO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'FATURANDO NO CONTRATO BOAS-VINDAS')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'FATURANDO EM OUTRO CONTRATO DO MESMO BENEFÍCIO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'NÃO INFORMA O MOTIVO')||
                        (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                         cobranca.Tabulacao_Cobranca_Filho__c == 'REALIZADO NOVO PEDIDO - AGUARDANDO FATURAMENTO'))
                    {
                        if (cobranca.Telefone_Errado__c > paramTabulacao.Quantidade_Tentativas__c ||
                            (cobranca.Telefone_Ocupado_ou_Nao_Atende__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.Telefone_Nao_Pertence_a_Empresa__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.Contato_Agendado__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.DCC_Desistiu_Contratacao__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.DCC_Reduziu_Quadro_Funcionarios__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.DCC_Fechou_com_Concorrencia__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.DCC_Encerrou_as_atividades__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.Sem_Previsao_Pagamento_Boleto__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Reducao_Funcionarios__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Problemas_Financeiros__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Faturando_Outro_Beneficio__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Faturando_Contrato_Boas_Vindas__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Faturando_Contrato_mesmo_beneficio__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Nao_Informa_Motivo__c > paramTabulacao.Quantidade_Tentativas__c) ||
                            (cobranca.NAF_Realizado_Novo_Pedido__c > paramTabulacao.Quantidade_Tentativas__c))
                        {
                            System.debug('Excedeu Tentativas');
                            Cobranca__c novaCobranca = new Cobranca__c();
                            novaCobranca.Id = cobranca.id;
                            novaCobranca.Status__c = 'Finalizado';
                            novaCobranca.OwnerId = filaDescarteCobranca.Id;
                            lstCobranca.add(novaCobranca);
                            system.debug('lstCobranca: '+lstCobranca);
                        }
                    }
                }
            }
        }

    if (!lstCobranca.isEmpty() && lstCobranca.size() > 0)
    {
        try
        {
            Database.SaveResult[] lstSrCobranca = Database.update(lstCobranca, false);

            for (Database.SaveResult srCobranca :lstSrCobranca)
                {
                    if (!srCobranca.isSuccess())
                    {
                        System.debug('Errors update lstSrCobranca: '+srCobranca.getErrors());
                    }
                }
        }
        catch (Exception ex)
        {
            system.debug('Exception update lstSrCobranca: ' + ex.getLineNumber());
            system.debug('Exception update lstSrCobranca: ' + ex.getMessage());
        }
    }

System.debug('#Cobranca_After - Fim');

}