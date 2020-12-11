(function () {

    /*
    ############# AGENT COMMAND ##############
    */


    /**
     * @constructor OlosAgentCommand
     * @description OlosAgentCommand implementa os comandos da this.olosAgentWS.
     * @returns {OlosAgentCommand}
     */
    var OlosAgentCommand = (function () {
        var olosAgentWS;
        if (!olosAgentWS) {
            olosAgentWS = new OlosAgentWS();
        }

        return {
            connect: function (addr) {
                olosAgentWS.connect(addr);
            },

            on: function on(evname, callback) {
                olosAgentWS.on(evname, callback);
            },

            off: function off(evname) {
                olosAgentWS.off(evname);
            },

            trigger: function trigger(evname, params) {
                olosAgentWS.trigger(evname, params);
            },
            setLogger: function setLogger(logger) {
                olosAgentWS.setLoger(logger);
            },
            /**
             * @description Realiza a autenticação do agente. Caso a autenticação for bem sucedida, o agentId, será > 0.
             * @param {String} login
             * @param {String} passwd
             * @returns {int} agentId
             */
            agentAuthentication: function (login, passwd, callback) {
                olosAgentWS.agentAuthentication(login, passwd, callback);
            },

            /**
             * @description Realiza a autenticação do agente e coloca em pausa logo em seguida. Caso a autenticação for bem sucedida, o agentId, será > 0.
             * @param {String} login
             * @param {String} passwd
             * @param {String} reasonCode
             * @returns {int} agentId
             */
            agentAuthenticationWithPause: function (login, passwd, reasonCode, callback) {
                olosAgentWS.agentAuthenticationWithPause(login, passwd, reasonCode, callback);
            },

            /**
             * @description Solicita pausa com base no reasonId (motivo da pausa). Caso o estado atual do agente seja TalkingWithPause ou WrapWithPause, solicitações anteriores do agentIdleRequest(), caso existam, serão canceladas.
             * @param {int} reasonId
             * @returns {undefined}
             */
            agentReasonRequest: function (reasonId) {
                olosAgentWS.agentReasonRequest(reasonId);
            },
            /**
             * @description Solicita a pausa do agente ao Olos. Caso o estado atual do agente seja TalkingWithPause ou WrapWithPause, solicitações anteriores do agentIdleRequest(), caso existam, serão canceladas.
             * @param {String} reasonCode código do motivo da pausa.
             * @returns {undefined}
             */
            agentReasonRequestByCode: function (reasonCode) {
                olosAgentWS.agentReasonRequestByCode(reasonCode);
            },
            /**
             * Solicita saida de pausa e entre no estado Idle para começar a receber ligações. Caso o estado atual do agente seja TalkingWithPause ou WrapWithPause, o estado será alterado primeiramente para Pause e em seguida para Idle.
             */
            agentIdleRequest: function () {
                olosAgentWS.agentIdleRequest();
            },
            updateAgentIpAddress: function (ip) {
                olosAgentWS.updateAgentIpAddress(ip);
            },
            /**
             * @description Solicita a lista de pausas do agente ao Olos.
             * @returns {JSON} listReasons Lista de pausas.
             */
            listReasons: function (callback) {
                var listReasons = olosAgentWS.listReasons(callback);
            },

            /**
             * @description Solicita a lista re Resultados e uma determinada campanha.
             * @returns {JSON} listDispositions Lista de pausas.
             */
            listDispositions: function (campaignId) {
                olosAgentWS.listDispositions(campaignId);
            },

            /**
             * @description Lista todas as ligações ativas.
             * @returns {JSON} listActiveCaslls Lista de ligações.
             */
            listActiveCalls: function () {
                olosAgentWS.listActiveCalls();
            },

            /**
             * @description Lista todas os agentes ativos.
             * @returns {JSON} listOnlineAgents Lista de agents.
             */
            listOnlineAgents: function () {
                olosAgentWS.listOnlineAgents();
            },

            /**
             * @description Lista campanhas para consulta. Pega da Tabela CampaingControl ConfigCampaign que vai para OnlineCampaing
             * @returns {JSON} campaigns Lista de campanhas.
             */
            listCampaignsToConsulting: function () {
                olosAgentWS.listCampaignsToConsulting();
            },

            /**
             * @description Desconecta uma chamada. Utilizado para desligar uma ligação Ativa, Receptiva ou Manual.
             * @returns {undefined}
             */
            hangupRequest: function (callId = null) {
                olosAgentWS.hangupRequest(callId);
            },
            /**
             * @description Redisca última discagem realizada por uma campanha ativa. O agente precisa estar no estado Wrap.
             * @returns {undefined}
             */
            redialRequest: function () {
                olosAgentWS.redialRequest();
            },
            /**
             * Finaliza atendimento.
             * Esse método é utilizado para tabulalções de Sucesso (Negócio), Sucesso (Recusa), Falha.
             * Verificar configuração da tabulação no Olos.
             *
             * @param {int} dispositionId código da tabulação.
             */
            dispositionCall: function (dispositionId) {
                olosAgentWS.dispositionCall(dispositionId);
            },
            /**
             * Finaliza atendimento.
             * Esse método é utilizado para tabulalções de Sucesso (Negócio), Sucesso (Recusa), Falha.
             * Verificar configuração da tabulação no Olos.
             *
             * @param {String} dispositionCode código da tabulação.
             */
            dispositionCallByCode: function (dispositionCode) {

                olosAgentWS.dispositionCallByCode(dispositionCode);
                //olosAgentWS.dispositionCallByCode(dispositionCode);
            },
            /**
             * Finaliza atendimento com agendamento.
             * Esse método é utilizado para tabulalções de Agendamento.
             * Verificar configuração da tabulação no Olos.
             *
             * @param {int} dispositionId código da tabulação.
             * @param {String} year
             * @param {String} month
             * @param {String} day
             * @param {String} hour
             * @param {String} minute
             * @param {String} phoneNumber
             * @param {boolean} specificAgent
             */
            dispositionCallBack: function (dispositionId, year, month, day, hour, minute, phoneNumber, specificAgent) {
                olosAgentWS.dispositionCallBack(dispositionId, year, month, day, hour, minute, phoneNumber, specificAgent);
            },
            /**
             * Finaliza atendimento com agendamento.
             * Esse método é utilizado para tabulalções de Agendamento.
             * Verificar configuração da tabulação no Olos.
             *
             * @param {String} dispositionCode código da tabulação.
             * @param {String} year
             * @param {String} month
             * @param {String} day
             * @param {String} hour
             * @param {String} minute
             * @param {String} phoneNumber
             * @param {boolean} specificAgent
             */
            dispositionCallBackByCode: function (dispositionCode, year, month, day, hour, minute, phoneNumber, specificAgent) {
                olosAgentWS.dispositionCallBackByCode(dispositionCode, year, month, day, hour, minute, phoneNumber, specificAgent);
            },
            /**
             * Solicita o estado de ManualCall. Esse estado permite que o agente realize uma ou mais discagens manuais.
             */
            manualCallStateRequest: function () {
                olosAgentWS.manualCallStateRequest();
            },
            /**
             * Finaliza o estado de ManualCall. Esse método faz com que o agente entre no estado Idle para receber ligações preditivas.
             */
            endManualCallStateRequest: function () {
                olosAgentWS.endManualCallStateRequest();
            },
            /**
             * Solicita uma discagem manual. É necessário que o agente esteja no estado ManualCall para realizar uma discagem.
             *
             * @param {String} ddd DDD com 2 dígitos.
             * @param {String} phoneNumber telefone para discagem
             * @param {int} campaignId código da campanha que será utilizada para discagem.
             * Essa campanha precisa ter uma rota de discagem válida e disponível.
             */
            sendManualCallRequest: function (ddd, phoneNumber, campaignId) {
                olosAgentWS.sendManualCallRequest(ddd, phoneNumber, campaignId);
            },
            /**
             * Realiza uma discagem em preview. É necessário que o agente esteja no estado Analyzing para realizar uma discagem.
             *
             * @param {String} phoneNumber telefone para discagem
             */
            sendPreviewCallRequest: function (phoneNumber) {
                olosAgentWS.sendPreviewCallRequest(phoneNumber);
            },
            /**
             * Pula para o próximo cliente. Utilizado somente no Preview.
             *
             */
            closeCustomer: function () {
                olosAgentWS.closeCustomer();
            },
            /**
             * Pula para o próximo cliente. Utilizado somente no Preview.
             *
             */
            closeCustomerWithDispositionId: function (dispositionId) {
                olosAgentWS.closeCustomerWithDispositionId(dispositionId);
            },
            /**
             * Pula para o próximo cliente. Utilizado somente no Preview.
             *
             */
            closeCustomerWithDispositionCode: function (dispositionCode) {
                olosAgentWS.closeCustomerWithDispositionCode(dispositionCode);
            },
            /**
             * Realiza consulta a um número externo ou à uma campanha. Se a consulta for
             * para uma campanha, o campaignId deverá ser > 0 e o phoneNumber = "". Caso
             * for para um número externo, o campaignId = 0 e o phoneNumber DDD +
             * Telefone. No caso de uma consulta para campanha, será realizada uma
             * transferência cega, ou seja, o cliente será conectado diretamente à
             * consulta e desconectado do agente.
             *
             * @param phoneNumber telefone com DDD para discagem. Deverá ser branco,
             * caso a consulta for para campanha.
             * @param campaignId código da campanha que será utilizada para discagem.
             * Deverá ser 0 (zero), caso a consulta for para um telefone. Essa campanha
             * precisa ter uma rota de discagem válida e disponível para consultas.
             * @param uuiData informação adicional que pode ser enviada quando o link E1
             * for ISDN.
             */
            consultingRequest: function (phoneNumber, campaignId, uuiData) {
                olosAgentWS.consultingRequest(phoneNumber, campaignId, uuiData);
            },

            /**
             * Consulta um agente. O estado do agente consultado é alterado para PersonalCall.
             *
             * @param transferAgentId Id do agente.
             * @param transferLogin login do agente.
             * @param uuiData informação adicional que pode ser enviada quando o link E1
             * for ISDN.
             */
            consultingAgentRequest: function (transferAgentId, transferLogin, uuiData) {
                olosAgentWS.consultingAgentRequest(transferAgentId, transferLogin, uuiData);
            },

            /**
             * Transfere a ligação do cliente ao consultado.
             */
            transferCallRequest: function () {
                olosAgentWS.transferCallRequest();
            },

            /**
             * Transfere a ligação do cliente ao consultado (externo), às cegas.
             */
            blindTransferCallRequest: function (phoneNumber, uuiData) {
                olosAgentWS.blindTransferCallRequest(phoneNumber, uuiData);
            },

            /**
             * Recupera a ligação que estava em espera (hold).
             */
            retrievesCall: function () {
                olosAgentWS.retrievesCall();
            },

            /**
             * Atualiza os dados do clientes no mailing, exceto os telefones. Esse
             * método precisa ser executado durante um atendimento.
             *
             * @param {String} mailingData XML com informações dos campos a serem atualizados. O nome da tag do XML precisa ser o mesmo nome do campo da tabela do mailing. Exemplo de XML: <Nome>Joao da Silva</Nome><Endereco>Av Paulista, 0000</Endereco>.
             * @returns {int} Retorna -1: Erro desconhecido; 0: OK; 1: Agente não está em
             * atendimento em uma campanha Ativa.
             */
            updateMailingData: function (mailingData) {
                var errorCode = olosAgentWS.updateMailingData(mailingData);
                return errorCode;
            },

            /**
             * Atualiza os dados do clientes no mailing, exceto os telefones. Esse
             * método precisa ser executado durante um atendimento.
             *
             * @param {String} mailingData XML com informações dos campos a serem atualizados. O nome da tag do XML precisa ser o mesmo nome do campo da tabela do mailing. Exemplo de XML: <Nome>Joao da Silva</Nome><Endereco>Av Paulista, 0000</Endereco>.
             * @returns {int} Retorna -1: Erro desconhecido; 0: OK; 1: Agente não está em
             * atendimento em uma campanha Ativa.
             */
            updateCallData: function (campaignData) {
                olosAgentWS.updateCallData(campaignData);
                //return errorCode;
            },

            /**
             * Retorna o estado atual do agente.
             *
             * @return {String} Retorna o estado atual do agente.
             */
            getAgentStatus: function () {
                var status = olosAgentWS.getAgentStatus();
                return status;
            },

            getActiveCall: function getActiveCall() {
                return olosAgentWS.getActiveCall();
            },

            /**
             * @description Desconecta o agente do Olos.
             */
            agentLogout: function () {
                olosAgentWS.agentLogout();
            },
            
            /**
             * @description Inicia Conferência.
             */
            conferenceRequest: function () {
                olosAgentWS.conferenceRequest();
            },

            /**
             * @description Para Conferência.
             */
            stopConferenceRequest: function () {
                olosAgentWS.stopConferenceRequest();
            },
            
            /**
            * Retorna uma Lista (Objeto) com todos os status dos Agentes
            *
            * @return {Object} 
            */
            getListStatusAgent: function () {
                return olosAgentWS.getListStatus();
            },

        };

    })();

    /*deprecated*/
    function olosDispatchEvent(objEvent) {
        olosEvents(objEvent);
    }

    /*
    ############# MAILING COMMAND ##############
    */

    var OlosMailingCommand = (function () {
        var olosMailingWS;
        if (!olosMailingWS) {
            olosMailingWS = new OlosMailingWS();
        }

        return {
            connect: function (addr) {
                olosMailingWS.connect(addr);
            },
            on: function on(evname, callback) {
                olosMailingWS.on(evname, callback);
            },
            off: function off(evname) {
                olosMailingWS.off(evname);
            },
            trigger: function trigger(evname, params) {
                olosMailingWS.trigger(evname, params);
            },
            setActiveCall: function setActiveCall(activeCall) {
                olosMailingWS.setActiveCall(activeCall);
            },
            /**
             * Invalida um telefone específico de um registro no mailing. Esse método
             * precisa ser executado durante um atendimento.
             *
             * @param {String} ddd DDD com 2 dígitos.
             * @param {String} phoneNumber telefone para discagem
             */
            invalidatePhoneNumber: function (ddd, phoneNumber) {
                olosMailingWS.invalidatePhoneNumber(ddd, phoneNumber);
            },
            /**
             * Insere um novo telefone para um registro no mailing. Esse método precisa
             * ser executado durante um atendimento.
             *
             * @param {String} ddd DDD com 2 dígitos.
             * @param {String} phoneNumber telefone para discagem
             * @param {String} callback função que será chamada, caso o método seja executado com sucesso. Essa função deverá receber um parâmetro que será a respostas do sucesso.
             */
            insertPhoneNumber: function (ddd, phoneNumber, callback) {
                olosMailingWS.insertPhoneNumber(ddd, phoneNumber, callback);
            },
            /**
             * Finaliza o cliente por disposition code. Caso o mailingName não foir informado, este customerId será finalizado em todos os mailings.
             *
             * @param {String} campaignId ID da campanha. Utilizado para identificar o DispositionId do DispositionCode informado.
             * @param {String} mailingName nome do mailing (opcional). Caso não seja informado. O customerId será finalizado em todos os mailings ativos.
             * @param {String} dispCode dispositionCode.
             * @param {String} customerId código que identifica o cliente.
             * @param {String} callback função que será chamada, caso o método seja executado com sucesso. Essa função deverá receber um parâmetro que será a respostas do sucesso.
             */
            finalizeClientByDispositionCode: function (campaignId, mailingName, dispCode, customerId, callback) {
                olosMailingWS.finalizeClientByDispositionCode(campaignId, mailingName, dispCode, customerId, callback);
            },
            /**
             * Finaliza o cliente por disposition ID. Caso o mailingName não foir informado, este customerId será finalizado em todos os mailings.
             *
             * @param {String} mailingName nome do mailing (opcional). Caso não seja informado. O customerId será finalizado em todos os mailings ativos.
             * @param {String} dispId dispositionId (código numérico).
             * @param {String} customerId código que identifica o cliente.
             * @param {String} callback função que será chamada, caso o método seja executado com sucesso. Essa função deverá receber um parâmetro que será a respostas do sucesso.
             */
            finalizeClient: function (mailingName, dispId, customerId, callback) {
                olosMailingWS.finalizeClient(mailingName, dispId, customerId, callback);
            },

            listMailings: function (campaignId, callback) {
                olosMailingWS.listMailings(campaignId, callback)
            }

        }
    })();


    /*
    ############# Olos Integration ##############
    */

    /**
     * @constructor OlosIntegration
     * @description Classe responsável para ampliar os metodos disponiveis para integração.
     * @returns {OlosIntegration}
     */

    var OlosIntegrationCommand = (function () {
        this.olosIntegrationWS;
        if (!this.olosIntegrationWS) {
            this.olosIntegrationWS = new OlosIntegrationWS();
        }

        return {
            connect: function (addr) {
                olosIntegrationWS.connect(addr);
            },
            on: function on(evname, callback) {
                olosIntegrationWS.on(evname, callback);
            },
            off: function off(evname) {
                olosIntegrationWS.off(evname);
            },
            trigger: function trigger(evname, params) {
                olosIntegrationWS.trigger(evname, params);
            },

            /**
             * Retorna Agentes passiveis de transferencia.
             *
             * @param 
             * @returns Event <List>Agents
             */
            listAvailableOnlineAgentsByCompany: function (agentId) {
                olosIntegrationWS.listAvailableOnlineAgentsByCompany(agentId);
            },
            /**
             * Retorna Campanhas passiveis de transferencia.
             * obs: configurar as campanhas em  OlosWebAgent.dbo.Settings Verificar se existe a procedure PS_CampaignsToConsulting
             * @param 
             * @returns Event <List>Agents
             */

            listCampaignsToConsulting: function (campaignId) {
                olosIntegrationWS.listCampaignsToConsulting(campaignId);
            },
        }

    })();

    /*
    ############# VOICE SUPPORT ##############
    */

    var OlosVoiceSupport = (function () {
        var olosVoiceSupportWS;
        if (!olosVoiceSupportWS) {
            olosVoiceSupportWS = new OlosVoiceSupportWS();
        }

        return {
            connect: function (addr) {
                //console.log(olosVoiceSupportWS);
                olosVoiceSupportWS.connect(addr);
            },
            on: function on(evname, callback) {
                olosVoiceSupportWS.on(evname, callback);
            },
            off: function off(evname) {
                olosVoiceSupportWS.off(evname);
            },
            trigger: function trigger(evname, params) {
                olosVoiceSupportWS.trigger(evname, params);
            },
            setActiveCall: function setActiveCall(activeCall) {
                olosVoiceSupportWS.setActiveCall(activeCall);
            },
            /**
             * Executa um áudio dentro durante uma chamada de um agente
             * 
             *
             * @param {String} Login do agente onde o áudio será executado.
             * @param {String} Nome do áudio à ser executado
             */
            start: function (login, audio) {
                olosVoiceSupportWS.start(login, audio)
            }
        }
    })();

    /*
    ############# USER CONFIG ##############
    */

    /**
     * @constructor OlosUserConfig
     * @description Classe responsável por gerenciar as configurações dos usuários do sistema.
     * @returns {OlosUserConfig}
     */
    var OlosUserConfig = function () {
        this.olosUserConfigWS;
        if (!this.olosUserConfigWS) {
            this.olosUserConfigWS = new OlosUserConfigWS();
        }

        this.connect = function (addr) {
            this.olosUserConfigWS.connect(addr);
        };

        /**
         * Associa ou desassocia a(s) campanha(s) ao agente especificado.
         *
         * @param {String} agentLogin Login do agente
         * @param {String} campaignIdOld ID da campanha atual do agente a ser desassociada.
         * Se for zero, o agente será desassociado de todas as campanhas. Se for
         * "null", o agente não será desassociado
         * @param {int} campaignIdNew ID da nova campanha. Associa o agente à nova
         * campanha
         * @returns {boolean} Retorna true se as alterações foram realizadas com sucesso.
         */
        this.changeAgentCampaign = function (agentLogin, campaignIdOld, campaignIdNew) {
            var changed = this.olosUserConfigWS.changeAgentCampaign(agentLogin, campaignIdOld, campaignIdNew);
            return changed;
        };

        /**
         * Associa um supervisor ao agente especificado.
         *
         * @param {String} agentLogin Login do agente
         * @param {String} supervisorLogin Login do supervisor.
         * @returns {boolean} Retorna true se o novo supervisor foi associado com sucesso.
         */
        this.changeAgentSupervisor = function (agentLogin, supervisorLogin) {
            var changed = this.olosUserConfigWS.changeAgentSupervisor(agentLogin, supervisorLogin);
            return changed;
        };

        /**
         * Cria um agente.
         *
         * @param {String} name Nome do agente
         * @param {String} login Login do agente
         * @param {String} passwd Senha do agente
         * @param {int} profileId ID do perfil do usuário (Consulte getUserProfiles()).
         * @param {int} companyId ID da organização que o agente irá trabalhar (Consultar
         * sistema Olos).
         * @returns {bollean} Retorna true se o novo agente foi criado com sucesso.
         */
        this.createAgent = function (name, login, passwd, profileId, companyId) {
            var created = this.olosUserConfigWS.createAgent(name, login, passwd, profileId, companyId);
            return created;
        };

        /**
         * Ativa ou inativa um usuário.
         *
         * @param {String} userLogin Login do usuário
         * @param {bollean}  enableUser Habilitar usuário no sistema
         * @returns {boolean} Retorna true se a atualização foi realizada com sucesso.
         */
        this.setUserStatus = function (userLogin, enableUser) {
            var created = this.olosUserConfigWS.setUserStatus(userLogin, enableUser);
            return created;
        };

        /**
         * Retorna o estado do cadastro do usuário.
         *
         * @param {String} userLogin Login do usuário
         * @returns {String} Retorna ACTIVE, INACTIVE ou NO_EXISTS.
         */
        this.getUserStatus = function (userLogin) {
            return this.olosUserConfigWS.getUserStatus(userLogin);
        };

        /**
         * Retorna os perfis dos usuários do sistema.
         *
         * @returns {JSON}
         */
        this.getUserProfiles = function () {
            var result = this.olosUserConfigWS.getUserProfiles();
            return result;
        };

        /**
         * Retorna as campanhas associadas ao agente especificado.
         *
         * @param {String} login Login do agente
         * @returns {JSON} Retorna as campanhas associadas ao agente especificado.
         */
        this.getCampaignByUserLogin = function (login, callback) {
            this.olosUserConfigWS.getCampaignByUserLogin(login, callback);
        };

        /**
         * Retorna as organizações associadas ao agente especificado.
         *
         * @param {String} login Login do agente
         * @returns {JSON} Retorna as organiza associadas ao agente especificado.
         */
        this.getCustomerByUserLogin = function (login, callback) {
            this.olosUserConfigWS.getCustomerByUserLogin(login, callback);
        };
    };

    var logger = (function () {
        return {
            // NONE, ERROR, INFO , DEBUG
            trigger: {},
            level: 'NONE',
            htmlLog: '',
            logWindow: {},
            logOpenWindow: 1,
            logDateTime: function () {
                return new Date().toLocaleString();
            },
            startWindowLog: function startWindowLogWindow(logOpenWindow) {
                if (logOpenWindow) {
                    var strWindowFeatures = "directories=no,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,status=no,width=300,height=300";
                    this.logWindow = window.open('', 'OlosLog', strWindowFeatures);
                    //this.logWindow.location = 'about:blank';
                    var olosLog = this.logWindow.document.createElement('div');
                    olosLog.id = 'log';
                    olosLog.innerHTML = this.logDateTime() + '  Start logging...</br>';
                    var body = this.logWindow.document.getElementsByTagName('body')[0];
                    body.appendChild(olosLog);
                    this.htmlLog = olosLog;
                }
            },
            loggerWindow: function (msg) {
                if (this.htmlLog && !this.logWindow.closed) {
                    this.htmlLog.innerHTML += this.logDateTime() + '  ' + msg + '</br>';
                }
            },
            error: function logError(msg) {
                if (this.level === 'ERROR') {
                    this.trigger('log', this.logDateTime() + '  ERROR  ' + msg);
                }
            },
            info: function logInfo(msg) {
                if (this.level === 'INFO' || this.level === 'DEBUG') {
                    this.trigger('log', this.logDateTime() + '  INFO  ' + msg)
                }
            },
            debug: function logDebug(msg) {
                if (this.level === 'DEBUG') {
                    this.trigger('log', this.logDateTime() + '  DEBUG  ' + msg)
                }
            }
        }
    })();

    function createOlos() {
        Olos = (function () {
            var _callbacks = {};
            return {
                trigger: function (evname, params) {
                    if (_callbacks[evname]) {
                        _callbacks[evname].fire(params);
                    }
                },
                on: function (evname, callback) {
                    if (!_callbacks[evname]) {
                        _callbacks[evname] = $.Callbacks();
                    }
                    _callbacks[evname].add(callback);
                },
                off: function (evname) {
                    if (!_callbacks[evname]) {
                        return;
                    }
                    _callbacks[evname] = null;
                },
                agentCommand: OlosAgentCommand,
                mailingCommand: OlosMailingCommand,
                integrationCommand: OlosIntegrationCommand,
                voiceSupportCommand: OlosVoiceSupport,
                userConfig: new OlosUserConfig(),

                /**
                 * Cria conexão com os WebServices especificados.
                 *
                 * @param {String} addrs Endereços dos WebServices. Ex: var addrs = { wsAgentCmd: "", wsAgentEvt: "", wsMailingCmd: "", wsAgentConfigCmd: "",  wsIntegrationCmd: "" };
                 */
                connect: function connect(addrs) {
                    this.agentCommand.connect(addrs);
                    this.voiceSupportCommand.connect(addrs);
                    this.mailingCommand.connect(addrs);
                    this.integrationCommand.connect(addrs);
                    this.mailingCommand.setActiveCall(this.agentCommand.getActiveCall());
                    this.userConfig.connect(addrs);
                    //this.setLogger(1, 'NONE');
                },
                /**
                 * Habilita o log.
                 *
                 * @param {int} logOpenWindow 0 - Para desabilitar a janela de logs. 1 - Para habilitar.
                 * @param {String} logLevel Indica o nível de logque será uitlizado. Opcoes: NONE, ERROR, INFO, DEBUG
                 */
                setLogger: function (logOpenWindow, logLevel) {
                    logger.level = logLevel;
                    logger.trigger = this.trigger;
                    if (logOpenWindow !== undefined) logger.startWindowLog(logOpenWindow);
                    this.agentCommand.setLogger(logger);
                }
            };
        })();
    }
    createOlos();
})();
