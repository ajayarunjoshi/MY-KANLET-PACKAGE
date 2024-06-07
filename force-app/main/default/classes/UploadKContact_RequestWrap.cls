public class UploadKContact_RequestWrap {

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
 //   public string error_message;
	
	public static List<UploadKContact_RequestWrap> parse(String json) {
		return (List<UploadKContact_RequestWrap>) System.JSON.deserialize(json, List<UploadKContact_RequestWrap>.class);
	}
}