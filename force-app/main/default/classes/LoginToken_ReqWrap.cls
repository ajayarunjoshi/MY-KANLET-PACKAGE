public class LoginToken_ReqWrap {

	public String email;
    public String password;
    
    public static LoginToken_ReqWrap parse(String json) {
        return (LoginToken_ReqWrap) System.JSON.deserialize(json, LoginToken_ReqWrap.class);
    }
}