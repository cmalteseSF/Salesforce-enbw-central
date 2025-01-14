global class EmailNotificationHandler implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equalsIgnoreCase('sendEmailQuoteDocument')){
            return sendEmail(processEmailQuoteDocument(input), input, outMap);
        }

        if (methodName.equalsIgnoreCase('sendEmailOrderVoiceTermination')) {
            Boolean result = false;
            result = sendEmail(processOrderVoiceTermination(input), input, outMap);
            if(result)
            {
                return result;
            }else{
                throw new EmailException();
            }
            
        }
        return false;
     }

    public static EmailTemplate processEmailQuoteDocument(Map<String,Object> input)
    {
        // template id comes from OS
        EmailTemplate emailTemplate = EmailTemplateService.getEmailTemplateByDevName((String)input.get('emailTemplateName'));
        System.debug('emailTemplateId: ' + emailTemplate.Id);
        // Get encryption key
        Encryption_Configuration__mdt encryptConfig = [SELECT Id, PrivateKey__c FROM Encryption_Configuration__mdt WHERE DeveloperName = 'Portal'];
        System.debug('encryptConfig: ' + encryptConfig.PrivateKey__c);

        Datetime expirationDate = (DateTime)JSON.deserialize('"' + input.get('quoteCreatedDate') + '"', DateTime.class);
        expirationDate = expirationDate.addDays(15);
  
        //email base address comes from custom metadata
        Email_Configuration__mdt emailConfig = [SELECT Id, Custom_URL__c FROM Email_Configuration__mdt WHERE DeveloperName = 'Portal'];
      
        // process the merge fields
        String subject = emailTemplate.Subject;
        subject = subject.replace('{{{Quote.QuoteNumber}}}', (String)input.get('quoteNumber'));

        String htmlBody = emailTemplate.HtmlValue;
        htmlBody = htmlBody.replace('{{Quote.QuoteNumber}}', (String)input.get('quoteNumber'));
        htmlBody = htmlBody.replace('{{{Quote.ExpirationDate}}}', (String)expirationDate.format('dd/MM/yyyy'));
        htmlBody = htmlBody.replace('{{{Sender.CompanyName}}}', (String)input.get('userCompanyName'));
        htmlBody = htmlBody.replace('{{{Sender.Name}}}', (String)input.get('userName'));
        htmlBody = htmlBody.replace('{{{Sender.Address}}}', (String)input.get('userAddress'));
        htmlBody = htmlBody.replace('{{{EncryptedQuoteId}}}', EncryptionUtil.encrypt((String)input.get('whatId'), encryptConfig.PrivateKey__c));
        htmlBody = htmlBody.replace('{{{customUrl}}}', emailConfig.Custom_URL__c);

        String plainBody = emailTemplate.Body;
        plainBody = plainBody.replace('{{Quote.QuoteNumber}}', (String)input.get('quoteNumber'));
        plainBody = plainBody.replace('{{{Quote.ExpirationDate}}}', (String)expirationDate.format('dd/MM/yyyy'));
        plainBody = plainBody.replace('{{{Sender.CompanyName}}}', (String)input.get('userCompanyName'));
        plainBody = plainBody.replace('{{{Sender.Name}}}', (String)input.get('userName'));
        plainBody = plainBody.replace('{{{Sender.Address}}}', (String)input.get('userAddress'));
        plainBody = plainBody.replace('{{{EncryptedQuoteId}}}', EncryptionUtil.encrypt((String)input.get('whatId'), encryptConfig.PrivateKey__c));
        plainBody = plainBody.replace('{{{customUrl}}}', emailConfig.Custom_URL__c);

        emailTemplate.Subject = subject;
        emailTemplate.HtmlValue = htmlBody;
        emailTemplate.Body = plainBody;
        
        System.debug('emailTemplate: ' + emailTemplate);

        return emailTemplate;
    }

    public static EmailTemplate processOrderVoiceTermination(Map<String,Object> input)
    {
        
            EmailTemplate emailTemplate = EmailTemplateService.getEmailTemplateByDevName((String)input.get('emailTemplateName'));
            System.debug('emailTemplateId: ' + emailTemplate.Id);

            Map<String,Object> orderMap = (Map<String,Object>)input.get('orderData');
            System.debug('!!!!!'+orderMap.get('OrderNumber'));
            List<Map<String,Object>>lstOrderItem = (List<Map<String,Object>>)input.get('orderItemData');
            String orderId=(String)input.get('orderId');
            String requestDate = String.valueOf(orderMap.get('RequestDate'));
            System.debug('SendMailVoiceTeam inputMap =>  ' + input);
            String tableHtml = '<head><style>.custom-table { border-collapse: collapse; margin: 20px 0; } .custom-table th, .custom-table td { border: 1px solid #ddd; padding: 8px; } .custom-table th { background-color: #f2f2f2; text-align: left; }</style></head><body><table class="custom-table"><thead><tr><th>Produktname</th><th>Rufnummer</th></tr></thead><tbody>';
    
            // process the merge fields
            String subject = emailTemplate.Subject;
            subject = subject.replace('{{{Order.OrderNumber}}}', (String)orderMap.get('OrderNumber'));
    
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{{{Order.OrderNumber}}}', (String)orderMap.get('OrderNumber'));
            htmlBody = htmlBody.replace('{{{Order.ATPBillingAccountId__c}}}', (String)orderMap.get('ATPBillingAccountId'));
            htmlBody = htmlBody.replace('{{{Order.vlocity_cmt__RequestDate__c}}}', requestDate.left(requestDate.length()-8));
            htmlBody = htmlBody.replace('{{{Order.LegacyContractId}}}', (String)orderMap.get('LegacyContractId'));
            htmlBody = htmlBody.replace('{{{Order.Account.Name}}}', (String)orderMap.get('BusinessAccountName'));
            htmlBody = htmlBody.replace('{{{Order.Contract.PartnerContractID__c}}}', (String)orderMap.get('PartnerId'));
            htmlBody = htmlBody.replace('{{{Order.vlocity_cmt__DefaultPremisesId__r.ServiceAddress__c}}}', (String)orderMap.get('ServiceAddress'));
            htmlBody = htmlBody.replace('{{{Order.Account.BusinessAddress__c}}}', (String)orderMap.get('BusinessAddress'));
            htmlBody = htmlBody.replace('{{{OrderItemCount}}}', String.valueOf(orderMap.get('OrderItemCount')));
    
            for(Map<String,Object> htmlgen: lstOrderItem)
            {
                tableHtml += '<tr><td>'+htmlgen.get('ProductName')+'</td><td>'+htmlgen.get('PhoneNo')+'</td></tr>' ; 
            }
            tableHtml += '</tbody></table></body>';
            htmlBody = htmlBody.replace('{{{PhoneNumberTable}}}', tableHtml);
            
            String plainBody = emailTemplate.Body;
    
            emailTemplate.Subject = subject;
            emailTemplate.HtmlValue = htmlBody;
            emailTemplate.Body = plainBody;
    
            return emailTemplate;
    }

    public static Boolean sendEmail(EmailTemplate emailTemplate, Map<String,Object> input, Map<String,Object> outMap) 
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        String emailAddressFromTemplate = (String)input.get('fromAddress');
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: emailAddressFromTemplate];

        email.setTemplateId(emailTemplate.Id);
        email.setOrgWideEmailAddressId(owea.get(0).Id);
        email.setTargetObjectId((String)input.get('emailTargetObjectId'));
        if(!Test.isRunningTest())
        {
            email.setSaveAsActivity(true);
        }else{
        
            email.setSaveAsActivity(false);
        }
                 
        email.setSubject(emailTemplate.Subject);
        email.setHtmlBody(emailTemplate.HtmlValue);
        email.setPlainTextBody(emailTemplate.Body);

        System.debug('email: ' + email);

        Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

        outMap.put('EmailResult', result[0].success);

        return result[0].success;
    }

    public static List<String> convertListObjectToListString(Map<String,Object> input, String key)
    {
        List<Object> listAny = (List<Object>) input.get(key);
        System.debug('listAny: ' + listAny);

        List<String> listString = new List<String>();
        for (Object item : listAny)
            listString.add((String) item);

        return listString;
    }
}