### Create a WAF that allows only requests from

After you have Flow set up to make the HTTP requests to API Gateway.  You must determine the specific User agent sent by that workflow.  

Uncomment the section in the PS1 script with the write-host convertto-json $lambdainput (if it isn't already).
Switch your lambda function to Lamda Proxy integration.  MAKE SURE TO COPY YOUR BODY MAPPING TEMPLATES to a text file- especially if they are complex.
Deploy your API.  

Make a test request from your SPO/Flow app.  It must be the same workflow you will be using. It doesn't matter if it fails to create an EC2 instance properly, we just want the headers..

Go to Cloud Watch logs for your Lambda function.  Find an entry that looks like this:

```
[Information] -
{
    "resource": "/create-instance",
    "path": "/create-instance",
    "httpMethod": "POST",
    "headers": {
        "Accept-Encoding": "gzip, deflate",
        "Accept-Language": "en-US",
        "Content-Type": "application/json; charset=utf-8",
        "Host": "c9z6llmqmi.execute-api.us-east-1.amazonaws.com",
        "User-Agent": "azure-logic-apps/1.0 (workflow fb6f6ffe7cf84df7beee4b7a9f9036ac; version 08586595368134558043)",
        "X-Amzn-Trace-Id": "Root=1-5bea6049-4f32ec22bb6b29e6851ed8be",
        "X-Forwarded-For": "40.118.244.241",
        "X-Forwarded-Port": "443",
        "X-Forwarded-Proto": "https",
        "x-ms-action-tracking-id": "728fd589-98bc-4c27-80f5-ef33f930eb85",
        "x-ms-activity-vector": "IN.11.IN.09.IN.0Z",
        "x-ms-client-request-id": "14ac8e8d-9f7c-4db0-9a3c-f2fe0d671a86",
        "x-ms-client-tracking-id": "08586595201664692963773773294CU53",
        "x-ms-correlation-id": "14ac8e8d-9f7c-4db0-9a3c-f2fe0d671a86",
        "x-ms-execution-location": "westus",
        "x-ms-tracking-id": "14ac8e8d-9f7c-4db0-9a3c-f2fe0d671a86",
        "x-ms-workflow-id": "fb6f6ffe7cf84df7beee4b7a9f9036ac",
        "x-ms-workflow-name": "a3113776-3e4c-4662-9953-4299d7f2492f",
        "x-ms-workflow-operation-name": "HTTP",
        "x-ms-workflow-resourcegroup-name": "CF4C90BD1F39414E851EB5CBEE5EBD95-2854B3C586E849A8A97D2DE59E315FC6",
        "x-ms-workflow-run-id": "08586595201664692962773773294CU82",
        "x-ms-workflow-run-tracking-id": "7295df09-c685-454a-ad7d-779a11207986",
        "x-ms-workflow-subscription-id": "72c9792d-e7e6-4eb5-b764-fc599b9b3005",
        "x-ms-workflow-system-id": "/locations/westus/scaleunits/prod-31/workflows/fb6f6ffe7cf84df7beee4b7a9f9036ac",
        "x-ms-workflow-version": "08586595368134558043"
    ```
    
    Find the entry User-Agent.  copy everything up to the ; (everything before version).  This is the specific workflow user agent - essentially the dedicated unique browser session of that workflow.
    
    Create a WAF and create a rule that only allows requests with the headers that contains that user agent.
    Apply the firewall to your stage. Disable lambda proxy integration, re-enter your body mapping templates.
    
    Deploy!
        
        
