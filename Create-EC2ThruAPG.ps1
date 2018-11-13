
### DO NOT REMOVE THE REQUIRES LINE BELOW.  This is required for Lambda and where we declare modules.
# More info https://aws.amazon.com/blogs/developer/announcing-lambda-support-for-powershell-core/
#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.365.0'}
### For this Proof of concept, You can customize the values of VPC ip, instance type etc.
#Uncomment below line to send the input to CloudWatch for debugging. 
# $lambainput is the input object from the event that started the function. Treat it like a normal $psobject in terms of syntax for accessing properties
# The values are from the columns in SharePoint which are copied and sent.  
# This function has 4 values it received from MS Flow:
# Env = Which determines the VPC
# Title = Which determines the Name Tag
# Application = which determines the Application tag
# Type = which determines the Instance Type (M,C,T)

#Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)
#

### First check what VPC, so we can get the subnets and security groups for that VPC only.
if ($lambdainput.Env -eq "Prod")
{$VPC = "vpc-xxxxxxx"}
elseif ($lambdainput.Env -eq "Dev")
{$VPC = "vpc-xxxxxxxxx"}

### This next part selects a random subnet in that VPC, obviously you can enforce the subnet values if you want.
$subnetcount=(Get-EC2Subnet | where {$_.VpcId -eq $VPC}).Count
$SubIndex=Get-Random -Minimum 0 -Maximum $subnetcount
$subnet = (Get-EC2Subnet | where {$_.VpcId -eq $VPC})[$SubIndex].SubnetId

# Enter your AMI.  If you have a standard image, you can put that here.
$ami = "ami-xxxxxxxxxxxx"

# Security group.  I just get the default one.

$secgroup = Get-EC2SecurityGroup | where {$_.VPCID -EQ $VPC -and $_.GroupName -eq "Default"}

# Select Instance Type. I am only passing the Class letter, which then determines the instance type.
if ($lambdainput.Type -eq "M")
{$instancetype = "m4.large"}
elseif ($lambdainput.Type -eq "C")
{$instancetype = "C4.large"}
elseif ($lambdainput.Type -eq "T")
{$instancetype = "T2.large"}

#Create the Application and Name tags.

$nametagobject=New-Object -TypeName Amazon.EC2.Model.Tag -ArgumentList @('Name', $lambdainput.Title)
$apptagobject = New-Object -TypeName Amazon.EC2.Model.Tag -ArgumentList @('Application', $lambdainput.Application)
$tagspec = New-Object -TypeName Amazon.ec2.model.tagspecification
$tagspec.ResourceType = "instance"
$tagspec.Tags = $nametagobject
$tagspec.Tags.Add($apptagobject)

# Create instance and attach tags.  Here is where you can enfore a IAM Role, PEM Key, or User data (I don't declare that), Check my aws-windows-bootstrap repo for a great user data script to prep windows images
New-EC2Instance -SubnetId $subnet -ImageId $ami -SecurityGroupId $secgroup.GroupId -InstanceType $instancetype -InstanceProfile_Name ROLENAME -KeyName MYKEY -TagSpecification $tagspec

