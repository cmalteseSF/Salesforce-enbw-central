global class RegistrationHandler implements Auth.RegistrationHandler{

    global User createUser(Id portalId, Auth.UserData data){
        // get a user with same email as the Open Id user
        System.debug('###' + data);
        User u = [SELECT Id FROM User WHERE federationidentifier = :data.email LIMIT 1];
        return u;
    }
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        // todo: we can do something when they login if needed
    }
}