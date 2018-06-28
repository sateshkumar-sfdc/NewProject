@isTest
public with sharing class TST_EnosixDL_Detail{
	@isTest
	static void testEnosixDL(){
		SBO_EnosixDL_Detail.EnosixDL sbo = new SBO_EnosixDL_Detail.EnosixDL();
				sbo.Delivery = 'X';
		System.assertEquals('X', sbo.Delivery);

		sbo.Truck = 'X';
		System.assertEquals('X', sbo.Truck);

		sbo.ShippingPoint = 'X';
		System.assertEquals('X', sbo.ShippingPoint);

		sbo.ShippingPointDescription = 'X';
		System.assertEquals('X', sbo.ShippingPointDescription);

		sbo.LoadingPoint = 'X';
		System.assertEquals('X', sbo.LoadingPoint);

		sbo.LoadingPointText = 'X';
		System.assertEquals('X', sbo.LoadingPointText);

		sbo.UnloadingPoint = 'X';
		System.assertEquals('X', sbo.UnloadingPoint);

		sbo.Route = 'X';
		System.assertEquals('X', sbo.Route);

		sbo.RouteText = 'X';
		System.assertEquals('X', sbo.RouteText);

		sbo.BillofLading = 'X';
		System.assertEquals('X', sbo.BillofLading);

		sbo.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.CreateDate);

		sbo.DeliveryDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.DeliveryDate);

		sbo.PGIDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), sbo.PGIDate);

		sbo.DeliveryType = 'X';
		System.assertEquals('X', sbo.DeliveryType);

		sbo.DeliveryTypeText = 'X';
		System.assertEquals('X', sbo.DeliveryTypeText);

		sbo.SoldToParty = 'X';
		System.assertEquals('X', sbo.SoldToParty);

		sbo.SoldToPartyText = 'X';
		System.assertEquals('X', sbo.SoldToPartyText);

		sbo.ShipToParty = 'X';
		System.assertEquals('X', sbo.ShipToParty);

		sbo.ShipToPartyText = 'X';
		System.assertEquals('X', sbo.ShipToPartyText);

		sbo.ShippingConditions = 'X';
		System.assertEquals('X', sbo.ShippingConditions);

		sbo.ShipConditionText = 'X';
		System.assertEquals('X', sbo.ShipConditionText);

		sbo.DeliveryPriority = 'X';
		System.assertEquals('X', sbo.DeliveryPriority);

		sbo.DeliveryPriorityText = 'X';
		System.assertEquals('X', sbo.DeliveryPriorityText);

		sbo.NetOrderValue = 1.5;
		System.assertEquals(1.5, sbo.NetOrderValue);

		sbo.SalesDocumentCurrency = 'X';
		System.assertEquals('X', sbo.SalesDocumentCurrency);

		sbo.DeliveryBlock = 'X';
		System.assertEquals('X', sbo.DeliveryBlock);

		sbo.DeliveryStatus = 'X';
		System.assertEquals('X', sbo.DeliveryStatus);

	}

		@isTest
	static void testPARTNERS(){
	SBO_EnosixDL_Detail.PARTNERS childObj = new SBO_EnosixDL_Detail.PARTNERS();
			childObj.PartnerFunction = 'X';
		System.assertEquals('X', childObj.PartnerFunction);

		childObj.PartnerFunctionName = 'X';
		System.assertEquals('X', childObj.PartnerFunctionName);

		childObj.CustomerNumber = 'X';
		System.assertEquals('X', childObj.CustomerNumber);

		childObj.Vendor = 'X';
		System.assertEquals('X', childObj.Vendor);

		childObj.PersonnelNumber = 'X';
		System.assertEquals('X', childObj.PersonnelNumber);

		childObj.ContactPersonNumber = 'X';
		System.assertEquals('X', childObj.ContactPersonNumber);

		childObj.PartnerName = 'X';
		System.assertEquals('X', childObj.PartnerName);

		childObj.PartnerName2 = 'X';
		System.assertEquals('X', childObj.PartnerName2);

		childObj.HouseNumber = 'X';
		System.assertEquals('X', childObj.HouseNumber);

		childObj.Street = 'X';
		System.assertEquals('X', childObj.Street);

		childObj.City = 'X';
		System.assertEquals('X', childObj.City);

		childObj.PostalCode = 'X';
		System.assertEquals('X', childObj.PostalCode);

		childObj.Region = 'X';
		System.assertEquals('X', childObj.Region);

		childObj.RegionDescription = 'X';
		System.assertEquals('X', childObj.RegionDescription);

		childObj.Country = 'X';
		System.assertEquals('X', childObj.Country);

		childObj.CountryName = 'X';
		System.assertEquals('X', childObj.CountryName);

		childObj.TimeZone = 'X';
		System.assertEquals('X', childObj.TimeZone);

		childObj.TimeZoneText = 'X';
		System.assertEquals('X', childObj.TimeZoneText);

		childObj.TransportationZone = 'X';
		System.assertEquals('X', childObj.TransportationZone);

		childObj.TransportationZoneDescription = 'X';
		System.assertEquals('X', childObj.TransportationZoneDescription);

		childObj.POBox = 'X';
		System.assertEquals('X', childObj.POBox);

		childObj.POBoxPostalCode = 'X';
		System.assertEquals('X', childObj.POBoxPostalCode);

		childObj.CompanyPostalCode = 'X';
		System.assertEquals('X', childObj.CompanyPostalCode);

		childObj.Language = 'X';
		System.assertEquals('X', childObj.Language);

		childObj.LanguageDesc = 'X';
		System.assertEquals('X', childObj.LanguageDesc);

		childObj.TelephoneNumber = 'X';
		System.assertEquals('X', childObj.TelephoneNumber);

		childObj.TelephoneNumberExtension = 'X';
		System.assertEquals('X', childObj.TelephoneNumberExtension);

		childObj.MobileNumber = 'X';
		System.assertEquals('X', childObj.MobileNumber);

		childObj.FaxNumber = 'X';
		System.assertEquals('X', childObj.FaxNumber);

		childObj.FaxNumberExtension = 'X';
		System.assertEquals('X', childObj.FaxNumberExtension);

		childObj.EMailAddress = 'X';
		System.assertEquals('X', childObj.EMailAddress);

		childObj.DefaultCommunicationMethod = 'X';
		System.assertEquals('X', childObj.DefaultCommunicationMethod);

		childObj.DefaultCommunicationMethodDescription = 'X';
		System.assertEquals('X', childObj.DefaultCommunicationMethodDescription);

		childObj.Extension1 = 'X';
		System.assertEquals('X', childObj.Extension1);

		childObj.Extension2 = 'X';
		System.assertEquals('X', childObj.Extension2);

		childObj.AddressNotes = 'X';
		System.assertEquals('X', childObj.AddressNotes);

	}
	@isTest
	static void testCUSTOMER(){
	SBO_EnosixDL_Detail.CUSTOMER childObj = new SBO_EnosixDL_Detail.CUSTOMER();
			childObj.ShipToParty = 'X';
		System.assertEquals('X', childObj.ShipToParty);

		childObj.Name = 'X';
		System.assertEquals('X', childObj.Name);

		childObj.HouseNumber = 'X';
		System.assertEquals('X', childObj.HouseNumber);

		childObj.Street = 'X';
		System.assertEquals('X', childObj.Street);

		childObj.City = 'X';
		System.assertEquals('X', childObj.City);

		childObj.Region = 'X';
		System.assertEquals('X', childObj.Region);

		childObj.PostalCode = 'X';
		System.assertEquals('X', childObj.PostalCode);

		childObj.OpenDeliveries = 0;
		System.assertEquals(0, childObj.OpenDeliveries);

	}
	@isTest
	static void testITEMS(){
	SBO_EnosixDL_Detail.ITEMS childObj = new SBO_EnosixDL_Detail.ITEMS();
			childObj.DeliveryItem = 'X';
		System.assertEquals('X', childObj.DeliveryItem);

		childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.MaterialDescription = 'X';
		System.assertEquals('X', childObj.MaterialDescription);

		childObj.DeliveryQuantity = 1.5;
		System.assertEquals(1.5, childObj.DeliveryQuantity);

		childObj.PickedQuantity = 1.5;
		System.assertEquals(1.5, childObj.PickedQuantity);

		childObj.SalesUnit = 'X';
		System.assertEquals('X', childObj.SalesUnit);

		childObj.SalesUOMText = 'X';
		System.assertEquals('X', childObj.SalesUOMText);

		childObj.QuantityUOM = 'X';
		System.assertEquals('X', childObj.QuantityUOM);

		childObj.UOMText = 'X';
		System.assertEquals('X', childObj.UOMText);

		childObj.ItemDescription = 'X';
		System.assertEquals('X', childObj.ItemDescription);

		childObj.CustomerMaterialNumber = 'X';
		System.assertEquals('X', childObj.CustomerMaterialNumber);

		childObj.CustomerPurchaseOrderNumber = 'X';
		System.assertEquals('X', childObj.CustomerPurchaseOrderNumber);

		childObj.ItemCategory = 'X';
		System.assertEquals('X', childObj.ItemCategory);

		childObj.ItemCategoryDescription = 'X';
		System.assertEquals('X', childObj.ItemCategoryDescription);

		childObj.DangerousGoodsIndicator = 'X';
		System.assertEquals('X', childObj.DangerousGoodsIndicator);

		childObj.HigherLevelItemNumber = 'X';
		System.assertEquals('X', childObj.HigherLevelItemNumber);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.PlantName = 'X';
		System.assertEquals('X', childObj.PlantName);

		childObj.MaterialType = 'X';
		System.assertEquals('X', childObj.MaterialType);

		childObj.MaterialGroup = 'X';
		System.assertEquals('X', childObj.MaterialGroup);

		childObj.ProductHierarchyDescription = 'X';
		System.assertEquals('X', childObj.ProductHierarchyDescription);

		childObj.StorageLocation = 'X';
		System.assertEquals('X', childObj.StorageLocation);

		childObj.BatchNumber = 'X';
		System.assertEquals('X', childObj.BatchNumber);

		childObj.ConditionPricingUnit = 1.5;
		System.assertEquals(1.5, childObj.ConditionPricingUnit);

		childObj.ConditionUnit = 'X';
		System.assertEquals('X', childObj.ConditionUnit);

		childObj.NetItemPrice = 1.5;
		System.assertEquals(1.5, childObj.NetItemPrice);

		childObj.NetOrderValue = 1.5;
		System.assertEquals(1.5, childObj.NetOrderValue);

		childObj.Netweight = 1.5;
		System.assertEquals(1.5, childObj.Netweight);

		childObj.GrossWeight = 1.5;
		System.assertEquals(1.5, childObj.GrossWeight);

		childObj.WeightUnit = 'X';
		System.assertEquals('X', childObj.WeightUnit);

		childObj.SalesOrder = 'X';
		System.assertEquals('X', childObj.SalesOrder);

		childObj.SalesOrderItem = 'X';
		System.assertEquals('X', childObj.SalesOrderItem);

		childObj.LoadingGroup = 'X';
		System.assertEquals('X', childObj.LoadingGroup);

		childObj.TransportationGroup = 'X';
		System.assertEquals('X', childObj.TransportationGroup);

		childObj.StorageType = 'X';
		System.assertEquals('X', childObj.StorageType);

		childObj.StorageBin = 'X';
		System.assertEquals('X', childObj.StorageBin);

		childObj.MovementType = 'X';
		System.assertEquals('X', childObj.MovementType);

		childObj.BatchManagmentRequired = 'X';
		System.assertEquals('X', childObj.BatchManagmentRequired);

		childObj.DistributionChannel = 'X';
		System.assertEquals('X', childObj.DistributionChannel);

		childObj.DistributionChannelName = 'X';
		System.assertEquals('X', childObj.DistributionChannelName);

		childObj.Division = 'X';
		System.assertEquals('X', childObj.Division);

		childObj.DivisionName = 'X';
		System.assertEquals('X', childObj.DivisionName);

		childObj.SpecialStockInd = 'X';
		System.assertEquals('X', childObj.SpecialStockInd);

		childObj.CumulBatchQuantity = 1.5;
		System.assertEquals(1.5, childObj.CumulBatchQuantity);

		childObj.HigerLevelBatchSplitItem = 'X';
		System.assertEquals('X', childObj.HigerLevelBatchSplitItem);

		childObj.InspectionLot = 'X';
		System.assertEquals('X', childObj.InspectionLot);

		childObj.QtyInInspectionStock = 'X';
		System.assertEquals('X', childObj.QtyInInspectionStock);

		childObj.ReservationNumber = 'X';
		System.assertEquals('X', childObj.ReservationNumber);

		childObj.ReservationItem = 'X';
		System.assertEquals('X', childObj.ReservationItem);

		childObj.NumeratorConvSalesToSKU = 1.5;
		System.assertEquals(1.5, childObj.NumeratorConvSalesToSKU);

		childObj.DenominatorConvSalesToSKU = 1.5;
		System.assertEquals(1.5, childObj.DenominatorConvSalesToSKU);

		childObj.ConversionSalesToBaseUOM = 1.5;
		System.assertEquals(1.5, childObj.ConversionSalesToBaseUOM);

		childObj.PickingStatus = 'X';
		System.assertEquals('X', childObj.PickingStatus);

		childObj.PackingStatus = 'X';
		System.assertEquals('X', childObj.PackingStatus);

		childObj.ProofofDelivery = 'X';
		System.assertEquals('X', childObj.ProofofDelivery);

	}
	@isTest
	static void testHU(){
	SBO_EnosixDL_Detail.HU childObj = new SBO_EnosixDL_Detail.HU();
			childObj.IntHUNumber = 'X';
		System.assertEquals('X', childObj.IntHUNumber);

		childObj.HUContentDescription = 'X';
		System.assertEquals('X', childObj.HUContentDescription);

		childObj.ExtHUID = 'X';
		System.assertEquals('X', childObj.ExtHUID);

		childObj.ExtHUIDType = 'X';
		System.assertEquals('X', childObj.ExtHUIDType);

		childObj.ShippingPoint = 'X';
		System.assertEquals('X', childObj.ShippingPoint);

		childObj.ShippingPointDescription = 'X';
		System.assertEquals('X', childObj.ShippingPointDescription);

		childObj.LoadingPoint = 'X';
		System.assertEquals('X', childObj.LoadingPoint);

		childObj.LoadingPointText = 'X';
		System.assertEquals('X', childObj.LoadingPointText);

		childObj.HUStatus = 'X';
		System.assertEquals('X', childObj.HUStatus);

		childObj.HUStatusDescription = 'X';
		System.assertEquals('X', childObj.HUStatusDescription);

		childObj.GrossWeight = 1.5;
		System.assertEquals(1.5, childObj.GrossWeight);

		childObj.Netweight = 1.5;
		System.assertEquals(1.5, childObj.Netweight);

		childObj.HUAllowedWeight = 1.5;
		System.assertEquals(1.5, childObj.HUAllowedWeight);

		childObj.TareWeight = 1.5;
		System.assertEquals(1.5, childObj.TareWeight);

		childObj.WeightUnit = 'X';
		System.assertEquals('X', childObj.WeightUnit);

		childObj.CreatedBy = 'X';
		System.assertEquals('X', childObj.CreatedBy);

		childObj.CreateDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.CreateDate);

		childObj.EntryTime = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.EntryTime);

		childObj.SortField = 'X';
		System.assertEquals('X', childObj.SortField);

		childObj.PackagingMaterial = 'X';
		System.assertEquals('X', childObj.PackagingMaterial);

		childObj.PackagingMaterialDescritpion = 'X';
		System.assertEquals('X', childObj.PackagingMaterialDescritpion);

		childObj.LengthWidthHeightUOM = 'X';
		System.assertEquals('X', childObj.LengthWidthHeightUOM);

		childObj.PackingMaterialType = 'X';
		System.assertEquals('X', childObj.PackingMaterialType);

		childObj.MaterialGroupPackagingMaterials = 'X';
		System.assertEquals('X', childObj.MaterialGroupPackagingMaterials);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.StorageLocation = 'X';
		System.assertEquals('X', childObj.StorageLocation);

		childObj.GlobalUniqueID = 'X';
		System.assertEquals('X', childObj.GlobalUniqueID);

	}
	@isTest
	static void testHU_ITEMS(){
	SBO_EnosixDL_Detail.HU_ITEMS childObj = new SBO_EnosixDL_Detail.HU_ITEMS();
			childObj.IntHUNumber = 'X';
		System.assertEquals('X', childObj.IntHUNumber);

		childObj.HUItem = 'X';
		System.assertEquals('X', childObj.HUItem);

		childObj.HUContentType = 'X';
		System.assertEquals('X', childObj.HUContentType);

		childObj.Delivery = 'X';
		System.assertEquals('X', childObj.Delivery);

		childObj.DeliveryItem = 'X';
		System.assertEquals('X', childObj.DeliveryItem);

		childObj.SDDocumentCategory = 'X';
		System.assertEquals('X', childObj.SDDocumentCategory);

		childObj.LowerLevelHU = 'X';
		System.assertEquals('X', childObj.LowerLevelHU);

		childObj.HUItemQuantity = 1.5;
		System.assertEquals(1.5, childObj.HUItemQuantity);

		childObj.HUItemUOM = 'X';
		System.assertEquals('X', childObj.HUItemUOM);

		childObj.HUUOMText = 'X';
		System.assertEquals('X', childObj.HUUOMText);

		childObj.Material = 'X';
		System.assertEquals('X', childObj.Material);

		childObj.MaterialDescription = 'X';
		System.assertEquals('X', childObj.MaterialDescription);

		childObj.CustomerPart = 'X';
		System.assertEquals('X', childObj.CustomerPart);

		childObj.CustomerPartDescription = 'X';
		System.assertEquals('X', childObj.CustomerPartDescription);

		childObj.BatchNumber = 'X';
		System.assertEquals('X', childObj.BatchNumber);

		childObj.Plant = 'X';
		System.assertEquals('X', childObj.Plant);

		childObj.StorageLocation = 'X';
		System.assertEquals('X', childObj.StorageLocation);

		childObj.StockCategory = 'X';
		System.assertEquals('X', childObj.StockCategory);

		childObj.SpecialStockInd = 'X';
		System.assertEquals('X', childObj.SpecialStockInd);

		childObj.SpecialStockNumber = 'X';
		System.assertEquals('X', childObj.SpecialStockNumber);

		childObj.InspectionLot = 'X';
		System.assertEquals('X', childObj.InspectionLot);

		childObj.SerialNumberProfile = 'X';
		System.assertEquals('X', childObj.SerialNumberProfile);

		childObj.ItemCategory = 'X';
		System.assertEquals('X', childObj.ItemCategory);

		childObj.GoodsReceiptDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.GoodsReceiptDate);

		childObj.ShelfLifeExpirationDate = Date.valueOf('2020-12-31');
		System.assertEquals(Date.valueOf('2020-12-31'), childObj.ShelfLifeExpirationDate);

		childObj.HUTenativeAssignment = 'X';
		System.assertEquals('X', childObj.HUTenativeAssignment);

	}
	@isTest
	static void testHEADER_TEXTS(){
	SBO_EnosixDL_Detail.HEADER_TEXTS childObj = new SBO_EnosixDL_Detail.HEADER_TEXTS();
			childObj.TextID = 'X';
		System.assertEquals('X', childObj.TextID);

		childObj.TextLanguage = 'X';
		System.assertEquals('X', childObj.TextLanguage);

		childObj.TextIDDescription = 'X';
		System.assertEquals('X', childObj.TextIDDescription);

		childObj.Text = 'X';
		System.assertEquals('X', childObj.Text);

	}
	@isTest
	static void testITEMS_TEXT(){
	SBO_EnosixDL_Detail.ITEMS_TEXT childObj = new SBO_EnosixDL_Detail.ITEMS_TEXT();
			childObj.DeliveryItem = 'X';
		System.assertEquals('X', childObj.DeliveryItem);

		childObj.TextID = 'X';
		System.assertEquals('X', childObj.TextID);

		childObj.TextLanguage = 'X';
		System.assertEquals('X', childObj.TextLanguage);

		childObj.TextIDDescription = 'X';
		System.assertEquals('X', childObj.TextIDDescription);

		childObj.Text = 'X';
		System.assertEquals('X', childObj.Text);

	}
	@isTest
	static void testDOC_ACTION(){
	SBO_EnosixDL_Detail.DOC_ACTION childObj = new SBO_EnosixDL_Detail.DOC_ACTION();
			childObj.ChangeDelivery = 'X';
		System.assertEquals('X', childObj.ChangeDelivery);

		childObj.PickDelivery = 'X';
		System.assertEquals('X', childObj.PickDelivery);

		childObj.PackDelivery = 'X';
		System.assertEquals('X', childObj.PackDelivery);

		childObj.PostGoodsIssue = 'X';
		System.assertEquals('X', childObj.PostGoodsIssue);

		childObj.CopyPickedQtyToDelveryQty = 'X';
		System.assertEquals('X', childObj.CopyPickedQtyToDelveryQty);

		childObj.ProofofDelivery = 'X';
		System.assertEquals('X', childObj.ProofofDelivery);

	}
	@isTest
	static void testITEMS_ACTION(){
	SBO_EnosixDL_Detail.ITEMS_ACTION childObj = new SBO_EnosixDL_Detail.ITEMS_ACTION();
			childObj.DeliveryItem = 'X';
		System.assertEquals('X', childObj.DeliveryItem);

		childObj.ItemChanged = 'X';
		System.assertEquals('X', childObj.ItemChanged);

		childObj.ItemDeleted = 'X';
		System.assertEquals('X', childObj.ItemDeleted);

	}
}