public with sharing class EmailTemplateService {
    
    public static EmailTemplate getEmailTemplateByDevName(String templateName) {
        return EmailTemplateSelector.getEmailTemplateByDevName(templateName);
    }
}