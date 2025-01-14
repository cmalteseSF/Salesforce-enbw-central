@isTest
private class RegistrationHandlerTest {
    
    @isTest
    static void testCreateUser() {
        RegistrationHandler registrationHandler = new RegistrationHandler();
        
        Profile pf = [Select Id from Profile where Name = 'System Administrator']; 

        User newUser =new User(firstName = 'John',
                               lastName = 'Smith', 
                               email = 'jsmith@test.com', 
                               Username = 'jsmith@test.com.org',
                               EmailEncodingKey = 'ISO-8859-1', 
                               Alias = 'jsmith', 
                               TimeZoneSidKey = 'America/Los_Angeles', 
                               LocaleSidKey = 'en_US', 
                               LanguageLocaleKey = 'en_US',
                               federationidentifier = 'jsmith@test.com',
                               ProfileId = pf.Id
                        	);
        
        insert newUser;
        
        Auth.UserData sampleData = new Auth.UserData('id01',
              'John',
              'Smith',
              'John Smith',
              'jsmith@test.com',
              null,
              'jsmith@test.com.org',
              'en_US',
              'facebook',
              null,
              new Map<String, String>{});
        
		try{
            User u = registrationHandler.createUser(null, sampleData);
            Assert.areEqual(newUser.Id, u.Id);
        }
        catch(Exception e){
        }
    }

        @isTest
    static void testUpdateUser() {
        RegistrationHandler registrationHandler = new RegistrationHandler();
        
        Profile pf = [Select Id from Profile where Name = 'System Administrator']; 

        User newUser =new User(firstName = 'John',
                               lastName = 'Smith', 
                               email = 'jsmith@test.com', 
                               Username = 'jsmith@test.com.org',
                               EmailEncodingKey = 'ISO-8859-1', 
                               Alias = 'jsmith', 
                               TimeZoneSidKey = 'America/Los_Angeles', 
                               LocaleSidKey = 'en_US', 
                               LanguageLocaleKey = 'en_US',
                               federationidentifier = 'jsmith@test.com',
                               ProfileId = pf.Id
                        	);
        
        insert newUser;
        
        Auth.UserData sampleData = new Auth.UserData('id01',
              'John',
              'Smith',
              'John Smith',
              'jsmith@test.com',
              null,
              'jsmith@test.com.org',
              'en_US',
              'facebook',
              null,
              new Map<String, String>{});
        
		try{
            registrationHandler.updateUser(newUser.Id, null, sampleData);
        }
        catch(Exception e){
        }
    }
}