public class ProcessedContactReqWrap {

public class Errors {
	}

	//public Boolean status;
	public List<Data> data;
	

	public class Data {
		public Integer customer_id;
		public Integer user_unique_id;
		public String unique_id;
		public String salesforce_contact_id;
		public String contact_first_name;
		public String contact_last_name;
		public String new_designation;
		public String salesforce_account_id;
		public String new_company_name;	
		public String new_company_website_url;
		public String new_email_id;
		public String contact_company_status;
        public String previos_company_name;
        public String previos_website;
        public String previos_designation;
        public String previos_email_Id;
      	public String start_date;
        
        
	}	
	public static ProcessedContactReqWrap parse(String json) {
		return (ProcessedContactReqWrap) System.JSON.deserialize(json, ProcessedContactReqWrap.class);
	}
    
    
}