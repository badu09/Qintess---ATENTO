// IE8
if (!Function.prototype.bind) {
    Function.prototype.bind = function (oThis) {
        if (typeof this !== "function") {
            // closest thing possible to the ECMAScript 5 internal IsCallable function
            throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
        }

        var aArgs = Array.prototype.slice.call(arguments, 1),
            fToBind = this,
            fNOP = function () { },
            fBound = function () {
                return fToBind.apply(this instanceof fNOP && oThis
                    ? this
                    : oThis,
                    aArgs.concat(Array.prototype.slice.call(arguments)));
            };

        fNOP.prototype = this.prototype;
        fBound.prototype = new fNOP();

        return fBound;
    };
}

var mainCall = 0;

// Enum AgentStatus
var enumAgentStatus = {
    "NOTHING": { "id": "NOTHING", "value": "Nothing" },
    "IDLE": { "id": "IDLE", "value": "Idle" },
    "TALKING": { "id": "TALKING", "value": "Talking" },
    "WRAP": { "id": "WRAP", "value": "Wrap" },
    "PAUSE": { "id": "PAUSE", "value": "Pause" },
    "ENDING": { "id": "ENDING", "value": "Ending" },
    "TALKING_WITH_PAUSE": { "id": "TALKING_WITH_PAUSE", "value": "TalkingWithPause" },
    "WRAP_WITH_PAUSE": { "id": "WRAP_WITH_PAUSE", "value": "WrapWithPause" },
    "TALKING_WITH_ENDING": { "id": "TALKING_WITH_ENDING", "value": "TalkingWithEnding" },
    "WRAP_WITH_ENDING": { "id": "WRAP_WITH_ENDING", "value": "WrapWithEnding" },
    "CONSULTING": { "id": "CONSULTING", "value": "Consulting" },
    "IN_CHAT": { "id": "IN_CHAT", "value": "Chat" },
    "IN_CHAT_WITH_PAUSE": { "id": "IN_CHAT_WITH_PAUSE", "value": "ChatWithPause" },
    "IN_CHAT_WITH_ENDING": { "id": "IN_CHAT_WITH_ENDING", "value": "ChatWithEnding" },
    "CONSULTING_WITH_PAUSE": { "id": "CONSULTING_WITH_PAUSE", "value": "ConsultingWithPause" },
    "CONSULTING_WITH_ENDING": { "id": "CONSULTING_WITH_ENDING", "value": "ConsultingWithEnding" },
    "TRANSFER": { "id": "TRANSFER", "value": "Transfer" },
    "HOLDING": { "id": "HOLDING", "value": "Holding" },
    "HOLDING_WITH_PAUSE": { "id": "HOLDING_WITH_PAUSE", "value": "HoldingWithPause" },
    "HOLDING_WITH_ENDING": { "id": "HOLDING_WITH_ENDING", "value": "HoldingWithEnding" },
    "MANUAL_CALL": { "id": "MANUAL_CALL", "value": "ManualCall" },
    "TALKING_WITH_MANUAL_CALL": { "id": "TALKING_WITH_MANUAL_CALL", "value": "TalkingWithManualCall" },
    "WRAP_WITH_MANUAL_CALL": { "id": "WRAP_WITH_MANUAL_CALL", "value": "WrapWithManualCall" },
    "CONSULTING_WITH_MANUAL_CALL": { "id": "CONSULTING_WITH_MANUAL_CALL", "value": "ConsultingWithManualCall" },
    "HOLDING_WITH_MANUAL_CALL": { "id": "HOLDING_WITH_MANUAL_CALL", "value": "HoldingWithManualCall" },
    "REDIAL": { "id": "REDIAL", "value": "Redial" },
    "PRIVATE_CALLBACK": { "id": "PRIVATE_CALLBACK", "value": "PrivateCallback" },
    "TALKING_WITH_PRIVATE_CALLBACK": { "id": "TALKING_WITH_PRIVATE_CALLBACK", "value": "TalkingWithPrivateCallback" },
    "WRAP_WITH_PRIVATE_CALLBACK": { "id": "WRAP_WITH_PRIVATE_CALLBACK", "value": "WrapWithPrivateCallback" },
    "MANUALCALL_WITH_PRIVATE_CALLBACK": { "id": "MANUALCALL_WITH_PRIVATE_CALLBACK", "value": "ManualCallWithPrivateCallback" },
    "CONSULTING_WITH_PRIVATE_CALLBACK": { "id": "CONSULTING_WITH_PRIVATE_CALLBACK", "value": "ConsultingWithPrivateCallback" },
    "HOLDING_WITH_PRIVATE_CALLBACK": { "id": "HOLDING_WITH_PRIVATE_CALLBACK", "value": "HoldingWithPrivateCallback" },
    "THIRD_PARTY_CAMPAIGN": { "id": "THIRD_PARTY_CAMPAIGN", "value": "ThirdPartyCampaign" },
    "PERSONAL_CALL": { "id": "PERSONAL_CALL", "value": "PersonalCall" },
    "TALKING_WITH_PERSONAL_CALL": { "id": "TALKING_WITH_PERSONAL_CALL", "value": "TalkingWithPersonalCall" },
    "WRAP_WITH_PERSONAL_CALL": { "id": "WRAP_WITH_PERSONAL_CALL", "value": "WrapWithPersonalCall" },
    "MANUALCALL_WITH_PERSONAL_CALL": { "id": "MANUALCALL_WITH_PERSONAL_CALL", "value": "ManualCallWithPersonalCall" },
    "CONSULTING_WITH_PERSONAL_CALL": { "id": "CONSULTING_WITH_PERSONAL_CALL", "value": "ConsultingWithPersonalCall" },
    "HOLDING_WITH_PERSONAL_CALL": { "id": "HOLDING_WITH_PERSONAL_CALL", "value": "HoldingWithPersonalCall" },
    "PERSONAL_CALL_WITH_ENDING": { "id": "PERSONAL_CALL_WITH_ENDING", "value": "PersonalCallWithEnding" },
    "PERSONAL_CALL_WITH_PAUSE": { "id": "PERSONAL_CALL_WITH_PAUSE", "value": "PersonalCallWithPause" },
    "Analyzing": { "id": "Analyzing", "value": "Analyzing" },
    "AnalyzingWithPersonalCall": { "id": "AnalyzingWithPersonalCall", "value": "AnalyzingWithPersonalCall" },
    "Attempting ": { "id": "Attempting ", "value": "Attempting" },
    "AttemptingWithPersonalCall ": { "id": "AttemptingWithPersonalCall", "value": "AttemptingWithPersonalCall" },
    "AfterAttempting ": { "id": "AfterAttempting ", "value": "AfterAttempting" },
    "AfterAttemptWithPersonalCall  ": { "id": "AfterAttemptWithPersonalCall  ", "value": "AfterAttemptWithPersonalCall" },
    "AttemptingWithPrivateCallback  ": { "id": "AttemptingWithPrivateCallback  ", "value": "AttemptingWithPrivateCallback" },
    "RedialWithPersonalCall ": { "id": "RedialWithPersonalCall ", "value": "RedialWithPersonalCall" },
    "InConference": { "id": "InConference ", "value": "InConference" },
    "InConferenceWithEnding": { "id": "InConferenceWithEnding ", "value": "InConferenceWithEnding" },
    "InConferenceWithManualCall": { "id": "InConferenceWithManualCall ", "value": "InConferenceWithManualCall" },
    "InConferenceWithPause": { "id": "InConferenceWithPause ", "value": "InConferenceWithPause" },
    "InConferenceWithPersonalCall": { "id": "InConferenceWithPersonalCall ", "value": "InConferenceWithPersonalCall" },
    "InConferenceWithPrivateCallback": { "id": "InConferenceWithPrivateCallback ", "value": "InConferenceWithPrivateCallback" },


};


