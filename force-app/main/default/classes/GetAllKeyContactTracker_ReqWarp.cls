public class GetAllKeyContactTracker_ReqWarp {

	public Integer customer_id;
	public Integer user_unique_id;

	
	public static GetAllKeyContactTracker_ReqWarp parse(String json) {
		return (GetAllKeyContactTracker_ReqWarp) System.JSON.deserialize(json, GetAllKeyContactTracker_ReqWarp.class);
	}
}