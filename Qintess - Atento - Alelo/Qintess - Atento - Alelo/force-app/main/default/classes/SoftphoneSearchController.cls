global class SoftphoneSearchController {

    public String contactName {get; set;}
    public List<Contact> contactList {get; set;}
      
    public SoftphoneSearchController() {
        contactName = '';
        doSearch();
    }
    
    public void doSearch() {
        contactList = [SELECT id, phone, firstname, lastname FROM Contact WHERE (firstname LIKE :('%' + contactName + '%') OR lastname LIKE :('%' + contactName + '%')) LIMIT 5];
    }
    
    webService static String getLeads(String ani) { 
        List<Lead> leads = new List<Lead>(); 
        for (Lead lead : [Select Id, Name, Phone from Lead where Phone = :ani]){ 
            leads.add(lead);
        }
        return JSON.serialize(leads);
    } 
    
}