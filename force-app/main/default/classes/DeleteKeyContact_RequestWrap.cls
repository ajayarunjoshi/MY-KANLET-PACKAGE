public class DeleteKeyContact_RequestWrap {

	public Integer user_unique_id;
	public Integer unique_id;

	
	public static List<DeleteKeyContact_RequestWrap> parse(String json) {
		return (List<DeleteKeyContact_RequestWrap>) System.JSON.deserialize(json, List<DeleteKeyContact_RequestWrap>.class);
	}
}