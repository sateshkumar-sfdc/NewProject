//
// (c) 2017 Appirio, Inc.
//
// Apex Controller Name: YETI_ExtractDataController
// For Lightning Components: YETI_DealerAccountDetails, YETI_RedirectUser
// Description: This apex controller class is used for the following functionalities -
//  1: Display dealer community user's account details.
//  2: Fetch account id for the currently logged-in partner community login user with profile named "Dealer - Corporate". 
//  3: Determine on which record do we need to navigate the dealer community user based on the record id passed as method parameter.
//
// 23th February 2017   Hemendra Singh Bhati   Original (Task # T-576269) - Please see the task description for more details.
// 28th March 2017      Hemendra Singh Bhati   Modified (Task # T-589425) - Please see the task description for more details.
// 03rd April 2017      Hemendra Singh Bhati   Modified (Task # T-590601) - Please see the task description for more details.
//
public with sharing class YETI_ExtractDataController {
  // Private Constants.
  // Public Data Members.

  // Private Data Members.
  private static Map<Integer, String> monthNames = new Map<Integer, String> {
    1 => 'January',
    2 => 'February',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'September',
    10 => 'October',
    11 => 'November',
    12 => 'December'
  };

  // Class Default Constructor.
  public YETI_ExtractDataController() {
  }

  /*
  @method      : getAccountId
  @description : This method is used to fetch account id for the currently logged-in partner community login user
                 with profile named "Dealer - Corporate".
  @params      : void
  @returns     : Id theAccountId
  */
  @AuraEnabled
  public static Id getAccountId() {
    return YETI_FunctionalUtility.getDealerCorporateUserAccountId();
  }

  /*
  @method      : getAccountDetails
  @description : This method is used to fetch logged-in community user's account details.
  @params      : void
  @returns     : Account theRecord
  */
  @AuraEnabled
  public static Account getAccountDetails() {
    Account theRecord = null;

    Id theAccountId = YETI_FunctionalUtility.getDealerCorporateUserAccountId();
    if(theAccountId != null) {
      for(Account theAccount : [SELECT Name, Phone, Website, Dealer_Status__c, ERP_Industry__c, Customer_Group__c, Customer_Number__c,
                                Limit__c, Credit_Exposure__c, Terms_and_Conditions__c, Inside_Rep_Email__c, Outside_Rep_Email__c,
                                Inside_Rep_Phone__c, Outside_Rep_Phone__c, Inside_SR_Name__c, Outside_SR_Name__c FROM Account WHERE Id = :theAccountId]) {
        theRecord = theAccount;
      }
    }
    return theRecord;
  }

  /*
  @method      : getRecordIdToRedirect
  @description : This method is used to determine on which record do we need to navigate the dealer community user based on
                 the record id passed as method parameter.
  @params      : Id theRecordId
  @returns     : Id recordIdToRedirect
  */
  @AuraEnabled
  public static Id getRecordIdToRedirect(Id theRecordId) {
    Id recordIdToRedirect = null;
    if(theRecordId != null) {
      String theSobjectName = theRecordId.getSObjectType().getDescribe().getName();
      if(theSobjectName == 'ProcessInstanceStep') {
        for(ProcessInstanceStep theStep : [SELECT ProcessInstance.TargetObjectId FROM ProcessInstanceStep WHERE Id = :theRecordId]) {
          recordIdToRedirect = theStep.ProcessInstance.TargetObjectId;
        }
      }
    }
    return recordIdToRedirect;
  }

  /*
  @method      : getAllCaseComments
  @description : This method is used to fetch all case comments associated with case record id passed as method parameter.
  @params      : Id theCaseId
  @returns     : List<CaseCommentsWrapper> caseComments
  */
  @AuraEnabled
  public static List<CaseCommentsWrapper> getAllCaseComments(Id theCaseId) {
    List<CaseCommentsWrapper> caseComments = new List<CaseCommentsWrapper>();
    if(theCaseId != null) {
      String theCreateDate = null;
      //IsPublished = true
      for(CaseComment theComment : [SELECT id,IsPublished,CommentBody, CreatedBy.Name, SystemModstamp FROM CaseComment WHERE ParentId = :theCaseId ORDER BY CreatedDate DESC]) {
        theCreateDate = monthNames.get(theComment.SystemModstamp.month()) + ' ' + theComment.SystemModstamp.day() + ', ' + theComment.SystemModstamp.year()
                        + ' at ' + theComment.SystemModstamp.hour() + ':' + theComment.SystemModstamp.minute();
                        string p=theComment.id+'-private';
                        if(thecomment.IsPublished)p=theComment.id+'-public';
        caseComments.add(new CaseCommentsWrapper(
        string.valueOf(theComment.id),
          theComment.CommentBody,
          theComment.CreatedBy.Name,
          theCreateDate,
          p
        ));
      }
    }
    return caseComments;
  }
  
   @AuraEnabled
  public static void saveCaseComment(string concatekey) {
      system.debug('AN:concatekey: '+concatekey);
      if(concatekey <> null && concatekey <> ''){
        string casecommentId = concatekey.split('-')[0];
        boolean ispublished;
        string key = concatekey.split('-')[1];
        if(key == 'public')ispublished=true;
        if(key == 'private')ispublished=false;
        casecomment cobj = [select Id,ispublished from CaseComment where id =: casecommentId];
        cobj.ispublished = ispublished;
        update cobj;
        system.debug('AN:Result: '+ispublished+'--'+cobj);
      }       
  }
  

  // Case Comments Wrapper Class.
  public class CaseCommentsWrapper {
    @AuraEnabled public String ccid;
    @AuraEnabled public String caseCommentBody;
    @AuraEnabled public String createByName;
    @AuraEnabled public String publish;
    @AuraEnabled public String createDate;

    public CaseCommentsWrapper(String cid,String theBody, String theName, String theCreateDate,String p) {
        ccid= cid;
      caseCommentBody = theBody;
      createByName = theName;
      createDate = theCreateDate;
      publish = p;
    }
  }

  /*
  @method      : changeUserPassword
  @description : This method is used to change user password.
  @params      : String currentPassword, String newPassword, String verifyNewPassword
  @returns     : void
  */
  @AuraEnabled
  public static void changeUserPassword(String currentPassword, String newPassword, String verifyNewPassword) {
    try {
      Site.changePassword(newPassword, verifyNewPassword, currentPassword);
    }
    catch(Exception e) {
      System.debug('TRACE: YETI_ExtractDataController - changeUserPassword - Exception Message - ' + e.getMessage());
      System.debug('TRACE: YETI_ExtractDataController - changeUserPassword - Exception Stack Trace - ' + e.getStackTraceString());

      throw new AuraHandledException(e.getMessage().replace('Error: ', ''));
    }
  }

  /*
  @method      : updateUserTimeZoneValue
  @description : This method is used to update timezone value selected by user.
  @params      : String theTimezoneValue
  @returns     : void
  */
  @AuraEnabled
  public static void updateUserTimeZoneValue(String theTimezoneValue) {
    try {
      update new User(
        Id = UserInfo.getUserId(),
        TimeZoneSidKey = theTimezoneValue
      );
    }
    catch(Exception e) {
      System.debug('TRACE: YETI_ExtractDataController - updateUserTimeZoneValue - Exception Message - ' + e.getMessage());
      System.debug('TRACE: YETI_ExtractDataController - updateUserTimeZoneValue - Exception Stack Trace - ' + e.getStackTraceString());

      throw new AuraHandledException('An internal error occurred while updating your timezone. Please contact your system administrator.');
    }
  }

 
  /*
  @method      : fetchUserData
  @description : This method is used to fetch user and contact information for the currently logged-in dealer community user.
  @params      : void
  @returns     : MyProfileWrapper theProfile
  */
  @AuraEnabled
  public static MyProfileWrapper fetchUserData() {
    // Extract user language codes with labels.
    Map<String, String> theLanguageCodesMap = new Map<String, String>();
    for(Schema.PicklistEntry thePicklistEntry : User.LanguageLocaleKey.getDescribe().getPicklistValues()) {
      theLanguageCodesMap.put(thePicklistEntry.getValue(), thePicklistEntry.getLabel());
    }

    // Extract user locale codes with labels.
    Map<String, String> theLocaleCodesMap = new Map<String, String>();
    for(Schema.PicklistEntry thePicklistEntry : User.LocaleSidKey.getDescribe().getPicklistValues()) {
      theLocaleCodesMap.put(thePicklistEntry.getValue(), thePicklistEntry.getLabel());
    }

    // Extract user timezone codes with labels.
    List<Map<String, String>> theTimezoneSelectOptions = new List<Map<String, String>>();
    for(Schema.PicklistEntry thePicklistEntry : User.TimeZoneSidKey.getDescribe().getPicklistValues()) {
      theTimezoneSelectOptions.add(new Map<String, String> {
        'value' => thePicklistEntry.getValue(),
        'label' => thePicklistEntry.getLabel()
      });
    }

    MyProfileWrapper theWrapper = null;
    for(User theUser : [SELECT Username, Email, LanguageLocaleKey, LocaleSidKey, TimeZoneSidKey, Contact.Account.Phone, Contact.Account.Fax,
                        Contact.Account.Website FROM User WHERE Id = :UserInfo.getUserId()]) {
      theWrapper = new MyProfileWrapper(
        theUser,
        theUser.Contact.Account.Phone,
        theUser.Contact.Account.Fax,
        theUser.Contact.Account.Website,
        theLanguageCodesMap.get(theUser.LanguageLocaleKey),
        theLocaleCodesMap.get(theUser.LocaleSidKey),
        theUser.TimeZoneSidKey,
        theTimezoneSelectOptions
      );
    }
    return theWrapper;
  }

  // My Profile Wrapper Class.
  public class MyProfileWrapper {
    @AuraEnabled public User theUserData;
    @AuraEnabled public String phoneNumber;
    @AuraEnabled public String faxNumber;
    @AuraEnabled public String website;
    @AuraEnabled public String userLanguage;
    @AuraEnabled public String userLocale;
    @AuraEnabled public String userTimezoneValue;
    @AuraEnabled public List<Map<String, String>> timezoneSelectOptions;

    public MyProfileWrapper(
      User theUserRecord,
      String thePhone,
      String theFax,
      String theWebsite,
      String theLanguage,
      String theLocale,
      String theTimezoneValue,
      List<Map<String, String>> theTimezoneSelectOptions
    ) {
      theUserData = theUserRecord;
      phoneNumber = thePhone;
      faxNumber = theFax;
      website = theWebsite;
      userLanguage = theLanguage;
      userLocale = theLocale;
      userTimezoneValue = theTimezoneValue;
      timezoneSelectOptions = theTimezoneSelectOptions;
    }
  }
}