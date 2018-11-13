### Configuring API Gateway

1. Create your resource in API Gateway. (essentially just the path in your parent URL string)
1. Create a POST Method.
1. Select Lambda.  Select your new Lambda function for your PS Core function.  
1. Select Integration Request. Go to body mapping template.  For content type put: application/json
1. In the template, put the following:
```json
{
"Title" : $input.json('$.Title'),
"Application" : $input.json('$.Application'),
"Type" : $input.json('$.Type'),
"Env" : $input.json('$.Env')
}
```

Your are taking the $input from the http request and parsing it with the json method.  You will need to do this for any of the values you will be passing from SPO to API Gateway/Lambda.  This tells API Gateway how to parse the body of the incoming message so it can be passed to Lambda.
1. (Optional) You can turn on request validation to enforce the schema of the http request in Method Request section.  
1. (Coming soon) Configuring security...


Feel free to test your API at this point.
###
DEPLOY YOUR API, it will not be live.

Copy your request URL this is what you put in Flow.
