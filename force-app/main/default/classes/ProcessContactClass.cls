public class ProcessContactClass {

	public List<Records> records {get;set;} 

	public ProcessContactClass(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'records') {
						records = arrayOfRecords(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ProcessContactClass consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Attributes {
		public String type {get;set;} 
		public String referenceId {get;set;} 

		public Attributes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type = parser.getText();
						} else if (text == 'referenceId') {
							referenceId = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Records {
		public Attributes attributes {get;set;} 
		public String First_Name {get;set;} 
		public String Last_Name {get;set;} 
		public String Company {get;set;} 
		public String Company_Website {get;set;} 
		public String New_Company {get;set;} 
		public String New_Email_Id {get;set;} 
		public String New_Company_Website {get;set;} 
		public String New_Designation {get;set;} 

		public Records(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attributes') {
							attributes = new Attributes(parser);
						} else if (text == 'First_Name__c') {
							First_Name = parser.getText();
						} else if (text == 'Last_Name__c') {
							Last_Name = parser.getText();
						} else if (text == 'Company__c') {
							Company = parser.getText();
						} else if (text == 'Company_Website__c') {
							Company_Website = parser.getText();
						} else if (text == 'New_Company__c') {
							New_Company = parser.getText();
						} else if (text == 'New_Email_Id__c') {
							New_Email_Id = parser.getText();
						} else if (text == 'New_Company_Website__c') {
							New_Company_Website = parser.getText();
						} else if (text == 'New_Designation__c') {
							New_Designation = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Records consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ProcessContactClass parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ProcessContactClass(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<Records> arrayOfRecords(System.JSONParser p) {
        List<Records> res = new List<Records>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Records(p));
        }
        return res;
    }



}