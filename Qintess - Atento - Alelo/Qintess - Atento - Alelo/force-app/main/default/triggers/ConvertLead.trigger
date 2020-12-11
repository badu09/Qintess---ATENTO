trigger ConvertLead on Lead (after update)
{                
        Map<Id, Lead> oldLeadList = Trigger.oldMap;
        List<Lead> rollBackLead = new List<Lead>();
        for(Lead lead : Trigger.new) {
            /*system.debug('Inicio da Trigger ConvertLead');
            system.debug('lead: '+ JSON.serialize(lead));
            system.debug('lead: '+ lead.IsConverted);
            system.debug('lead: '+ lead.Status);
            system.debug('lead: '+ lead.Motivo_Detalhado__c);*/

            if(!lead.IsConverted && (lead.Status == 'TEM INTERESSE (003)' && lead.Motivo_Detalhado__c != null ||
            (lead.Status == 'AGENDAMENTO (001)' && lead.Motivo_Detalhado__c == 'AGENDAMENTO FIDELIZADO (033)'))) {
//                system.debug('Inicio da Conversão.');
                BOLead.convertLead(lead);
//                system.debug('Fim da Conversão: Converteu');
            } else {
//                system.debug('Fim da Conversão: Não converteu');
            }

            if(Trigger.isUpdate){
//                system.debug('Old status: '+oldLeadList.get(lead.id).Status);
                if(lead.Status.contains('007') && !(oldLeadList.get(lead.id).Status.contains('002'))&& !(oldLeadList.get(lead.id).Status.contains('009')) && !lead.IsConverted){
                    Lead l = lead.clone(true,true,false,false),
                        oldLead = oldLeadList.get(lead.id);

                    l.Status = oldLead.Status;
                    l.Motivo_Detalhado__c = oldLead.Motivo_Detalhado__c;
                    rollBackLead.add(l);
//                    System.debug('Atualizou');

                }
            }
        }
        if(rollBackLead.size() > 0 && !RecursiveTriggerHelper.isAlreadyModified())
        {
            RecursiveTriggerHelper.setAlreadyModified();
            update rollBackLead;
        }   
}