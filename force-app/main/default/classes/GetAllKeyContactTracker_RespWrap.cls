public class GetAllKeyContactTracker_RespWrap {

	public class Data {
	}

	public Boolean status;
	public Data data;
	public String message;
	public Integer status_code;
	public Data errors;

	
	public static GetAllKeyContactTracker_RespWrap parse(String json) {
		return (GetAllKeyContactTracker_RespWrap) System.JSON.deserialize(json, GetAllKeyContactTracker_RespWrap.class);
	}
}