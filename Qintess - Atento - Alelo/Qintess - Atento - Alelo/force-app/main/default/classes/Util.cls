public with sharing class Util {
    private final static Blob cryptoKey = EncodingUtil.convertFromHex('62517F712BABCA6B56B31BFA83501318');
    private final static Blob vector = EncodingUtil.convertFromHex('AB1D925753B1C8FE90E80C7D7F904711');


    private static Map < String, Integer > hexMap = new Map < String, Integer > ();
    static{
        hexMap.put('0', 0);
        hexMap.put('1', 1);
        hexMap.put('2', 2);
        hexMap.put('3', 3);
        hexMap.put('4', 4);
        hexMap.put('5', 5);
        hexMap.put('6', 6);
        hexMap.put('7', 7);
        hexMap.put('8', 8);
        hexMap.put('9', 9);
        hexMap.put('A', 10);
        hexMap.put('B', 11);
        hexMap.put('C', 12);
        hexMap.put('D', 13);
        hexMap.put('E', 14);
        hexMap.put('F', 15);
        hexMap.put('a', 10);
        hexMap.put('b', 11);
        hexMap.put('c', 12);
        hexMap.put('d', 13);
        hexMap.put('e', 14);
        hexMap.put('f', 15);
    }
    
    public static Decimal decimalValueOf(Object par) {
        String value = null;
        try {
            
            if(par != null && par != ''){
                value = String.valueof(par);
                
                if(value.contains(','))
                    value = value.replaceAll('\\.| ', '').replace(',', '.'); 
                
                return Decimal.valueOf(value);
            }
            else {
                return 0.00;
            }
        }
        catch(Exception e) {
            System.debug('Exception tratada: ' + e + '\n' + e.getStackTraceString());
            return 0;
        }
    }

    public static String descriptografarIndicacoes(String hex) {
        Blob descript = EncodingUtil.convertFromHex(hex);
        Blob decryptedData2 = Crypto.decrypt('AES128', cryptoKey, vector, descript);

        return decryptedData2.toString();
    }

  public static String criptografarIndicacoes(String valor) {
    Blob encrypto = Blob.valueOf(valor);
    Blob encryptedData = Crypto.encrypt('AES128', cryptoKey, vector, encrypto);
    String retorno = EncodingUtil.convertToHex(encryptedData);
    return retorno;
  }

    public class UTFException extends Exception{
    }

    public static String StringValueOf(Object toConvert) {
        if(toConvert != null) {
            return String.valueOf(toConvert);
        }
        else {
            return '';
        }
    }
    
    public static Boolean sendEmailAttach(List<Attachment> listAttachment, List<Id> listTargetObjectId, List<String> listccAddress, 
        String htmlBody, Id templateId, Boolean saveAsActivity, Boolean task, Id whatId, String subject, Id emailFromAddressId) {
        
        Messaging.EmailFileAttachment[] listEmailFileAttachment = new List<Messaging.EmailFileAttachment>();
        for(Attachment attach : listAttachment) {
            Messaging.EmailFileAttachment objAttach = new Messaging.EmailFileAttachment();
            objAttach.setContentType(attach.ContentType);
            objAttach.setFileName(attach.Name);
            objAttach.setInline(false);
            objAttach.body = attach.Body;
            
            listEmailFileAttachment.add(objAttach);
        }
        
        Messaging.SingleEmailMessage[] listSingleEmailMessage = new List<Messaging.SingleEmailMessage>();
        Boolean isSendEmailCc = false;
        
        for(Id targetObjectId : listTargetObjectId) {
            Messaging.Singleemailmessage objMail = new Messaging.Singleemailmessage();
            objMail.setUseSignature(false);
            
            if(!isSendEmailCc && listccAddress != null && !listccAddress.isEmpty()) {
                objMail.setCcAddresses(listccAddress);
                isSendEmailCc = true;
            }
            
            if(emailFromAddressId != null)
                objMail.setOrgWideEmailAddressId(emailFromAddressId);
                
            objMail.setTargetObjectId(targetObjectId);
            
            if(templateId != null)
                objMail.setTemplateId(templateId);
            else if(htmlBody != null)
                objMail.setHtmlBody(htmlBody);
                
            objMail.setFileAttachments(listEmailFileAttachment);
            objMail.saveAsActivity = saveAsActivity;
            objMail.setSubject(subject);
            listSingleEmailMessage.add(objMail);
            
            //system.debug('objMail: ' + objMail);
            //system.debug('listccAddress[0]: ' + JSON.serializePretty(listccAddress));
        }
        
        Messaging.sendEmail(listSingleEmailMessage);
        
        if(task) {
            Task objTask = new Task();
            objTask.WhatId = whatId;
            
            upsert objTask;
        }
        
        return true;
    }
    
    public static Boolean sendEmailAttach(List<Attachment> listAttachment, List<Id> listTargetObjectId, List<String> listccAddress, 
        String htmlBody, Boolean saveAsActivity, Boolean task, Id whatId, String subject, Id emailFromAddressId) {
        //Messaging.SingleEmailMessage[] listSingleEmailMessage = new List<Messaging.SingleEmailMessage>﻿();
        
        Messaging.EmailFileAttachment[] listEmailFileAttachment = new List<Messaging.EmailFileAttachment>();
        for(Attachment attach : listAttachment) {
            Messaging.EmailFileAttachment objAttach = new Messaging.EmailFileAttachment();
            objAttach.setContentType(attach.ContentType);
            objAttach.setFileName(attach.Name);
            objAttach.setInline(false);
            objAttach.body = attach.Body;
            
            listEmailFileAttachment.add(objAttach);
        }
        
        //List<Messaging.SingleEmailMessage> listSingleEmailMessage = new List<Messaging.SingleEmailMessage>﻿();
        Messaging.SingleEmailMessage[] listSingleEmailMessage = new List<Messaging.SingleEmailMessage>();
        Boolean isSendEmailCc = false;
        
        for(Id targetObjectId : listTargetObjectId) {
            Messaging.Singleemailmessage objMail = new Messaging.Singleemailmessage();
            objMail.setUseSignature(false);
            
            if(!isSendEmailCc && listccAddress != null && !listccAddress.isEmpty()) {
                //objMail.setCcAddresses(new List<String>{'marcelo.costa@bsitecnologia.com.br'});
                objMail.setCcAddresses(listccAddress);
                //objMail.setWhatId(this.Id);
                isSendEmailCc = true;
            }
            
            if(emailFromAddressId != null)
                objMail.setOrgWideEmailAddressId(emailFromAddressId);
                
            objMail.setTargetObjectId(targetObjectId);
            //objMail.setTemplateId(templateId);
            //objMail.setHtmlBody('<html><body><p>teste</p></body></html>');
            objMail.setHtmlBody(htmlBody);
            objMail.setFileAttachments(listEmailFileAttachment);
            objMail.saveAsActivity = saveAsActivity;
            objMail.setSubject(subject);
            listSingleEmailMessage.add(objMail);
            
            system.debug('objMail: ' + objMail);
            system.debug('listccAddress[0]: ' + JSON.serializePretty(listccAddress));
        }
        
        Messaging.sendEmail(listSingleEmailMessage);
        
        if(task) {
            Task objTask = new Task();
            objTask.WhatId = whatId;
            
            upsert objTask;
        }
        
        return true;
    }
    
    public static String getNameMonth(Integer month) {

        if(month == 1)
            return 'Janeiro';
        else if(month == 2)
            return 'Fevereiro';
        else if(month == 3)
            return 'Março';
        else if(month == 4)
            return 'Abril';
        else if(month == 5)
            return 'Maio';
        else if(month == 6)
            return 'Junho';
        else if(month == 7)
            return 'Julho';
        else if(month == 8)
            return 'Agosto';
        else if(month == 9)
            return 'Setembro';
        else if(month == 10)
            return 'Outubro';
        else if(month == 11)
            return 'Novembro';
        else if(month == 12)
            return 'Dezembro';
        else
            return 'Mês não identificado';
    }
    
    public static String formatCurrency(Decimal value) {
        return formatCurrency('BRL', value, 'R$ ');
    }
    
    public static String formatCurrency(String IsoCode, Decimal value) {
        return formatCurrency(isoCode, value, 'R$ ');
    }
    
    public static String formatCurrency(String isoCode, Decimal value, String symbol) {
        if(value == null)
            return '';
            
        String valueFormat = formatCurrencyString(value);
        
        if(isoCode == 'BRL')
            if(symbol != null)
                return symbol + valueFormat;
    
        return valueFormat;
    }
    
    public static String formatCurrencyString(Decimal value) {
        List<String> args = new String[]{'0','number','###.###.##0,00'};
        String retorno = String.format(value.format(), args);
        if(!retorno.contains(','))
            retorno = retorno + ',00';
        else if(retorno.contains(',')){
            String[] ar = retorno.split(',');
            retorno = ar[1].length() == 1 ? retorno + '0' : retorno;
        }
            
            
        return retorno;
    }
    
    public static String formatCPFCNPJ(String value) {
        //String value = '12345678912345';
        String retorno = '';
        if(value != null) {
	        if(value.length() == 14){
	            retorno = value.substring(0,2) + '.' + value.substring(2,5)
	                + '.' + value.substring(5,8) + '/' + value.substring(8,12) + '-' + value.substring(12,14);
	        } else if(value.length() == 11){
	            retorno = value.substring(0,3) + '.' + value.substring(3,6)
	                + '.' + value.substring(6,9) + '-' + value.substring(9,11);
	        }
        }
        system.debug('retorno: ' + retorno);
        
        return retorno;
    }
    
    public static String getNameObject(Id id){
        Schema.SObjectType token = id.getSObjectType();
        Schema.DescribeSObjectResult dr = token.getDescribe();
        return dr.getName();
    }
    
    public static String getValueString(String valor, String inicio, String fim){
        
        if(valor != null && valor.contains(inicio) && valor.contains(inicio)){
            String[] body = null;
            body = valor.split(inicio);
            body = body[1].split(fim);
            return body[0];
        }else{
            return null;
        }
    }
    
    public static String truncate(String valor, Integer limite){
        
        if(valor != null && valor.length() > limite){
            return valor.substring(0, limite);
        }else if(valor != null && valor.length() <= limite){
            return valor;
        }else{
            return null;
        }
    }
    
    public static Date formatDate(String dateFormat){
        try{
            if(dateFormat == null)
                return null;
                
            dateFormat = dateFormat.substring(6, 10) + '-' + dateFormat.substring(3, 5) + '-' + dateFormat.substring(0, 2);
            return Date.valueOf(dateFormat);
        }catch(Exception e){
            System.debug('Exception tratada: ' + e + '\n' + e.getStackTraceString());
            return Date.today();
        }
    }
    
    
}