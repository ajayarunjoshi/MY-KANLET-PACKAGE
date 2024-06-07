public class UploadKContact_ResWrap {

	public class Errors {
	}

	public Boolean status;
	public List<Data> data;
	public String message;
	public Integer status_code;
	public Errors errors;

	public class Data {
		public Integer customer_id;
		public Integer user_unique_id;
		public String unique_id;
		public String salesforce_contact_id;
		public String contact_first_name;
		public String contact_last_name;
		public String contact_title;
		public String salesforce_account_id;
		public String contact_company_name;
		public String contact_company_website_url;
		public String contact_email;
		public String contact_company_status;
	}

	
	public static UploadKContact_ResWrap parse(String json) {
		return (UploadKContact_ResWrap) System.JSON.deserialize(json, UploadKContact_ResWrap.class);
	}
    
    
    
}