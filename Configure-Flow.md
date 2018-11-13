### Configure MS Flow.
1. Select When Item is created
1. Enter the parent site url of your intake list and then select the name of the list.
1. Select Approval from the Actions.  Put the email of the approver(s), configure the content.
1. Next step, select HTTP.  
1. Select POST
1. In "Body", put the request in JSON format
Values with underscores around are the names of the dynamic content value.  If you are select a non-text field (Choice etc, make sure you select the column name Value from Dynamic Content.
{"Title": "_Title_","Application":"_Application Value_","Env":"_Env Value_","Type":"_InstanceType_"}.

Keys are the values you put in LambdaInput and Body mapping template.  Values are column names from SPO List.
