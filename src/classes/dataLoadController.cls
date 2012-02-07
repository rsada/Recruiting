public class dataLoadController {

public class dataAlreadyLoadedException extends Exception {}
public class notEnoughUsersException extends Exception {}
public String loadStatus {get; set;}

List<Candidate__c> loadCandidates = new List<Candidate__c>();
List<Position__c> loadPositions = new List<Position__c>();
List<Job_Application__c> loadJobApplications = new List<Job_Application__c>();
List<Interview__c> loadInterviews = new List<Interview__c>();
List<Position_Tracker__c> loadPositionTrackers = new List<Position_Tracker__c>();
List<Recruiting_Tracker__c> loadRecruitingTrackers = new List<Recruiting_Tracker__c>();


Map<String, ID> mapPositions = new Map<String, ID>();
Map<String, ID> mapCandidates = new Map<String, ID>();

List<Location__c> existingLocations = [select Name, ID from location__c order by Name];
List<User> existingUsers = [select Name, ID from user order by Name];
List<Job_Application__c> existingJobApplications = [select Name, ID from Job_Application__c order by Name];
List<Position__c> existingPositions = [select Name, ID from Position__c order by Name];
List<Candidate__c> existingCandidates = [select Name, ID from Candidate__c order by Name];


public PageReference loadChapterData() {
        try { 
            If (existingUsers.size() < 5) {
                throw new notEnoughUsersException('You have not defined 5 users required to load the data.  Please initialize users with the tab in the Force.com application.');}
            else {
                loadChapter2Data();
                loadChapter3Data();
                loadChapter6Data();
                loadRecruitingTrackerData();
                return null;
                }
         }
         catch (notEnoughUsersException nu) {
             ApexPages.addMessages(nu);
             return null;
             }
}


public void loadChapter3Data() {
    loadPositionData();
    loadCandidateData();
    loadJobApplicationData();
}

public void loadChapter6Data() {
    loadInterviewData();
    loadPositionTrackerData();
}

public ID getUserID(Integer userPosition){
    return existingUsers[userPosition].ID;
}

public ID getLocationID(Integer locationPosition){
    return existingLocations[locationPosition].ID;
}

public void loadChapter2Data() {
      List<Location__c> loadLocations = [select Name, Street_Address__c, City__c, Country__c, Location_Map_URL__c, Phone__c, 
            Postal_Code__c, State_Province__c from Location__c];
      delete loadLocations; 
      loadLocations.clear();
      loadLocations.add(new Location__c( Name = 'Toronto',
        Street_Address__c = '20 Bay Street Suite 800',
        City__c = 'Toronto', Country__c = 'Canada',
        Location_Map_URL__c = 'maps.google.com/maps?f=q&hl=en&geocode=&q=20+Bay+St,+Toronto,+ON,+Canada&sll=40.753223,-73.97423&sspn=0.009428,0.022745&ie=UTF8&t=h&z=16&iwloc=addr',
        Phone__c = '(647) 258-3400', Postal_Code__c = 'M5J 2N8',
        State_Province__c = 'ON'));
      loadLocations.add(new Location__c( Name = 'HQ',
        Street_Address__c = 'The Landmark @ One Market',
        City__c = 'San Francisco', Country__c = 'USA',
        Location_Map_URL__c = 'maps.google.com/maps?f=q&hl=en&geocode=&q=1+market+st.+san+francisco,+ca&sll=37.0625,-95.677068&sspn=48.240201,82.265625&ie=UTF8&ll=37.794067,-122.395098&spn=0.011835,0.020084&z=16',
        Phone__c = '(415) 901-7000', Postal_Code__c = '94105',
        State_Province__c = 'CA'));
      loadLocations.add(new Location__c( Name = 'Reston',
        Street_Address__c = '11600 Sunrise Valley Drive Suite 250',
        City__c = 'Reston', Country__c = 'USA',
        Location_Map_URL__c = 'maps.google.com/maps?f=q&hl=en&geocode=&q=11600+Sunrise+Valley+Drive+20191&sll=38.93111,-77.348908&sspn=0.093208,0.160675&ie=UTF8&z=16',
        Phone__c = '(793) 463-3200', Postal_Code__c = '20191',
        State_Province__c = 'VA'));
      loadLocations.add(new Location__c( Name = 'New York',
        Street_Address__c = '140 East 45th Street 29th floor',
        City__c = 'New York City', Country__c = 'USA',
        Location_Map_URL__c = 'maps.google.com/maps?q=140+e.+45th+street,+ny+ny&ie=UTF-8&oe=utf-8&rls=org.mozilla:en-US:official&client=firefox-a&um=1&sa=X&oi=geocode_result&resnum=1&ct=title',
        Phone__c = '(646) 346-8909', Postal_Code__c = '10017',
        State_Province__c = 'NY'));
              
        try {              
              insert loadLocations;
              loadStatus = 'Location data successfully loaded. ';
              }
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
          catch (dataAlreadyLoadedException le) {
              ApexPages.addMessages(le);}
          }

public void loadPositionData(){
// Load Position data //    
    Date startDateSeed = date.Today();
    existingLocations = [select Name, ID from location__c order by Name];
    loadPositions = [select Responsibilities__c, Legacy_ID__c, Job_Description__c, Hiring_Manager__c,
        Start_Date__c from Position__c]; 
    delete loadPositions; 
    loadPositions.clear();
    existingLocations = [select Name, ID from location__c order by Name];
    loadPosition('Supports escalations.', '1000001', 'Second tier technical support.',
        getUserID(4), getLocationID(3), startDateSeed + 7,
        'Support', 'College', '', 'Open', '', 'SUP-200', startDateSeed - 10);    
    loadPosition('Manage all facets of initial development.', '1000002', 'Leader of stealth project.',
        getUserID(1), getLocationID(3), startDateSeed + 1,
        'Engineering', 'Masters', 'Java;.Net;Apex;PHP;Perl', 'Open', '', 'ENG-400', startDateSeed - 1);
    loadPosition('Design collateral, educate field, work with key customers.', '1000003', 'Product Marketing Manager for new product.',
        getUserID(1), getLocationID(3), startDateSeed + 28,
        'Engineering', 'College', '.Net', 'New', '', 'ENG-200', NULL);
    loadPosition('Insure that we meet service guarantees.', '1000004', 'HA specialist.',
        getUserID(1), getLocationID(0), startDateSeed + 21,
        'Engineering', 'Phd', 'Java;.Net;Perl;Apex', 'Open', '', 'Custom', startDateSeed - 15);
    loadPosition('Create technical collateral.', '1000005', 'Technical marketing manager.',
        getUserID(4), getLocationID(0), startDateSeed + 15,
        'Engineering', 'College', 'Apex', 'Open', '', 'ENG-200', startDateSeed - 5);   
    loadPosition('Increase revenue through channel.', '1000006', 'Vice President of channel sales.',
        getUserID(0), getLocationID(0), startDateSeed + 28,
        'Sales', 'Masters', '', 'Open', '', 'Custom', startDateSeed - 15);
    loadPosition('Design and execute QA procedures.  Track and report on results of procedures.', '1000007', 'Quality Assurance engineer for new product.',
        getUserID(4), getLocationID(0), startDateSeed + 10,
        'Engineering', 'College', 'Java;.Net;PHP', 'New', '', 'ENG-200', NULL);
    loadPosition('Entry level QA position.', '1000008', 'QA Assistant.',
        getUserID(3), getLocationID(0), startDateSeed + 5,
        'Engineering', 'College', '.Net', 'Open', '', 'ENG-100', startDateSeed - 3);
    loadPosition('Organize interviews, screen candidates, maintain schedule for Vice President, assorted other duties.', 
        '1000009', 'Administrative assistant to VP of Finance.',
        getUserID(0), getLocationID(0), startDateSeed + 21,
        'Finance', 'High school', '', 'New', '', 'FIN-100', NULL);
    loadPosition('Work customer support, day shift.', '1000010', 'Support representative.',
        getUserID(4), getLocationID(2), startDateSeed + 1,
        'Support', 'College', '', 'Open', '', 'SUP-200', startDateSeed - 5);     
    loadPosition('Standard accounting work.', '1000011', 'Mid-level accountant.',
        getUserID(4), getLocationID(2), startDateSeed + 4,
        'Finance', 'College', '', 'New', '', 'FIN-200', NULL );
    loadPosition('Supervise audit crew.', '1000012', 'Director of auditing.',
        getUserID(4), getLocationID(1), startDateSeed + 14,
        'Finance', 'Masters', '', 'New', '', 'FIN-400', NULL);
    loadPosition('Develop modules of new product.', '1000013', 'Developer.',
        getUserID(3), getLocationID(1), startDateSeed + 2,
        'Engineering', 'Masters', 'Java;Apex;,Net', 'Open', '', 'ENG-200', startDateSeed - 3);
    loadPosition('Selling our products.', '1000014', 'Field rep.',
        getUserID(4), getLocationID(1), startDateSeed + 1,
        'Sales', 'College', '', 'Open', '', 'SAL-200', startDateSeed - 5);
    loadPosition('Entry level position.', '1000015', 'Accounts receivables clerk.',
        getUserID(3), getLocationID(1), startDateSeed + 5,
        'Finance', 'College', '', 'Open', '', 'FIN-100', startDateSeed - 10);
        try {           
              insert loadPositions;
              if (loadStatus == null) {
                  loadStatus = 'Position data successfully loaded.  ';}
              else {    
                  loadStatus = loadStatus + 'Position data successfully loaded.  ';}}
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
}

public void loadPosition( String Responsibilities, 
    String LegacyID, String JobDescription,
    ID HiringManager, ID Location, Date StartDate,
    String Department, String EducationalRequirements, String ProgrammingLanguages,
    String Status, String SubStatus, String SalaryGrade, Date OpenPositionDate ) {
// insert individual Postion record //  
    loadPositions.add(new Position__c(
        Responsibilities__c = Responsibilities, 
        Legacy_ID__c = LegacyID, Job_Description__c = JobDescription,
        Location__c = Location, Hiring_Manager__c = HiringManager, Start_Date__c = StartDate,
        Department__c = Department, Educational_Requirements__c = EducationalRequirements,
        Programming_Languages__c = ProgrammingLanguages, Status__c = Status,
        Sub_status__c = SubStatus, Salary_grade__c = SalaryGrade, Open_Position_Date__c = OpenPositionDate));    
}

public void loadCandidateData() {
    loadCandidates = [select Address__c, City__c, Country__c,
            Current_Employer__c, Email__c,
            First_Name__c, Last_Name__c,
            Legacy_ID__c, Mobile__c,
            Phone__c, Postal_Code__c,
            State_Province__c from Candidate__c];
    delete loadCandidates;
    loadCandidates.clear();
        loadCandidate('5265 Elm Street', 'Toronto', 'Canada',
        'Hydro Canada', 'rsmith@gmail.com', 'Robert',
        'Smith', '10001', '',
        '416-555-1212', '3T3 4B6', 'ON', 'High school');
    loadCandidate('3 Overhead Lane', 'Escanaba', 'USA',
        'State of Michigan', 'chuckg@gmail.com', 'Chuck',
        'Grey', '10002', '',
        '516-555-1212', '41001', 'MI', 'High school');
    loadCandidate('6416 Bartlett Avenue', 'McKees Rocks', 'USA',
        'Carnegie Mellon', 'lhuff@gmail.com', 'LuAnn',
        'Huff', '10003', '',
        '412-555-1212', '15234', 'PA', 'College');
    loadCandidate('2525 Portsmouth Avenue', 'Toledo', 'USA',
        'salesforce.com', 'rgreenwald@gmail.com', 'Rick',
        'Ostenberg', '10004', '',
        '419-555-1212', '43823', 'OH', 'PhD');
    loadCandidate('36 Greenway', 'Mountain View', 'USA',
        'Oracle', 'ddaly@gmail.com', 'Donald',
        'Daily', '10005', '',
        '650-555-1212', '91919', 'CA', 'College');
    loadCandidate('111 Montclair Street', 'Boston', 'USA',
        'City of Boston', 'prevere@gmail.com', 'Paul',
        'Revere', '10006', '',
        '617-555-1212', '21111', 'MA', 'Post-doc');
    loadCandidate('110 Walnut Avenue', 'Wilmette', 'USA',
        'Evanston Healthcare', 'elliev@gmail.com', 'Elinor',
        'Vera', '10007', '',
        '847-555-1212', '60268', 'IL', 'PhD');
    loadCandidate('249 First Avenue', 'Scottsdale', 'USA',
        'General Dynamics', 'robiny@gmail.com', 'Robin',
        'Yang', '10008', '',
        '480-555-1212', '85258', 'AZ', 'Masters');
    loadCandidate('2287 Talmadge Road', 'Mountain View', 'USA',
        'Google', 'baileyj@gmail.com', 'Bailey',
        'Jackson', '10009', '',
        '650-555-1212', '90543', 'CA', 'PhD');
    loadCandidate('2498 Kalekalua Avenue', 'Honolulu', 'USA',
        'PetSmart', 'josies@gmail.com', 'Josie',
        'Shang', '10010', '',
        '808-555-1212', '39287', 'HI', 'College');             
        try {
              insert loadCandidates;
              if (loadStatus == null) {
                  loadStatus = 'Candidate data successfully loaded.  ';}
              else { 
                  loadStatus = loadStatus + 'Candidate data successfully loaded.  ';}}
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
          }                
                
    
public void loadCandidate(String Address, String City, String Country,
    String CurrentEmployer, String Email, String FirstName,
    String LastName, String LegacyID, String Mobile, 
    String Phone, String PostalCode, String StateProvince, String Education) {
        loadCandidates.add(new Candidate__c(Address__c = Address,
            City__c = City, Country__c = Country,
            Current_Employer__c = CurrentEmployer, Email__c = Email,
            First_Name__c = FirstName, Last_Name__c = LastName,
            Legacy_ID__c = LegacyID, Mobile__c = Mobile,
            Phone__c = Phone, Postal_Code__c = PostalCode,
            State_Province__c = StateProvince, Education__c = Education));
    }
                    
public void loadJobApplicationData() {
    loadJobApplications = [select Position__c, Candidate__c from Job_Application__c];
    delete loadJobApplications;
    loadJobApplications.clear();
    Integer JobApps = [select count() from Job_Application__c];
    List<Position__c> currentPositions = [select ID, Legacy_ID__c from position__c];
    List<Candidate__c> currentCandidates = [select ID, Legacy_ID__c from Candidate__c];
    for (Position__c p : currentPositions) {
        mapPositions.put(p.Legacy_ID__c, p.ID);
        }
    for (Candidate__c c : currentCandidates) {
        mapCandidates.put(c.Legacy_ID__c, c.ID);
        }
    loadJobApp(mapPositions.get('1000003'), mapCandidates.get('10001'), 'Applied');   
    loadJobApp(mapPositions.get('1000011'), mapCandidates.get('10001'), 'Applied');
    loadJobApp(mapPositions.get('1000014'), mapCandidates.get('10001'), 'Applied');
    loadJobApp(mapPositions.get('1000006'), mapCandidates.get('10001'), 'Applied');
    loadJobApp(mapPositions.get('1000008'), mapCandidates.get('10001'), 'Applied');
    loadJobApp(mapPositions.get('1000002'), mapCandidates.get('10001'), 'Applied');
    loadJobApp(mapPositions.get('1000004'), mapCandidates.get('10001'), 'Applied');     
    loadJobApp(mapPositions.get('1000014'), mapCandidates.get('10002'), 'Applied');
    loadJobApp(mapPositions.get('1000015'), mapCandidates.get('10003'), 'Applied');
    loadJobApp(mapPositions.get('1000009'), mapCandidates.get('10004'), 'Applied');
    loadJobApp(mapPositions.get('1000002'), mapCandidates.get('10004'), 'Applied');
    loadJobApp(mapPositions.get('1000003'), mapCandidates.get('10004'), 'Applied');   
    loadJobApp(mapPositions.get('1000001'), mapCandidates.get('10005'), 'Applied');    
    loadJobApp(mapPositions.get('1000014'), mapCandidates.get('10005'), 'Applied');           
    loadJobApp(mapPositions.get('1000009'), mapCandidates.get('10005'), 'Applied');  
    loadJobApp(mapPositions.get('1000003'), mapCandidates.get('10006'), 'Applied');    
    loadJobApp(mapPositions.get('1000012'), mapCandidates.get('10006'), 'Applied');      
    loadJobApp(mapPositions.get('1000010'), mapCandidates.get('10006'), 'Applied');      
    loadJobApp(mapPositions.get('1000006'), mapCandidates.get('10006'), 'Applied');  
    loadJobApp(mapPositions.get('1000006'), mapCandidates.get('10007'), 'Applied');      
    loadJobApp(mapPositions.get('1000007'), mapCandidates.get('10007'), 'Applied');   
    loadJobApp(mapPositions.get('1000014'), mapCandidates.get('10007'), 'Applied');      
    loadJobApp(mapPositions.get('1000008'), mapCandidates.get('10007'), 'Applied');  
    loadJobApp(mapPositions.get('1000015'), mapCandidates.get('10008'), 'Applied');  
    loadJobApp(mapPositions.get('1000003'), mapCandidates.get('10008'), 'Applied');           
    loadJobApp(mapPositions.get('1000012'), mapCandidates.get('10008'), 'Applied');           
    loadJobApp(mapPositions.get('1000013'), mapCandidates.get('10008'), 'Applied');           
    loadJobApp(mapPositions.get('1000011'), mapCandidates.get('10008'), 'Applied');           
    loadJobApp(mapPositions.get('1000014'), mapCandidates.get('10008'), 'Applied');      
    loadJobApp(mapPositions.get('1000005'), mapCandidates.get('10009'), 'Applied');              
    loadJobApp(mapPositions.get('1000001'), mapCandidates.get('10009'), 'Applied');
    loadJobApp(mapPositions.get('1000002'), mapCandidates.get('10009'), 'Applied');  
    loadJobApp(mapPositions.get('1000009'), mapCandidates.get('10009'), 'Applied');  
    loadJobApp(mapPositions.get('1000008'), mapCandidates.get('10009'), 'Applied');  
    loadJobApp(mapPositions.get('1000013'), mapCandidates.get('10010'), 'Applied'); 
    loadJobApp(mapPositions.get('1000003'), mapCandidates.get('10010'), 'Applied');     
    loadJobApp(mapPositions.get('1000014'), mapCandidates.get('10010'), 'Applied'); 
    loadJobApp(mapPositions.get('1000005'), mapCandidates.get('10010'), 'Applied');        
        try {
             insert loadJobApplications;
              if (loadStatus == null) {
                  loadStatus = 'Job Application data successfully loaded.  ';}
              else { 
                  loadStatus = loadStatus + 'Job Application data successfully loaded.  ';}
              }
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
    }
    
public void loadJobApp(ID positionID, ID candidateID, String Status) {
    loadJobApplications.add(new Job_Application__c(Position__c = positionID,
        Candidate__c = candidateID, Status__c = Status));
}

 public void loadInterviewData() {
    loadInterviews = [select Job_Application__c, Interviewer__c from Interview__c];
    delete loadInterviews;
    loadInterviews.clear();
    existingJobApplications = [select Name, ID from Job_Application__c order by Name];
    loadInterview(getUserID(0), existingJobApplications[1].ID); 
    loadInterview(getUserID(1), existingJobApplications[1].ID); 
    loadInterview(getUserID(2), existingJobApplications[5].ID); 
    loadInterview(getUserID(3), existingJobApplications[5].ID); 
    loadInterview(getUserID(4), existingJobApplications[9].ID);
        try {
             insert loadInterviews;
              if (loadStatus == null) {
                  loadStatus = 'Interview data successfully loaded.  ';}
              else { 
                  loadStatus = loadStatus + 'Interview data successfully loaded.  ';}
              }
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
    }


public void loadInterview(ID Interviewer, ID JobApplication) {
    loadInterviews.add(new Interview__c(Job_Application__c = JobApplication,
        Interviewer__c = Interviewer));
        }

public void loadPositionTrackerData() {
    loadPositionTrackers = [select Status__c, Position__c from Position_Tracker__c];
    delete loadPositionTrackers;
    loadPositionTrackers.clear();    
    existingPositions = [select ID from Position__c];
    Date startDateSeed = Date.Today();
    loadPositionTracker(3, 'New', existingPositions[0].ID, startDateSeed - 27);
    loadPositionTracker(1, 'Closed', existingPositions[0].ID, startDateSeed - 27);
    loadPositionTracker(2, 'New', existingPositions[0].ID, startDateSeed - 20);
    loadPositionTracker(3, 'Closed', existingPositions[0].ID, startDateSeed - 20);
    loadPositionTracker(4, 'New', existingPositions[0].ID, startDateSeed - 13);
    loadPositionTracker(2, 'Closed', existingPositions[0].ID, startDateSeed - 13);
    loadPositionTracker(3, 'New', existingPositions[0].ID, startDateSeed - 6);
    loadPositionTracker(3, 'Closed', existingPositions[0].ID, startDateSeed - 6);
        try {
             insert loadPositionTrackers;
              if (loadStatus == null) {
                  loadStatus = 'Position Tracker data successfully loaded.  ';}
              else { 
                  loadStatus = loadStatus + 'Position Tracker data successfully loaded.  ';}
              }
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
    }

public void loadPositionTracker(Integer repeats, String Status, ID Position, Date dateOfStatus) {
    for (Integer i = 0; i < repeats; i++) {
        loadPositionTrackers.add(new Position_Tracker__c(Position__c = Position, Date_of_Status__c = dateOfStatus,
                Status__c = Status)); 
    }
}
 
 public void loadRecruitingTrackerData() {
    loadRecruitingTrackers = [select Position__c, Candidate__c from Recruiting_Tracker__c];
    delete loadRecruitingTrackers;
    loadRecruitingTrackers.clear();
    existingPositions = [select ID from Position__c];
    existingJobApplications = [select ID from Job_Application__c];
    existingCandidates = [select ID from Candidate__c];
    Date startDateSeed = Date.Today();
    Datetime startDateTimeSeed = DateTime.now();
    loadRecruitingTracker(3, existingPositions[0].ID, existingJobApplications[0].ID,
        existingCandidates[0].ID, startDateSeed - 27, startDateTimeSeed.adddays(-27));
        loadRecruitingTracker(6, existingPositions[0].ID, existingJobApplications[0].ID,
        existingCandidates[0].ID, startDateSeed - 20, startDateTimeSeed.adddays(-20));
    loadRecruitingTracker(8, existingPositions[0].ID, existingJobApplications[0].ID,
        existingCandidates[0].ID, startDateSeed - 13, startDateTimeSeed.adddays(-13));
    loadRecruitingTracker(4, existingPositions[0].ID, existingJobApplications[0].ID,
        existingCandidates[0].ID, startDateSeed - 6, startDateTimeSeed.adddays(-6));
        try {
             insert loadRecruitingTrackers;
              if (loadStatus == null) {
                  loadStatus = 'Recruiting Tracker data successfully loaded.  ';}
              else { 
                  loadStatus = loadStatus + 'Recruiting Tracker data successfully loaded.  ';}
              }
          catch (DmlException de) {
              ApexPages.addMessages(de);
              }
    }




public void loadRecruitingTracker(Integer repeats, ID Position, ID JobApplication, ID Candidate, 
        Date ApplicationCreatedDate, Datetime DateTimeCreated) {
    for (Integer i = 0; i < repeats; i++) {
        loadRecruitingTrackers.add(new Recruiting_Tracker__c(Position__c = Position, Job_Application__c = JobApplication,
            Candidate__c = Candidate, Application_Created_Date__c = ApplicationCreatedDate, Date_Time_Collected__c = DateTimeCreated,
            First_Name__c = 'Robby', Last_Name__c = 'Bobby'));
    }
}


    
}