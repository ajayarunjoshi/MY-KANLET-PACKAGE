public class KLicenseReq_Wrap {

	public Data data;

	public class Data {
		public Integer customer_id;
		public Integer user_unique_id;
		public String user_first_name;
		public String user_last_name;
		public String user_title;
		public String tracking_start_date;
		public String tracking_end_date;
		public String duration;
		public Integer contact_limit;
        Public String frequency;
	}

	
	public static KLicenseReq_Wrap parse(String json) {
		return (KLicenseReq_Wrap) System.JSON.deserialize(json, KLicenseReq_Wrap.class);
	}
}