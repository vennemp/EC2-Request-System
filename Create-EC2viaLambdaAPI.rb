require 'json'
require 'aws-sdk-ec2'

def lambda_handler(event:, context:)
ec2 = Aws::EC2::Resource.new(region: 'us-east-1')

if event['Env'] == "Development"
  inst_subnet = "subnet-0998011da433ddcfb" ##datasandbox05
  inst_securitygroup = "sg-e1c3de8d" ##internalany
elsif event['Env'] == "Central Services"
  inst_subnet = "subnet-621bcf6d" ##web 1f
  inst_securitygroup = "sg-e2f76094" ##DR_Mgt_WinTemp
elsif event['Env'] == "Evaluation"
  inst_subnet = "subnet-0998011da433ddcfb" ##CSR-PrivateSubnet-1b
  inst_securitygroup = "subnet-08006f833b2607317" ##default
end
 
image = ec2.images({filters: [{name: "name", values: ["CFPB_Windows_2012R2_Standard_Image"]}]})
inst_imageid = image.first.id

inst_userdata = "PHBvd2Vyc2hlbGw+Ck5ldy1JdGVtIC1QYXRoIGM6XGJvb3RzdHJhcCAtSXRlbVR5cGUgZGlyZWN0b3J5CkdldC1TM09iamVjdCAtQnVja2V0TmFtZSBjZnBiLWJvb3RzdHJhcCAtS2V5UHJlZml4IGJvb3RzdHJhcCB8IENvcHktUzNPYmplY3QgLUJ1Y2tldE5hbWUgY2ZwYi1ib290c3RyYXAgLWxvY2FsZm9sZGVyIGM6XGJvb3RzdHJhcCAtU2VydmVyU2lkZUVuY3J5cHRpb25DdXN0b21lclByb3ZpZGVkS2V5IDVWRDA2WGFaQnVocG1wQUNhZ01mY1E5WWtUSml4ejFUYzc3Q0dYRzNWVEk9IC1TZXJ2ZXJTaWRlRW5jcnlwdGlvbkN1c3RvbWVyTWV0aG9kIGFlczI1NgpzZXQtbG9jYXRpb24gYzpcYm9vdHN0cmFwCi4vYm9vdHN0cmFwLWF3cy13aW5kb3dzLnBzMQo8L3Bvd2Vyc2hlbGw+"

instance = ec2.create_instances({
  image_id: inst_imageid,
  min_count: 1,
  max_count: 1,
  key_name: 'DR_Windows',
  instance_type: 't2.micro',
  subnet_id: inst_subnet,
  security_group_ids: [inst_securitygroup],
  user_data: inst_userdata,
    tag_specifications: [
    {
      resource_type: "instance", 
      tags: [
        {
          key: "Name",
          value: event['Title'],
        },
        {
          key: "Application",
          value: event['Application'],
        },
      ],
    },
  ],
  iam_instance_profile: {
    arn: 'arn:aws:iam::626560329871:instance-profile/se_Windows_Bootstrap'
  }
  })
  
  #puts event
  { eventdata: event, statusCode: 200, body: { privateIP: instance.first.private_ip_address , instanceID: instance.first.id} }
end