var objAgentStatus = {
    "Nothing": { "value": "Nothing", "description": "Nothing" },
    "Idle": { "value": "Idle", "description": "Livre" },
    "Talking": { "value": "Talking", "description": "Falando" },
    "Wrap": { "value": "Wrap", "description": "Tabulando" },
    "Pause": { "value": "Pause", "description": "Pausa" },
    "Ending": { "value": "Ending", "description": "Deslogando" },
    "TalkingWithPause": { "value": "TalkingWithPause", "description": "Falando com pedido de pausa" },
    "WrapWithPause": { "value": "WrapWithPause", "description": "Tabulando com pedido de pausa" },
    "TalkingWithEnding": { "value": "TalkingWithEnding", "description": "Falando com pedido de saída do OLOS" },
    "WrapWithEnding": { "value": "WrapWithEnding", "description": "Tabulando com pedido de saída do OLOS" },
    "Consulting": { "value": "Consulting", "description": "Consultando" },
    "Chat": { "value": "Chat", "description": "Chat" },
    "ChatWithPause": { "value": "ChatWithPause", "description": "Chat" },
    "ChatWithEnding": { "value": "ChatWithEnding", "description": "Chat" },
    "ConsultingWithPause": { "value": "ConsultingWithPause", "description": "Consulta com pedido de pausa" },
    "ConsultingWithEnding": { "value": "ConsultingWithEnding", "description": "Consulta com pedido de saída do OLOS" },
    "Transfer": { "value": "Transfer", "description": "Consulta com pedido de saída do OLOS" },
    "Holding": { "value": "Holding", "description": "Chamada em espera" },
    "HoldingWithPause": { "value": "HoldingWithPause", "description": "Chamada em espera com pedido de pausa" },
    "HoldingWithEnding": { "value": "HoldingWithEnding", "Description": "Chamada em espera com pedido de saída do OLOS" },
    "ManualCall": { "value": "ManualCall", "description": "Chamada manual" },
    "TalkingWithManualCall": { "value": "TalkingWithManualCall", "description": "Falando com pedido de chamada manual" },
    "WrapWithManualCall": { "value": "WrapWithManualCall", "description": "Tabulando com pedido de chamada manual" },
    "ConsultingWithManualCall": { "value": "ConsultingWithManualCall", "description": "Consultando com pedido de chamada manual" },
    "HoldingWithManualCall": { "value": "HoldingWithManualCall", "description": "Chamada em espera com pedido de chamada manual" },
    "Redial": { "value": "Redial", "description": "Rediscagem" },
    "PrivateCallback": { "value": "PrivateCallback", "description": "Agendamento privado" },
    "TalkingWithPrivateCallback": { "value": "TalkingWithPrivateCallback", "description": "Falando com próxima chamada em agendamento privado" },
    "WrapWithPrivateCallback": { "value": "WrapWithPrivateCallback", "description": "Tabulando com próxima chamada em agendamento privado" },
    "ManualCallWithPrivateCallback": { "value": "ManualCallWithPrivateCallback", "description": "Chamada manual com próxima chamada em agendamento privado" },
    "ConsultingWithPrivateCallback": { "value": "ConsultingWithPrivateCallback", "description": "Consulta com próxima chamada em agendamento privado" },
    "HoldingWithPrivateCallback": { "value": "HoldingWithPrivateCallback", "description": "Chamada em espera com próxima chamada em agendamento privado" },
    "ThirdPartyCampaign": { "value": "ThirdPartyCampaign", "description": "ThirdPartyCampaign" },
    "PersonalCall": { "value": "PersonalCall", "description": "Chamada pessoal" },
    "TalkingWithPersonalCall": { "value": "TalkingWithPersonalCall", "description": "Falando com chamada pessoal em espera" },
    "WrapWithPersonalCall": { "value": "WrapWithPersonalCall", "description": "Tabulando com chamada pessoal em espera" },
    "ManualCallWithPersonalCall": { "value": "ManualCallWithPersonalCall", "description": "Chamada manual com chamada pessoal em espera" },
    "ConsultingWithPersonalCall": { "value": "ConsultingWithPersonalCall", "description": "Consulta com chamada pessoal em espera" },
    "HoldingWithPersonalCall": { "value": "HoldingWithPersonalCall", "description": "Chamada em espera com chamada pessoal em espera" },
    "PersonalCallWithEnding": { "value": "PersonalCallWithEnding", "description": "Chamada pessoal com pedido de saída do OLOS" },
    "PersonalCallWithPause": { "value": "PersonalCallWithPause", "description": "Chamada pessoal com pedido de pausa" },
    "Analyzing": { "value": "Analyzing", "description": "Analisando" },
    "AnalyzingWithPersonalCall": { "value": "AnalyzingWithPersonalCall", "description": "Analisando com chamada pessoal em espera" },
    "Attempting": { "value": "Attempting ", "description": "Discando" },
    "AttemptingWithPersonalCall": { "value": "AttemptingWithPersonalCall ", "description": "Analisando com chamada pessoal em espera" },
    "AfterAttempting": { "value": "AfterAttempting", "description": "Pós-Tentativa" },
    "AfterAttemptWithPersonalCall": { "value": "AfterAttemptWithPersonalCall", "description": "Discando com chamada pessoal em espera" },
    "AttemptingWithPrivateCallback": { "value": "AttemptingWithPrivateCallback", "description": "Discando com próxima chamada em agendamento privado" },
    "RedialWithPersonalCall": { "value": "RedialWithPersonalCall", "description": "Resdiscando com pedido de chamada pessoal" },
    "InConference": { "value": "InConference ", "description": "Em Conferência" },
    "InConferenceWithEnding": { "value": "InConferenceWithEnding ", "description": "Em Conferência com pedido de saída do OLOS" },
    "InConferenceWithManualCall": { "value": "InConferenceWithManualCall ", "description": "Em Conferência com pedido de chamada manual" },
    "InConferenceWithPause": { "value": "InConferenceWithPause ", "description": "Em Conferência com pedido de pausa" },
    "InConferenceWithPersonalCall": { "value": "InConferenceWithPersonalCall ", "description": "Em Conferência com chamada pessoal em espera" },
    "InConferenceWithPrivateCallback": { "value": "InConferenceWithPrivateCallback ", "description": "Em Conferência com próxima chamada em agendamento privado" }
};

