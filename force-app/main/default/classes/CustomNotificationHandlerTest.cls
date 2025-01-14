@isTest(seeAllData=true)
private class CustomNotificationHandlerTest {
    @isTest
    static void notificationSuccess() {
        List<String> userIdList = new List<String>();
        String userId = UserInfo.getUserId();
        userIdList.add(userId);
        String targetId = [SELECT Id FROM Quote LIMIT 1].Id;
        
        Map<String, Object> inputMap = new Map<String, Object>{
            'recipientsIds' => userIdList,
            'targetId' => targetId,
            'developerName' => 'QuoteNotifications',
            'title' => 'Quote Ready for Review',
            'body' => 'The Quote has been successfully created and products configured. Its now ready for your review.'
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        CustomNotificationHandler notificationClass = new CustomNotificationHandler();
        
        Test.startTest();
        Boolean result = notificationClass.invokeMethod('notifyUsers', inputMap, outputMap, optionsMap);
        Test.stopTest();
        
        Assert.isTrue(result);
    }
    
    @isTest
    static void notificationFailure() {
        List<String> userIdList = new List<String>();
        String userId = UserInfo.getUserId();
        userIdList.add(userId);
        String targetId = [SELECT Id FROM Quote LIMIT 1].Id;
        
        Map<String, Object> inputMap = new Map<String, Object>{
            'targetId' => targetId,
            'developerName' => 'QuoteNotifications',
            'title' => 'Quote Ready for Review',
            'body' => 'The Quote has been successfully created and products configured. Its now ready for your review.'
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        
        CustomNotificationHandler notificationClass = new CustomNotificationHandler();
        
        Test.startTest();
        Boolean result = notificationClass.invokeMethod('notifyUsers', inputMap, outputMap, optionsMap);
        Test.stopTest();
        
        Assert.isFalse(result);
    }
}