/*
Name                IndustryProgramFormController
Created By          Nitish Bansal
Created Date        03/07/2016
Purpose             T-482555
*/
public class IndustryProgramFormController{

    public String documentId{get;set;}
    public String documentId1{get;set;}
    public String documentId2{get;set;}
    public String documentId3{get;set;}
    public Document doc{get;set;}
    public Document doc1{get;set;}
    public Document doc2{get;set;}
    public Document doc3{get;set;} 
    public List<Document> attachedDocList{get;set;}
    public String email {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String streetLine1 {get;set;}
    public String streetLine2 {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String country {get;set;}
    public String zipcode {get;set;}
    public String newCaseId {get;set;}
    public String phoneNumber {get;set;}
    public String militaryBranch {get;set;}
    public String teamName {get;set;}
    public String headCookName {get;set;}
    public String compBBQ {get;set;}
    public String webAddr {get;set;}
    public String companyName {get;set;}
    
    public List<SelectOption> listStateCodes {
        get{
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Case.State__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple) {
                options.add(new SelectOption(f.getValue(), f.getValue()));
            }
            return options;
        }
        set;
    }
    public List<SelectOption> listPrograms {get;set;}
    
    public String selectedProgram {get;set;}
    public String newProg {get;set;}
    private Boolean attachRequired {get;set;}

    public Boolean showMilitary {get;set;}
    public Boolean showProGuide {get;set;}
    public Boolean showBBQ {get;set;}
    
    private static final Pattern zipCodePattern = Pattern.compile('^[A-Za-z]{1}\\d{1}[A-Za-z]{1} *\\d{1}[A-Za-z]{1}\\d{1}$'); 
    public String CURRENT_DATE_TIME{get;set;}
    
    // the contact record you are adding values to
    public Case newcase {
        get {
          if (newcase == null)
            newcase = new Case();
          return newcase;
        }
        set;
    }
    
    public IndustryProgramFormController(){
        doc = new Document();
        doc1 = new Document();
        doc2 = new Document();
        doc3 = new Document();
        attachedDocList = new list<Document>();
        CURRENT_DATE_TIME = system.now().format('ddMMyyyy hh:mm:ss a');
    
        //Default case values
        newcase.Status = 'New';
        newcase.Type = 'Outfitter';
        newcase.Origin = 'Web';
        newcase.Priority = 'Medium';

        //Default state value
        state = listStateCodes.get(0).getLabel();
        
        //Country Default Value
        newcase.Country__c = 'United States';
        
        //Industry program
        listPrograms = new List<SelectOption>();
        List<String> fieldValues = getPicklistValues('Case', 'Industry_Program__c');
        for(String s : fieldValues){
            listPrograms.add(new SelectOption(s,s));
        }

        selectedProgram = listPrograms.get(0).getLabel();
        showMilitary = showBBQ = false;
        showProGuide= true;
    }
    
    //Function takes sObject & Field name as parameters and returns the list of picklist values for that field.
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name){ 
      List<String> listPickvals = new List<String>();
      Map<String, Schema.SObjectField> mapsObjectFields = Schema.getGlobalDescribe().get(ObjectApi_name).newSObject().getSObjectType().getDescribe().fields.getMap(); //map of fields for that sobject
        List<Schema.PicklistEntry> listPickListValues = mapsObjectFields.get(Field_name).getDescribe().getPickListValues(); //list of picklist values for the passed field for that object
        for (Schema.PicklistEntry a : listPickListValues) { 
            listPickvals.add(a.getValue());
        }
      return listPickvals;
    }
    
