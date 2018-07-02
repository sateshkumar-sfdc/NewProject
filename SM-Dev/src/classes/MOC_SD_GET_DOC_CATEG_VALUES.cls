/// enosiX Inc. Generated Apex Model
/// Generated On: 12/8/2016 5:21:34 PM
/// SAP Host: 10.0.1.235
/// CID: S4H

@isTest
public class MOC_SD_GET_DOC_CATEG_VALUES
{
	public class MockSuccess implements ensx.EnosixFramework.RFCMock
	{
		public ensx.EnosixFramework.FunctionObject executeFunction() 
		{
			RFC_SD_GET_DOC_CATEG_VALUES.RESULT funcObj = new RFC_SD_GET_DOC_CATEG_VALUES.RESULT();

			RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES et_valuesField = new RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES();

					et_valuesField.VBTYP = 'X';
		et_valuesField.VBTYP_TEXT = 'X';
				
			funcObj.getCollection(RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class).add(et_valuesField);


			funcObj.setSuccess(true);

			return funcObj;
        }
	}

	public class MockRFC_SD_GET_DOC_CATEG_VALUESFailure implements ensx.EnosixFramework.RFCMock
	{
		public ensx.EnosixFramework.FunctionObject executeFunction() 
		{
			RFC_SD_GET_DOC_CATEG_VALUES.RESULT funcObj = new RFC_SD_GET_DOC_CATEG_VALUES.RESULT();

							RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES et_valuesField = new RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES();

						et_valuesField.VBTYP = 'X';
		et_valuesField.VBTYP_TEXT = 'X';
				funcObj.getCollection(RFC_SD_GET_DOC_CATEG_VALUES.ET_VALUES.class).add(et_valuesField);

			
			funcObj.setSuccess(false);

			return funcObj;
        }
	}
}