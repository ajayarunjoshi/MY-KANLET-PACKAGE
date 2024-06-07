public class GetKeyContact_ResWrap {

	public class Errors {
	}

	public Boolean status;
	public Data data;
	public String message;
	public Integer status_code;
	public Errors errors;

	public class Data {
		public Integer customer_id;
		public String customer_name;
		public Integer user_unique_id;
		public List<String> industry;
		public List<String> location_city;
		public List<String> location_state;
		public List<String> location_country;
		public List<String> employee_count;
		public List<String> revenue;
		public List<String> job_title_function;
		public List<String> job_title_seniority;
		public List<String> job_title;
		public List<String> last_funding_status;
		public List<String> tech_stack;
	}

	
	public static GetKeyContact_ResWrap parse(String json) {
		return (GetKeyContact_ResWrap) System.JSON.deserialize(json, GetKeyContact_ResWrap.class);
	}
}