    //Create & associate attachment with new case
    public void createAttachment(){
        String caseNumber;
        for(Case cs : [select Id, CaseNumber from Case where Id = :newcase.Id]) {
            caseNumber = cs.CaseNumber;
            newCaseId = cs.Id;
        }
        //inserting attachments
        List<Attachment> newAttachments = new List<Attachment>();
        for(Document attachedDoc : [select Name, body from Document where ID IN : attachedDocList]) {
            Attachment a = new Attachment();
            a.body = attachedDoc.body;
            a.parentId = newcase.Id;
            a.Name = attachedDoc.Name;
            newAttachments.add(a);
        }
        String policyDescLikeStr = 'Test' + ' - ' + ' - %';
         for(Document relatedDoc : [select id from Document
                                    where ID NOT IN : attachedDocList AND
                                    FolderId = :Userinfo.getUserId()
                                   AND Description like :policyDescLikeStr]) {
            attachedDocList.add(relatedDoc);
        }
        if(!newAttachments.isEmpty()) insert newAttachments;
        // deleting all temp documents which were created to store attachments files.
        if(!attachedDocList.isEmpty()) delete attachedDocList;
    }

    // display list of attachment
    public void showAttachment() {
        String docPostFixStr = 'Test' + ' - ' + CURRENT_DATE_TIME;
        attachedDocList = [select Id, name from Document where folderId = :userinfo.getUserId() AND Description = :docPostFixStr];
    }

