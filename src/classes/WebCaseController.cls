/*
Name                WebCaseController
Created By          Nitish Bansal
Created Date        03/02/2016
Purpose             T-481231, T-482284; T-482543; T-482556
*/
public class WebCaseController {
    // the contact record you are adding values to
    public Case newcase {
        get {
          if (newcase == null)
            newcase = new Case();
          return newcase;
        }
        set;
    }
    public String documentId{get;set;}
    public Document doc{get;set;}
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
    public String organisationVal{get;set;}
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
    public List<SelectOption> listNumberOfCoolers {
        get{
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Case.Number_of_Coolers__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple) {
                options.add(new SelectOption(f.getValue(), f.getValue()));
            }
            return options;
        }
        set;
    }
  /*  public List<SelectOption> listInterests {
        get{
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Case.Interests__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple) {
                options.add(new SelectOption(f.getValue(), f.getValue()));
            }
            return options;
        }
        set;
    }
    public String selectedValues{get;
            //Parsing the Selected Multi-picklist value in a form which can be saved in the Obejct
            //When inserting/updating a record
            set{
                selectedValues = value.replace(',',';');
                selectedValues = selectedValues.replace('[','');
                selectedValues = selectedValues.replace(']','');
            }}
    */        
    public List<SelectOption> listWebForms {get;set;}
    public List<SelectOption> listPrograms {get;set;}
    public String selectedForm {get;set;}
    public Boolean attachRequired {get;set;}
    public String coolerNumber {get;set;}
    public String emailConfirmation {get;set;}
    public String empRelationship {get;set;}
    public String emailConfirmationYourEmail {get;set;}
    
    private static final Pattern zipCodePattern = Pattern.compile('^[A-Za-z]{1}\\d{1}[A-Za-z]{1} *\\d{1}[A-Za-z]{1}\\d{1}$'); 
    public String CURRENT_DATE_TIME{get;set;}

    //constructor
    public WebCaseController() {
        doc = new Document();
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
        

        //Web form names - T-482556
        listWebForms = new List<SelectOption>();
        listWebForms.add(new SelectOption(label.Request_Catalog_Sticker_Form, label.Request_Catalog_Sticker_Form));
        listWebForms.add(new SelectOption(label.Sponsorship_Marketing_Requests_Form, label.Sponsorship_Marketing_Requests_Form));
        listWebForms.add(new SelectOption(label.Return_Warranty_Request_Form, label.Return_Warranty_Request_Form));
        listWebForms.add(new SelectOption(label.Friends_Family_Purchase_Program_Request_Form, label.Friends_Family_Purchase_Program_Request_Form));
        listWebForms.add(new SelectOption(label.Supplier_Vendor_Application_Form, label.Supplier_Vendor_Application_Form));
        listWebForms.add(new SelectOption(label.Dealer_Employee_Purchase_Program_Request_Form, label.Dealer_Employee_Purchase_Program_Request_Form));
        listWebForms.add(new SelectOption(label.Industry_Program_Request_Form, label.Industry_Program_Request_Form));
        listWebForms.add(new SelectOption(label.Custom_Logo_Request_Form, label.Custom_Logo_Request_Form));
                        
        selectedForm = listWebForms.get(0).getLabel();

        attachRequired = true;
    }

    //NB - T-482556 - 03/04 - To open selected form page from sites home page
    public PageReference openForm(){
        if(selectedForm == label.Request_Catalog_Sticker_Form){
            return Page.RequestStickerWebPage;
        } else if(selectedForm == label.Sponsorship_Marketing_Requests_Form){
            return Page.SponsorshipMarketingRequestForm;
        } else if(selectedForm == label.Return_Warranty_Request_Form){
            return Page.WarrantyRequestForm;
        } else if(selectedForm == label.Friends_Family_Purchase_Program_Request_Form){
            return Page.FriendsFamilyPurchaseProgramRequest;
        } else if(selectedForm == label.Supplier_Vendor_Application_Form){
            return Page.YetiSupplierVendorForm;
        } else if(selectedForm == label.Dealer_Employee_Purchase_Program_Request_Form){
            return Page.DealerEmpForm;
        } else if(selectedForm == label.Industry_Program_Request_Form){
            return Page.IndustryProgramForm;
        } else if(selectedForm == label.Custom_Logo_Request_Form){
            return Page.CustomLogoForm;
        }       
        return null;
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
    }

    // T-482543 - NB - 03/04 - Save/Submit - Catalogue Request Web Form
    public PageReference saveStickerRequest() {
        Boolean error = false;
        //Apex Validations
        if(streetLine1 == null || streetLine1 == '' || !(streetLine1.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Street_Address)); 
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Please_enter_a_valid_email_address)); 
            error = true;
        }
        if(emailConfirmation != email){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Email_Address_Mismatch)); 
            error = true;
        } 
        if(error){
            return null;
        } else {
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
            //newcase.Interests__c = selectedValues;
            newcase.Reason = 'Other';
            newcase.Subject = 'Catalogue/Sticker Request';
            newcase.Description = 'A new catalogue/sticker request has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + email + '\r\n' + nameFormat(Label.FIRST_NAME.toLowerCase()) + ' : ' + firstName + '\r\n' + nameFormat(Label.LAST_NAME.toLowerCase()) + ' : ' + lastName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.STREET_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n' + nameFormat(Label.ADDRESS_LINE_2.toLowerCase()) + ' : ' + streetLine2 + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CITY.toLowerCase()) + ' : ' + city + '\r\n' + nameFormat(Label.STATE.toLowerCase()) + ' : ' + state + '\r\n' +  nameFormat(Label.ZIP.toLowerCase()) + ' : ' + zipcode;
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Outfitter' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            if(newcase.Requsting_Item__c == 'Catalog'){
                return Page.CatalogConfirmationPage;
            } else {
                return Page.StickerConfirmationPage;
            }
             
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
          return null;
        }
    }

    //T-482284 - NB - 03/03 - Save method - Marketing Request Form
    public PageReference saveSponsorship(){
        Boolean error = false;
        //apex validations
        if(firstName == null || firstName == '' || !(firstName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_First_Name)); 
            error = true;
        }
        if(organisationVal == null || organisationVal == '' || !(organisationVal.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Please_enter_the_Organisation)); 
            error = true;
        }
        if(phoneNumber != null && phoneNumber != '' && (phoneNumber.length() > 0) && !(Pattern.matches('(\\d){10}', phoneNumber) || Pattern.matches('\\D*?(\\d\\D*?){10}', phoneNumber))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_10_digit_phone_number)); 
            error = true;
        }
        if(email == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Please_enter_a_valid_email_address)); 
            error = true;
        } 
        if(error){
            if(!attachRequired){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, Label.Attachment_Uploaded_No_need_to_reattach_the_file)); 
            }
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
        //creating case with form data
        try{
            newcase.Reason = 'Promotional';
            newcase.Subject = 'Marketing Request';
            newcase.Description = 'A new marketing request has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.FIRST_NAME.toLowerCase()) + ' : ' + firstName + '\r\n' + nameFormat(Label.LAST_NAME.toLowerCase()) + ' : ' + lastName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.PHONE.toLowerCase()) + ' : ' + formatphonenumber(phoneNumber) + '\r\n' + nameFormat(Label.ORGANIZATION.toLowerCase()) + ' : ' + organisationVal  + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + email + '\r\n';  
            newcase.Description = newcase.Description + Schema.Case.fields.Name_of_Event__c.getDescribe().getLabel() + ' : ' + newcase.Name_of_Event__c + '\r\n';
            newcase.Description = newcase.Description + Schema.Case.fields.Estimated_Cost__c.getDescribe().getLabel()+ ' :' + newcase.Estimated_Cost__c;
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
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
            return null;
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

    //T-482551 - NB - 03/04 - Save method - Warranty Request Form
    public PageReference saveWarrantyRequest(){
        Boolean error = false;
        //apex validations
        if(firstName == null || firstName == '' || !(firstName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Name)); 
            error = true;
        }
        if(phoneNumber == null || !(Pattern.matches('(\\d){10}', phoneNumber) || Pattern.matches('\\D*?(\\d\\D*?){10}', phoneNumber))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_10_digit_phone_number)); 
            error = true;
        }
        if(streetLine1 == null || streetLine1 == '' || !(streetLine1.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Shipping_Address)); 
            error = true;
        }
        if(email == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Please_enter_a_valid_email_address)); 
            error = true;
        } 
        if(error){
            if(!attachRequired){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, Label.Attachment_Uploaded_No_need_to_reattach_the_file)); 
            }
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
        //creating case with form data
        try{
            newcase.Reason = 'Return/Warranty';
            newcase.Subject = 'Warranty Request';
            newcase.Description = 'A new warranty request has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.FIRST_AND_LAST_NAME.toLowerCase()) + ' : ' + firstName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + email + '\r\n';  
            newcase.Description = newcase.Description + nameFormat(Label.PHONE_NUMBER.toLowerCase()) + ' : ' + formatphonenumber(phoneNumber) + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.SHIPPING_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n'; 
            newcase.Description = newcase.Description + nameFormat(Label.REASON_FOR_REQUESTING_WARRANTY_CLAIM.toLowerCase()) + ' : ' + newcase.ReasonWeb__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.LOCATION_OF_PURCHASE.toLowerCase()) + ' : ' + newcase.Purchase_Location__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.DATE_OF_PURCHASE_OR_YEARS_OWNED.toLowerCase()) + ' : ' + newcase.Date_Purchase_Years_Owned__c + '\r\n';
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Outfitter' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            //attachment is required.
            if(doc.body == null && attachRequired) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Please_choose_file_before_save));
                return null;
            }
            insertDoc();
            showAttachment();
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            createAttachment();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            return Page.ConfirmationMessagePage;
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
            return null;
        }
    }

    //Nitish Bansal - 03/07/2016 - T-482949
    public PageReference saveFamilyProgramRequest(){
        Boolean error = false;
        //apex validations
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
        if(email == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Please_enter_a_valid_email_address)); 
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
        if(newcase.Employee_Email_Address__c == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', newcase.Employee_Email_Address__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_valid_email_address_of_Yeti_Employee)); 
            error = true;
        }
        if(emailConfirmation != newcase.Employee_Email_Address__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Email_Address_Mismatch)); 
            error = true;
        }
        if(empRelationship == null || empRelationship == '' || !(empRelationship.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_relation_to_Yeti_Employee)); 
            error = true;
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
            email = newcase.Employee_Email_Address__c;
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
            newcase.Reason = 'Inquiry';
            newcase.Subject = 'Friends/Family Purchase Program Request';
            newcase.Description = 'A new  friends/family purchase program reques has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.FIRST_NAME.toLowerCase()) + ' : ' + firstName + '\r\n' + nameFormat(Label.LAST_NAME.toLowerCase()) + ' : ' + lastName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + email + '\r\n' + nameFormat(Label.PHONE_NUMBER.toLowerCase()) + ' : ' + phoneNumber + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.STREET_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n' + nameFormat(Label.ADDRESS_LINE_2.toLowerCase()) + ' : ' + streetLine2 + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CITY.toLowerCase()) + ' : ' + city + '\r\n' + nameFormat(Label.STATE.toLowerCase()) + ' : ' + state + '\r\n' +  nameFormat(Label.ZIP_CODE.toLowerCase()) + ' : ' + zipcode + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMPLOYEE_FIRST_NAME.toLowerCase()) + ' : ' + newcase.Employee_First_Name__c + '\r\n' + nameFormat(Label.EMPLOYEE_LAST_NAME.toLowerCase()) + ' : ' + newcase.Employee_Last_Name__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL_ADDRESS_OF_YETI_EMPLOYEE.toLowerCase()) + ' : ' + newcase.Employee_Email_Address__c + '\r\n' + nameFormat(Label.RELATION_TO_YETI_EMPLOYEE.toLowerCase()) + ' : ' + empRelationship;
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Outfitter' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            return Page.ConfirmationMessagePage;
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
          return null;
        }
    }

    //NB - T-482943 - Save method for YetiSupplierVendor
    public PageReference saveSupplierVendorForm(){
        Boolean error = false;
        //apex validations
        if(firstName == null || firstName == '' || !(firstName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_First_Name)); 
            error = true;
        }
        if(lastName == null || lastName == '' || !(lastName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_Last_Name)); 
            error = true;
        }
        if(phoneNumber == null || !(Pattern.matches('(\\d){10}', phoneNumber) || Pattern.matches('\\D*?(\\d\\D*?){10}', phoneNumber))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_10_digit_phone_number)); 
            error = true;
        }
        if(streetLine1 == null || streetLine1 == '' || !(streetLine1.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_Shipping_Address)); 
            error = true;
        }
        if(email == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Please_enter_a_valid_email_address)); 
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
        if(emailConfirmation != email){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Email_Address_Mismatch)); 
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
        //creating case with form data
        try{
            newcase.Reason = 'Inquiry';
            newcase.Subject = 'Vendor/Supplier Purchase Program Request';
            newcase.Description = 'A new vendor/supplier purchase program request has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.FIRST_NAME.toLowerCase()) + ' : ' + firstName + '\r\n' + nameFormat(Label.LAST_NAME.toLowerCase()) + ' : ' + lastName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.STREET_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n' + nameFormat(Label.ADDRESS_LINE_2.toLowerCase()) + ' : ' + streetLine2 + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CITY.toLowerCase()) + ' : ' + city + '\r\n' + nameFormat(Label.STATE_PROVINCE_REGION.toLowerCase()) + ' : ' + state + '\r\n' +  nameFormat(Label.ZIP_POSTAL_CODE.toLowerCase()) + ' : ' + zipcode + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.COUNTRY.toLowerCase()) + ' : ' + newcase.Country__c + '\r\n' + nameFormat(Label.PHONE_NUMBER.toLowerCase()) + ' : ' + phoneNumber + '\r\n';    
            newcase.Description = newcase.Description + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + email + '\r\n' + nameFormat(Label.EMPLOYEE_IDENTIFICATION_NUMBER_EMPLOYEE_ID.toLowerCase()) + ' : ' + newcase.Employee_ID__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.COMPANY.toLowerCase()) + ' : ' + newcase.CompanyPicklist__c;
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Outfitter' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            //attachment is required.
          /*  if(doc.body == null && attachRequired) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Please_choose_file_before_save));
                return null;
            }*/
            insertDoc();
            showAttachment();
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            createAttachment();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            return Page.ConfirmationMessagePage;
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
            return null;
        }
    }

    //NB - T-482942 - 03/07 - Save for Dealer Employee Form
    public PageReference saveDealerEmpForm(){
        Boolean error = false;
        if(phoneNumber == null || !(Pattern.matches('(\\d){10}', phoneNumber) || Pattern.matches('\\D*?(\\d\\D*?){10}', phoneNumber))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_10_digit_phone_number)); 
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
        if(newcase.Employee_Email_Address__c == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', newcase.Employee_Email_Address__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_email_address)); 
            error = true;
        }
        if(emailConfirmation != newcase.Manager_Email__c || emailConfirmationYourEmail != newcase.Employee_Email_Address__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Email_Address_Mismatch)); 
            error = true;
        }
        if(error){
            return null;
        }
        else {
            //Populating case contact and account lookup fields
            email = newcase.Employee_Email_Address__c;
            if(email != null && email != ''){
                for(Contact con : [Select Id, AccountId From Contact where Email =:email]){
                    newcase.ContactId = con.Id;
                    newcase.AccountId = con.AccountId;
                    break;
                }
            }
        }
        //creating case with form data
        try{
            newcase.Reason = 'Inquiry';
            newcase.Subject = 'Dealer Employee Purchase Program Request';
            newcase.Description = 'A new dealer employee purchase program request has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMPLOYEE_FIRST_NAME_YOUR_NAME.toLowerCase()) + ' : ' + newcase.Employee_First_Name__c + '\r\n' + nameFormat(Label.EMPLOYEE_S_LAST_NAME.toLowerCase())+ ' : ' + newcase.Employee_Last_Name__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.EMPLOYEE_S_EMAIL_YOUR_EMAIL.toLowerCase()) + ' : ' + newcase.Employee_Email_Address__c + '\r\n' + nameFormat(Label.EMPLOYEE_IDENTIFICATION_NUMBER_EMPLOYEE_ID.toLowerCase()) + ' : ' + newcase.Employee_ID__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.PHONE_NUMBER.toLowerCase()) + ' : ' + phoneNumber + '\r\n' + nameFormat(Label.MANAGER_S_FIRST_NAME.toLowerCase()) + ' : ' + newcase.Manager_First_Name__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.MANAGER_S_LAST_NAME.toLowerCase()) + ' : ' + newcase.Manager_Last_Name__c + '\r\n' + nameFormat(Label.MANAGER_S_EMAIL.toLowerCase()) + ' : ' + newcase.Manager_Email__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.DEALER_STORE_NAME_STORE_YOU_WORK_AT.toLowerCase()) + ' : ' + newcase.Store_Name__c + '\r\n' + nameFormat(Label.STORE_S_PHONE_NUMBER.toLowerCase()) + ' : ' + newcase.Store_Phone_Number__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.STREET_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n' + nameFormat(Label.ADDRESS_LINE_2.toLowerCase()) + ' : ' + streetLine2 + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CITY.toLowerCase()) + ' : ' + city + '\r\n' + nameFormat(Label.STATE_PROVINCE_REGION.toLowerCase()) + ' : ' + state + '\r\n' +  nameFormat(Label.ZIP_POSTAL_CODE.toLowerCase()) + ' : ' + zipcode + '\r\n';
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Outfitter' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            return Page.ConfirmationMessagePage;
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
            return null;
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

   //NB - 03/10 - T-483901
    public PageReference saveCustomLogo(){
        Boolean error = false;
        if(organisationVal == null || organisationVal == '' || !(organisationVal.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_Company_Name)); 
            error = true;
        }
        if(firstName == null || firstName == '' || !(firstName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_First_Name)); 
            error = true;
        }
        if(lastName == null || lastName == '' || !(lastName.length() > 0)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_the_Last_Name)); 
            error = true;
        }
        if(phoneNumber == null || !(Pattern.matches('(\\d){10}', phoneNumber) || Pattern.matches('\\D*?(\\d\\D*?){10}', phoneNumber))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_10_digit_phone_number)); 
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
        if(newcase.Web_Form_Email__c == null || !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', newcase.Web_Form_Email__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Please_enter_a_valid_email_address)); 
            error = true;
        }
        if(emailConfirmation != newcase.Web_Form_Email__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, label.Email_Address_Mismatch)); 
            error = true;
        }
        if(error){
            return null;
        }
        else {
            //Populating case contact and account lookup fields
            email = newcase.Web_Form_Email__c;
            if(email != null && email != ''){
                for(Contact con : [Select Id, AccountId From Contact where Email =:email]){
                    newcase.ContactId = con.Id;
                    newcase.AccountId = con.AccountId;
                    break;
                }
            }
        }
       //creating case with form data
        try{
            newcase.Number_of_Coolers__c = coolerNumber;
            newcase.RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Custom Logo').getRecordTypeId();
            newcase.Reason = 'Inquiry';
            newcase.Subject = 'Custom Logo Request';
            newcase.Type = 'Custom Logo';
            newcase.Description = 'A new custom logo request has been submitted via a web form.' + '\r\n' + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.COMPANY_NAME_OR_OTHER.toLowerCase()) + ' : ' + organisationVal + '\r\n' + nameFormat(Label.CONTACT_PERSON_S_FIRST_NAME.toLowerCase())+ ' : ' + firstName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CONTACT_PERSON_S_LAST_NAME.toLowerCase()) + ' : ' + lastName + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.STREET_ADDRESS.toLowerCase()) + ' : ' + streetLine1 + '\r\n' + nameFormat(Label.ADDRESS_LINE_2.toLowerCase()) + ' : ' + streetLine2 + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.CITY.toLowerCase()) + ' : ' + city + '\r\n' + nameFormat(Label.STATE.toLowerCase()) + ' : ' + state + '\r\n' +  nameFormat(Label.ZIP_CODE.toLowerCase()) + ' : ' + zipcode + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.PHONE.toLowerCase()) + ' : ' + phoneNumber + '\r\n' + nameFormat(Label.EMAIL.toLowerCase()) + ' : ' + newcase.Web_Form_Email__c + '\r\n';
            newcase.Description = newcase.Description + nameFormat(Label.COMMENTS.toLowerCase()) + ' : ' + empRelationship + '\r\n';
                
            List<Group> gropuList = [Select Id, Name from Group where Name = 'Custom Logo' and Type = 'Queue'];
            if(gropuList.size() > 0){
                newcase.OwnerId = gropuList.get(0).Id;  
            }
            
            applyCaseAssignRule();
            insert newcase; // inserts the new record into the database
            newCaseId = newcase.Id;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Case_Successfully_Created));
            return Page.ConfirmationMessagePage;
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_creating_new_case));
            return null;
        }
    }

    //assignmnet rule
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
    
    //Multi-select picklist to checkboxes
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
   
    //get the multi-select pick list values
    public List<SelectOption> MultiSelectPicklistOptions {
     get {
       List<SelectOption> options = new List<SelectOption>();
       for( String picklistVal : getPicklistValues('Case', 'Interests__c')) {
         options.add(new SelectOption(picklistVal, picklistVal));
        } 
       return options;
     }  
     set;
    } 
    
    //get and set the multi-select pick list as checkboxes
    public String[] MPCheckBoxItems { 
     get {
        String[] selectedValues = new List<String>();
        List<SelectOption> sos = this.MultiSelectPicklistOptions;
        for(SelectOption s : sos) {
        if (newcase.Interests__c !=null && newcase.Interests__c.contains(s.getValue()))
           selectedValues.add(s.getValue());
        }
        return selectedValues;
     }public set {
        String selectedValConcat = '';
        for(String s : value) {
         if (selectedValConcat == '') 
           selectedValConcat += s;
         else selectedValConcat += ';' + s;
        }
        newcase.Interests__c = selectedValConcat;
     }
   }

}