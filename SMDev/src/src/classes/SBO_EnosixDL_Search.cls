public with sharing class SBO_EnosixDL_Search extends ensx.EnosixFramework.SearchSBO {

	public SBO_EnosixDL_Search() {
		super('EnosixDL', SBO_EnosixDL_Search.EnosixDL_SC.class, SBO_EnosixDL_Search.EnosixDL_SR.class);
	}

	public class EnosixDL_SC extends ensx.EnosixFramework.SearchContext {
		public EnosixDL_SC() {
			super(new Map<string, type> {
				'SEARCHPARAMS' => SBO_EnosixDL_Search.SEARCHPARAMS.class

			});
		}

		public SBO_EnosixDL_Search.SEARCHPARAMS SEARCHPARAMS {
			get
			{
				return (SEARCHPARAMS)this.getStruct(SBO_EnosixDL_Search.SEARCHPARAMS.class);
			}
		}
	}

	public EnosixDL_SC SearchContext {
		get { return ( EnosixDL_SC)this.getSearchContext(); }
	}

	public class EnosixDL_SR extends ensx.EnosixFramework.SearchResult {
		public EnosixDL_SR() {
			super(new Map<string, type> {'SEARCHRESULT' => SBO_EnosixDL_Search.SEARCHRESULT.class } );
		}

		public ensx.EnosixFramework.FrameworkCollection SearchResults {
			get { return super.getCollection(SBO_EnosixDL_Search.SEARCHRESULT.class); }
		}

		public List<SEARCHRESULT> getResults() {
			List<SEARCHRESULT> results = new List<SEARCHRESULT>();
			SearchResults.copyTo(results);
			return results;
		}
	}

	public EnosixDL_SR execute() {
		return (EnosixDL_SR)super.executeSearch();
	}

	public class SEARCHPARAMS extends ensx.EnosixFramework.ValueObject {
		public String Route {
			get { return this.getString ('ROUTE'); }
			set { this.Set (value, 'ROUTE'); }
		}

		public String Truck {
			get { return this.getString ('TRAID'); }
			set { this.Set (value, 'TRAID'); }
		}

		public Date FromCreateDate {
			get { return this.getDate ('ERDAT_FR'); }
			set { this.Set (value, 'ERDAT_FR'); }
		}

		public Date ToCreateDate {
			get { return this.getDate ('ERDAT_TO'); }
			set { this.Set (value, 'ERDAT_TO'); }
		}

		public DateTime DeliveryDateFrom {
			get { return this.getDate ('LFDAT_FR'); }
			set { this.Set (value, 'LFDAT_FR'); }
		}

		public DateTime DeliveryDateTo {
			get { return this.getDate ('LFDAT_TO'); }
			set { this.Set (value, 'LFDAT_TO'); }
		}

		public String DeliveryFrom {
			get { return this.getString ('VBELN_FR'); }
			set { this.Set (value, 'VBELN_FR'); }
		}

		public String DeliveryTo {
			get { return this.getString ('VBELN_TO'); }
			set { this.Set (value, 'VBELN_TO'); }
		}

		public String SoldToParty {
			get { return this.getString ('KUNAG'); }
			set { this.Set (value, 'KUNAG'); }
		}

		public String ShipToParty {
			get { return this.getString ('KUNWE'); }
			set { this.Set (value, 'KUNWE'); }
		}

		public String DeliveryType {
			get { return this.getString ('LFART'); }
			set { this.Set (value, 'LFART'); }
		}

		public String ShippingPoint {
			get { return this.getString ('VSTEL'); }
			set { this.Set (value, 'VSTEL'); }
		}

		public String ShippingConditions {
			get { return this.getString ('VSBED'); }
			set { this.Set (value, 'VSBED'); }
		}

		public String DeliveryPriority {
			get { return this.getString ('LPRIO'); }
			set { this.Set (value, 'LPRIO'); }
		}

		public String BillofLading {
			get { return this.getString ('BOLNR'); }
			set { this.Set (value, 'BOLNR'); }
		}

		public DateTime PGIDateFrom {
			get { return this.getDate ('WADAT_FR'); }
			set { this.Set (value, 'WADAT_FR'); }
		}

		public DateTime PGIDateTo {
			get { return this.getDate ('WADAT_TO'); }
			set { this.Set (value, 'WADAT_TO'); }
		}

		public String Username {
			get { return this.getString ('USERNAME'); }
			set { this.Set (value, 'USERNAME'); }
		}

		public String Open {
			get { return this.getString ('X_OPEN'); }
			set { this.Set (value, 'X_OPEN'); }
		}

		public String Picked {
			get { return this.getString ('X_PICKED'); }
			set { this.Set (value, 'X_PICKED'); }
		}

		public String Packed {
			get { return this.getString ('X_PACKED'); }
			set { this.Set (value, 'X_PACKED'); }
		}

		public String PGIed {
			get { return this.getString ('X_PGIED'); }
			set { this.Set (value, 'X_PGIED'); }
		}

	}
	public class SEARCHRESULT extends ensx.EnosixFramework.ValueObject {
		public String Delivery {
			get { return this.getString ('VBELN'); }
			set { this.Set (value, 'VBELN'); }
		}

		public String Route {
			get { return this.getString ('ROUTE'); }
			set { this.Set (value, 'ROUTE'); }
		}

		public String Truck {
			get { return this.getString ('TRAID'); }
			set { this.Set (value, 'TRAID'); }
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

		public String SoldToName {
			get { return this.getString ('KUNAG_NAME'); }
			set { this.Set (value, 'KUNAG_NAME'); }
		}

		public String SoldToCity {
			get { return this.getString ('KUNAG_CITY1'); }
			set { this.Set (value, 'KUNAG_CITY1'); }
		}

		public String SoldToRegion {
			get { return this.getString ('KUNAG_REGION'); }
			set { this.Set (value, 'KUNAG_REGION'); }
		}

		public String ShipToParty {
			get { return this.getString ('KUNWE'); }
			set { this.Set (value, 'KUNWE'); }
		}

		public String ShipToName {
			get { return this.getString ('KUNWE_NAME'); }
			set { this.Set (value, 'KUNWE_NAME'); }
		}

		public String ShipToCity {
			get { return this.getString ('KUNWE_CITY1'); }
			set { this.Set (value, 'KUNWE_CITY1'); }
		}

		public String ShipToRegion {
			get { return this.getString ('KUNWE_REGION'); }
			set { this.Set (value, 'KUNWE_REGION'); }
		}

		public String ShippingPoint {
			get { return this.getString ('VSTEL'); }
			set { this.Set (value, 'VSTEL'); }
		}

		public String ShippingConditions {
			get { return this.getString ('VSBED'); }
			set { this.Set (value, 'VSBED'); }
		}

		public String DeliveryPriority {
			get { return this.getString ('LPRIO'); }
			set { this.Set (value, 'LPRIO'); }
		}

		public Decimal NetOrderValue {
			get { return this.getDecimal ('NETWR'); }
			set { this.Set (value, 'NETWR'); }
		}

		public String SalesDocumentCurrency {
			get { return this.getString ('WAERK'); }
			set { this.Set (value, 'WAERK'); }
		}

		public String DeliveryStatus {
			get { return this.getString ('DELV_STAT'); }
			set { this.Set (value, 'DELV_STAT'); }
		}

	}

}