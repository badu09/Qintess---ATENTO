trigger UpdateRelationID on EmailMessage (before insert)
{
    system.debug('lEmailMessage: ' + json.serialize(Trigger.New));
    
    for (EmailMessage item : trigger.New)
    {
        system.debug('item: ' + json.serialize(item));
        system.debug('VanerOportunidade: ' + item.Oportunidade__c);
        system.debug('VanerLead: ' + item.Lead__c);
        
        
        if(item.Oportunidade__c != null)
        {
            item.RelatedToId  = item.Oportunidade__c;
        }
        /*else
        {
            String LeadId = item.Lead__c;
            item.RelatedToId = item.Lead__c;
        }*/
    }
    
    system.debug('lEmailMessage: ' + json.serialize(Trigger.New));
}