    // Insertion of documents when add attachment get called
    public void insertDoc() {
        if(doc.body != null){
            String fileExtension = doc.name.indexOf('.') <> -1 ? doc.name.substring(doc.name.lastIndexOf('.') + 1) : null;
            if(fileExtension == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.WebToCaseAttachmentFileTypeError));
                return;
            }
            doc.FolderId = Userinfo.getUserId();
            doc.Description = 'Test' + ' - ' + CURRENT_DATE_TIME;
            try{
                insert doc;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Unable_to_create_the_document_Please_contact_your_Administrator));
                return;
            }
            documentId = doc.Id;
            doc.Body = null;
            attachRequired = false;
        }
        if(doc1.body != null){
            String fileExtension = doc1.name.indexOf('.') <> -1 ? doc1.name.substring(doc1.name.lastIndexOf('.') + 1) : null;
            if(fileExtension == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.WebToCaseAttachmentFileTypeError));
                return;
            }
            doc1.FolderId = Userinfo.getUserId();
            doc1.Description = 'Test' + ' - ' + CURRENT_DATE_TIME;
            try{
                insert doc1;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Unable_to_create_the_document_Please_contact_your_Administrator));
                return;
            }
            documentId1 = doc1.Id;
            doc1.Body = null;
            attachRequired = false;
        }
        if(doc2.body != null){
            String fileExtension = doc2.name.indexOf('.') <> -1 ? doc2.name.substring(doc2.name.lastIndexOf('.') + 1) : null;
            if(fileExtension == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.WebToCaseAttachmentFileTypeError));
                return;
            }
            doc2.FolderId = Userinfo.getUserId();
            doc2.Description = 'Test' + ' - ' + CURRENT_DATE_TIME;
            try{
                insert doc2;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Unable_to_create_the_document_Please_contact_your_Administrator));
                return;
            }
            documentId2 = doc2.Id;
            doc2.Body = null;
            attachRequired = false;
        }
        if(doc3.body != null){
            String fileExtension = doc3.name.indexOf('.') <> -1 ? doc3.name.substring(doc3.name.lastIndexOf('.') + 1) : null;
            if(fileExtension == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.WebToCaseAttachmentFileTypeError));
                return;
            }
            doc3.FolderId = Userinfo.getUserId();
            doc3.Description = 'Test' + ' - ' + CURRENT_DATE_TIME;
            try{
                insert doc3;
            } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Unable_to_create_the_document_Please_contact_your_Administrator));
                return;
            }
            documentId3 = doc3.Id;
            doc3.Body = null;
            attachRequired = false;
        }
    }
    
    public PageReference save(){
        Boolean error = false;
        if(firstName == null || firstName == '' || !(firstName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_First_Name)); 
            error = true;
        }
        if(lastName == null || lastName == '' || !(lastName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_Last_Name)); 
            error = true;
        }
        if(streetLine1 == null || streetLine1 == '' || !(streetLine1.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Shipping_Address)); 
            error = true;
        }
        if(city == null || city == '' || !(city.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_City)); 
            error = true;
        }
        if(zipcode == null || zipcode == '' || !(zipcode.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_Zip_Code)); 
            error = true;
        } else {
            error = !zipCodeValidation(state);
        }
        if(email == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_email_address)); 
            error = true;
        }
        /*if(newcase.Country__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_select_a_country)); 
            error = true;
        }*/
        if(showProGuide){
            if(companyName == null || companyName == '' || !(companyName.length() > 0)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Company_Name)); 
                error = true;
            }
        }
        if(showMilitary){
            if(militaryBranch == null || militaryBranch == '' || !(militaryBranch.length() > 0)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Military_Branch)); 
                error = true;
            }
        } 
        if(showBBQ){
            if(teamName == null || teamName == '' || !(teamName.length() > 0)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_team_name)); 
                error = true;
            }
            if(headCookName == null || headCookName == '' || !(headCookName.length() > 0)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Head_Cook)); 
                error = true;
            }
            if(compBBQ == null || compBBQ == '' || !(compBBQ.length() > 0)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_BBQ_Competitions)); 
                error = true;
            }
        }
        if(!newcase.T_C_Agreement__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_accept_terms_and_conditions)); 
            error = true;
        }
        if(webAddr != null && webAddr != '' && (webAddr.length() > 0)){
            if(!Pattern.matches('(^((http|https)://)??(www[.])??([a-zA-Z0-9]|-)+?([.][a-zA-Z0-9(-|/|=|?)??]+?)+?$)', webAddr)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_valid_web_address_for_the_website)); 
                error = true;
            }
        }
        if(phoneNumber == null || !(Pattern.matches('(\\d){10}', phoneNumber) || Pattern.matches('\\D*?(\\d\\D*?){10}', phoneNumber))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_10_digit_phone_number)); 
            error = true;
        }
        if(error){
            return null;
        }
        else {
            //Populating case contact and account lookup fields
            if(email != null && email != ''){
                for(Contact con : [Select Id, AccountId From Contact where Email =:email]){
                    newcase.ContactId = con.Id;
                    newcase.AccountId = con.AccountId;
                    break;
                }
            }
        }
        //Creating Case with form data
        try {
            newcase.Industry_Program__c = selectedProgram;
            newcase.Reason = 'Inquiry';
            newcase.Subject = 'Industry Program Request';
            newcase.Description = 'A new industry program request has been submitted via a web form.' + '\r\n' + '\r\n';
            if(showProGuide){
                newcase.Description = newcase.Description + nameFormat(Label.COMPANY_NAME.toLowerCase()) + ' : ' + companyName + '\r\n';
            } else if(showMilitary){
                newcase.Description = newcase.Description + nameFormat(Label.MILITARY_BRANCH.toLowerCase()) + ' : ' + militaryBranch + '\r\n';
            } else if(showBBQ){
                newcase.Description = newcase.Description + nameFormat(Label.TEAM_NAME.toLowerCase()) + ' : ' + teamName + '\r\n';
                newcase.Description = newcase.Description + nameFormat(Label.HEAD_COOK_S_NAME.toLowerCase()) + ' : ' + headCookName + '\r\n';
                newcase.Description = newcase.Description + nameFormat(Label.BARBECUE_COMPETITIONS_ATTENDED_ATTENDING_AND_YEAR.toLowerCase()) + ' : ' + compBBQ + '\r\n';
            }
            newcase.Description = newcase.Description + nameFormat(Label.FIRST_NAME.toLowerCase()) + ' : ' + firstName + '\r\n' + nameFormat(Label.LAST_NAME.toLowerCase()) + ' : ' + lastName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.STREET_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n' + nameFormat(Label.ADDRESS_LINE_2.toLowerCase()) + ' : ' + streetLine2 + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CITY.toLowerCase()) + ' : ' + city + '\r\n' + nameFormat(Label.STATE_PROVINCE_REGION.toLowerCase()) + ' : ' + state + '\r\n' + nameFormat(Label.ZIP_POSTAL_CODE.toLowerCase()) + ' : ' + zipcode;
            newcase.Description = newcase.Description + nameFormat(Label.COUNTRY.toLowerCase()) + ' : ' + newcase.Country__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.PHONE.toLowerCase()) + ' : ' + formatphonenumber(phoneNumber) + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + email + '\r\n' + nameFormat(Label.WEBSITE.toLowerCase()) + ' : ' + webAddr + '\r\n';  
            if(newcase.License_ID_Number__c == null){
                newcase.Description = newcase.Description + nameFormat(Label.LICENSE_ID_NUMBER_IF_APPLICABLE.toLowerCase()) + '\r\n';
            } else {
                newcase.Description = newcase.Description + nameFormat(Label.LICENSE_ID_NUMBER_IF_APPLICABLE.toLowerCase()) + ' : ' + newcase.License_ID_Number__c + '\r\n';
            }
            
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Outfitter' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            insertDoc();
            showAttachment();
            createAttachment();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            return Page.ConfirmationMessagePage;
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
          return null;
        }
    }

     public void selectProgram(){
        showProGuide = showMilitary = showBBQ= false;
        selectedProgram = newProg;
        //system.assert(false, newProg);
        if(selectedProgram == 'Military'){
            showMilitary = true;
        } else if(selectedProgram == 'Pro/guide' || selectedProgram == 'First responders' || selectedProgram == 'Industry'){
            showProGuide = true;
        } else {
            showBBQ = true;
        }
    }

    //Formating entered phone number
    private String formatphonenumber(String cphone) {
        String fphone = cphone.replaceAll('\\D','');

        if (fphone.length() == 10) {
          fphone = formatphonenum(fphone);
          return fphone;
        }
        else {
          return cphone;
        }
    }

    private String formatphonenum(String s) {
      s = '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);
      return s;
    }

    //Zip code validation for US and CA country code
    private Boolean zipCodeValidation(String stateCode){
        if(newcase.Country__c != null && newcase.Country__c == 'Canada'){
            zipcode = zipcode.replaceAll('[^A-Za-z0-9]', '');       
            if(zipcode.length()!=6){        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Postal_Code_must_be_6_characters_with_a_space_between_the_3rd_and_4th_characters));        
                return false;       
            }       
            zipcode = zipcode.substring(0, 3) + ' ' + zipcode.substring(3, zipcode.length());       
            if(!zipCodePattern.matcher(zipcode).matches()){     
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Postal_Code_must_be_6_characters_with_a_space_between_the_3rd_and_4th_characters));        
                return false;       
            }       
            return true;               
        } else {
            zipcode = zipcode.replaceAll('[^0-9]', '');     
            if(zipcode.length()<5 || zipcode.length()>9){       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Postcode_must_be_between_5_and_9_numeric_digits_in_length));       
                return false;       
            }       
            if(zipcode.length()>5) {     
                zipcode = zipcode.substring(0, 5) + '-' + zipcode.substring(5, zipcode.length());       
            }
            return true;
        } 
    }

    public String nameFormat (String name) {
        String result = '';
        if (name != null && name != '') {
            for (String iter : name.split('[ ]+')) {
                if (iter != null && iter != '') {
                    if (iter.length() > 1) {
                        result += iter.substring(0,1).toUpperCase() + iter.substring(1,iter.length()) + ' ';
                    }else {
                        result += iter.substring(0,1).toUpperCase() + ' ';
                    }
                }
            }
            result = result.substring(0, result.length() - 1);
        }
        return result;
    } 

    public void applyCaseAssignRule(){
        //Fetching the assignment rules on case
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            //Setting the DMLOption on Case instance
            newCase.setOptions(dmlOpts);
    }
}