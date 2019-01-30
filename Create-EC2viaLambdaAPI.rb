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

#make sure user data is base64 encoded... you can do this in the script with the base64 sdk...
inst_userdata = "BASE64GOBBLEDYGOOK"

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
