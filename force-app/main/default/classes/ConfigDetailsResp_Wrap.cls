public class ConfigDetailsResp_Wrap {

	public Boolean status;
	public Data data;
	public String message;
	public Integer status_code;
	public Errors errors;

	public class Errors {
	}

	public class Data {
		public Integer customer_id;
		public Integer user_unique_id;
		public String user_first_name;
		public String user_last_name;
		public String user_title;
		public String tracking_start_date;
		public String tracking_end_date;
		public String duration;
        public String frequency;
		public Integer contact_limit;
	}

	
	public static ConfigDetailsResp_Wrap parse(String json) {
		return (ConfigDetailsResp_Wrap) System.JSON.deserialize(json, ConfigDetailsResp_Wrap.class);
	}
}