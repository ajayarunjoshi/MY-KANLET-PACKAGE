public class CreateKeyContacts_ResWrap {

   
	public Boolean status;
	public Data data;
	public String message;
	public Integer status_code;
	public Data errors;

	public class Data {
	}

	
	public static CreateKeyContacts_ResWrap parse(String json) {
		return (CreateKeyContacts_ResWrap) System.JSON.deserialize(json, CreateKeyContacts_ResWrap.class);
	}
}