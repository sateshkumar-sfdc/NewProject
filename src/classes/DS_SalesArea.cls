public interface DS_SalesArea {
	// Master Data
    RFC_SD_GET_SALES_AREAS.RESULT getSalesAreas();
    RFC_SD_GET_GROUP_OFFICE.RESULT getGroupOffice();
    RFC_SD_GET_PRICING_STAT.RESULT getPricingStat();
    RFC_SD_GET_SHIP_INFO.RESULT getShipInfo();
    void updateSalesArea(SBO_EnosixCustomer_Detail.SALES_DATA sd);
    // Sales area to edit/display
	SBO_EnosixCustomer_Detail.SALES_DATA getSALES_DATA();
}