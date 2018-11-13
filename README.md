# EC2-Request-System

Here is a quick proof of concept that allow stream-lined intake to request EC2 instances in AWS.  It enforces configuration management

Here is the process flow:
1. Intake - SharePoint Online - you can also integrate Power Apps.  Users fill out a simple form that takes a few fields (server name, environment, application, instance type).
1. Approval Workflow - Microsoft Flow.  The request is sent to a stake holder to approve.
1. Once approved, a dynamic HTTP request is sent to API Gateway, which parses the body of the HTTP POST request.
1. Lambda takes the HTTP Body and kicks off a function written in PowerShell Core. 

Side Note: My customer uses AWS and Office 365, no plans for Azure as of yet. Hence why this solution was written for AWS. 

The benefit here is that you can enforce approvals, transparency (who requested and approved what), configuration management (Security Groups, IAM Roles, Instance Size, User Data, AMIs) etc.
