public with sharing class DAOReport {
    public static Report[] getReportByFolder(String folder) {
        return [SELECT DeveloperName,FolderName,Id,Name FROM Report WHERE FolderName = :folder];
    }
    
    public static Report getReportById(String reportId){
        return [SELECT DeveloperName,Id,Name FROM Report WHERE id=:reportId];
    }
}