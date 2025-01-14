public with sharing class EmailTemplateSelector {

    public static EmailTemplate getEmailTemplateByDevName(String templateName){
        return [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: templateName];
    }
}