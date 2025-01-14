global class CustomNotificationHandler implements vlocity_cmt.VlocityOpenInterface{
    
    global Boolean invokeMethod (String methodName, Map<String, object> input, Map<String, object> output, Map<String, object> options) {
        try{
            if(methodName.equalsIgnoreCase('notifyUsers')){
                notifyUsers(input);
                return true;
            }
        }
        catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
            return false;
        }
        return false;
    }

    public static void notifyUsers(Map<String, Object> input) 
    {
        List<Object> recipientsIdsList = (List<Object>)input.get('recipientsIds');
        Set<String> recipientsIds = new Set<String>();

        for(Object obj: recipientsIdsList)
            recipientsIds.add(String.valueOf(obj));

        String targetId = (String) input.get('targetId');
        String developerName = (String) input.get('developerName');
        String title = (String) input.get('title');
        String body = (String) input.get('body');

        if(recipientsIds.isEmpty() || String.isBlank(targetId) || String.isBlank(developerName) || String.isBlank(title) || String.isBlank(body)) 
            throw new IllegalArgumentException();

        CustomNotificationType notificationType = 
            [SELECT Id 
             FROM CustomNotificationType 
             WHERE DeveloperName=:developerName];
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);

        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}