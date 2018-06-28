public with sharing class SBO_EnosixDL_Detail extends ensx.EnosixFramework.DetailSBO {

	public SBO_EnosixDL_Detail() {
		super('EnosixDL', SBO_EnosixDL_Detail.EnosixDL.class);
	}

	public EnosixDL getDetail(object key) {
		return (EnosixDL)this.executeGetDetail(key);
	}

	public EnosixDL save(EnosixDL obj) {
		return (EnosixDL) this.executeSave(obj);
	}

	public EnosixDL command(string command, EnosixDL obj) {
		return (EnosixDL) this.executeCommand(command, obj);
	}

	public with sharing class EnosixDL extends ensx.EnosixFramework.DetailObject {
		public EnosixDL() {
			super(  'HEADER', new Map<string, type> {
				'PARTNERS' => SBO_EnosixDL_Detail.PARTNERS.class
				,
				'CUSTOMER' => SBO_EnosixDL_Detail.CUSTOMER.class
				,
				'ITEMS' => SBO_EnosixDL_Detail.ITEMS.class
				,
				'HU' => SBO_EnosixDL_Detail.HU.class
				,
				'HU_ITEMS' => SBO_EnosixDL_Detail.HU_ITEMS.class
				,
				'HEADER_TEXTS' => SBO_EnosixDL_Detail.HEADER_TEXTS.class
				,
				'ITEMS_TEXT' => SBO_EnosixDL_Detail.ITEMS_TEXT.class
				,
				'DOC_ACTION' => SBO_EnosixDL_Detail.DOC_ACTION.class
				,
				'ITEMS_ACTION' => SBO_EnosixDL_Detail.ITEMS_ACTION.class
			}
			     );

		}

		public String Delivery {
			get { return this.getString ('VBELN'); }
			set { this.Set (value, 'VBELN'); }
		}

		public String Truck {
			get { return this.getString ('TRAID'); }
			set { this.Set (value, 'TRAID'); }
		}

		public String ShippingPoint {
			get { return this.getString ('VSTEL'); }
			set { this.Set (value, 'VSTEL'); }
		}

		public String ShippingPointDescription {
			get { return this.getString ('VSTEL_VTEXT'); }
			set { this.Set (value, 'VSTEL_VTEXT'); }
		}

		public String LoadingPoint {
			get { return this.getString ('LSTEL'); }
			set { this.Set (value, 'LSTEL'); }
		}

		public String LoadingPointText {
			get { return this.getString ('LSTEL_VTEXT'); }
			set { this.Set (value, 'LSTEL_VTEXT'); }
		}

		public String UnloadingPoint {
			get { return this.getString ('ABLAD'); }
			set { this.Set (value, 'ABLAD'); }
		}

		public String Route {
			get { return this.getString ('ROUTE'); }
			set { this.Set (value, 'ROUTE'); }
		}

		public String RouteText {
			get { return this.getString ('ROUTE_TEXT'); }
			set { this.Set (value, 'ROUTE_TEXT'); }
		}

		public String BillofLading {
			get { return this.getString ('BOLNR'); }
			set { this.Set (value, 'BOLNR'); }
		}

		public DateTime CreateDate {
			get { return this.getDate ('ERDAT'); }
			set { this.Set (value, 'ERDAT'); }
		}

		public DateTime DeliveryDate {
			get { return this.getDate ('LFDAT'); }
			set { this.Set (value, 'LFDAT'); }
		}

		public DateTime PGIDate {
			get { return this.getDate ('WADAT_IST'); }
			set { this.Set (value, 'WADAT_IST'); }
		}

		public String DeliveryType {
			get { return this.getString ('LFART'); }
			set { this.Set (value, 'LFART'); }
		}

		public String DeliveryTypeText {
			get { return this.getString ('LFART_TEXT'); }
			set { this.Set (value, 'LFART_TEXT'); }
		}

		public String SoldToParty {
			get { return this.getString ('KUNAG'); }
			set { this.Set (value, 'KUNAG'); }
		}

		public String SoldToPartyText {
			get { return this.getString ('KUNAG_TXTPA'); }
			set { this.Set (value, 'KUNAG_TXTPA'); }
		}

		public String ShipToParty {
			get { return this.getString ('KUNWE'); }
			set { this.Set (value, 'KUNWE'); }
		}

		public String ShipToPartyText {
			get { return this.getString ('KUNWE_TXTPA'); }
			set { this.Set (value, 'KUNWE_TXTPA'); }
		}

		public String ShippingConditions {
			get { return this.getString ('VSBED'); }
			set { this.Set (value, 'VSBED'); }
		}

		public String ShipConditionText {
			get { return this.getString ('VSBED_TEXT'); }
			set { this.Set (value, 'VSBED_TEXT'); }
		}

		public String DeliveryPriority {
			get { return this.getString ('LPRIO'); }
			set { this.Set (value, 'LPRIO'); }
		}

		public String DeliveryPriorityText {
			get { return this.getString ('LPRIO_TEXT'); }
			set { this.Set (value, 'LPRIO_TEXT'); }
		}

		public Decimal NetOrderValue {
			get { return this.getDecimal ('NETWR'); }
			set { this.Set (value, 'NETWR'); }
		}

		public String SalesDocumentCurrency {
			get { return this.getString ('WAERK'); }
			set { this.Set (value, 'WAERK'); }
		}

		public String DeliveryBlock {
			get { return this.getString ('LIFSK'); }
			set { this.Set (value, 'LIFSK'); }
		}

		public String DeliveryStatus {
			get { return this.getString ('DELV_STAT'); }
			set { this.Set (value, 'DELV_STAT'); }
		}


		public ensx.EnosixFramework.FrameworkCollection PARTNERS {
			get { return this.getCollection(SBO_EnosixDL_Detail.PARTNERS.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection CUSTOMER {
			get { return this.getCollection(SBO_EnosixDL_Detail.CUSTOMER.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection ITEMS {
			get { return this.getCollection(SBO_EnosixDL_Detail.ITEMS.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection HU {
			get { return this.getCollection(SBO_EnosixDL_Detail.HU.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection HU_ITEMS {
			get { return this.getCollection(SBO_EnosixDL_Detail.HU_ITEMS.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection HEADER_TEXTS {
			get { return this.getCollection(SBO_EnosixDL_Detail.HEADER_TEXTS.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection ITEMS_TEXT {
			get { return this.getCollection(SBO_EnosixDL_Detail.ITEMS_TEXT.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection DOC_ACTION {
			get { return this.getCollection(SBO_EnosixDL_Detail.DOC_ACTION.class); }
		}


		public ensx.EnosixFramework.FrameworkCollection ITEMS_ACTION {
			get { return this.getCollection(SBO_EnosixDL_Detail.ITEMS_ACTION.class); }
		}


	}

	//Write child objects
	public class PARTNERS extends ensx.EnosixFramework.ValueObject {
		public String PartnerFunction {
			get { return this.getString ('PARVW'); }
			set { this.Set (value, 'PARVW'); }
		}

		public String PartnerFunctionName {
			get { return this.getString ('PARVW_VTEXT'); }
			set { this.Set (value, 'PARVW_VTEXT'); }
		}

		public String CustomerNumber {
			get { return this.getString ('KUNNR'); }
			set { this.Set (value, 'KUNNR'); }
		}

		public String Vendor {
			get { return this.getString ('LIFNR'); }
			set { this.Set (value, 'LIFNR'); }
		}

		public String PersonnelNumber {
			get { return this.getString ('PERNR'); }
			set { this.Set (value, 'PERNR'); }
		}

		public String ContactPersonNumber {
			get { return this.getString ('PARNR'); }
			set { this.Set (value, 'PARNR'); }
		}

		public String PartnerName {
			get { return this.getString ('NAME1'); }
			set { this.Set (value, 'NAME1'); }
		}

		public String PartnerName2 {
			get { return this.getString ('NAME2'); }
			set { this.Set (value, 'NAME2'); }
		}

		public String HouseNumber {
			get { return this.getString ('HOUSE_NUM1'); }
			set { this.Set (value, 'HOUSE_NUM1'); }
		}

		public String Street {
			get { return this.getString ('STREET'); }
			set { this.Set (value, 'STREET'); }
		}

		public String City {
			get { return this.getString ('CITY1'); }
			set { this.Set (value, 'CITY1'); }
		}

		public String PostalCode {
			get { return this.getString ('POST_CODE1'); }
			set { this.Set (value, 'POST_CODE1'); }
		}

		public String Region {
			get { return this.getString ('REGION'); }
			set { this.Set (value, 'REGION'); }
		}

		public String RegionDescription {
			get { return this.getString ('REGIO_BEZEI'); }
			set { this.Set (value, 'REGIO_BEZEI'); }
		}

		public String Country {
			get { return this.getString ('COUNTRY'); }
			set { this.Set (value, 'COUNTRY'); }
		}

		public String CountryName {
			get { return this.getString ('COUNTRY_LANDX'); }
			set { this.Set (value, 'COUNTRY_LANDX'); }
		}

		public String TimeZone {
			get { return this.getString ('TIME_ZONE'); }
			set { this.Set (value, 'TIME_ZONE'); }
		}

		public String TimeZoneText {
			get { return this.getString ('TIME_ZONE_TEXT'); }
			set { this.Set (value, 'TIME_ZONE_TEXT'); }
		}

		public String TransportationZone {
			get { return this.getString ('TRANSPZONE'); }
			set { this.Set (value, 'TRANSPZONE'); }
		}

		public String TransportationZoneDescription {
			get { return this.getString ('TRANSPZONE_VTEXT'); }
			set { this.Set (value, 'TRANSPZONE_VTEXT'); }
		}

		public String POBox {
			get { return this.getString ('PO_BOX'); }
			set { this.Set (value, 'PO_BOX'); }
		}

		public String POBoxPostalCode {
			get { return this.getString ('POST_CODE2'); }
			set { this.Set (value, 'POST_CODE2'); }
		}

		public String CompanyPostalCode {
			get { return this.getString ('POST_CODE3'); }
			set { this.Set (value, 'POST_CODE3'); }
		}

		public String Language {
			get { return this.getString ('LANGU'); }
			set { this.Set (value, 'LANGU'); }
		}

		public String LanguageDesc {
			get { return this.getString ('LANGU_SPTXT'); }
			set { this.Set (value, 'LANGU_SPTXT'); }
		}

		public String TelephoneNumber {
			get { return this.getString ('TEL_NUMBER'); }
			set { this.Set (value, 'TEL_NUMBER'); }
		}

		public String TelephoneNumberExtension {
			get { return this.getString ('TEL_EXTENS'); }
			set { this.Set (value, 'TEL_EXTENS'); }
		}

		public String MobileNumber {
			get { return this.getString ('MOB_NUMBER'); }
			set { this.Set (value, 'MOB_NUMBER'); }
		}

		public String FaxNumber {
			get { return this.getString ('FAX_NUMBER'); }
			set { this.Set (value, 'FAX_NUMBER'); }
		}

		public String FaxNumberExtension {
			get { return this.getString ('FAX_EXTENS'); }
			set { this.Set (value, 'FAX_EXTENS'); }
		}

		public String EMailAddress {
			get { return this.getString ('SMTP_ADDR'); }
			set { this.Set (value, 'SMTP_ADDR'); }
		}

		public String DefaultCommunicationMethod {
			get { return this.getString ('DEFLT_COMM'); }
			set { this.Set (value, 'DEFLT_COMM'); }
		}

		public String DefaultCommunicationMethodDescription {
			get { return this.getString ('DEFLT_COMM_TEXT'); }
			set { this.Set (value, 'DEFLT_COMM_TEXT'); }
		}

		public String Extension1 {
			get { return this.getString ('EXTENSION1'); }
			set { this.Set (value, 'EXTENSION1'); }
		}

		public String Extension2 {
			get { return this.getString ('EXTENSION2'); }
			set { this.Set (value, 'EXTENSION2'); }
		}

		public String AddressNotes {
			get { return this.getString ('REMARK'); }
			set { this.Set (value, 'REMARK'); }
		}

	}
	public class CUSTOMER extends ensx.EnosixFramework.ValueObject {
		public String ShipToParty {
			get { return this.getString ('KUNWE'); }
			set { this.Set (value, 'KUNWE'); }
		}

		public String Name {
			get { return this.getString ('NAME1'); }
			set { this.Set (value, 'NAME1'); }
		}

		public String HouseNumber {
			get { return this.getString ('HOUSE_NUM1'); }
			set { this.Set (value, 'HOUSE_NUM1'); }
		}

		public String Street {
			get { return this.getString ('STREET'); }
			set { this.Set (value, 'STREET'); }
		}

		public String City {
			get { return this.getString ('CITY1'); }
			set { this.Set (value, 'CITY1'); }
		}

		public String Region {
			get { return this.getString ('REGION'); }
			set { this.Set (value, 'REGION'); }
		}

		public String PostalCode {
			get { return this.getString ('POST_CODE1'); }
			set { this.Set (value, 'POST_CODE1'); }
		}

		public Integer OpenDeliveries {
			get { return this.getInteger ('NUM_DELVS'); }
			set { this.Set (value, 'NUM_DELVS'); }
		}

	}
	public class ITEMS extends ensx.EnosixFramework.ValueObject {
		public String DeliveryItem {
			get { return this.getString ('POSNR'); }
			set { this.Set (value, 'POSNR'); }
		}

		public String Material {
			get { return this.getString ('MATNR'); }
			set { this.Set (value, 'MATNR'); }
		}

		public String MaterialDescription {
			get { return this.getString ('MAKTX'); }
			set { this.Set (value, 'MAKTX'); }
		}

		public Decimal DeliveryQuantity {
			get { return this.getDecimal ('LFIMG'); }
			set { this.Set (value, 'LFIMG'); }
		}

		public Decimal PickedQuantity {
			get { return this.getDecimal ('PIKMG'); }
			set { this.Set (value, 'PIKMG'); }
		}

		public String SalesUnit {
			get { return this.getString ('VRKME'); }
			set { this.Set (value, 'VRKME'); }
		}

		public String SalesUOMText {
			get { return this.getString ('VRKME_MSEHT'); }
			set { this.Set (value, 'VRKME_MSEHT'); }
		}

		public String QuantityUOM {
			get { return this.getString ('MEINS'); }
			set { this.Set (value, 'MEINS'); }
		}

		public String UOMText {
			get { return this.getString ('MEINS_MSEHT'); }
			set { this.Set (value, 'MEINS_MSEHT'); }
		}

		public String ItemDescription {
			get { return this.getString ('ARKTX'); }
			set { this.Set (value, 'ARKTX'); }
		}

		public String CustomerMaterialNumber {
			get { return this.getString ('KDMAT'); }
			set { this.Set (value, 'KDMAT'); }
		}

		public String CustomerPurchaseOrderNumber {
			get { return this.getString ('BSTKD'); }
			set { this.Set (value, 'BSTKD'); }
		}

		public String ItemCategory {
			get { return this.getString ('PSTYV'); }
			set { this.Set (value, 'PSTYV'); }
		}

		public String ItemCategoryDescription {
			get { return this.getString ('PSTYV_VTEXT'); }
			set { this.Set (value, 'PSTYV_VTEXT'); }
		}

		public String DangerousGoodsIndicator {
			get { return this.getString ('PROFL'); }
			set { this.Set (value, 'PROFL'); }
		}

		public String HigherLevelItemNumber {
			get { return this.getString ('UEPOS'); }
			set { this.Set (value, 'UEPOS'); }
		}

		public String Plant {
			get { return this.getString ('WERKS'); }
			set { this.Set (value, 'WERKS'); }
		}

		public String PlantName {
			get { return this.getString ('WERKS_NAME'); }
			set { this.Set (value, 'WERKS_NAME'); }
		}

		public String MaterialType {
			get { return this.getString ('MTART'); }
			set { this.Set (value, 'MTART'); }
		}

		public String MaterialGroup {
			get { return this.getString ('MATKL'); }
			set { this.Set (value, 'MATKL'); }
		}

		public String ProductHierarchyDescription {
			get { return this.getString ('PRODH'); }
			set { this.Set (value, 'PRODH'); }
		}

		public String StorageLocation {
			get { return this.getString ('LGORT'); }
			set { this.Set (value, 'LGORT'); }
		}

		public String BatchNumber {
			get { return this.getString ('CHARG'); }
			set { this.Set (value, 'CHARG'); }
		}

		public Decimal ConditionPricingUnit {
			get { return this.getDecimal ('KPEIN'); }
			set { this.Set (value, 'KPEIN'); }
		}

		public String ConditionUnit {
			get { return this.getString ('KMEIN'); }
			set { this.Set (value, 'KMEIN'); }
		}

		public Decimal NetItemPrice {
			get { return this.getDecimal ('NETPR'); }
			set { this.Set (value, 'NETPR'); }
		}

		public Decimal NetOrderValue {
			get { return this.getDecimal ('NETWR'); }
			set { this.Set (value, 'NETWR'); }
		}

		public Decimal Netweight {
			get { return this.getDecimal ('NTGEW'); }
			set { this.Set (value, 'NTGEW'); }
		}

		public Decimal GrossWeight {
			get { return this.getDecimal ('BRGEW'); }
			set { this.Set (value, 'BRGEW'); }
		}

		public String WeightUnit {
			get { return this.getString ('GEWEI'); }
			set { this.Set (value, 'GEWEI'); }
		}

		public String SalesOrder {
			get { return this.getString ('VGBEL'); }
			set { this.Set (value, 'VGBEL'); }
		}

		public String SalesOrderItem {
			get { return this.getString ('VGPOS'); }
			set { this.Set (value, 'VGPOS'); }
		}

		public String LoadingGroup {
			get { return this.getString ('LADGR'); }
			set { this.Set (value, 'LADGR'); }
		}

		public String TransportationGroup {
			get { return this.getString ('TRAGR'); }
			set { this.Set (value, 'TRAGR'); }
		}

		public String StorageType {
			get { return this.getString ('LGTYP'); }
			set { this.Set (value, 'LGTYP'); }
		}

		public String StorageBin {
			get { return this.getString ('LGPLA'); }
			set { this.Set (value, 'LGPLA'); }
		}

		public String MovementType {
			get { return this.getString ('BWART'); }
			set { this.Set (value, 'BWART'); }
		}

		public String BatchManagmentRequired {
			get { return this.getString ('XCHPF'); }
			set { this.Set (value, 'XCHPF'); }
		}

		public String DistributionChannel {
			get { return this.getString ('VTWEG'); }
			set { this.Set (value, 'VTWEG'); }
		}

		public String DistributionChannelName {
			get { return this.getString ('VTWEG_VTEXT'); }
			set { this.Set (value, 'VTWEG_VTEXT'); }
		}

		public String Division {
			get { return this.getString ('SPART'); }
			set { this.Set (value, 'SPART'); }
		}

		public String DivisionName {
			get { return this.getString ('SPART_VTEXT'); }
			set { this.Set (value, 'SPART_VTEXT'); }
		}

		public String SpecialStockInd {
			get { return this.getString ('SOBKZ'); }
			set { this.Set (value, 'SOBKZ'); }
		}

		public Decimal CumulBatchQuantity {
			get { return this.getDecimal ('KCMENG'); }
			set { this.Set (value, 'KCMENG'); }
		}

		public String HigerLevelBatchSplitItem {
			get { return this.getString ('UECHA'); }
			set { this.Set (value, 'UECHA'); }
		}

		public String InspectionLot {
			get { return this.getString ('QPLOS'); }
			set { this.Set (value, 'QPLOS'); }
		}

		public String QtyInInspectionStock {
			get { return this.getString ('INSMK'); }
			set { this.Set (value, 'INSMK'); }
		}

		public String ReservationNumber {
			get { return this.getString ('RSNUM'); }
			set { this.Set (value, 'RSNUM'); }
		}

		public String ReservationItem {
			get { return this.getString ('RSPOS'); }
			set { this.Set (value, 'RSPOS'); }
		}

		public Decimal NumeratorConvSalesToSKU {
			get { return this.getDecimal ('UMVKZ'); }
			set { this.Set (value, 'UMVKZ'); }
		}

		public Decimal DenominatorConvSalesToSKU {
			get { return this.getDecimal ('UMVKN'); }
			set { this.Set (value, 'UMVKN'); }
		}

		public Decimal ConversionSalesToBaseUOM {
			get { return this.getDecimal ('UMREV'); }
			set { this.Set (value, 'UMREV'); }
		}

		public String PickingStatus {
			get { return this.getString ('KOSTA'); }
			set { this.Set (value, 'KOSTA'); }
		}

		public String PackingStatus {
			get { return this.getString ('PKSTA'); }
			set { this.Set (value, 'PKSTA'); }
		}

		public String ProofofDelivery {
			get { return this.getString ('PDSTA'); }
			set { this.Set (value, 'PDSTA'); }
		}

	}
	public class HU extends ensx.EnosixFramework.ValueObject {
		public String IntHUNumber {
			get { return this.getString ('VENUM'); }
			set { this.Set (value, 'VENUM'); }
		}

		public String HUContentDescription {
			get { return this.getString ('INHALT'); }
			set { this.Set (value, 'INHALT'); }
		}

		public String ExtHUID {
			get { return this.getString ('EXIDV'); }
			set { this.Set (value, 'EXIDV'); }
		}

		public String ExtHUIDType {
			get { return this.getString ('EXIDA'); }
			set { this.Set (value, 'EXIDA'); }
		}

		public String ShippingPoint {
			get { return this.getString ('VSTEL'); }
			set { this.Set (value, 'VSTEL'); }
		}

		public String ShippingPointDescription {
			get { return this.getString ('VSTEL_VTEXT'); }
			set { this.Set (value, 'VSTEL_VTEXT'); }
		}

		public String LoadingPoint {
			get { return this.getString ('LSTEL'); }
			set { this.Set (value, 'LSTEL'); }
		}

		public String LoadingPointText {
			get { return this.getString ('LSTEL_VTEXT'); }
			set { this.Set (value, 'LSTEL_VTEXT'); }
		}

		public String HUStatus {
			get { return this.getString ('STATUS'); }
			set { this.Set (value, 'STATUS'); }
		}

		public String HUStatusDescription {
			get { return this.getString ('STATUS_VTEXT'); }
			set { this.Set (value, 'STATUS_VTEXT'); }
		}

		public Decimal GrossWeight {
			get { return this.getDecimal ('BRGEW'); }
			set { this.Set (value, 'BRGEW'); }
		}

		public Decimal Netweight {
			get { return this.getDecimal ('NTGEW'); }
			set { this.Set (value, 'NTGEW'); }
		}

		public Decimal HUAllowedWeight {
			get { return this.getDecimal ('MAGEW'); }
			set { this.Set (value, 'MAGEW'); }
		}

		public Decimal TareWeight {
			get { return this.getDecimal ('TARAG'); }
			set { this.Set (value, 'TARAG'); }
		}

		public String WeightUnit {
			get { return this.getString ('GEWEI'); }
			set { this.Set (value, 'GEWEI'); }
		}

		public String CreatedBy {
			get { return this.getString ('ERNAM'); }
			set { this.Set (value, 'ERNAM'); }
		}

		public DateTime CreateDate {
			get { return this.getDate ('ERDAT'); }
			set { this.Set (value, 'ERDAT'); }
		}

		public DateTime EntryTime {
			get { return this.getDate ('ERUHR'); }
			set { this.Set (value, 'ERUHR'); }
		}

		public String SortField {
			get { return this.getString ('SORTL'); }
			set { this.Set (value, 'SORTL'); }
		}

		public String PackagingMaterial {
			get { return this.getString ('VHILM'); }
			set { this.Set (value, 'VHILM'); }
		}

		public String PackagingMaterialDescritpion {
			get { return this.getString ('VHILM_MAKTX'); }
			set { this.Set (value, 'VHILM_MAKTX'); }
		}

		public String LengthWidthHeightUOM {
			get { return this.getString ('MEABM'); }
			set { this.Set (value, 'MEABM'); }
		}

		public String PackingMaterialType {
			get { return this.getString ('VHART'); }
			set { this.Set (value, 'VHART'); }
		}

		public String MaterialGroupPackagingMaterials {
			get { return this.getString ('MAGRV'); }
			set { this.Set (value, 'MAGRV'); }
		}

		public String Plant {
			get { return this.getString ('WERKS'); }
			set { this.Set (value, 'WERKS'); }
		}

		public String StorageLocation {
			get { return this.getString ('LGORT'); }
			set { this.Set (value, 'LGORT'); }
		}

		public String GlobalUniqueID {
			get { return this.getString ('HANDLE'); }
			set { this.Set (value, 'HANDLE'); }
		}

	}
	public class HU_ITEMS extends ensx.EnosixFramework.ValueObject {
		public String IntHUNumber {
			get { return this.getString ('VENUM'); }
			set { this.Set (value, 'VENUM'); }
		}

		public String HUItem {
			get { return this.getString ('VEPOS'); }
			set { this.Set (value, 'VEPOS'); }
		}

		public String HUContentType {
			get { return this.getString ('VELIN'); }
			set { this.Set (value, 'VELIN'); }
		}

		public String Delivery {
			get { return this.getString ('VBELN'); }
			set { this.Set (value, 'VBELN'); }
		}

		public String DeliveryItem {
			get { return this.getString ('POSNR'); }
			set { this.Set (value, 'POSNR'); }
		}

		public String SDDocumentCategory {
			get { return this.getString ('VBTYP'); }
			set { this.Set (value, 'VBTYP'); }
		}

		public String LowerLevelHU {
			get { return this.getString ('UNVEL'); }
			set { this.Set (value, 'UNVEL'); }
		}

		public Decimal HUItemQuantity {
			get { return this.getDecimal ('VEMNG'); }
			set { this.Set (value, 'VEMNG'); }
		}

		public String HUItemUOM {
			get { return this.getString ('VEMEH'); }
			set { this.Set (value, 'VEMEH'); }
		}

		public String HUUOMText {
			get { return this.getString ('VEMEH_MSEHT'); }
			set { this.Set (value, 'VEMEH_MSEHT'); }
		}

		public String Material {
			get { return this.getString ('MATNR'); }
			set { this.Set (value, 'MATNR'); }
		}

		public String MaterialDescription {
			get { return this.getString ('MAKTX'); }
			set { this.Set (value, 'MAKTX'); }
		}

		public String CustomerPart {
			get { return this.getString ('P_MATERIAL'); }
			set { this.Set (value, 'P_MATERIAL'); }
		}

		public String CustomerPartDescription {
			get { return this.getString ('P_MAKTX'); }
			set { this.Set (value, 'P_MAKTX'); }
		}

		public String BatchNumber {
			get { return this.getString ('CHARG'); }
			set { this.Set (value, 'CHARG'); }
		}

		public String Plant {
			get { return this.getString ('WERKS'); }
			set { this.Set (value, 'WERKS'); }
		}

		public String StorageLocation {
			get { return this.getString ('LGORT'); }
			set { this.Set (value, 'LGORT'); }
		}

		public String StockCategory {
			get { return this.getString ('BESTQ'); }
			set { this.Set (value, 'BESTQ'); }
		}

		public String SpecialStockInd {
			get { return this.getString ('SOBKZ'); }
			set { this.Set (value, 'SOBKZ'); }
		}

		public String SpecialStockNumber {
			get { return this.getString ('SONUM'); }
			set { this.Set (value, 'SONUM'); }
		}

		public String InspectionLot {
			get { return this.getString ('QPLOS'); }
			set { this.Set (value, 'QPLOS'); }
		}

		public String SerialNumberProfile {
			get { return this.getString ('SERAIL'); }
			set { this.Set (value, 'SERAIL'); }
		}

		public String ItemCategory {
			get { return this.getString ('PSTYV'); }
			set { this.Set (value, 'PSTYV'); }
		}

		public DateTime GoodsReceiptDate {
			get { return this.getDate ('WDATU'); }
			set { this.Set (value, 'WDATU'); }
		}

		public DateTime ShelfLifeExpirationDate {
			get { return this.getDate ('VFDAT'); }
			set { this.Set (value, 'VFDAT'); }
		}

		public String HUTenativeAssignment {
			get { return this.getString ('XCHAR'); }
			set { this.Set (value, 'XCHAR'); }
		}

	}
	public class HEADER_TEXTS extends ensx.EnosixFramework.ValueObject {
		public String TextID {
			get { return this.getString ('TDID'); }
			set { this.Set (value, 'TDID'); }
		}

		public String TextLanguage {
			get { return this.getString ('TDSPRAS'); }
			set { this.Set (value, 'TDSPRAS'); }
		}

		public String TextIDDescription {
			get { return this.getString ('TDTEXT'); }
			set { this.Set (value, 'TDTEXT'); }
		}

		public String Text {
			get { return this.getString ('TEXT'); }
			set { this.Set (value, 'TEXT'); }
		}

	}
	public class ITEMS_TEXT extends ensx.EnosixFramework.ValueObject {
		public String DeliveryItem {
			get { return this.getString ('POSNR'); }
			set { this.Set (value, 'POSNR'); }
		}

		public String TextID {
			get { return this.getString ('TDID'); }
			set { this.Set (value, 'TDID'); }
		}

		public String TextLanguage {
			get { return this.getString ('TDSPRAS'); }
			set { this.Set (value, 'TDSPRAS'); }
		}

		public String TextIDDescription {
			get { return this.getString ('TDTEXT'); }
			set { this.Set (value, 'TDTEXT'); }
		}

		public String Text {
			get { return this.getString ('TEXT'); }
			set { this.Set (value, 'TEXT'); }
		}

	}
	public class DOC_ACTION extends ensx.EnosixFramework.ValueObject {
		public String ChangeDelivery {
			get { return this.getString ('X_CHANGE'); }
			set { this.Set (value, 'X_CHANGE'); }
		}

		public String PickDelivery {
			get { return this.getString ('X_PICK'); }
			set { this.Set (value, 'X_PICK'); }
		}

		public String PackDelivery {
			get { return this.getString ('X_PACK'); }
			set { this.Set (value, 'X_PACK'); }
		}

		public String PostGoodsIssue {
			get { return this.getString ('X_PGI'); }
			set { this.Set (value, 'X_PGI'); }
		}

		public String CopyPickedQtyToDelveryQty {
			get { return this.getString ('X_KOMUE'); }
			set { this.Set (value, 'X_KOMUE'); }
		}

		public String ProofofDelivery {
			get { return this.getString ('X_POD'); }
			set { this.Set (value, 'X_POD'); }
		}

	}
	public class ITEMS_ACTION extends ensx.EnosixFramework.ValueObject {
		public String DeliveryItem {
			get { return this.getString ('POSNR'); }
			set { this.Set (value, 'POSNR'); }
		}

		public String ItemChanged {
			get { return this.getString ('X_ITEMCHANGED'); }
			set { this.Set (value, 'X_ITEMCHANGED'); }
		}

		public String ItemDeleted {
			get { return this.getString ('X_ITEMDELETED'); }
			set { this.Set (value, 'X_ITEMDELETED'); }
		}

	}
}