// Enum AgentEvents
var enumAgentEventType = {
    "NOTHING": "Nothing",
    "LOGIN_CCM": "LoginCCM",
    "LOGOUT_CCM": "LogoutCCM",
    "LOGIN_CAMPAIGN": "LoginCampaign",
    "LOGOUT_CAMPAIGN": "LogoutCampaign",
    "CHANGE_STATUS": "ChangeStatus",
    "SCREEN_POP": "ScreenPop",
    "CHANGE_STATUS_FAIL": "ChangeStatusFail",
    "DISPOSITION_REQUEST_FAIL": "DispositionRequestFail",
    "LOGIN_CCM_FAIL": "LoginCCMFail",
    "LOGIN_CAMPAIGN_FAIL": "LoginCampaignFail",
    "LOGOUT_CCM_FAIL": "LogoutCCMFail",
    "LOGOUT_CAMPAIGN_FAIL": "LogoutCampaignFail",
    "ONLINE_CAMPAIGN_CHANGE_STATUS_ID": "OnlineCampaignChangeStatusId",
    "PASS_CODE": "PassCode",
    "NEW_CHAT": "NewChat",
    "NEW_CHAT_MSG": "NewChatMsg",
    "END_CHAT": "EndChat",
    "NEW_MESSAGE": "NewMessage",
    "CONSULTING_REQUEST_FAIL": "ConsultingRequestFail",
    "ACTIVE_CALL": "ActiveCall",
    "MANUAL_CALL_REQUEST_FAIL": "ManualCallRequestFail",
    "CHANGE_MANUAL_CALL_STATE": "ChangeManualCallState",
    "REDIAL_REQUEST_FAIL": "RedialRequestFail",
    "REDIAL_SUCCESS": "RedialSuccess",
    "LIST_ACTIVE_CALLS": "ListActiveCalls",
    "PRIVATE_CALLBACK_FAIL": "PrivateCallbackFail",
    "THIRD_PARTY_SCREEN_POP": "ThirdPartyScreenPop",
    "ChangePreviewCallState": "ChangePreviewCallState",
    "ChangePreviewCallResult": "ChangePreviewCallResult"
};

var enumCallStatus = {
    "Started": "Started",
    "CustomerConnected": "CustomerConnected",
    "CustomerConnected": "CustomerConnected",
    "Finished": "Finished",
    "AgentConnected": "AgentConnected"
};

function OlosAgent() {
    var agentId = 0;
    var login = '';
    var _callbacks = {};
    var status = enumAgentStatus.NOTHING.value;

    this.trigger = function (evname, params) {
        if (_callbacks[evname]) {
            _callbacks[evname].fire(params);
        }
    };
    this.on = function (evname, callback) {
        if (!_callbacks[evname]) {
            _callbacks[evname] = $.Callbacks();
        }
        _callbacks[evname].add(callback);
    };
    this.off = function (evname) {
        if (!_callbacks[evname]) {
            return;
        }
        _callbacks[evname] = null;
    };
    this.setStatus = function (stats) {
        status = stats;

        if (this.isAgentInWrapStatus()) {
            this.trigger('dispositionPending');
            this.off('dispositionPending');
        }

        if (status === enumAgentStatus.PAUSE.value) {
            this.trigger('pauseCancel', this.agentId);
            this.off('pauseCancel');
            this.trigger('changePauseReason', this.agentId);
            this.off('changePauseReason');
        }
        //wrapTmoCheck();
    };
    this.getStatus = function () {
        return status;
    };
    this.isAgentInWrapStatus = function isAgentInWrapStatus() {
        if (status === enumAgentStatus.WRAP.value
            || status === enumAgentStatus.WRAP_WITH_PAUSE.value
            || status === enumAgentStatus.WRAP_WITH_PRIVATE_CALLBACK.value
            || status === enumAgentStatus.WRAP_WITH_MANUAL_CALL.value
            || status === enumAgentStatus.WRAP_WITH_ENDING.value
            || status === enumAgentStatus.WRAP_WITH_PERSONAL_CALL.value) {
            return true;
        }
        return false;
    };

    this.isAgentInPendingPauseStatus = function isAgentInPendingPauseStatus() {
        if (status === enumAgentStatus.TALKING_WITH_PAUSE.value
            || status === enumAgentStatus.WRAP_WITH_PAUSE.value) {
            return true;
        }
        return false;
    };


}

function OlosActiveCall() {
    var callId = 0;
    var callIdConsulting = 0;
    var callIdActive = 0;
    var callIdToUnHold = 0;
    var campaignId = 0;
    var customerId = '';
    var tableName = '';
    var _callbacks = {};

    this.trigger = function (evname, params) {
        if (_callbacks[evname]) {
            _callbacks[evname].fire(params);
        }
    };
    this.on = function (evname, callback) {
        if (!_callbacks[evname]) {
            _callbacks[evname] = $.Callbacks();
        }
        _callbacks[evname].add(callback);
    };
    this.off = function (evname) {
        if (!_callbacks[evname]) {
            return;
        }
        _callbacks[evname] = null;
    };
    this.setCallIdToUnHold = function setCallIdToUnHold(cIdToUnHold) {
        this.callIdToUnHold = cIdToUnHold;
        this.trigger('unHoldCall', cIdToUnHold);
        this.off('unHoldCall');
    };

    this.resetAll = function () {
		console.log("FUNCTION resetAll");
		console.log(" Antes CallId: " + callId + "this.CallId: " + this.callId);
        this.callId = 0;
        this.callIdConsulting = 0;
        this.callIdActive = 0;
        this.callIdToUnHold = 0;
        this.campaignId = 0;
        this.customerId = '';
        this.tableName = '';
		console.log("Depois CallId: " + callId + "this.CallId: " + this.callId);
    };
}

