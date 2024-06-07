public class UserProfileAPI_RespWrapper {
    public string error;
	public class Errors {
	}

	public Boolean status;
	public Data data;
	public String message;
	public Integer status_code;
	public string errors;

	public class Data {
		public Integer customer_id;
		public Integer user_unique_id;
		public String first_name;
		public String last_name;
		public String email;
		public String role;
		public String organization_name;
		public String phone_number;
		public String phone_country_code;
		public String department;
		public Object user_photo_url;
	}

	
	public static UserProfileAPI_RespWrapper parse(String json) {
		return (UserProfileAPI_RespWrapper) System.JSON.deserialize(json, UserProfileAPI_RespWrapper.class);
	}
}