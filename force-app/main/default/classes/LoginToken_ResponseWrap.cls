public class LoginToken_ResponseWrap {

	public class Errors {
    }
    public class Data {
        public Integer user_unique_id;
        public String first_name;
        public String last_name;
        public String email;
        public String refresh_token;
        public String access_token;
        public Integer customer_id;
    }
    public Boolean status;
    public Data data;
    public String message;
    public Integer status_code;
    public Errors errors;
    
    public static LoginToken_ResponseWrap parse(String json) {
        return (LoginToken_ResponseWrap) System.JSON.deserialize(json, LoginToken_ResponseWrap.class);
    }
}