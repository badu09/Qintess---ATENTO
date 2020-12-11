public with sharing class TriggerUtils {
    
    public static Boolean isChanged(SObject aSObject, Schema.sObjectField aField )
    {
        return ( trigger.isInsert ||
                ( trigger.isUpdate && 
                 aSObject.get(aField) != trigger.oldMap.get(aSObject.Id).get(aField) ));
    }

    public static Decimal somarUm (Decimal valor)
    {
        if (valor == null)
        {
            return 0;
        }
        return valor + 1;
    }
    
}