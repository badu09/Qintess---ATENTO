public class CtrlParametrosMetas {
    public List<ParametroMeta__c> lParametroMeta { get; set; }
    public String mes { get; set; }
    public String ano { get; set; }
    public String areaSelecionada { get; set; }
    public static Map<String, Set<User>> mDesdobramentoSupervisores { get; set; }
    public static Map<String, Set<User>> mDesdobramentoOperadores { get; set; }
    public Map<String, List<Calculo>> mCalculo { get; set; }
    public List<Calculo> lCalculo { get; set; }
    public String metaGlobalStr { get; set; }
    public Boolean permiteAlteracao { get; set; }
    public String qtdContrato { get; set; }
    public Boolean ativarParametroMeta { get; set; }
    public Boolean salvarParametroMeta { get; set; }

    public CtrlParametrosMetas() {
        this.permiteAlteracao = true;
        mes = String.valueOf(Date.today().month());
        ano = String.valueOf(Date.today().year());

        Schema.DescribeFieldResult fieldResult =
                Desdobramento__c.Area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        areaSelecionada = ple[0].getValue();

        obterParametros();
    }

    public List<SelectOption> getMeses() {
        List<SelectOption> retorno = new List<SelectOption>();
        retorno.add(new SelectOption('1', 'Janeiro'));
        retorno.add(new SelectOption('2', 'Fevereiro'));
        retorno.add(new SelectOption('3', 'Março'));
        retorno.add(new SelectOption('4', 'Abril'));
        retorno.add(new SelectOption('5', 'Maio'));
        retorno.add(new SelectOption('6', 'Junho'));
        retorno.add(new SelectOption('7', 'Julho'));
        retorno.add(new SelectOption('8', 'Agosto'));
        retorno.add(new SelectOption('9', 'Setembro'));
        retorno.add(new SelectOption('10', 'Outubro'));
        retorno.add(new SelectOption('11', 'Novembro'));
        retorno.add(new SelectOption('12', 'Dezembro'));
        return retorno;
    }

    public void obterParametros() {
        Integer month = Integer.valueOf(mes);
        Integer year = Integer.valueOf(ano);
        this.ativarParametroMeta = false;
        this.salvarParametroMeta = false;
        this.permiteAlteracao = true;
        List<ParametroMeta__c> lista = DAOParametroMeta.getParametroMeta(month, year, areaSelecionada);
        Date referencia = Date.newInstance(year, month, 1);
        this.metaGlobalStr = '';
        this.qtdContrato = '';
        //this.ano = '';
        
        system.debug('areaSelecionada: ' + areaSelecionada);
        system.debug('lista: ' + lista);
        
        if(lista == null || lista.isEmpty()) {
            System.debug('lista: ' + JSON.serialize(lista));
            List<Desdobramento__c> listaDesdobramento = DAODesdobramento.getByArea(areaSelecionada);
            carregarUsuarios();
            System.debug('listaDesdobramento: ' + JSON.serialize(listaDesdobramento));

            for(Desdobramento__c d : listaDesdobramento) {
                ParametroMeta__c p = new ParametroMeta__c();
                p.Desdobramento__c = d.Id;
                p.Desdobramento__r = d;
                p.DataReferencia__c = referencia;
                p.Ativo__c = false;
                Set<User> lOperadores = mDesdobramentoOperadores.get(d.Id);
                p.Qtd_de_Operador__c = lOperadores != null ? lOperadores.size() : 0;
                Set<User> lSupervisores = mDesdobramentoSupervisores.get(d.Id);
                p.Qtd_Supervisor__c = lSupervisores != null ? lSupervisores.size() : 0;
                lista.add(p);
            }
        }
        else {
        	this.ativarParametroMeta = true;
            this.metaGlobalStr = String.valueOf(lista[0].MetaGlobal__c);
            this.qtdContrato = String.valueOf(lista[0].Qtd_de_Contratos__c);
            
            for(ParametroMeta__c para : lista) {
                if(para.Ativo__c) {
                    this.permiteAlteracao = false;
                    this.ativarParametroMeta = false;
                    break;
                }
            }
        }

        this.lParametroMeta = lista;
    }

    public List<SelectOption> getAreas() {
        List<SelectOption> tipos = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
                Desdobramento__c.Area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
            {
                tipos.add(new SelectOption(f.getValue(), f.getValue()));
            }
        return tipos;
    }

    public void carregarUsuarios() {
		try {
			List<Desdobramento_Usuario__c> desdobramentosUsuarios = DAODesdobramentoUsuario.getByArea(this.areaSelecionada);
			mDesdobramentoSupervisores = new Map<String, Set<User>>();
            mDesdobramentoOperadores = new Map<String, Set<User>>();
			System.debug(JSON.serialize(desdobramentosUsuarios));
            for (Desdobramento_Usuario__c du : desdobramentosUsuarios) {
                if (du.Desdobramento__c != null) {
                    Set<User> listaS;
					Set<User> listaO;
					if (mDesdobramentoSupervisores.containsKey(du.Desdobramento__c)) {
						listaS = mDesdobramentoSupervisores.get(du.Desdobramento__c);
					} else {
						listaS = new Set<User>();
					}
					listaS.add(du.Supervisor__r);

					if (mDesdobramentoOperadores.containsKey(du.Desdobramento__c)) {
						listaO = mDesdobramentoOperadores.get(du.Desdobramento__c);
					} else {
						listaO = new Set<User>();
					}
					listaO.add(du.Operador__r);
					mDesdobramentoOperadores.put(du.Desdobramento__c, listaO);
					mDesdobramentoSupervisores.put(du.Desdobramento__c, listaS);
                }
            }
			system.debug('mDesdobramentoOperadores: ' + JSON.serialize(mDesdobramentoOperadores));
			system.debug('mDesdobramentoSupervisores: ' + JSON.serialize(mDesdobramentoSupervisores));
        }
        catch(Exception e) {
            System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
        }
    }

    public void salvar() {
        try {
            Decimal metaGlobal = Decimal.valueOf(metaGlobalStr.replaceAll('\\.', '').replaceAll(',', '.'));
            Date inicioVigencia = Date.newInstance(Integer.valueOf(this.ano), Integer.valueOf(this.mes), 1);
            for(ParametroMeta__c para : this.lParametroMeta) {
                para.MetaGlobal__c = metaGlobal;
                para.Qtd_de_Contratos__c = qtdContrato != null && String.isNotEmpty(qtdContrato) ? Decimal.valueOf(qtdContrato) : 0;
                para.DataReferencia__c = inicioVigencia;
                if (para.Representacao__c != null && para.Representacao__c > 0 && para.Qtd_de_Operador__c != null 
                	&& para.Qtd_Supervisor__c != null && para.Qtd_de_Operador__c > 0 && para.Qtd_Supervisor__c > 0) {
                    
                    para.Representacao__c = para.Representacao__c;
                    para.Valor_Meta_Operador__c = metaGlobal * (para.Representacao__c / 100) / para.Qtd_de_Operador__c;
                    para.Valor_Meta_Supervisor__c = metaGlobal * (para.Representacao__c / 100) / para.Qtd_Supervisor__c;
                    para.Qtd_Contratos_Operador__c = para.Qtd_de_Contratos__c != null ? para.Qtd_de_Contratos__c * (para.Representacao__c / 100) / para.Qtd_de_Operador__c : 0;
                    para.Qtd_Contratos_Supervisor__c = para.Qtd_de_Contratos__c != null ? para.Qtd_de_Contratos__c * (para.Representacao__c / 100) / para.Qtd_Supervisor__c : 0;
                }
                else {
                    para.Representacao__c = 0;
                    para.Valor_Meta_Operador__c = 0;
                    para.Valor_Meta_Supervisor__c = 0;
                }
            }
            
            upsert this.lParametroMeta;
            this.ativarParametroMeta = true;
            this.salvarParametroMeta = false;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Salvo com sucesso!'));
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e + ''));
            System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
        }
    }

    public void simular() {
        carregarUsuarios();
        if (metaGlobalStr == null || metaGlobalStr == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A meta global deve ter no máximo 18 digitos.'));
            return;
        }
        Decimal metaGlobal = Decimal.valueOf(metaGlobalStr.replaceAll('\\.', '').replaceAll(',', '.'));
        // Verifica se o valor da meta global é maior que 18 digitos
        if(metaGlobal == null || String.valueOf(metaGlobal).replaceAll('\\.|,', '').length() > 18) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A meta global deve ter no máximo 18 digitos.'));
            return;
        }

        // Verifica se a soma total dos percentuais dos desdobramento está em 100%
        Decimal percentualTotal = 0;
        for(ParametroMeta__c para : this.lParametroMeta) {
            if (para.Representacao__c > 0) {
                percentualTotal += para.Representacao__c;
            }
        }
        if(areaSelecionada.containsIgnoreCase('Venda') && percentualTotal > 100.00) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A soma de todos os percentuais dos desdobramentos deve ser exatamente 100%.'));
            return;
        }

        // Verifica se existe Supervisores e Operadores dentro dos desdobramentos
        for(ParametroMeta__c para : this.lParametroMeta) {
            if(para.Representacao__c > 0) {
                if (para.Qtd_Supervisor__c == null || para.Qtd_Supervisor__c == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                    'Não foram encontrados Supervisores associados ao desdobramento: ' +
                                    para.Desdobramento__r.Name));
                    return;
                }

                if (para.Qtd_de_Operador__c == null || para.Qtd_de_Operador__c == 0) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                    'Não foram encontrados Operadores associados ao desdobramento: ' +
                                    para.Desdobramento__r.Name));
                    return;
                }
            }
        }

        mCalculo = new Map<String, List<Calculo>>();

        // Popula o mCalculo para apresentar na Tela
        for(Set<User> ls : mDesdobramentoSupervisores.values()) {
            for(User s : ls) {
                mCalculo.put(s.Id, new List<Calculo>());
            }
        }

        Map<String, ParametroMeta__c> mParametros = new Map<String, ParametroMeta__c>();
        for(ParametroMeta__c para : lParametroMeta) {
                mParametros.put(para.Desdobramento__r.Id, para);
        }

        lCalculo = new List<Calculo>();

        for(String supervisorId : mCalculo.keySet()) {
            List<Calculo> calculos = mCalculo.get(supervisorId);
            for(String idDesdobramento : mDesdobramentoSupervisores.keySet()) {
                for(User us: mDesdobramentoSupervisores.get(idDesdobramento)) {
                    if(us.Id == supervisorId) {
                        Calculo calc = new Calculo();
                        ParametroMeta__c parametro = mParametros.get(idDesdobramento);
                        if(parametro != null) {
                            parametro.Representacao__c = parametro.Representacao__c != null ? parametro.Representacao__c : 0;
                            //if(parametro.Representacao__c > 0) {
                            if (parametro.Representacao__c != null && parametro.Representacao__c > 0 && parametro.Qtd_de_Operador__c != null 
                            	&& parametro.Qtd_Supervisor__c != null && parametro.Qtd_de_Operador__c > 0 && parametro.Qtd_Supervisor__c > 0) {
                					
                                //parametro.Qtd_Supervisor__c = parametro.Qtd_Supervisor__c != null ? parametro.Qtd_Supervisor__c : 0;
                                //parametro.Qtd_de_Operador__c = parametro.Qtd_de_Operador__c != null ? parametro.Qtd_de_Operador__c : 0;
                                calc.supervisor = us;
                                calc.parametroMeta = parametro;
                                calc.metaSupervisorDesdobramento = metaGlobal * (parametro.Representacao__c / 100) / parametro.Qtd_Supervisor__c;
                                calc.metaOperador = metaGlobal * (parametro.Representacao__c / 100) / parametro.Qtd_de_Operador__c;
                                calc.qtdContratoOperador = qtdContrato != null && String.isNotEmpty(qtdContrato) ? Decimal.valueOf(qtdContrato) * (parametro.Representacao__c / 100): 0;
                                calc.qtdContratoSupervisor = qtdContrato != null && String.isNotEmpty(qtdContrato) ? Decimal.valueOf(qtdContrato) * (parametro.Representacao__c / 100) * parametro.Qtd_de_Operador__c : 0;
                                calculos.add(calc);
                                break;
                            }
                        }
                    }
                }
            }
            Decimal totalMetaSupervisor = 0;
            for(Calculo c : calculos) {
                totalMetaSupervisor += c.metaSupervisorDesdobramento;
            }

            for(Calculo c : calculos) {
                c.metaGeralSupervisor = totalMetaSupervisor;
            }

            lCalculo.addAll(calculos);
            mCalculo.put(supervisorId, calculos);
        }
        
        this.salvarParametroMeta = true;
    }


    public void limpar() {
        lCalculo = new List<Calculo>();
        mCalculo = new Map<String, List<CtrlParametrosMetas.Calculo>>();
        mes = String.valueOf(Date.today().month());
        ano = String.valueOf(Date.today().year());

        Schema.DescribeFieldResult fieldResult =
                Desdobramento__c.Area__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        areaSelecionada = ple[0].getValue();

        this.metaGlobalStr = '';
        obterParametros();

    }

    public void ativar() {
        carregarUsuarios();
        Boolean jaExisteAtivo = false;
        for(ParametroMeta__c para : lParametroMeta) {
            if(para.Ativo__c) {
                jaExisteAtivo = para.Ativo__c;
                break;
            }
        }
        if(jaExisteAtivo) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Já existe metas ativadas para esse mês.'));
        }
        else {
            try {
                Date inicioVigencia = Date.newInstance(Integer.valueOf(this.ano), Integer.valueOf(this.mes), 1);
                Date fimVigencia =
                        Date.newInstance(Integer.valueOf(this.ano), Integer.valueOf(this.mes) + 1, 1).addDays(-1);
                List<Meta__c> metas = new List<Meta__c>();
                for (Calculo c : lCalculo) {
//                    if(c != null && c.parametroMeta != null && c.parametroMeta.Desdobramento__r != null) {
//                        for (User supervisor : mDesdobramentoSupervisores.get(c.parametroMeta.Desdobramento__r.Id)) {
//                            Meta__c meta = new Meta__c();
//                            meta.DataInicioVigencia__c = inicioVigencia;
//                            meta.DataFimVigencia__c = fimVigencia;
//                            meta.Valor_da_Meta__c = c.metaSupervisorDesdobramento;
//                            meta.Supervisor__c = supervisor.Id;
//                            meta.ParametroMeta__c = c.parametroMeta.Id;
//                            metas.add(meta);
//                        }
//                    }

                    if(c != null && c.parametroMeta != null && c.parametroMeta.Desdobramento__r != null) {
                        for (User operador : mDesdobramentoOperadores.get(c.parametroMeta.Desdobramento__r.Id)) {
                            Meta__c meta = new Meta__c();
                            meta.DataInicioVigencia__c = inicioVigencia;
                            meta.DataFimVigencia__c = fimVigencia;
                            meta.Valor_da_Meta__c = c.metaOperador;
                            meta.Operador__c = operador.Id;
							meta.Supervisor__c = c.supervisor.Id;
                            meta.ParametroMeta__c = c.parametroMeta.Id;
                            metas.add(meta);
                        }
                    }
                }
                for (ParametroMeta__c para : lParametroMeta) {
                    para.Ativo__c = true;
                }
                insert metas;
                salvar();
                this.permiteAlteracao = false;
            }
            catch(DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e + ''));
                System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
            }
        }
    }


    // Objeto de apoio par ao cálculo
    public class Calculo {
        public User supervisor{ get; set; }
        public ParametroMeta__c parametroMeta { get; set; }
        public Decimal metaSupervisorDesdobramento { get{ return this.metaSupervisorDesdobramento.setScale(2); } set; }
        public Decimal metaOperador { get{ return this.metaOperador.setScale(2); } set; }
        public Decimal metaGeralSupervisor { get{ return this.metaGeralSupervisor.setScale(2); } set; }
        public Decimal qtdContratoOperador { get{ return this.qtdContratoOperador.setScale(2); } set; }
        public Decimal qtdContratoSupervisor { get{ return this.qtdContratoSupervisor.setScale(2); } set; }
    }
}