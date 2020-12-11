public with sharing class DiasUteis {
    
    public static Datetime calcularDiasUteis(Integer days, dateTime dataHoraTabulacao)
    {

        Datetime pointer = dataHoraTabulacao;
        Integer diasUteis=0;
        Integer diasNaoUteis = 0;
        BusinessHours bh = [SELECT Id FROM BusinessHours Where IsDefault=true];

        if (days == 0)
        {
            return dataHoraTabulacao;
        }
        if(days > 0){

            while(diasUteis < days){
                pointer = pointer+1;
                if (BusinessHours.isWithin(bh.id, pointer)) {
                    diasUteis++;
                }else{
                    diasNaoUteis++;
                }

                pointer = dataHoraTabulacao + (diasUteis + diasNaoUteis);

            }
            return pointer;
        }
        else{
            days = Integer.valueOf(String.valueOf(days).replace('-',''));
            System.debug('entrou no else : ' + pointer);
            while(diasUteis < days){
                pointer = pointer-1;
                if (BusinessHours.isWithin(bh.id, pointer)) {
                    diasUteis++;
                }else{
                    diasNaoUteis++;
                }
                pointer = dataHoraTabulacao - (diasUteis + diasNaoUteis);
            }
            return pointer;
        }
    }
}