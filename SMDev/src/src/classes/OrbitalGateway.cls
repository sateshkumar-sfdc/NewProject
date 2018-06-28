public with sharing class OrbitalGateway {
	
	//misc settings and variables
	private static final Credit_Card_Settings__c creditCardSettings = Credit_Card_Settings__c.getOrgDefaults();
	public static final Map<String,String> cardTypeVals = new Map<String,String>{'VISA' => 'VI', 'MC' => 'MC', 'AMEX' => 'AE', 'DISC' => 'DS'};
	private static String procStatus;
	private static String statusMsg;
	private static String profileProcStatus;
	private static String customerProfileMessage;
	
	//http request variables
	private static final String endPoint1 = 'https://orbital1.paymentech.net/authorize';
	private static final String endPoint2 = 'https://orbital2.paymentech.net/authorize';
	private static final String testEndPoint1 = 'https://orbitalvar1.paymentech.net/authorize';
	private static final String testEndPoint2 = 'https://orbitalvar2.paymentech.net/authorize';
	private static Integer defaultTimeOut = 30000; //30 seconds
	
	//http header variables
	private static final String mimeVersion = '1.1';
	private static final String contentType = 'application/PTI62';
	private static final String contentTransferEncoding = 'text';
	private static final String requestNumber = '1';
	private static final String documentType = 'Request';
	
	/*
	public static void authOnly(Credit_Card__c creditCard, Boolean addProfile) {
		
		//create new HttpRequest object with properties/header
		HttpRequest req = new HttpRequest();
		
		String xml = OrbitalGateway.authOnlyXML(creditCard, addProfile);		
		system.debug(xml);
		
		if (!creditCardSettings.Test_Mode__c) {
			req.setEndpoint(OrbitalGateway.endPoint1);
		}
		else {
			req.setEndpoint(OrbitalGateway.testEndPoint1);
		}
		
		req.setMethod('POST');
		req.setBody(xml);
		req.setTimeout(OrbitalGateway.defaultTimeOut);		
		
		req.setHeader('MIME-Version', mimeVersion);
		req.setHeader('Content-type', contentType);
		req.setHeader('Content-length', String.valueOf(req.getBody().length()));
		req.setHeader('Content-transfer-encoding', contentTransferEncoding);
		req.setHeader('Request-number', requestNumber);
		req.setHeader('Document-type', documentType);
		
		//create new http object and send request
		Http http = new Http();
		HTTPResponse res = http.send(req);
		System.debug(res.getBody());
		
	}*/
	
	public static String profileRequest(Credit_Card__c creditCard, String modType, String accountUpdater) {
		
		String result = 'success';
		String xml = OrbitalGateway.profileXML(creditCard, modType, accountUpdater);
		system.debug(xml);
		
		//create new HttpRequest object with properties/header
		HttpRequest req = setupHttpReq(xml);
		
		//create new http object and send request
		Http http = new Http();
		HTTPResponse res = http.send(req);
		System.debug(res.getBody());
		
		//web service not accessible, fail over
		if(res.getStatusCode() <> 200) {
			if (!creditCardSettings.Test_Mode__c) {
				req.setEndpoint(OrbitalGateway.endPoint2);
			}
			else {
				req.setEndpoint(OrbitalGateway.testEndPoint2);
			}
			
			res = http.send(req);
			
			if(res.getStatusCode() <> 200) {
				result = res.getStatus();
			}
		}
		
		if (result == 'success') {
			getResult(creditCard, res.getBody());
			
			//quick response error
			if (procStatus <> null && procStatus <> '0') {
				result = statusMsg;
			}
			//profile service success
			else if (ProfileProcStatus == '0') {
				result = 'success';
			}
			//profile service error
			else {
				result = CustomerProfileMessage;
			}
		}
		
		
		return result;
		
	}
	
	private static HttpRequest setupHttpReq(String xml) {
		
		HttpRequest req = new HttpRequest();
		
		if (!creditCardSettings.Test_Mode__c) {
			req.setEndpoint(OrbitalGateway.endPoint1);
		}
		else {
			req.setEndpoint(OrbitalGateway.testEndPoint1);
		}
		
		req.setMethod('POST');
		req.setBody(xml);
		req.setTimeout(OrbitalGateway.defaultTimeOut);		
		
		req.setHeader('MIME-Version', mimeVersion);
		req.setHeader('Content-type', contentType);
		req.setHeader('Content-length', String.valueOf(req.getBody().length()));
		req.setHeader('Content-transfer-encoding', contentTransferEncoding);
		req.setHeader('Request-number', requestNumber);
		req.setHeader('Document-type', documentType);
		
		return req;
		
	}
	
	private static string profileXML(Credit_Card__c creditCard, String modType, String accountUpdater) {
		
		String customerRefNum = creditCard.Chase_Profile_Id__c;
		String address1 = creditCard.Address1__c;
		String address2 = creditCard.Address2__c;
		String city = creditCard.City__c;
		String state = creditCard.State__c;
		String zip = creditCard.Zip__c;
		String email = creditCard.Email__c;
		String phone = creditCard.Phone__c;
		String country = creditCard.Country__c;
		String status = 'A';
		
		/*
		if (!creditCard.Active__c) {
			status = 'I';
		}*/
		
		//change null values to blank values  for create and read calls
		if (modType == 'C' || modType == 'R') {
			if (String.isBlank(address1)) {
				address1 = '';
			}
			if (String.isBlank(address2)) {
				address2 = '';
			}
			if (String.isBlank(city)) {
				city = '';
			}
			if (String.isBlank(state)) {
				state = '';
			}
			if (String.isBlank(zip)) {
				zip = '';
			}
			if (String.isBlank(email)) {
				email = '';
			}
			if (String.isBlank(phone)) {
				phone = '';
			}
			if (String.isBlank(country)) {
				country = '';
			}
		}
		//change null values to ~ to clear value in update call
		else if (modType == 'U') {
			if (String.isBlank(address2)) {
				address2 = '~';
			}
			if (String.isBlank(state)) {
				state = '~';
			}
			if (String.isBlank(email)) {
				email = '~';
			}
			if (String.isBlank(phone)) {
				phone = '~';
			}
		}
		
		Dom.Document doc = new Dom.Document();
		Dom.XmlNode Request = doc.createRootElement('Request', null, null);
		Dom.XmlNode ProfileElement = request.addChildElement('Profile', null, null);
		
		ProfileElement.addChildElement('OrbitalConnectionUsername', null, null).addTextNode(OrbitalGateway.creditCardSettings.Orbital_Gateway_Username__c);
		ProfileElement.addChildElement('OrbitalConnectionPassword', null, null).addTextNode(OrbitalGateway.creditCardSettings.Orbital_Gateway_Password__c);
		ProfileElement.addChildElement('CustomerBin', null, null).addTextNode('000001');
		ProfileElement.addChildElement('CustomerMerchantID', null, null).addTextNode(OrbitalGateway.creditCardSettings.Orbital_Gateway_Merchant_Id__c);
		ProfileElement.addChildElement('CustomerName', null, null).addTextNode(creditCard.Credit_Card_Name__c);
		
		if (modType <> 'C') {
			ProfileElement.addChildElement('CustomerRefNum', null, null).addTextNode(customerRefNum);
		}
		
		ProfileElement.addChildElement('CustomerAddress1', null, null).addTextNode(address1);
		ProfileElement.addChildElement('CustomerAddress2', null, null).addTextNode(address2);
		ProfileElement.addChildElement('CustomerCity', null, null).addTextNode(city);
		ProfileElement.addChildElement('CustomerState', null, null).addTextNode(state);
		ProfileElement.addChildElement('CustomerZIP', null, null).addTextNode(zip);
		ProfileElement.addChildElement('CustomerEmail', null, null).addTextNode(email);
		ProfileElement.addChildElement('CustomerPhone', null, null).addTextNode(phone);
		ProfileElement.addChildElement('CustomerCountryCode', null, null).addTextNode(country);
		ProfileElement.addChildElement('CustomerProfileAction', null, null).addTextNode(modType);		
		ProfileElement.addChildElement('CustomerProfileOrderOverrideInd', null, null).addTextNode('NO');
		ProfileElement.addChildElement('CustomerProfileFromOrderInd', null, null).addTextNode('A');
		ProfileElement.addChildElement('CustomerAccountType', null, null).addTextNode('CC');
		
		if (modType == 'C') {
			ProfileElement.addChildElement('Status', null, null).addTextNode(status);
			ProfileElement.addChildElement('CCAccountNum', null, null).addTextNode(creditCard.Credit_Card_Number__c);
		}
		
		ProfileElement.addChildElement('CCExpireDate', null, null).addTextNode(creditCard.Expiration_Month__c + creditCard.Expiration_Year__c.right(2));
		ProfileElement.addChildElement('AccountUpdaterEligibility', null, null).addTextNode(accountUpdater);
		
		return doc.toXmlString();
		
	}
	
	/*
	private static string authOnlyXML(Credit_Card__c creditCard, Boolean addProfile) {
		
		String accountUpdater;
		
		
		//prep data
		if (addProfile) {
			accountUpdater = 'Y';
		}
		else {
			accountUpdater = 'N';
		}
		
		if (String.isBlank(creditCard.Address2__c)) {
			creditCard.Address2__c = '';
		}
		
		if (String.isBlank(creditCard.Phone__c)) {
			creditCard.Phone__c = '';
		}
		
		Dom.Document doc = new Dom.Document();
		Dom.XmlNode Request = doc.createRootElement('Request', null, null);
		Dom.XmlNode NewOrder = request.addChildElement('NewOrder', null, null);
		
		NewOrder.addChildElement('OrbitalConnectionUsername', null, null).addTextNode(OrbitalGateway.creditCardSettings.Orbital_Gateway_Username__c);
		NewOrder.addChildElement('OrbitalConnectionPassword', null, null).addTextNode(OrbitalGateway.creditCardSettings.Orbital_Gateway_Password__c);
		NewOrder.addChildElement('IndustryType', null, null).addTextNode('EC');
		NewOrder.addChildElement('MessageType', null, null).addTextNode('A');
		NewOrder.addChildElement('BIN', null, null).addTextNode('000001');
		NewOrder.addChildElement('MerchantID', null, null).addTextNode(OrbitalGateway.creditCardSettings.Orbital_Gateway_Merchant_Id__c);
		NewOrder.addChildElement('TerminalID', null, null).addTextNode('001');
		NewOrder.addChildElement('CardBrand', null, null).addTextNode(cardTypeVals.get(creditCard.Credit_Card_Type__c));
		NewOrder.addChildElement('AccountNum', null, null).addTextNode(creditCard.Credit_Card_Number__c);
		NewOrder.addChildElement('Exp', null, null).addTextNode(creditCard.Expiration_Month__c + creditCard.Expiration_Year__c.right(2));
		NewOrder.addChildElement('CurrencyCode', null, null).addTextNode('840'); //USD only
		NewOrder.addChildElement('CurrencyExponent', null, null).addTextNode('2'); //USD only
		//NewOrder.addChildElement('CardSecValInd', null, null).addTextNode('1'); //remove for AE and MC?
		//NewOrder.addChildElement('CardSecVal', null, null).addTextNode(String.valueOf(creditCard.Security_Code__c));
		NewOrder.addChildElement('AVSzip', null, null).addTextNode(creditCard.Zip__c);	
		NewOrder.addChildElement('AVSaddress1', null, null).addTextNode(creditCard.Address1__c);
		NewOrder.addChildElement('AVSaddress2', null, null).addTextNode(creditCard.Address2__c);
		NewOrder.addChildElement('AVScity', null, null).addTextNode(creditCard.City__c);
		NewOrder.addChildElement('AVSstate', null, null).addTextNode(creditCard.State__c);		
		NewOrder.addChildElement('AVSphoneNum', null, null).addTextNode(creditCard.Phone__c);
		NewOrder.addChildElement('AVSname', null, null).addTextNode(creditCard.Credit_Card_Name__c);
		NewOrder.addChildElement('CustomerProfileFromOrderInd', null, null).addTextNode('A');
		NewOrder.addChildElement('CustomerProfileOrderOverrideInd', null, null).addTextNode('NO');
		NewOrder.addChildElement('Status', null, null).addTextNode('A');
		NewOrder.addChildElement('OrderID', null, null).addTextNode('12345678'); //update with what?
		NewOrder.addChildElement('Amount', null, null).addTextNode('0');
		NewOrder.addChildElement('AccountUpdaterEligibility', null, null).addTextNode(accountUpdater);
		
		return doc.toXmlString();
		
	}*/
	
	private static void getResult(Credit_Card__c creditCard, String xml) {

		DOM.Document doc = new DOM.Document();
		        
		doc.load(xml);   
		DOM.XMLNode root = doc.getRootElement();
		               
		// Parse the document
		parseNode(creditCard, root);
		
	}
	
	private static void parseNode(Credit_Card__c creditCard, DOM.XMLNode node)
    {
        String name  = '';
        String value = '';
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) 
        {
            name  = node.getName().toLowerCase();
            value = node.getText();
            
            //quick response status
            if (name == 'ProcStatus') {
                procStatus = value;
            }
            //quick response message
            else if (name == 'StatusMsg') {
                statusMsg = value;
            }
            else if (name == 'ProfileProcStatus') {
                profileProcStatus = value;
            }
            else if (name == 'CustomerProfileMessage') {
            	customerProfileMessage = value;
            }
            else if (name == 'CustomerRefNum') {
            	creditCard.Chase_Profile_Id__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerAddress1') {
            	creditCard.Address1__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerAddress2') {
            	creditCard.Address2__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerCity') {
            	creditCard.City__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerName') {
            	creditCard.Credit_Card_Name__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerEmail') {
            	creditCard.Email__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CCExpireDate') {
            	creditCard.Expiration_Month__c = value.left(2);
            	creditCard.Expiration_Year__c = '20' + value.right(2);
            }
            else if (profileProcStatus == '0' && name == 'CustomerPhone') {
            	creditCard.Phone__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerState') {
            	creditCard.State__c = value;
            }
            else if (profileProcStatus == '0' && name == 'CustomerZIP') {
            	creditCard.Zip__c = value;
            }
            
            else if (profileProcStatus == '0' && name == 'CustomerCountryCode') {
            	creditCard.Country__c = value;
            }/*
            else if (profileProcStatus == '0' && name == 'Status') {
            	if (value == 'A') {
            		creditCard.Active__c = true;
            	}
            	else {
            		creditCard.Active__c = false;
            	}
            }*/
            
            for (Dom.XMLNode child: node.getChildElements()) 
            {
               parseNode(creditCard, child);
            }
        }
    }
	
	/*
	public class result {
		
		String status;
		String message;
		
		public void result(String procStatus, String procMsg) {
			
			this.status = procStatus;
			this.message = procMsg;
			
		}
		
	}*/

}