function OlosAgentWS() {

    var agent = new OlosAgent();
    var activeCall = new OlosActiveCall();
    var wsAgentCmd;
    var wsAgentEvt;
    var wsMailingCmd;
    var wsAgentConfigCmd;
    var wsIntegration;
    var wsVoiceSupport;
    var _callbacks = {};
    var logger;
    var setTmoId1 = 0;
    var setTmoId2 = 0;

    this.trigger = function (evname, params) {
        if (_callbacks[evname]) {
            _callbacks[evname].fire(params);
        }
    };
    this.on = function (evname, callback) {
        if (!_callbacks[evname]) {
            _callbacks[evname] = $.Callbacks();
        }
        _callbacks[evname].add(callback);
    };
    this.off = function (evname) {
        if (!_callbacks[evname]) {
            return;
        }
        _callbacks[evname] = null;
    };
    this.connect = function (addr) {
        wsAgentCmd = addr.wsAgentCmd;
        wsAgentEvt = addr.wsAgentEvt;
        wsMailingCmd = addr.wsMailingCmd;
        wsIntegration = addr.wsIntegration;
        wsVoiceSupport = addr.wsVoiceSupport;
    };

    this.setLoger = function (log) {
        logger = log;
    };
    this.getAgentStatus = function getAgentStatus() {
        return agent.getStatus();
    };
    this.defaultAjaxCallError = function (wsAgentCmd, method, data) {
        return function (xhr, response, err) {
            logger.error('ERROR REQUESTING = [ URL: ' + wsAgentCmd + '/' + method + '?' + data + ' ]');
        }
    };
    this.ajaxCall = function ajaxCall(url, method, data, success, error) {
        //logger.loggerWindow(wsAgentCmd + '/' + method + '?' + data);
        var request = $.ajax({
            url: url + '/' + method,
            //contentType: "application/json; charset=utf-8",
            dataType: 'jsonp',
            jsonp: 'callback',
            context: this,
            data: data
        });
        request.done(success);
        request.fail(error);
    };
    this.ajaxCallAgentCmd = function ajaxCallAgentCmd(method, data, success, error) {
        //logger.info(wsAgentCmd + '/' + method + '?' + data);
        this.ajaxCall(wsAgentCmd, method, data, success, error);
    };
    this.ajaxCallAgentEvt = function ajaxCallAgentEvt(method, data, success, error) {
        logger.debug(wsAgentEvt + '/' + method + '?' + data);
        this.ajaxCall(wsAgentEvt, method, data, success, error);
    };
    this.agentAuthentication = function agentAuthentication(login, passwd, callback) {
        var method = 'AgentAuthentication';
        var data = 'Login=' + login + '&Password=' + passwd + '&ForceLogout=true';
        var success = function (response) {
            agent.agentId = response.agentId;
            agent.setStatus(enumAgentStatus.NOTHING);
            if (callback instanceof Function) {
                callback.call(this, agent.agentId);
            } else {
                this.trigger('agentAuthentication', agent.agentId);
            }
            clearTimeout(setTmoId1);
            clearTimeout(setTmoId2);
            this.getNextEvent();
        };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.agentAuthenticationWithPause = function agentAuthenticationWithPause(login, passwd, reasonCode, callback) {
        var method = 'AgentAuthenticationWithPause';
        var data = 'Login=' + login + '&Password=' + passwd + '&ForceLogout=true' + '&reasonCode=' + reasonCode;
        var success = function (response) {
            agent.agentId = response.agentId;
            agent.setStatus(enumAgentStatus.NOTHING);
            if (callback instanceof Function) {
                callback.call(this, agent.agentId);
            } else {
                this.trigger('agentAuthenticationWithPause', agent.agentId);
            }
            clearTimeout(setTmoId1);
            clearTimeout(setTmoId2);
            this.getNextEvent();
        };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.agentReasonRequest = function agentReasonRequest(reasonId) {
        var reasonRequest = function reasonRequest(agentId, reasonId, oThis) {
            var method = 'AgentReasonRequest';
            var data = 'AgentId=' + agentId + '&ReasonId=' + reasonId;
            var success = function (response) { };
            var error = function (xhr, response, err) { };
            oThis.ajaxCallAgentCmd(method, data, success, error);
        };
        if (agent.isAgentInPendingPauseStatus()) {
            agent.on('changePauseReason', function (agentId) {
                reasonRequest(agentId, reasonId, this);
            }.bind(this));
        } else {
            reasonRequest(agent.agentId, reasonId, this);
        }
    };
    this.agentReasonRequestByCode = function agentReasonRequestByCode(reasonCode) {
        var reasonRequest = function reasonRequest(agentId, reasonCode, oThis) {
            var method = 'AgentReasonRequestByCode';
            var data = 'AgentId=' + agentId + '&ReasonCode=' + reasonCode;
            var success = function (response) { };
            var error = function (xhr, response, err) { };
            oThis.ajaxCallAgentCmd(method, data, success, error);
        };
        if (agent.isAgentInPendingPauseStatus()) {
            agent.on('changePauseReason', function (agentId) {
                reasonRequest(agentId, reasonCode, this);
            }.bind(this));
        } else {
            reasonRequest(agent.agentId, reasonCode, this);
        }
    };
    this.agentIdleRequest = function agentIdleRequest() {
        var idleRequest = function idleRequest(agentId, oThis) {
            var method = 'AgentIdleRequest';
            var data = 'AgentId=' + agentId;
            var success = function (response) { };
            var error = function (xhr, response, err) { };
            oThis.ajaxCallAgentCmd(method, data, success, error);
        };
        if (agent.isAgentInPendingPauseStatus()) {
            agent.off('changePauseReason');
            agent.on('pauseCancel', function (agentId) {
                idleRequest(agentId, this);
            }.bind(this));
        } else {
            idleRequest(agent.agentId, this);
        }
    };
    this.agentLogout = function agentLogout() {
        var method = 'AgentLogout';
        var data = 'AgentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.updateAgentIpAddress = function updateAgentIpAddress(ip) {
        var method = 'UpdateAgentIpAddress';
        var data = 'AgentId=' + agent.agentId + '&Ip=' + ip;;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.updateMailingData = function updateMailingData(campaignId, tableName, customerId, mailingData) {
        var method = 'UpdateMailingData';
        var data = 'agentId=' + agent.agentId + '&campaignId=' + activeCall.campaignId + '&tableName=' + activeCall.tableName + '&customerId=' + activeCall.customerId + '&mailingData=' + mailingData;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.updateCallData = function updateCallData(campaignData) {
        var method = 'UpdateCallData';
        var data = 'agentId=' + agent.agentId + '&callId=' + activeCall.callId + '&customerId=' + activeCall.customerId + '&campaignData=' + campaignData;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.transferCallRequest = function transferCallRequest(callId) {
        var method = 'TransferCallRequest';
        var data = 'agentId=' + agent.agentId + '&callId=' + callId || activeCall.callIdConsulting;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.blindTransferCallRequest = function blindTransferCallRequest(phoneNumber, uuiData) {
        var method = 'BlindTransferCallRequest';
        var data = 'agentId=' + agent.agentId + '&phoneNumber=' + phoneNumber + '&uuiData=' + uuiData;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.thirdPartyIdleRequest = function thirdPartyIdleRequest() {
        var method = 'ThirdPartyIdleRequest';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.thirdPartyHangupRequest = function thirdPartyHangupRequest(thirdPartyCallId) {
        var method = 'ThirdPartyHangupRequest';
        var data = 'agentId=' + agent.agentId + '&ThirdPartyCallId=' + thirdPartyCallId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.thirdPartyBlindTransferRequest = function thirdPartyBlindTransferRequest(phoneNumber) {
        var method = 'ThirdPartyBlindTransferRequest';
        var data = 'agentId=' + agent.agentId + '&phoneNumber=' + phoneNumber;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.stopRecPrompt = function stopRecPrompt() {
        var method = 'StopRecPrompt';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.stopPrompt = function stopPrompt(promptId) {
        var method = 'StopPrompt';
        var data = 'agentId=' + agent.agentId + '&promptId=' + promptId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.stopBroadcastMedia = function stopBroadcastMedia() {
        var method = 'StopBroadcastMedia';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.startChat = function startChat(campaignId, toCampaignId) {
        var method = 'StartChat';
        var data = 'agentId=' + agent.agentId + '&campaignId=' + activeCall.campaignId + '&toCampaignId=' + toCampaignId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.sendPreviewCallRequest = function sendPreviewCallRequest(phoneNumber) {
        var method = 'SendPreviewCallRequest';
        var data = 'agentId=' + agent.agentId + '&phoneNumber=' + phoneNumber;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.sendMyContact = function sendMyContact(chatId, callId) {
        var method = 'SendMyContact';
        var data = 'agentId=' + agent.agentId + '&chatId=' + chatId + '&callId=' + activeCall.callId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.sendManualCallRequest = function sendManualCallRequest(ddd, phoneNumber, campaignId) {
        var method = 'SendManualCallRequest';
        var data = 'agentId=' + agent.agentId + '&ddd=' + ddd + '&phoneNumber=' + phoneNumber + '&campaignId=' + campaignId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.retrievesCall = function retrievesCall() {
        activeCall.on('unHoldCall', function (callIdToUnHold) {
            var method = 'RetrievesCall';
            var data = 'agentId=' + agent.agentId + '&callId=' + callIdToUnHold;
            var success = function (response) { };
            var error = function (xhr, response, err) { };
            this.ajaxCallAgentCmd(method, data, success, error);
        }.bind(this));
        this.listActiveCalls();
    };
    this.resumeBroadcastMedia = function resumeBroadcastMedia() {
        var method = 'ResumeBroadcastMedia';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.removePrompt = function removePrompt(promptId) {
        var method = 'RemovePrompt';
        var data = 'agentId=' + agent.agentId + '&promptId=' + promptId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.redialRequest = function redialRequest() {
        var method = 'RedialRequest';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.recPrompt = function recPrompt(promptId) {
        var method = 'RecPrompt';
        var data = 'agentId=' + agent.agentId + '&promptId=' + promptId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.readyToWork = function readyToWork() {
        var method = 'ReadyToWork';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.playPrompt = function playPrompt(promptId) {
        var method = 'PlayPrompt';
        var data = 'agentId=' + agent.agentId + '&promptId=' + promptId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.pauseBroadcastMedia = function pauseBroadcastMedia() {
        var method = 'PauseBroadcastMedia';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.newPrompt = function newPrompt(companyId, description) {
        var method = 'NewPrompt';
        var data = 'agentId=' + agent.agentId + '&companyId=' + companyId + '&description=' + description;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.newChatMsg = function newChatMsg(chatId, msg) {
        var method = 'NewChatMsg';
        var data = 'agentId=' + agent.agentId + '&ChatId=' + chatId + '&Msg=' + msg;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.markRecordingRequest = function markRecordingRequest(callId, description) {
        var method = 'MarkRecordingRequest';
        var data = 'agentId=' + agent.agentId + '&CallId=' + activeCall.callId + '&Description=' + description;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.manualCallStateRequest = function manualCallStateRequest() {
        var method = 'ManualCallStateRequest';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listReasons = function listReasons(callback) {
        var method = 'ListReasons';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('listReasons', response);
            }

            logger.info(response);
        };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listPromptsWhereCampaignId = function listPromptsWhereCampaignId(campaignId) {
        var method = 'ListPromptsWhereCampaignId';
        var data = 'campaignId=' + activeCall.campaignId;
        var success = function (response) {
            this.trigger('listPromptsWhereCampaignId', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listPromptsByCompanyId = function listPromptsByCompanyId(companyId) {
        var method = 'ListPromptsByCompanyId';
        var data = 'agentId=' + agent.agentId + '&companyId=' + companyId;
        var success = function (response) {
            this.trigger('listPromptsByCompanyId', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listPromptsByAgentId = function listPromptsByAgentId() {
        var method = 'ListPromptsByAgentId';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) {
            this.trigger('listPromptsByAgentId', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listOnlineAgents = function listOnlineAgents() {
        var method = 'ListOnlineAgents';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) {
            this.trigger('listOnlineAgents', response);
            logger.info(response);
        };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listDispositions = function listDispositions(campaignId) {
        var method = 'ListDispositions';
        var data = 'campaignId=' + (campaignId || activeCall.campaignId);
        var success = function (response) {
            this.trigger('listDispositions', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listCompanies = function listCompanies() {
        var method = 'ListCompanies';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) {
            this.trigger('listCompanies', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listCampaignsToConsulting = function listCampaignsToConsulting(campaignId) {
        var method = 'ListCampaignsToConsulting';
        var data = 'CampaignId=' + activeCall.campaignId;
        var success = function (response) {
            this.trigger('listCampaignsToConsulting', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listCampaignsToChat = function listCampaignsToChat(campaignId) {
        var method = 'ListCampaignsToChat';
        var data = 'CampaignId=' + activeCall.campaignId;
        var success = function (response) {
            this.trigger('listCampaignsToChat', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listCampaignCompany = function listCampaignCompany() {
        var method = 'ListCampaignCompany';
        var data = '';
        var success = function (response) {
            this.trigger('listCampaignCompany', response);
            logger.info(response);
        };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.listActiveCalls = function listActiveCalls() {
        var method = 'ListActiveCalls';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) {
            this.trigger('listActiveCalls', response);
            logger.info(response);
        };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.hangupRequest = function hangupRequest(callId) {
        var method = 'HangupRequest';
        var data = 'agentId=' + agent.agentId + '&callId=' + (callId == null ? activeCall.callId : callId);
        var success = function (response){};
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.hangupAndDispositionCallByCode = function hangupAndDispositionCallByCode(dispositionCode) {
        var method = 'HangupAndDispositionCallByCode';
        var data = 'agentId=' + agent.agentId + '&dispositionCode=' + dispositionCode + '&callId=' + activeCall.callId;
        var success = function (response) { logger.info(response); };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.hangupAndDispositionCallBackByCode = function hangupAndDispositionCallBackByCode(dispositionCode, year, month, day, hour, minute, phoneNumber, specificAgent) {
        var method = 'HangupAndDispositionCallBackByCode';
        var data = 'agentId=' + agent.agentId + '&dispositionCode=' + dispositionCode + '&callId=' + activeCall.callId + '&year=' + year + '&month=' + month + '&day=' + day + '&hour=' + hour + '&minute=' + minute + '&phoneNumber=' + phoneNumber + '&specificAgent=' + specificAgent;
        var success = function (response) { logger.info(response); };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.hangupAndDispositionCallBack = function hangupAndDispositionCallBack(dispositionId, year, month, day, hour, minute, phoneNumber, specificAgent) {
        var method = 'HangupAndDispositionCallBack';
        var data = 'agentId=' + agent.agentId + '&dispositionId=' + dispositionId + '&callId=' + activeCall.callId + '&year=' + year + '&month=' + month + '&day=' + day + '&hour=' + hour + '&minute=' + minute + '&phoneNumber=' + phoneNumber + '&specificAgent=' + specificAgent;
        var success = function (response) { logger.info(response); };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.hangupAndDispositionCall = function hangupAndDispositionCall(dispositionId) {
        var method = 'HangupAndDispositionCall';
        var data = 'agentId=' + agent.agentId + '&dispositionId=' + dispositionId + '&callId=' + activeCall.callId;
        var success = function (response) { logger.info(response); };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.endManualCallStateRequest = function endManualCallStateRequest() {
        var method = 'EndManualCallStateRequest';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { logger.info(response); };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.endChat = function endChat(chatId) {
        var method = 'EndChat';
        var data = 'agentId=' + agent.agentId + '&chatId=' + chatId;
        var success = function (response) { logger.info(response); };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.dispositionCallByCode = function dispositionCallByCode(dispositionCode) {
        var dispCallByCode = function dispCallByCode() {
            var method = 'DispositionCallByCode';
            var data = 'agentId=' + agent.agentId + '&dispositionCode=' + dispositionCode + '&callId=' + activeCall.callId;
            var success = function (response) { logger.info(response); };
            var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
            this.ajaxCallAgentCmd(method, data, success, error);
        };

        if (agent.isAgentInWrapStatus()) {
            dispCallByCode.call(this);
        } else {
            agent.on('dispositionPending', function () {
                dispCallByCode.call(this);
            }.bind(this));
            this.hangupRequest();
        }
    };
    this.dispositionCallBackByCode = function dispositionCallBackByCode(dispositionCode, year, month, day, hour, minute, phoneNumber, specificAgent) {
        var dispCallbackByCode = function dispCallbackByCode() {
            var method = 'DispositionCallBackByCode';
            var data = 'agentId=' + agent.agentId + '&dispositionCode=' + dispositionCode + '&callId=' + activeCall.callId + '&year=' + year + '&month=' + month + '&day=' + day + '&hour=' + hour + '&minute=' + minute + '&phoneNumber=' + phoneNumber + '&specificAgent=' + specificAgent;
            var success = function (response) { logger.info(response); };
            var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
            this.ajaxCallAgentCmd(method, data, success, error);
        };

        if (agent.isAgentInWrapStatus()) {
            dispCallbackByCode.call(this);
        } else {
            agent.on('dispositionPending', function () {
                dispCallbackByCode.call(this);
            }.bind(this));
            this.hangupRequest();
        }
    };
    this.dispositionCallBack = function dispositionCallBack(dispositionId, year, month, day, hour, minute, phoneNumber, specificAgent) {
        var dispCallback = function dispCallback() {
            var method = 'DispositionCallBack';
            var data = 'agentId=' + agent.agentId + '&dispositionId=' + dispositionId + '&callId=' + activeCall.callId + '&year=' + year + '&month=' + month + '&day=' + day + '&hour=' + hour + '&minute=' + minute + '&phoneNumber=' + phoneNumber + '&specificAgent=' + specificAgent;
            var success = function (response) { logger.info(response); };
            var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
            this.ajaxCallAgentCmd(method, data, success, error);
        };

        if (agent.isAgentInWrapStatus()) {
            dispCallback.call(this);
        } else {
            agent.on('dispositionPending', function () {
                dispCallback.call(this);
            }.bind(this));
            this.hangupRequest();
        }
    };
    this.dispositionCall = function dispositionCall(dispositionId) {
        var dispCall = function dispCall() {
            var method = 'DispositionCall';
            var data = 'agentId=' + agent.agentId + '&dispositionId=' + dispositionId + '&callId=' + activeCall.callId;
            var success = function (response) { logger.info(response); };
            var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
            this.ajaxCallAgentCmd(method, data, success, error);
        };

        if (agent.isAgentInWrapStatus()) {
            dispCall.call(this);
        } else {
            agent.on('dispositionPending', function () {
                dispCall.call(this);
            }.bind(this));
            this.hangupRequest();
        }

    };
    this.consultingRequest = function consultingRequest(phoneNumber, campaignId, uuiData) {
        var method = 'ConsultingRequest';
        var data = 'agentId=' + agent.agentId + '&phoneNumber=' + phoneNumber + '&campaignId=' + campaignId + '&uuiData=' + uuiData;
        var success = function (response){};
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.consultingAgentRequest = function consultingAgentRequest(transferAgentId, transferLogin, uuiData) {
        var method = 'ConsultingAgentRequest';
        var data = 'agentId=' + agent.agentId + '&transferAgentId=' + transferAgentId + '&transferLogin=' + transferLogin + '&uuiData=' + uuiData;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.commitPrompt = function commitPrompt() {
        var method = 'CommitPrompt';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.closeCustomer = function closeCustomer() {
        var method = 'CloseCustomer';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.closeCustomerWithDispositionId = function closeCustomerWithDispositionId(dispositionId) {
        var method = 'CloseCustomerWithDispositionId';
        var data = 'agentId=' + agent.agentId + '&dispositionId=' + dispositionId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.closeCustomerWithDispositionCode = function closeCustomerWithDispositionCode(dispositionCode) {
        var method = 'CloseCustomerWithDispositionCode';
        var data = 'agentId=' + agent.agentId + '&dispositionCode=' + dispositionCode;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.broadcastMedia = function broadcastMedia(promptId) {
        var method = 'BroadcastMedia';
        var data = 'agentId=' + agent.agentId + '&promptId=' + promptId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };
    this.getAllEventObjectProps = function (evtObj) {
        var eventProps = '';
        if (evtObj) {
            for (var prop in evtObj) {
                eventProps += (prop + ': ' + evtObj[prop] + ' ');
            }
        }
        if (!eventProps) eventProps = evtObj;
        return eventProps;
    };

    this.conferenceRequest = function conferenceRequest(promptId) {
        var method = 'ConferenceRequest';
        var data = 'agentId=' + agent.agentId;
        var success = function (response){};
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };

    this.stopConferenceRequest = function stopConferenceRequest(promptId) {
        var method = 'StopConferenceRequest';
        var data = 'agentId=' + agent.agentId;
        var success = function (response) { };
        var error = function (xhr, response, err) { };
        this.ajaxCallAgentCmd(method, data, success, error);
    };


    this.getNextEvent = function getNextEvent() {
        var method = 'GetNextEvent';
        var data = 'agentId=' + agent.agentId;
        var success = function (objEvent) {
			console.log("GETNEXTEVENT --- activeCall.callId = " + activeCall.callId + " activeCall.callIdActive = " + activeCall.callIdActive);			
			console.log(objEvent);
            switch (objEvent.agentEventType) {
                case enumAgentEventType.NOTHING:
                    break;
                case enumAgentEventType.ACTIVE_CALL:
                    activeCall.callIdActive = objEvent.genericInt;
                    break;
                case enumAgentEventType.LIST_ACTIVE_CALLS:
					console.log("LIST_ACTIVE_CALLS");
					console.log(objEvent);
                    if (objEvent.eventObjectActiveCall != null) {
						console.log("eventObjectActiveCall");
						console.log(objEvent.eventObjectActiveCall);
                        var objList = objEvent.eventObjectActiveCall;
                        switch (objList.length) {
                            case 1:
                                activeCall.setCallIdToUnHold(objList[0].callId);
                                break;
                            case 2:
                                if (activeCall.callIdActive === objList[0].callId) {
                                    activeCall.setCallIdToUnHold(objList[1].callId);
                                } else {
                                    activeCall.setCallIdToUnHold(objList[0].callId);
                                }
                                break;
                            //BUG: objEvent.eventObjectActiveCall com chamadas antigas não desconectadas
                            default:
                                if (activeCall.callIdActive === objList[0].callId) {
                                    activeCall.setCallIdToUnHold(objList[1].callId);
                                } else {
                                    activeCall.setCallIdToUnHold(objList[0].callId);
                                }
                        }
                    }
                    break;
                case enumAgentEventType.CHANGE_MANUAL_CALL_STATE:
					if (objEvent.eventObjectManualCallState.callState != "CustomerConnected")
						mainCall = 0;
					
					if(mainCall == 0)
					{
						activeCall.callId = objEvent.eventObjectManualCallState.callId;
						mainCall = 1;
					}
                    activeCall.callIdActive = activeCall.callId;
                    activeCall.campaignId = 0;
                    break;
                case enumAgentEventType.SCREEN_POP:
				console.log("GETNEXTEVENT SCREEN_POP; activeCall.callId = " + activeCall.callId);
					if(mainCall == 0)
					{
						activeCall.callId = objEvent.eventObjectScreenPop.callId;
						mainCall = 1;
					}
                    activeCall.campaignId = objEvent.eventObjectScreenPop.campaignId;
                    activeCall.customerId = objEvent.eventObjectScreenPop.customerId;
                    activeCall.tableName = objEvent.eventObjectScreenPop.tableName;
                    activeCall.callIdConsulting = objEvent.eventObjectScreenPop.callId;
                    activeCall.callIdToUnHold = activeCall.callId;
					activeCall.callIdActive = objEvent.eventObjectScreenPop.callId;

                    break;
                case enumAgentEventType.ChangePreviewCallState:
				if(mainCall == 0)
				{
                    activeCall.callId = objEvent.eventObject.callId;
				}
				else
				{
					activeCall.callIdActive = objEvent.eventObject.callId;
				}
                    break;
                case enumAgentEventType.LOGOUT_CCM:
                    agent.setStatus(enumAgentStatus.ENDING);
                    clearTimeout(setTmoId1);
                    clearTimeout(setTmoId2);
                    break;
                case enumAgentEventType.CHANGE_STATUS:
                    agent.setStatus(objEvent.eventObjectAgentChangeStatus.agentStatusId);
					console.log("CHANGE_STATUS");
					console.log(agent.getStatus());
                    switch (agent.getStatus()) {							
                        case enumAgentStatus.IDLE.value:
							console.log("IDLE");
                            activeCall.resetAll();
							mainCall = 0;
                            break;
                        case enumAgentStatus.MANUAL_CALL.value:
                            activeCall.resetAll();
							mainCall = 0;
                            break;
                        case enumAgentStatus.PAUSE.value:
                            activeCall.resetAll();
							mainCall = 0;
                            break;
                        case enumAgentStatus.HOLDING:
                            if (agent.getStatus() === enumAgentStatus.TALKING
                                || agent.getStatus() === enumAgentStatus.TALKING_WITH_ENDING
                                || agent.getStatus() === enumAgentStatus.TALKING_WITH_MANUAL_CALL
                                || agent.getStatus() === enumAgentStatus.TALKING_WITH_PAUSE
                                || agent.getStatus() === enumAgentStatus.TALKING_WITH_PERSONAL_CALL
                                || agent.getStatus() === enumAgentStatus.TALKING_WITH_PRIVATE_CALLBACK) {
                                activeCall.setCallIdToUnHold(activeCall.callIdConsulting);
                            } else {
                                activeCall.setCallIdToUnHold(activeCall.callId);
                                activeCall.callIdConsulting = 0;
                            }
                            break;
                    }
                    break;
                default:

                    break;
            }
            if (objEvent.agentEventType === enumAgentEventType.NOTHING) {
                if (agent.getStatus() !== enumAgentStatus.ENDING) {
                    setTmoId1 = setTimeout(getNextEvent.bind(this), 1500);
                }
            } else {
                olosEvents(objEvent); // deprecated
                this.trigger(objEvent.agentEventType.toLowerCase(), objEvent.eventObject);
                logger.info('EventType (objEvent.agentEventType): [' + objEvent.agentEventType + ']  EventData (objEvent.eventObject): [' + this.getAllEventObjectProps(objEvent.eventObject) + ' ]');
                logger.loggerWindow('EventType (objEvent.agentEventType): [' + objEvent.agentEventType + ']  EventData (objEvent.eventObject): [' + this.getAllEventObjectProps(objEvent.eventObject) + ' ]');
                setTmoId2 = setTimeout(getNextEvent.bind(this), 0);
            }
        };
        var error = this.defaultAjaxCallError.call(this, wsAgentCmd, method, data);
        this.ajaxCallAgentEvt(method, data, success, error);
    };

    this.getActiveCall = function getActiveCall() {
        return activeCall;
    };

    this.getListStatus = function getListStatus() {
        return objAgentStatus;
    };
}

function OlosMailingWS() {
    var wsAgentCmd;
    var wsAgentEvt;
    var wsMailingCmd;
    var wsAgentConfigCmd;
    var wsIntegration;
    var _callbacks = {};
    var activeCall;

    this.setActiveCall = function setActiveCall(actCall) {
        activeCall = actCall;
    };

    this.trigger = function (evname, params) {
        if (_callbacks[evname]) {
            _callbacks[evname].fire(params);
        }
    };
    this.on = function (evname, callback) {
        if (!_callbacks[evname]) {
            _callbacks[evname] = $.Callbacks();
        }
        _callbacks[evname].add(callback);
    };
    this.off = function (evname) {
        if (!_callbacks[evname]) {
            return;
        }
        _callbacks[evname] = null;
    };
    this.connect = function (addr) {
        wsAgentCmd = addr.wsAgentCmd;
        wsAgentEvt = addr.wsAgentEvt;
        wsMailingCmd = addr.wsMailingCmd;
        wsIntegration = addr.wsIntegration;
        wsAgentConfigCmd = addr.wsAgentConfigCmd;
    };
    this.ajaxCall = function ajaxCall(method, data, success, error) {
        $.ajax({
            url: wsMailingCmd + '/' + method,
            contentType: "application/json; charset=utf-8",
            dataType: 'jsonp',
            crossDomain: true,
            jsonp: 'callback',
            context: this,
            data: data,
            success: success,
            error: error
        });
    };

    this.listMailings = function listMailings(campaignId, callback) {
        var method = 'ListMailingsJSON';
        var data = 'CampaignId=' + campaignId;
        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('listMailings', response);
            }
        };
        var error = function (xhr, response, err) {
            this.logger.info(response + ': ' + err);
        };
        this.ajaxCall(method, data, success, error);
    };


    this.finalizeClient = function finalizeClient(mailingName, dispId, customerId, callback) {
        var method = 'FinalizeClientJSON';
        var data = 'MailingName=' + mailingName + '&DispositionId=' + dispId + '&CustomerId=' + customerId;
        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('finalizeClient', response);
            }
        };
        var error = function (xhr, response, err) {
            this.logger.info(response + ': ' + err);
        };
        this.ajaxCall(method, data, success, error);
    };

    this.finalizeClientByDispositionCode = function finalizeClientByDispositionCode(campaignId, mailingName, dispCode, customerId, callback) {
        var method = 'FinalizeClientByDispositionCodeJSON';
        var data = 'CampaignId=' + campaignId + '&MailingName=' + mailingName + '&DispositionCode=' + dispCode + '&CustomerId=' + customerId;
        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('finalizeClientByDispositionCode', response);
            }
        };
        var error = function (xhr, response, err) {
            this.logger.info(response + ': ' + err);
        };
        this.ajaxCall(method, data, success, error);
    };

    this.invalidatePhoneNumber = function invalidatePhoneNumber(ddd, phoneNumber, callback) {
        var method = 'FinalizeClientByPhoneNumberJSON';
        var data = 'MailingName=' + activeCall.tableName + '&CustomerId=' + activeCall.customerId + '&TypePhoneId=1' + '&PhoneNumber=' + phoneNumber;
        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('invalidatePhoneNumber', response);
            }
        };
        var error = function (xhr, response, err) {
            this.logger.info(response + ': ' + err);
        };
        this.ajaxCall(method, data, success, error);
    };

    this.insertPhoneNumber = function insertPhoneNumber(ddd, phoneNumber, callback) {
        var method = 'InsertPhoneNumberJSON';
        var data = 'MailingName=' + activeCall.tableName + '&CustomerId=' + activeCall.customerId + '&TypePhoneId=1' + '&PhoneNumber=' + ddd + phoneNumber;
        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('insertPhoneNumber', response);
            }

        };
        var error = function (xhr, response, err) {
            this.logger.info(response + ': ' + err);
        };
        this.ajaxCall(method, data, success, error);
    }
}

function OlosIntegrationWS() {
    var wsAgentCmd;
    var wsAgentEvt;
    var wsMailingCmd;
    var wsAgentConfigCmd;
    var wsIntegration;
    var _callbacks = {};
    var activeCall;

    this.setActiveCall = function setActiveCall(actCall) {
        activeCall = actCall;
    };

    this.trigger = function (evname, params) {
        if (_callbacks[evname]) {
            _callbacks[evname].fire(params);
        }
    };
    this.on = function (evname, callback) {
        if (!_callbacks[evname]) {
            _callbacks[evname] = $.Callbacks();
        }
        _callbacks[evname].add(callback);
    };
    this.off = function (evname) {
        if (!_callbacks[evname]) {
            return;
        }
        _callbacks[evname] = null;
    };
    this.connect = function (addr) {
        wsAgentCmd = addr.wsAgentCmd;
        wsAgentEvt = addr.wsAgentEvt;
        wsMailingCmd = addr.wsMailingCmd;
        wsAgentConfigCmd = addr.wsAgentConfigCmd;
        wsIntegration = addr.wsIntegration;
    };
    this.ajaxCall = function ajaxCall(method, data, success, error) {
        $.ajax({
            url: wsIntegration + '/' + method,
            //contentType: "application/json; charset=utf-8",
            dataType: 'jsonp',
            crossDomain: true,
            jsonp: 'callback',
            context: this,
            data: data,
            success: success,
            error: error
        });
    };

    this.listAvailableOnlineAgentsByCompany = function listAvailableOnlineAgentsByCompany(agentId, callback) {
        var method = 'ListAvailableOnlineAgentsByCompany';
        var data = 'AgentId=' + agentId;
        var success = function (response) {

            if (callback instanceof Function) {
                callback.call(this, response);
            } else {

                this.trigger('listAvailableOnlineAgentsByCompany', response);
            }
        };
        var error = function (xhr, response, err) { };
        this.ajaxCall(method, data, success, error);
    };

    this.listCampaignsToConsulting = function listCampaignsToConsulting(campaignId, callback) {
        var method = 'ListCampaignsToConsulting';
        var data = 'CampaignId=' + campaignId;
        var success = function (response) {

            if (callback instanceof Function) {
                callback.call(this, response);
            } else {

                this.trigger('listCampaignsToConsulting', response);
            }
        };
        var error = function (xhr, response, err) { };
        this.ajaxCall(method, data, success, error);
    };
}

function OlosVoiceSupportWS() {
    var wsVoiceSupport;
    var wsAgentCmd;
    var wsAgentEvt;
    var wsMailingCmd;
    var wsAgentConfigCmd;
    var wsIntegration;
    var _callbacks = {};
    var activeCall;
    var agent = new OlosAgent();

    this.setActiveCall = function setActiveCall(actCall) {
        activeCall = actCall;
    };

    this.trigger = function (evname, params) {
        if (_callbacks[evname]) {
            _callbacks[evname].fire(params);
        }
    };
    this.on = function (evname, callback) {
        if (!_callbacks[evname]) {
            _callbacks[evname] = $.Callbacks();
        }
        _callbacks[evname].add(callback);
    };
    this.off = function (evname) {
        if (!_callbacks[evname]) {
            return;
        }
        _callbacks[evname] = null;
    };
    this.connect = function (addr) {
        wsVoiceSupport = addr.wsVoiceSupport;
        wsAgentCmd = addr.wsAgentCmd;
        wsAgentEvt = addr.wsAgentEvt;
        wsMailingCmd = addr.wsMailingCmd;
        wsAgentConfigCmd = addr.wsAgentConfigCmd;
        wsIntegration = addr.wsIntegration;
    };
    this.ajaxCall = function ajaxCall(method, data, success, error) {
        $.ajax({
            url: wsVoiceSupport + '/' + method,
            contentType: "application/json; charset=utf-8",
            dataType: 'jsonp',
            crossDomain: true,
            jsonp: 'callback',
            jsonpCallback: 'myCallback',
            context: this,
            data: data,
            success: success,
            error: error
        });
    };

    this.start = function start(agentLogin, audio) {
        var method = 'VoiceSupportStart';
        var data = 'paramAgentLogin=' + agentLogin + '&paramFileName=' + audio;

        var success = function (response) {
            if (callback instanceof Function) {
                callback.call(this, response);
            } else {
                this.trigger('start', response);
            }
        };
        var error = function (xhr, response, err) {
            //console.log(xhr);
            //console.log(response);
            //console.log(err);
            //this.logger.info(response + ': ' + err);
        };

        this.ajaxCall(method, data, success, error);

    };

}

function OlosUserConfigWS() {
    this.wsAgentCmd;
    this.wsAgentEvt;
    this.wsMailingCmd;
    this.wsAgentConfigCmd;
    this.wsIntegration;
    this._callbacks = {};
}

OlosUserConfigWS.prototype.trigger = function (evname, params) {
    if (this._callbacks[evname]) {
        this._callbacks[evname].fire(params);
    }
};
OlosUserConfigWS.prototype.on = function (evname, callback) {
    if (!this._callbacks[evname]) {
        this._callbacks[evname] = $.Callbacks();
    }
    this._callbacks[evname].add(callback);
};
OlosUserConfigWS.prototype.off = function (evname) {
    if (!this._callbacks[evname]) {
        return;
    }
    this._callbacks[evname] = null;
};
OlosUserConfigWS.prototype.connect = function (addr) {
    this.wsAgentCmd = addr.wsAgentCmd;
    this.wsAgentEvt = addr.wsAgentEvt;
    this.wsMailingCmd = addr.wsMailingCmd;
    this.wsAgentConfigCmd = addr.wsAgentConfigCmd;
    this.wsIntegration = addr.wsIntegration;
};
OlosUserConfigWS.prototype.ajaxCall = function ajaxCall(method, data, success, error) {
    var request = $.ajax({
        url: this.wsAgentConfigCmd + '/' + method,
        contentType: "application/json; charset=utf-8",
        dataType: 'jsonp',
        jsonp: 'callback',
        context: this,
        data: data
    });
    request.done(success);
    request.fail(error);
};
OlosUserConfigWS.prototype.getCampaignByUserLogin = function (login, loginOwner, loginOwnerPasswd, callback) {
    var method = 'GetCampaignByUserLogin';
    var data = 'Login=' + login;
    var success = function (response) {
        callback.call(this, response);
    };
    var error = function (xhr, response, err) {
    };
    this.ajaxCall(method, data, success, error);
};


/*
OlosAgentWS.on('log', function (msg) {
    OlosAgentWS.logger(msg);
});
*/