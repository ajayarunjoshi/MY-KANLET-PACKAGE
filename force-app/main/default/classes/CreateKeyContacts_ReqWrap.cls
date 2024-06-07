public class CreateKeyContacts_ReqWrap {


	public string customer_id;	//2
	public String customer_name;	//Krios Info Solution
	public string user_unique_id;	//2
	public cls_industry[] industry;
	public cls_employee_count[] employee_count;
	public cls_location_country[] location_country;
	public cls_location_state[] location_state;
	public cls_location_city[] location_city;
	public cls_revenue[] revenue;
	public cls_job_title_function[] job_title_function;
	public cls_job_title_seniority[] job_title_seniority;
	public cls_job_title[] job_title;
	public cls_last_funding_status[] last_funding_status;
	public cls_tech_stack[] tech_stack;
	public class cls_industry {
		
	}
	class cls_employee_count {
	
	}
	class cls_location_country {
		
	}
	class cls_location_state {
	
	}
	class cls_location_city {
	
	}
	class cls_revenue {
	
	}
	class cls_job_title_function {
	
	}
	class cls_job_title_seniority {
	
	}
	class cls_job_title {
		
	}
	class cls_last_funding_status {
	
	}
	class cls_tech_stack {
	
	}
	

	
		   
    

	public static CreateKeyContacts_ReqWrap parse(String json) {
		return (CreateKeyContacts_ReqWrap) System.JSON.deserialize(json, CreateKeyContacts_ReqWrap.class);
	}
}