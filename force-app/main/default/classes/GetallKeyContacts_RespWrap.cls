public class GetallKeyContacts_RespWrap {

	public class Errors {
	}

	public string status;
	public List<Data> data;
	public String message;
	public Integer status_code;
	public Errors errors;

	public class Data {
		public Integer customer_id;
		public Integer user_unique_id;
		public Integer unique_id;
		public Integer salesforce_contact_id;
		public String contact_first_name;
		public String contact_last_name;
		public String contact_title;
		public Integer salesforce_account_id;
		public String contact_company_name;
		public String contact_company_website_url;
		public String contact_email;
		public string contact_company_status;
	}
    // Define the parse method to deserialize JSON
    public static GetallKeyContacts_RespWrap parse(String json) {
        return (GetallKeyContacts_RespWrap) System.JSON.deserialize(json, GetallKeyContacts_RespWrap.class);
    }
}