// TODO: Fix SBO MOCs and regen this file
@isTest
public class MOC_EnosixCustomer_Detail
{
	public class MockEnosixCustomerSuccess implements ENSX.EnosixFramework.DetailSBOGetMock, ENSX.EnosixFramework.DetailSBOSaveMock, ENSX.EnosixFramework.DetailSBOCommandMock, ENSX.EnosixFramework.DetailSBOInitMock
	{
		public ENSX.EnosixFramework.DetailObject executeGetDetail(object obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(true);

			return result;
        }

        public ENSX.EnosixFramework.DetailObject executeSave(ENSX.EnosixFramework.DetailObject obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(true);

			return result;
        }

        public ENSX.EnosixFramework.DetailObject executeCommand(string commandName, ENSX.EnosixFramework.DetailObject obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(true);

			return result;
        }

		public ENSX.EnosixFramework.DetailObject executeInitialize(ENSX.EnosixFramework.DetailObject obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(true);

			return result;
		}
	}

	public class MockEnosixCustomerFailure implements ENSX.EnosixFramework.DetailSBOGetMock, ENSX.EnosixFramework.DetailSBOSaveMock, ENSX.EnosixFramework.DetailSBOCommandMock, ENSX.EnosixFramework.DetailSBOInitMock
	{
		public ENSX.EnosixFramework.DetailObject executeGetDetail(object obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(false);

			return result;
        }

        public ENSX.EnosixFramework.DetailObject executeSave(ENSX.EnosixFramework.DetailObject obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(false);

			return result;
        }

        public ENSX.EnosixFramework.DetailObject executeCommand(string commandName, ENSX.EnosixFramework.DetailObject obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(false);

			return result;
        }

		public ENSX.EnosixFramework.DetailObject executeInitialize(ENSX.EnosixFramework.DetailObject obj)
		{
			SBO_EnosixCustomer_Detail.EnosixCustomer result = new SBO_EnosixCustomer_Detail.EnosixCustomer();

			result.setSuccess(false);

			return result;
		}
	}
}