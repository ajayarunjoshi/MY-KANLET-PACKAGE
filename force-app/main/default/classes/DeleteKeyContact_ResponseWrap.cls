public class DeleteKeyContact_ResponseWrap {

	public String detail;

	
	public static DeleteKeyContact_ResponseWrap parse(String json) {
		return (DeleteKeyContact_ResponseWrap) System.JSON.deserialize(json, DeleteKeyContact_ResponseWrap.class);
	}
}