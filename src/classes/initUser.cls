public class initUser {
   
    public List<User> newUserList = new List<User>();
    public List<Profile> standardUserProfile = [select ID from profile where Name = 'Standard User'];
    public List<Profile> standardPlatformUserProfile = [select ID from profile where Name = 'Standard Platform User'];

    public String resultStatus { get; set;}
 
    public User newUsers { get{
        If (newUsers == null) {
            newUsers = new User();}
            return newUsers;}
            set;} 
            
    public String domainID {get; set;}
            
    //Create 4 users, 1 with Standard User license, the others with Standard Platform User licenses//
    public PageReference initializeUsers() {         
        createUser('VP', 'Prodman', 'VPProdma', 'vpprodman@' + domainID, 
            'VPPM', standardUserProfile[0].ID); 
        createUser('Joe', 'Personnel', 'JoeHR', 'joep@'+ domainID, 
            'JoeHR', standardPlatformUserProfile[0].ID);
        createUser('Product', 'Manager', 'PMana', 'prodman@' + domainID, 
            'PM', standardPlatformUserProfile[0].ID);
        createUser('Director','Prodman','DirPM', 'dirpm@'+ domainID, 
            'DPM', standardPlatformUserProfile[0].ID);
        //Once users are added, insert into organization and return message on outcome//    
         try {
             insert newUserList;
             resultStatus = 'Four users have been added to your organization.';
             return null;}
         catch (DmlException de) {
            ApexPages.addMessages(de);
            return null;} 
         addManagers();
         return null;   
        }
        
 public void addManagers() {
    List<User> existingUsers = [select ID, FirstName from User];
    Map<String, ID> mapUsers = new Map<String, ID>();
    for (User u : existingUsers) {
        mapUsers.put(u.FirstName, u.ID);
    }
    ID userID;
    ID newManagerID;
    userID = mapUsers.get('Product');
    List<User> updateUsers = [select ManagerID from User where ID = :userID];
    newManagerID = mapUsers.get('Director');
    updateUsers[0].ManagerID = newManagerID;
    update updateUsers;
}

//Create an individual user //        
    public void createUser(String FirstName, String LastName, String Alias, String Username,
        String CommunityNickname, ID profileID) {
              newUserList.add(new User(emailEncodingKey = 'ISO-8859-1',
                 timeZoneSidKey = 'America/Los_Angeles',
                 localeSidKey = 'en_US',
                 languageLocaleKey = 'en_US',
                 profileID = profileID,
                 FirstName = FirstName,
                 LastName = LastName,
                 Alias = Alias,
                 Username = Username,
                 CommunityNickname = CommunityNickname,
                 email = newUsers.Email,
                 Street = newUsers.Street,
                 City = newUsers.City,
                 CompanyName = newUsers.CompanyName,
                 State = newUsers.State  ));
    }

}