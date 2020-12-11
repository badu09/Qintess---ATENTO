public with sharing class DAOOrgWideEmailAddress {
    public static List<OrgWideEmailAddress> getEmailAddress() {
		return [SELECT
					Id,
					Address,
					DisplayName,
					IsAllowAllProfiles
				FROM
					OrgWideEmailAddress
				WHERE
					Address != null];
	}
    
    public static List<OrgWideEmailAddress> getEmailAddressByName(String displayName){
        return [SELECT
					Id,
					Address,
					DisplayName,
					IsAllowAllProfiles
				FROM
					OrgWideEmailAddress
				WHERE
					Address != null
                AND
               		DisplayName=:displayName];
    }
}