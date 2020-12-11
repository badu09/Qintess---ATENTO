trigger Cobranca_Before on Cobranca__c (before update, before insert)
{

    System.debug('#Cobranca_Before - Início');
    public  BusinessHours bh ;
    bh = [SELECT Id FROM BusinessHours Where IsDefault=true];


    for (Cobranca__c cobranca : Trigger.New)
        {
            cobranca.Data_Vencimento_Boleto__c = calcularDiaUtil(cobranca.Data_Disponibilizacao_Faturamento__c);
            System.debug('cobranca.DataVencimento : '+  cobranca.Data_Vencimento_Boleto__c);
            //Iniciar os contadores com valor zero, se não tiver tabulação.
            if (String.isBlank(cobranca.Tabulacao_Cobranca_Pai__c))
            {


                cobranca.Telefone_Errado__c = 0;
                cobranca.Telefone_Ocupado_ou_Nao_Atende__c = 0;
                cobranca.Telefone_Nao_Pertence_a_Empresa__c = 0;
                cobranca.Contato_Agendado__c = 0;
                cobranca.DCC_Desistiu_Contratacao__c = 0;
                cobranca.DCC_Reduziu_Quadro_Funcionarios__c = 0;
                cobranca.DCC_Fechou_com_Concorrencia__c = 0;
                cobranca.DCC_Encerrou_as_atividades__c = 0;
                cobranca.Sem_Previsao_Pagamento_Boleto__c = 0;
                cobranca.NAF_Reducao_Funcionarios__c = 0;
                cobranca.NAF_Problemas_Financeiros__c = 0;
                cobranca.NAF_Faturando_Outro_Beneficio__c = 0;
                cobranca.NAF_Faturando_Contrato_Boas_Vindas__c = 0;
                cobranca.NAF_Faturando_Contrato_mesmo_beneficio__c = 0;
                cobranca.NAF_Nao_Informa_Motivo__c = 0;
                cobranca.NAF_Realizado_Novo_Pedido__c = 0;
            }

            //Se Cobrança, contabilizar contadores
            if (String.isNotBlank(cobranca.Tabulacao_Cobranca_Pai__c) &&
                    TriggerUtils.isChanged(cobranca, Cobranca__c.Data_Hora_Tabulacao__c))
            {
                system.debug('Trigger Before Contar 1');
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'TELEFONE ERRADO')
                {
                    cobranca.Telefone_Errado__c = TriggerUtils.somarUm(cobranca.Telefone_Errado__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'TELEFONE OCUPADO OU NÃO ATENDE')
                {
                    cobranca.Telefone_Ocupado_ou_Nao_Atende__c =
                            TriggerUtils.somarUm(cobranca.Telefone_Ocupado_ou_Nao_Atende__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'TELEFONE NÃO PERTENCE A EMPRESA')
                {
                    cobranca.Telefone_Nao_Pertence_a_Empresa__c =
                            TriggerUtils.somarUm(cobranca.Telefone_Nao_Pertence_a_Empresa__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'CONTATO AGENDADO')
                {
                    cobranca.Contato_Agendado__c = TriggerUtils.somarUm(cobranca.Contato_Agendado__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'DESISTIU CONTRATAÇÃO')
                {
                    cobranca.DCC_Desistiu_Contratacao__c = TriggerUtils.somarUm(cobranca.DCC_Desistiu_Contratacao__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'REDUÇÃO DE FUNCIONÁRIO')
                {
                    cobranca.DCC_Reduziu_Quadro_Funcionarios__c =
                            TriggerUtils.somarUm(cobranca.DCC_Reduziu_Quadro_Funcionarios__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'FECHOU CONTRATO COM CONCORRENTE')
                {
                    cobranca.DCC_Fechou_com_Concorrencia__c =
                            TriggerUtils.somarUm(cobranca.DCC_Fechou_com_Concorrencia__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'DESEJA CANCELAR CONTRATO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'ENCERROU AS ATIVIDADES')
                {
                    cobranca.DCC_Encerrou_as_atividades__c =
                            TriggerUtils.somarUm(cobranca.DCC_Encerrou_as_atividades__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'SEM PREVISÃO PARA PAGAMENTO DO BOLETO')
                {
                    cobranca.Sem_Previsao_Pagamento_Boleto__c =
                            TriggerUtils.somarUm(cobranca.Sem_Previsao_Pagamento_Boleto__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'REDUÇÃO DE FUNCIONÁRIOS')
                {
                    cobranca.NAF_Reducao_Funcionarios__c = TriggerUtils.somarUm(cobranca.NAF_Reducao_Funcionarios__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'PROBLEMAS FINANCEIROS')
                {
                    cobranca.NAF_Problemas_Financeiros__c = TriggerUtils.somarUm(cobranca.NAF_Problemas_Financeiros__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'FATURANDO EM OUTRO BENEFÍCIO')
                {
                    cobranca.NAF_Faturando_Outro_Beneficio__c =
                            TriggerUtils.somarUm(cobranca.NAF_Faturando_Outro_Beneficio__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'FATURANDO NO CONTRATO BOAS-VINDAS')
                {
                    cobranca.NAF_Faturando_Contrato_Boas_Vindas__c =
                            TriggerUtils.somarUm(cobranca.NAF_Faturando_Contrato_Boas_Vindas__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c ==
                                'FATURANDO EM OUTRO CONTRATO DO MESMO BENEFÍCIO')
                {
                    cobranca.NAF_Faturando_Contrato_mesmo_beneficio__c =
                            TriggerUtils.somarUm(cobranca.NAF_Faturando_Contrato_mesmo_beneficio__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c == 'NÃO INFORMA O MOTIVO')
                {
                    cobranca.NAF_Nao_Informa_Motivo__c = TriggerUtils.somarUm(cobranca.NAF_Nao_Informa_Motivo__c);
                }
                if (cobranca.Tabulacao_Cobranca_Pai__c == 'NÃO ATINGIU FATURAMENTO' &&
                                cobranca.Tabulacao_Cobranca_Filho__c ==
                                'REALIZADO NOVO PEDIDO - AGUARDANDO FATURAMENTO')
                {
                    cobranca.NAF_Realizado_Novo_Pedido__c = TriggerUtils.somarUm(cobranca.NAF_Realizado_Novo_Pedido__c);
                }
            }
        }
        public static Date calcularDiaUtil(Date dataTabulacao){

            if(dataTabulacao != null){
                System.debug('datatab : ' + dataTabulacao);
                Date dataTabulacaoSub = dataTabulacao;
                Integer diasUteis = 0;
                Integer diasNaoUteis = 0;
                while(diasUteis < 3){
                    dataTabulacaoSub = dataTabulacaoSub-1;
                    if (BusinessHours.isWithin(bh.id, dataTabulacaoSub)) {
                        diasUteis++;
                        System.debug('diasUteis : ' +diasUteis);
                    }else{
                        diasNaoUteis++;
                        System.debug('diasNaoUteis : ' +diasNaoUteis);
                    }
                    dataTabulacaoSub = dataTabulacao - (diasUteis + diasNaoUteis);
                }
                System.debug('dataTab : ' + dataTabulacaoSub);
                return date.valueOf(dataTabulacaoSub);
            }else{
                return null;
            }

        }

    System.debug('#Cobranca_Before - Fim');

}