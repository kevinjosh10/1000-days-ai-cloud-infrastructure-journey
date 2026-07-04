# AWS Solution Architect - Mock 3 Detailed Solutions

This document contains a detailed explanation and solution breakdown for every question in the mock-3 assessment.

---

## Question 1

### Problem Statement & Options
A company hosted a web application in an Auto Scaling group of EC2 instances. The IT manager is concerned about the over-provisioning of the resources that can cause higher operating costs. A Solutions Architect has been instructed to create a cost-effective solution without affecting the performance of the application.

Which dynamic scaling policy should be used to satisfy this requirement?

Use suspend and resume scaling.
Use target tracking scaling.
Use scheduled scaling.
Use simple scaling.

### Detailed Solution Explanation
An Auto Scaling group contains a collection of Amazon EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management. An Auto Scaling group also enables you to use Amazon EC2 Auto Scaling features such as health check replacements and scaling policies. Both maintaining the number of instances in an Auto Scaling group and automatic scaling are the core functionality of the Amazon EC2 Auto Scaling service. The size of an Auto Scaling group depends on the number of instances that you set as the desired capacity. You can adjust its size to meet demand, either manually or by using automatic scaling.

Step scaling policies and simple scaling policies are two of the dynamic scaling options available for you to use. Both require you to create CloudWatch alarms for the scaling policies. Both require you to specify the high and low thresholds for the alarms. Both require you to define whether to add or remove instances, and how many, or set the group to an exact size. The main difference between the policy types is the step adjustments that you get with step scaling policies. When step adjustments are applied, and they increase or decrease the current capacity of your Auto Scaling group, the adjustments vary based on the size of the alarm breach.



The primary issue with simple scaling is that after a scaling activity is started, the policy must wait for the scaling activity or health check replacement to complete and the cooldown period to expire before responding to additional alarms. Cooldown periods help to prevent the initiation of additional scaling activities before the effects of previous activities are visible.

With a target tracking scaling policy, you can increase or decrease the current capacity of the group based on a target value for a specific metric. This policy will help resolve the over-provisioning of your resources. The scaling policy adds or removes capacity as required to keep the metric at, or close to, the specified target value. In addition to keeping the metric close to the target value, a target tracking scaling policy also adjusts to changes in the metric due to a changing load pattern.

Hence, the correct answer is: Use target tracking scaling.

The option that says: Use simple scaling is incorrect because you need to wait for the cooldown period to complete before initiating additional scaling activities. Target tracking or step scaling policies can trigger a scaling activity immediately without waiting for the cooldown period to expire.

The option that says: Use scheduled scaling is incorrect because this policy is mainly used for predictable traffic patterns. You need to use the target tracking scaling policy to optimize the cost of your infrastructure without affecting the performance.

The option that says: Use suspend and resume scaling is incorrect because this type is used to temporarily pause scaling activities triggered by your scaling policies and scheduled actions.

 

**References:**

https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html

https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html

 

Check out this AWS Auto Scaling Cheat Sheet:

https://tutorialsdojo.com/aws-auto-scaling/

---

## Question 2

### Problem Statement & Options
A company is using AWS IAM to manage access to AWS services. The Solutions Architect of the company created the following IAM policy for AWS Lambda:

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"lambda:CreateFunction",
"lambda:DeleteFunction"
],
"Resource": "*"
},
{
"Effect": "Deny",
"Action": [
"lambda:CreateFunction",
"lambda:DeleteFunction",
"lambda:InvokeFunction",
"lambda:TagResource"
],
"Resource": "*",
"Condition": {
"IpAddress": {
"aws:SourceIp": "187.5.104.11/32"
}
}
}
]
}

Which of the following options is allowed by this policy?


Create an AWS Lambda function using the 187.5.104.11/32 address.

Create an AWS Lambda function using the 100.220.0.11/32 address.
Delete an AWS Lambda function from any network address.

Delete an AWS Lambda function using the 187.5.104.11/32 address.

### Detailed Solution Explanation
You manage access in AWS by creating policies and attaching them to IAM identities (users, groups of users, or roles) or AWS resources. A policy is an object in AWS that, when associated with an identity or resource, defines their permissions. AWS evaluates these policies when an IAM principal (user or role) makes a request. Permissions in the policies determine whether the request is allowed or denied. Most policies are stored in AWS as JSON documents.

 JSON policy document structure 

You can use AWS Identity and Access Management (IAM) to manage access to the Lambda API and resources like functions and layers. Based on the given IAM policy, you can create and delete a Lambda function from any network address except for the IP address 187.5.104.11/32. Since the IP address 100.220.0.11/32 is not denied in the policy, you can use this address to create a Lambda function.

Hence, the correct answer is: Create an AWS Lambda function using the 100.220.0.11/32 address.

The option that says: Delete an AWS Lambda function using the 187.5.104.11/32 address is incorrect because the source IP used in this option is denied by the IAM policy.

The option that says: Delete an AWS Lambda function from any network address is incorrect. You can’t delete a Lambda function from any network address because the address 187.5.104.11/32 is denied by the policy.

The option that says: Create an AWS Lambda function using the 187.5.104.11/32 address is incorrect. Just like the option above, the IAM policy denied the IP address 187.5.104.11/32.

 

**References:**

https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html

https://docs.aws.amazon.com/lambda/latest/dg/lambda-permissions.html

 

Check out this AWS IAM Cheat Sheet:

https://tutorialsdojo.com/aws-identity-and-access-management-iam/

---

## Question 3

### Problem Statement & Options
A Solutions Architect is designing a monitoring application which generates audit logs of all operational activities of the company’s cloud infrastructure. Their IT Security and Compliance team mandates that the application retain the logs for 5 years before the data can be deleted.

How can the Architect meet the above requirement?

Store the audit logs in a Glacier vault and use the Vault Lock feature.
Store the audit logs in an EFS volume and use Network File System version 4 (NFSv4) file-locking mechanism.
Store the audit logs in an Amazon S3 bucket and enable Multi-Factor Authentication Delete (MFA Delete) on the S3 bucket.
Store the audit logs in an EBS volume and then take EBS snapshots every month.

### Detailed Solution Explanation
An Amazon S3 Glacier (Glacier) vault can have one resource-based vault access policy and one Vault Lock policy attached to it. A Vault Lock policy is a vault access policy that you can lock. Using a Vault Lock policy can help you enforce regulatory and compliance requirements. Amazon S3 Glacier provides a set of API operations for you to manage the Vault Lock policies.



As an example of a Vault Lock policy, suppose that you are required to retain archives for one year before you can delete them. To implement this requirement, you can create a Vault Lock policy that denies users permission to delete an archive until the archive has existed for one year. You can test this policy before locking it down. After you lock the policy, the policy becomes immutable. For more information about the locking process, see Amazon S3 Glacier Vault Lock. If you want to manage other user permissions that can be changed, you can use the vault access policy

Amazon S3 Glacier supports the following archive operations: Upload, Download, and Delete. Archives are immutable and cannot be modified. Hence, the correct answer is to store the audit logs in a Glacier vault and use the Vault Lock feature.

Storing the audit logs in an EBS volume and then taking EBS snapshots every month is incorrect because this is not a suitable and secure solution. Anyone who has access to the EBS Volume can simply delete and modify the audit logs. Snapshots can be deleted too.

Storing the audit logs in an Amazon S3 bucket and enabling Multi-Factor Authentication Delete (MFA Delete) on the S3 bucket is incorrect because this would still not meet the requirement. If someone has access to the S3 bucket and also has the proper MFA privileges, then the audit logs can be edited.

Storing the audit logs in an EFS volume and using Network File System version 4 (NFSv4) file-locking mechanism is incorrect because the data integrity of the audit logs can still be compromised if it is stored in an EFS volume with Network File System version 4 (NFSv4) file-locking mechanism and hence, not suitable as storage for the files. Although it will provide some sort of security, the file lock can still be overridden and the audit logs might be edited by someone else.

 

**References:**

https://docs.aws.amazon.com/amazonglacier/latest/dev/vault-lock.html

https://docs.aws.amazon.com/amazonglacier/latest/dev/vault-lock-policy.html

https://aws.amazon.com/blogs/aws/glacier-vault-lock/

 

Check out this Amazon S3 Glacier Cheat Sheet:

https://tutorialsdojo.com/amazon-glacier/

---

## Question 4

### Problem Statement & Options
A company is running a dashboard application on a Spot EC2 instance inside a private subnet. The dashboard is reachable via a domain name that maps to the private IPv4 address of the instance’s network interface. A solutions architect needs to increase network availability by allowing the traffic flow to resume in another instance if the primary instance is terminated.

Which solution accomplishes these requirements?


Set up AWS Transfer for FTPS service in Implicit FTPS mode to automatically disable the source/destination checks on the instance’s primary elastic network interface and reassociate it to another instance.
Create a secondary elastic network interface and point its private IPv4 address to the application’s domain name. Attach the new network interface to the primary instance. If the instance goes down, move the secondary network interface to another instance.
Use the AWS Network Firewall to detach the instance’s primary elastic network interface and move it to a new instance upon failure.
Attach an elastic IP address to the instance’s primary network interface and point its IP address to the application’s domain name. Automatically move the EIP to a secondary instance if the primary instance becomes unavailable using the AWS Transit Gateway.

### Detailed Solution Explanation
If one of your instances serving a particular function fails, its network interface can be attached to a replacement or hot standby instance pre-configured for the same role in order to rapidly recover the service. For example, you can use a network interface as your primary or secondary network interface to a critical service such as a database instance or a NAT instance. If the instance fails, you (or more likely, the code running on your behalf) can attach the network interface to a hot standby instance.

Because the interface maintains its private IP addresses, Elastic IP addresses, and MAC address, network traffic begins flowing to the standby instance as soon as you attach the network interface to the replacement instance. Users experience a brief loss of connectivity between the time the instance fails and the time that the network interface is attached to the standby instance, but no changes to the route table or your DNS server are required.

Hence, the correct answer is Create a secondary elastic network interface and point its private IPv4 address to the application’s domain name. Attach the new network interface to the primary instance. If the instance goes down, move the secondary network interface to another instance.

The option that says: Attach an elastic IP address to the instance’s primary network interface and point its IP address to the application’s domain name. Automatically move the EIP to a secondary instance if the primary instance becomes unavailable using the AWS Transit Gateway is incorrect. Elastic IPs are not needed in the solution since the application is private. Furthermore, an AWS Transit Gateway is primarily used to connect your Amazon Virtual Private Clouds (VPCs) and on-premises networks through a central hub. This particular networking service cannot be used to automatically move an Elastic IP address to another EC2 instance.

The option that says: Set up AWS Transfer for FTPS service in Implicit FTPS mode to automatically disable the source/destination checks on the instance’s primary elastic network interface and reassociate it to another instance is incorrect. First of all, the AWS Transfer for FTPS service is not capable of automatically disabling the source/destination checks and it only supports Explicit FTPS mode. Disabling the source/destination check only allows the instance to which the ENI is connected to act as a gateway (both a sender and a receiver). It is not possible to make the primary ENI of any EC2 instance detachable. A more appropriate solution would be to use an Elastic IP address which can be reassociated with your secondary instance.

The option that says: Use the AWS Network Firewall to detach the instance’s primary elastic network interface and move it to a new instance upon failure is incorrect. It’s not possible to detach the primary network interface of an EC2 instance. In addition, the AWS Network Firewall is only used for filtering traffic at the perimeter of your VPC and not for detaching ENIs.

 

**References:**

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/scenarios-enis.html

https://aws.amazon.com/aws-transfer-family/faqs/

 

Check out this Amazon EC2 Cheat Sheet:

https://tutorialsdojo.com/amazon-elastic-compute-cloud-amazon-ec2/

---

## Question 5

### Problem Statement & Options
A company plans to develop a custom messaging service that will be used to train an AI for an automatic response feature. The service is expected to receive thousands of messages per day, all of which will be processed by an Amazon EMR cluster. It is crucial that none of the messages are lost, no duplicates are produced, and that the messages are processed in EMR in the same order as arrival.

Which of the following options can satisfy the given requirement?

Create an Amazon Data Firehose to handle the messages.
Create an Amazon Kinesis Data Stream to collect the messages.
Set up an Amazon SQS standard queue and configure a dead-letter queue (DLQ) to handle failed messages.
Set up an Amazon SNS Topic to handle the messages.

### Detailed Solution Explanation
The solution must ensure that messages are durable so that no data is lost and that records are processed in the same order as they arrive. Amazon Kinesis Data Streams satisfies these requirements through its streaming architecture. A Kinesis data stream is composed of shards, where each shard stores a sequence of ordered data records. Each record written to the stream is assigned a unique sequence number, which allows consumers to process records in the exact order in which they were received within a shard. In addition, records are durably stored and replicated across multiple Availability Zones within the same AWS Region, helping ensure that data is not lost even if failures occur.

Amazon Kinesis Data Streams diagram

Amazon Kinesis Data Streams is designed for real-time ingestion and processing of large streaming datasets. Producers continuously write records to the stream, and consumer applications—such as workloads running on Amazon EMR using Apache Spark—can read and process the data in near real time. Because Kinesis preserves record ordering within shards and retains data for a configurable period, applications can reliably process messages in sequence.

The Amazon Kinesis Client Library (KCL) can also be used to simplify building consumer applications by coordinating distributed processing and ensuring that records associated with the same partition key are processed together in order. This architecture makes Kinesis Data Streams well-suited for high-throughput streaming workloads that require durable storage and ordered message processing.

Hence, the correct answer is: Create an Amazon Kinesis Data Stream to collect the messages.

The option that says: Set up an Amazon SQS standard queue and configure a dead-letter queue (DLQ) to handle failed messages is incorrect because although SQS is a valid messaging service, a standard queue only provides at-least-once delivery and does not guarantee strict message ordering, which means duplicate messages may occur and messages can be processed out of sequence. Although a dead-letter queue (DLQ) helps capture messages that fail processing after multiple attempts, it does not change the ordering or duplication behavior of the standard queue.

The option that says: Set up an Amazon SNS Topic to handle the messages is incorrect because SNS is primarily a pub-sub messaging service in AWS. SNS might not be capable of handling such a large volume of messages being received and sent at the same time. It also does not guarantee that the data will be transmitted in the same order in which they were received.

The option that says: Create an Amazon Data Firehose to handle the messages is incorrect because Amazon Data Firehose is designed only for delivering real-time streaming data to destinations such as data lakes, data stores, and analytics services. It ensures reliable data delivery, but it doesn’t guarantee the order of message delivery and processing.

 

**References:**

https://docs.aws.amazon.com/streams/latest/dev/introduction.html

https://aws.amazon.com/kinesis/data-streams/faqs/

 

Check out this Amazon Kinesis Cheat Sheet:

https://tutorialsdojo.com/amazon-kinesis/

---

## Question 6

### Problem Statement & Options
A Solutions Architect created a new Standard-class Amazon S3 bucket to store financial reports that are not frequently accessed but should immediately be available when an auditor requests the reports. To save costs, the Architect changed the storage class of the S3 bucket from Standard to Infrequent Access storage class.

In S3 Standard – Infrequent Access storage class, which of the following statements are true? (Select TWO.)

It automatically moves data to the most cost-effective access tier without any operational overhead.
It is designed for data that is accessed less frequently.
It is designed for data that requires rapid access when needed.
Ideal to use for data archiving.
It provides high latency and low throughput performance.

### Detailed Solution Explanation
Amazon S3 Standard – Infrequent Access (Standard – IA) is an Amazon S3 storage class for data that is accessed less frequently, but requires rapid access when needed. Standard – IA offers the high durability, throughput, and low latency of Amazon S3 Standard, with a low per GB storage price and per GB retrieval fee.

Amazon S3 

This combination of low cost and high performance make Standard – IA ideal for long-term storage, backups, and as a data store for disaster recovery. The Standard – IA storage class is set at the object level and can exist in the same bucket as Standard, allowing you to use lifecycle policies to automatically transition objects between storage classes without any application changes.

Key Features:

– Same low latency and high throughput performance of Standard

– Designed for durability of 99.999999999% of objects

– Designed for 99.9% availability over a given year

– Backed with the Amazon S3 Service Level Agreement for availability

– Supports SSL encryption of data in transit and at rest

– Lifecycle management for automatic migration of objects

Hence, the correct answers are:

– It is designed for data that is accessed less frequently.

– It is designed for data that requires rapid access when needed.

The option that says: It automatically moves data to the most cost-effective access tier without any operational overhead is incorrect because it actually refers to Amazon S3 – Intelligent Tiering, which is the only cloud storage class that delivers automatic cost savings by moving objects between different access tiers when access patterns change.

The option that says: It provides high latency and low throughput performance is incorrect because it should just be “low latency” and “high throughput” instead. S3 automatically scales performance to meet user demands.

The option that says: Ideal to use for data archiving is incorrect because this statement refers to Amazon S3 Glacier. Glacier is a secure, durable, and extremely low-cost cloud storage service for data archiving and long-term backup.

 

**References:**

https://aws.amazon.com/s3/storage-classes/

https://aws.amazon.com/s3/faqs

 

Check out this Amazon S3 Cheat Sheet:

https://tutorialsdojo.com/amazon-s3/

---

## Question 7

### Problem Statement & Options
A company has a fleet of running Spot EC2 instances behind an Application Load Balancer. The incoming traffic comes from various users across multiple AWS regions, and you would like to have the user’s session shared among the fleet of instances.

A Solutions Architect is required to set up a distributed session management layer that will provide scalable and shared data storage for the user sessions that supports multithreaded performance. The cache layer must also detect any node failures and replace the failed ones automatically.

Which of the following would be the best choice to meet the requirement while still providing sub-millisecond latency for the users?

AWS ELB sticky sessions
Amazon RDS database with RDS Proxy
Amazon ElastiCache for Memcached with Auto Discovery
Amazon ElastiCache for Redis Global Datastore

### Detailed Solution Explanation
For sub-millisecond latency caching, ElastiCache is the best choice. In order to address scalability and to provide a shared data storage for sessions that can be accessed from any individual web server, you can abstract the HTTP sessions from the web servers themselves. A common solution for this is to leverage an In-Memory Key/Value store such as Redis and Memcached.



For clusters running the Memcached engine, ElastiCache supports Auto Discovery—the ability for client programs to automatically identify all of the nodes in a cache cluster, and to initiate and maintain connections to all of these nodes.

With Auto Discovery, your application does not need to manually connect to individual cache nodes; instead, your application connects to one Memcached node and retrieves the list of nodes. From that list, your application is aware of the rest of the nodes in the cluster and can connect to any of them. You do not need to hardcode the individual cache node endpoints in your application.

Cache node failures are automatically detected; failed nodes are automatically replaced.

Hence, the correct answer is: Amazon ElastiCache for Memcached with Auto Discovery

The option that says: ELB sticky sessions is incorrect because the scenario does not require you to route a user to the particular web server that is managing that individual user’s session. Since the session state is shared among the instances, the use of the ELB sticky sessions feature is not recommended in this scenario.

The option that says: Amazon ElastiCache for Redis Global Datastore is incorrect because Redis does not supports multithreaded performance by default. This cache layer is not capable of detecting any node failures and replacing the failed ones automatically.  Keep in mind that the Global Datastore feature just allows your application to write to your ElastiCache for Redis cluster in one region and have the data available to be read from two other cross-region replica clusters, thereby enabling disaster recovery across regions.

The option that says: Amazon RDS Multi-AZ database instance with RDS Proxy is incorrect. Although you can use RDS for storing session state, it is not the best choice in terms of cost-effectiveness and performance when compared to ElastiCache. There is a significant difference in terms of latency if you use RDS when you store the session data.

**References:**

https://aws.amazon.com/caching/session-management/

https://docs.aws.amazon.com/whitepapers/latest/scale-performance-elasticache/memcached-vs.-redis.html

https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/AutoDiscovery.Benefits.html

 

Check out this Amazon Elasticache Cheat Sheet:

https://tutorialsdojo.com/amazon-elasticache/

 

Redis (cluster mode enabled vs. disabled) vs. Memcached:

https://tutorialsdojo.com/redis-cluster-mode-enabled-vs-disabled-vs-memcached/

---

## Question 8

### Problem Statement & Options
To save costs, your manager instructed you to analyze and review the setup of your AWS cloud infrastructure. You should also provide an estimate of how much your company will pay for all of the AWS resources that they are using.

In this scenario, which of the following will incur costs? (Select TWO.)

Public Data Set
A stopped On-Demand EC2 Instance
Using an Amazon VPC
A running EC2 Instance
EBS Volumes attached to stopped EC2 Instances

### Detailed Solution Explanation
Billing commences when Amazon EC2 initiates the boot sequence of an AMI instance. Billing ends when the instance terminates, which could occur through a web services command, by running “shutdown -h”, or through instance failure. When you stop an instance, AWS shuts it down but doesn’t charge hourly usage for a stopped instance or data transfer fees. However, AWS does charge for the storage of any Amazon EBS volumes.

Hence, a running EC2 Instance and EBS Volumes attached to stopped EC2 Instances are the right answers and conversely, a stopped On-Demand EC2 Instance is incorrect as there is no charge for a stopped EC2 instance that you have shut down.

Using Amazon VPC is incorrect because there are no additional charges for creating and using the VPC itself. Usage charges for other Amazon Web Services, including Amazon EC2, still apply at published rates for those resources, including data transfer charges.

Public Data Set is incorrect due to the fact that Amazon stores the data sets at no charge to the community and, as with all AWS services, you pay only for the compute and storage you use for your own applications.

 

**References:**

https://aws.amazon.com/cloudtrail/

https://aws.amazon.com/vpc/faqs

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-public-data-sets.html

 

Check out this Amazon EC2 Cheat Sheet:

https://tutorialsdojo.com/amazon-elastic-compute-cloud-amazon-ec2/

---

## Question 9

### Problem Statement & Options
A financial application consists of an Auto Scaling group of Amazon EC2 instances, an Application Load Balancer, and a MySQL RDS instance set up in a Multi-AZ Deployment configuration. To protect customers’ confidential data, it must be ensured that the Amazon RDS database is only accessible using an authentication token specific to the profile credentials of EC2 instances.

Which of the following actions should be taken to meet this requirement?

Use a combination of IAM and STS to enforce restricted access to your RDS instance using a temporary authentication token.
Create an IAM Role and assign it to your EC2 instances which will grant exclusive access to your RDS instance.
Configure SSL in your application to encrypt the database connection to RDS.
Enable the IAM DB Authentication.

### Detailed Solution Explanation
You can authenticate to your DB instance using AWS Identity and Access Management (IAM) database authentication. IAM database authentication works with MySQL and PostgreSQL. With this authentication method, you don’t need to use a password when you connect to a DB instance. Instead, you use an authentication token.

An authentication token is a unique string of characters that Amazon RDS generates on request. Authentication tokens are generated using AWS Signature Version 4. Each token has a lifetime of 15 minutes. You don’t need to store user credentials in the database, because authentication is managed externally using IAM. You can also still use standard database authentication.

IAM database authentication

IAM database authentication provides the following benefits:

Network traffic to and from the database is encrypted using Secure Sockets Layer (SSL).
You can use IAM to centrally manage access to your database resources, instead of managing access individually on each DB instance.
For applications running on Amazon EC2, you can use profile credentials specific to your EC2 instance to access your database instead of a password, for greater security
Hence, the correct answer is: Enable the IAM DB Authentication.

The option that says: Configuring SSL in your application to encrypt the database connection to RDS is incorrect because an SSL connection is not just using an authentication token from IAM. Although configuring SSL to your application can improve the security of your data in flight, it is still not a suitable option to use in this scenario.

The option that says: Creating an IAM Role and assigning it to your EC2 instances which will grant exclusive access to your RDS instance is incorrect because although you can create and assign an IAM Role to your EC2 instances, you still need to configure your RDS to use IAM DB Authentication.

The option that says: Use a combination of IAM and STS to enforce restricted access to your RDS instance using a temporary authentication token is incorrect because you have to use IAM DB Authentication for this scenario, and not simply a combination of an IAM and STS. Although STS is used to send temporary tokens for authentication, this is not a compatible use case for RDS.

 

**References:**

https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html

https://aws.amazon.com/rds/ 

 

Check out this Amazon RDS cheat sheet:

https://tutorialsdojo.com/amazon-relational-database-service-amazon-rds/

---

## Question 10

### Problem Statement & Options
A GraphQL API hosted is hosted in an Amazon EKS cluster with AWS Fargate launch type and deployed using AWS SAM. The API is connected to an Amazon DynamoDB table with DynamoDB Accelerator (DAX) as its data store. Both resources are hosted in the us-east-1 region.

The AWS IAM authenticator for Kubernetes is integrated into the EKS cluster for role-based access control (RBAC) and cluster authentication. A solutions architect must improve network security by preventing database calls from traversing the public internet. An automated cross-account backup for the DynamoDB table is also required for long-term retention.

Which of the following should the solutions architect implement to meet the requirement?

Create a DynamoDB interface endpoint. Associate the endpoint to the appropriate route table. Enable Point-in-Time Recovery (PITR) to restore the DynamoDB table to a particular point in time on the same or a different AWS account.
Create a DynamoDB gateway endpoint. Associate the endpoint to the appropriate route table. Use AWS Backup to automatically copy the on-demand DynamoDB backups to another AWS account for disaster recovery.

Create a DynamoDB gateway endpoint. Set up a Network Access Control List (NACL) rule that allows outbound traffic to the dynamodb.us-east-1.amazonaws.com gateway endpoint. Use the built-in on-demand DynamoDB backups for cross-account backup and recovery.

Create a DynamoDB interface endpoint. Set up a stateless rule using AWS Network Firewall to control all outbound traffic to only use the dynamodb.us-east-1.amazonaws.com endpoint. Integrate the DynamoDB table with Amazon Timestream to allow point-in-time recovery from a different AWS account.

### Detailed Solution Explanation
Since DynamoDB tables are public resources, applications within a VPC rely on an Internet Gateway to route traffic to/from Amazon DynamoDB. You can use a Gateway endpoint if you want to keep the traffic between your VPC and Amazon DynamoDB within the Amazon network. This way, resources residing in your VPC can use their private IP addresses to access DynamoDB with no exposure to the public internet.

When you create a DynamoDB Gateway endpoint, you specify the VPC where it will be deployed as well as the route table that will be associated with the endpoint. The route table will be updated with an Amazon DynamoDB prefix list (list of CIDR blocks) as the destination and the endpoint’s ID as the target.

amazon dynamodb gateway endpoint

DynamoDB on-demand backups are available at no additional cost beyond the normal pricing that’s associated with backup storage size. DynamoDB on-demand backups cannot be copied to a different account or Region. To create backup copies across AWS accounts and Regions and for other advanced features, you should use AWS Backup.

With AWS Backup, you can configure backup policies and monitor activity for your AWS resources and on-premises workloads in one place. Using DynamoDB with AWS Backup, you can copy your on-demand backups across AWS accounts and Regions, add cost allocation tags to on-demand backups, and transition on-demand backups to cold storage for lower costs. To use these advanced features, you must opt into AWS Backup. Opt-in choices apply to the specific account and AWS Region, so you might have to opt into multiple Regions using the same account.

Hence, the correct answer is: Create a DynamoDB gateway endpoint. Associate the endpoint to the appropriate route table. Use AWS Backup to automatically copy the on-demand DynamoDB backups to another AWS account for disaster recovery.

The option that says: Create a DynamoDB interface endpoint. Associate the endpoint to the appropriate route table. Enable Point-in-Time Recovery (PITR) to restore the DynamoDB table to a particular point in time on the same or a different AWS account is incorrect. While this option addresses the network security requirement, Point-in-Time Recovery (PITR) is only used for restoring a DynamoDB table to a specific point in time within the same AWS account and region. It does not support cross-account backups or long-term retention. If this functionality is needed, you have to use the AWS Backup service instead.

The option that says: Create a DynamoDB gateway endpoint. Set up a Network Access Control List (NACL) rule that allows outbound traffic to the dynamodb.us-east-1.amazonaws.com gateway endpoint. Use the built-in on-demand DynamoDB backups for cross-account backup and recovery is incorrect because using a Network Access Control List alone is not enough to prevent traffic traversing to the public Internet. Moreover, you cannot copy DynamoDB on-demand backups to a different account or Region.

The option that says: Create a DynamoDB interface endpoint. Set up a stateless rule using AWS Network Firewall to control all outbound traffic to only use the dynamodb.us-east-1.amazonaws.com endpoint. Integrate the DynamoDB table with Amazon Timestream to allow point-in-time recovery from a different AWS account is incorrect. Keep in mind that the dynamodb.us-east-1.amazonaws.com is a public service endpoint for Amazon DynamoDB. Since the application is able to communicate with Amazon DynamoDB prior to the required architectural change, it’s implied that no firewalls (security group, NACL, etc.) are blocking traffic to/from Amazon DynamoDB, hence, adding an NACL rule to allow outbound traffic to DynamoDB is unnecessary. Furthermore, the use of the AWS Network Firewall in this solution is simply incorrect as you have to integrate this with your Amazon VPC. The use of Amazon Timestream is also wrong since this is a time series database service in AWS for IoT and operational applications. You cannot directly integrate DynamoDB and Amazon Timestream for the purpose of point-in-time data recovery.

 

**References:**

https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/vpc-endpoints-dynamodb.html

https://aws.amazon.com/blogs/database/how-to-configure-a-private-network-environment-for-amazon-dynamodb-using-vpc-endpoints/

https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/BackupRestore.html

 

Check out this Amazon DynamoDB Cheat sheet:

https://tutorialsdojo.com/amazon-dynamodb

---

## Question 11

### Problem Statement & Options
An e-commerce company runs a highly scalable web application that depends on an Amazon Aurora database. As the number of users increases, the read replica faces difficulties keeping up with the increasing read traffic, causing performance bottlenecks during peak periods.

Which of the following will resolve the issue with the most cost-effective solution?

Set up a read replica that can operate across different regions.
Use automatic scaling for the Aurora read replica using Aurora Auto Scaling.
Increase the size of the Aurora DB cluster.
Implement read scaling with Aurora Global Database.

### Detailed Solution Explanation
Amazon Aurora is a cloud-based relational database service that provides better performance and reliability for database workloads. It is highly available and scalable, making it a great choice for businesses of any size. One of the key features of Amazon Aurora is Aurora Auto Scaling, which automatically adjusts the capacity of your Aurora database cluster based on the workload. This means that you don’t have to worry about manually adjusting the ability of your database cluster to handle changes in demand. With Aurora Auto Scaling, you can be sure that your database cluster will always have the appropriate capacity to handle your workload while minimizing costs.

Amazon Aurora

Aurora Auto Scaling is particularly useful for businesses that have fluctuating workloads. It ensures that your database cluster scales up or down as needed without manual intervention. This feature saves time and resources, allowing businesses to focus on other aspects of their operations. Aurora Auto Scaling is also cost-effective, as it helps minimize unnecessary expenses associated with overprovisioning or underprovisioning database resources.

In this scenario, the company can benefit from using Aurora Auto Scaling. This solution allows the system to dynamically manage resources, effectively addressing the surge in read traffic during peak periods. This dynamic management of resources ensures that the company pays only for the extra resources when they are genuinely required.

Hence, the correct answer is: Use automatic scaling for the Aurora read replica using Aurora Auto Scaling.

The option that says: Increase the size of the Aurora DB cluster is incorrect because it’s not economical to upsize the cluster just to alleviate the bottleneck during peak periods. A static increase in the DB cluster size results in constant costs, regardless of whether your database’s resources are being fully utilized during off-peak periods or not.

The option that says: Implement read scaling with Aurora Global Database is incorrect. Amazon Aurora Global Database is primarily designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS Regions. While this can provide global availability, it introduces additional complexity and can be more expensive due to infrastructure and data transfer costs.

The option that says: Set up a read replica that can operate across different regions is incorrect. Setting up a read replica that operates across different regions can provide read scalability and load-balancing benefits by typically distributing the read traffic across regions. However, it is not the most cost-effective solution in this scenario since it incurs additional costs associated with inter-region data replication. Moreover, the issue is not related to cross-region availability but rather the read replica’s performance within the current region.

 

**References:**

https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Integrating.AutoScaling.html

https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html

 

Check out this Amazon Aurora Cheat Sheet:

https://tutorialsdojo.com/amazon-aurora/

---

## Question 12

### Problem Statement & Options
A Solutions Architect working for a startup is designing a High Performance Computing (HPC) application which is publicly accessible for their customers. The startup founders want to mitigate distributed denial-of-service (DDoS) attacks on their application.

Which of the following options are not suitable to be implemented in this scenario? (Select TWO.)

Use AWS Shield and AWS WAF.
Use an Application Load Balancer with Auto Scaling groups for your EC2 instances. Prevent direct Internet traffic to your Amazon RDS database by deploying it to a new private subnet.
Add multiple Elastic Fabric Adapters (EFA) to each EC2 instance to increase the network bandwidth.
Use an Amazon CloudFront service for distributing both static and dynamic content.
Use Dedicated EC2 instances to ensure that each instance has the maximum performance possible.

### Detailed Solution Explanation
Take note that the question asks about the viable mitigation techniques that are NOT suitable to prevent Distributed Denial of Service (DDoS) attack.

A Denial of Service (DoS) attack is an attack that can make your website or application unavailable to end users. To achieve this, attackers use a variety of techniques that consume network or other resources, disrupting access for legitimate end users.

To protect your system from DDoS attack, you can do the following:

– Use an Amazon CloudFront service for distributing both static and dynamic content.

– Use an Application Load Balancer with Auto Scaling groups for your EC2 instances. Prevent direct Internet traffic to your Amazon RDS database by deploying it to a new private subnet.

– Set up alerts in Amazon CloudWatch to look for high Network In and CPU utilization metrics.

Services that are available within AWS Regions, like Elastic Load Balancing and Amazon Elastic Compute Cloud (EC2), allow you to build Distributed Denial of Service resiliency and scale to handle unexpected volumes of traffic within a given region. Services that are available in AWS edge locations, like Amazon CloudFront, AWS WAF, Amazon Route53, and Amazon API Gateway, allow you to take advantage of a global network of edge locations that can provide your application with greater fault tolerance and increased scale for managing larger volumes of traffic.

In addition, you can also use AWS Shield and AWS WAF to fortify your cloud network. AWS Shield is a managed DDoS protection service that is available in two tiers: Standard and Advanced. AWS Shield Standard applies always-on detection and inline mitigation techniques, such as deterministic packet filtering and priority-based traffic shaping, to minimize application downtime and latency.

AWS WAF is a web application firewall that helps protect web applications from common web exploits that could affect application availability, compromise security, or consume excessive resources. You can use AWS WAF to define customizable web security rules that control which traffic accesses your web applications. If you use AWS Shield Advanced, you can use AWS WAF at no extra cost for those protected resources and can engage the DRT to create WAF rules.



Using Dedicated EC2 instances to ensure that each instance has the maximum performance possible is not a viable mitigation technique because Dedicated EC2 instances are just an instance billing option. Although it may ensure that each instance gives the maximum performance, that by itself is not enough to mitigate a DDoS attack.

Adding multiple Elastic Fabric Adapters (EFA) to each EC2 instance to increase the network bandwidth is also not a viable option as this is mainly done for performance improvement and not for DDoS attack mitigation. Moreover, you can attach only one EFA per EC2 instance. An Elastic Fabric Adapter (EFA) is a network device that you can attach to your Amazon EC2 instance to accelerate High-Performance Computing (HPC) and machine learning applications.

The following options are valid mitigation techniques that can be used to prevent DDoS:

– Use an Amazon CloudFront service for distributing both static and dynamic content.

– Use an Application Load Balancer with Auto Scaling groups for your EC2 instances. Prevent direct Internet traffic to your Amazon RDS database by deploying it to a new private subnet.

– Use AWS Shield and AWS WAF.

 

**References:**

https://aws.amazon.com/answers/networking/aws-ddos-attack-mitigation/

https://d0.awsstatic.com/whitepapers/DDoS_White_Paper_June2015.pdf

 

Best practices on DDoS Attack Mitigation:

---

## Question 13

### Problem Statement & Options
An operations team has an application running on EC2 instances inside two custom VPCs. The VPCs are located in the Ohio and N.Virginia Region respectively. The team wants to transfer data between the instances without traversing the public internet.

Which combination of steps will achieve this? (Select TWO.)

Launch a NAT Gateway in the public subnet of each VPC.
Set up a VPC peering connection between the VPCs.
Create an Egress-only Internet Gateway.
Re-configure the route table’s target and destination of the instances’ subnet.
Deploy a VPC endpoint on each region to enable a private connection.

### Detailed Solution Explanation
A VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses. Instances in either VPC can communicate with each other as if they are within the same network. You can create a VPC peering connection between your own VPCs, or with a VPC in another AWS account. The VPCs can be in different regions (also known as an inter-region VPC peering connection).



Inter-Region VPC Peering provides a simple and cost-effective way to share resources between regions or replicate data for geographic redundancy. Built on the same horizontally scaled, redundant, and highly available technology that powers VPC today, Inter-Region VPC Peering encrypts inter-region traffic with no single point of failure or bandwidth bottleneck. Traffic using Inter-Region VPC Peering always stays on the global AWS backbone and never traverses the public internet, thereby reducing threat vectors, such as common exploits and DDoS attacks.

Hence, the correct answers are:

– Set up a VPC peering connection between the VPCs.

– Re-configure the route table’s target and destination of the instances’ subnet.

The option that says: Create an Egress only Internet Gateway is incorrect because this will just enable outbound IPv6 communication from instances in a VPC to the internet. Take note that the scenario requires private communication to be enabled between VPCs from two different regions.

The option that says: Launch a NAT Gateway in the public subnet of each VPC is incorrect because NAT Gateways are used to allow instances in private subnets to access the public internet. Note that the requirement is to make sure that communication between instances will not traverse the internet.

The option that says: Deploy a VPC endpoint on each region to enable private connection is incorrect. VPC endpoints are region-specific only and do not support inter-region communication.

 

**References:**

https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html

https://aws.amazon.com/about-aws/whats-new/2017/11/announcing-support-for-inter-region-vpc-peering/

 

Check out this Amazon VPC Cheat Sheet:

https://tutorialsdojo.com/amazon-vpc/

---

## Question 14

### Problem Statement & Options
A Solutions Architect is trying to enable Cross-Region Replication to an Amazon S3 bucket but this option is disabled. The bucket has been configured with a Multi-Region Access Point to manage incoming requests.

Which of the following options is a valid reason for this?

This is a premium feature which is only for AWS Enterprise accounts.
The Cross-Region Replication feature is only available for S3 – Infrequent Access.
The Cross-Region Replication feature is only available for S3 – One Zone-IA.
In order to use the Cross-Region Replication feature in S3, you need to first enable versioning on the bucket.

### Detailed Solution Explanation
To enable the cross-region replication feature in S3, the following items should be met:

The source and destination buckets must have versioning enabled.
The source and destination buckets must be in different AWS Regions.
Amazon S3 must have permission to replicate objects from that source bucket to the destination bucket on your behalf.
Amazon S3 Replication Diagram

Hence, the correct answer is: In order to use the Cross-Region Replication feature in S3, you need to first enable versioning on the bucket.

The options that say: The Cross-Region Replication feature is only available for S3 – One Zone-IA, and The Cross-Region Replication feature is only available for S3 – Infrequent Access are incorrect, as these features are only available to all types of S3 classes.

The option that says: This is a premium feature which is only for AWS Enterprise accounts is incorrect as this CRR feature is typically available to all Support Plans.

 

**References:**

https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html

https://aws.amazon.com/blogs/aws/new-cross-region-replication-for-amazon-s3/

 

Check out this Amazon S3 Cheat Sheet:

https://tutorialsdojo.com/amazon-s3/

---

## Question 15

### Problem Statement & Options
The media company that you are working for has a video transcoding application running on Amazon EC2. Each EC2 instance polls a queue to find out which video should be transcoded, and then runs a transcoding process. If this process is interrupted, the video will be transcoded by another instance based on the queuing system. This application has a large backlog of videos which need to be transcoded. Your manager would like to reduce this backlog by adding more EC2 instances, however, these instances are only needed until the backlog is reduced.

In this scenario, which type of Amazon EC2 instance is the most cost-effective type to use?

Reserved instances
Spot instances
On-demand instances
Dedicated instances

### Detailed Solution Explanation
You require an instance that will be used not as a primary server but as a spare compute resource to augment the transcoding process of your application. These instances should also be terminated once the backlog has been significantly reduced. In addition, the scenario mentions that if the current process is interrupted, the video can be transcoded by another instance based on the queuing system. This means that the application can gracefully handle an unexpected termination of an EC2 instance, like in the event of a Spot instance termination when the Spot price is greater than your set maximum price. Hence, an Amazon EC2 Spot instance is the best and cost-effective option for this scenario.



Amazon EC2 Spot instances are spare compute capacity in the AWS cloud available to you at steep discounts compared to On-Demand prices. EC2 Spot enables you to optimize your costs on the AWS cloud and scale your application’s throughput up to 10X for the same budget. By simply selecting Spot when launching EC2 instances, you can save up to 90% on On-Demand prices. The only difference between On-Demand instances and Spot Instances is that Spot instances can be interrupted by EC2 with two minutes of notification when the EC2 needs the capacity back.

You can specify whether Amazon EC2 should hibernate, stop, or terminate Spot Instances when they are interrupted. You can choose the interruption behavior that meets your needs.

Take note that there is no “bid price” anymore for Spot EC2 instances since March 2018. You simply have to set your maximum price instead.

Reserved instances and Dedicated instances are incorrect as both do not act as spare compute capacity.

On-demand instances is a valid option but a Spot instance is much cheaper than On-Demand.

 

**References:** 

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-interruptions.html

http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/how-spot-instances-work.html

https://aws.amazon.com/blogs/compute/new-amazon-ec2-spot-pricing

 

Check out this Amazon EC2 Cheat Sheet:

https://tutorialsdojo.com/amazon-elastic-compute-cloud-amazon-ec2/

---

## Question 16

### Problem Statement & Options
A travel company has a suite of web applications hosted in an Auto Scaling group of On-Demand EC2 instances behind an Application Load Balancer that handles traffic from various web domains such as i-love-manila.com,i-love-boracay.com i-love-cebu.com and many others. To improve security and lessen the overall cost, you are instructed to secure the system by allowing multiple domains to serve SSL traffic without the need to reauthenticate and reprovision your certificate everytime you add a new domain. This migration from HTTP to HTTPS will help improve their SEO and Google search ranking.

Which of the following is the most cost-effective solution to meet the above requirement?

Create a new CloudFront web distribution and configure it to serve HTTPS requests using dedicated IP addresses in order to associate your alternate domain names with a dedicated IP address in each CloudFront edge location.
Add a Subject Alternative Name (SAN) for each additional domain to your certificate.
Use a wildcard certificate to handle multiple sub-domains and different domains.
Upload all SSL certificates of the domains in the ALB using the console and bind multiple certificates to the same secure listener on your load balancer. ALB will automatically choose the optimal TLS certificate for each client using Server Name Indication (SNI).

### Detailed Solution Explanation
SNI Custom SSL relies on the SNI extension of the Transport Layer Security protocol, which allows multiple domains to serve SSL traffic over the same IP address by including the hostname which the viewers are trying to connect to.

You can host multiple TLS-secured applications, each with its own TLS certificate, behind a single load balancer. In order to use SNI, all you need to do is bind multiple certificates to the same secure listener on your load balancer. ALB will automatically choose the optimal TLS certificate for each client. These features are provided at no additional charge.



To meet the requirements in the scenario, you can upload all SSL certificates of the domains in the ALB using the console and bind multiple certificates to the same secure listener on your load balancer. ALB will automatically choose the optimal TLS certificate for each client using Server Name Indication (SNI).

Hence, the correct answer is the option that says: Upload all SSL certificates of the domains in the ALB using the console and bind multiple certificates to the same secure listener on your load balancer. ALB will automatically choose the optimal TLS certificate for each client using Server Name Indication (SNI).

Using a wildcard certificate to handle multiple sub-domains and different domains is incorrect because a wildcard certificate can only handle multiple sub-domains but not different domains.

Adding a Subject Alternative Name (SAN) for each additional domain to your certificate is incorrect because although using SAN is correct, you will still have to reauthenticate and reprovision your certificate every time you add a new domain. One of the requirements in the scenario is that you should not have to reauthenticate and reprovision your certificate hence, this solution is incorrect.

The option that says: Create a new CloudFront web distribution and configure it to serve HTTPS requests using dedicated IP addresses in order to associate your alternate domain names with a dedicated IP address in each CloudFront edge location is incorrect because although it is valid to use dedicated IP addresses to meet this requirement, this solution is not cost-effective. Remember that if you configure CloudFront to serve HTTPS requests using dedicated IP addresses, you incur an additional monthly charge. The charge begins when you associate your SSL/TLS certificate with your CloudFront distribution. You can just simply upload the certificates to the ALB and use SNI to handle multiple domains in a cost-effective manner.

 

**References:**

https://aws.amazon.com/blogs/aws/new-application-load-balancer-sni/

https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-https-dedicated-ip-or-sni.html#cnames-https-dedicated-ip

https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html

 

Check out this Amazon CloudFront Cheat Sheet:

https://tutorialsdojo.com/amazon-cloudfront/

 

SNI Custom SSL vs Dedicated IP Custom SSL:

https://tutorialsdojo.com/sni-custom-ssl-vs-dedicated-ip-custom-ssl/

 

Comparison of AWS Services Cheat Sheets:

https://tutorialsdojo.com/comparison-of-aws-services/

---

## Question 17

### Problem Statement & Options
A DevOps Engineer is required to design a cloud architecture in AWS. The Engineer is planning to develop a highly available and fault-tolerant architecture consisting of an Elastic Load Balancer and an Auto Scaling group of EC2 instances deployed across multiple Availability Zones. This will be used by an online accounting application that requires path-based routing, host-based routing, and bi-directional streaming using Remote Procedure Call (gRPC).

Which configuration will satisfy the given requirement?

Configure an Application Load Balancer in front of the auto-scaling group. Select gRPC as the protocol version.
Configure a Network Load Balancer in front of the auto-scaling group. Create an AWS Global Accelerator accelerator and set the load balancer as an endpoint.
Configure a Network Load Balancer in front of the auto-scaling group. Use a UDP listener for routing.
Configure a Gateway Load Balancer in front of the auto-scaling group. Ensure that the IP Listener Routing uses the GENEVE protocol on port 6081 to allow gRPC response traffic.

### Detailed Solution Explanation
Application Load Balancer operates at the request level (layer 7), routing traffic to targets (EC2 instances, containers, IP addresses, and Lambda functions) based on the content of the request. Ideal for advanced load balancing of HTTP and HTTPS traffic, Application Load Balancer provides advanced request routing targeted at delivery of modern application architectures, including microservices and container-based applications. Application Load Balancer simplifies and improves the security of your application, by ensuring that the latest SSL/TLS ciphers and protocols are used at all times.



If your application is composed of several individual services, an Application Load Balancer can route a request to a service based on the content of the request such as Host field, Path URL, HTTP header, HTTP method, Query string, or Source IP address.



ALBs can also route and load balance gRPC traffic between microservices or between gRPC-enabled clients and services. This will allow customers to seamlessly introduce gRPC traffic management in their architectures without changing any of the underlying infrastructure on their clients or services.

Therefore, the correct answer is: Configure an Application Load Balancer in front of the auto-scaling group. Select gRPC as the protocol version.

The option that says: Configure a Network Load Balancer in front of the auto-scaling group. Use a UDP listener for routing is incorrect. Network Load Balancers do not support gRPC.

The option that says: Configure a Gateway Load Balancer in front of the auto-scaling group. Ensure that the IP Listener Routing uses the GENEVE protocol on port 6081 to allow gRPC response traffic is incorrect. A Gateway Load Balancer operates as a Layer 3 Gateway and a Layer 4 Load Balancing service. Do take note that the gRPC protocol is at Layer 7 of the OSI Model so this service is not appropriate for this scenario.

The option that says: Configure a Network Load Balancer in front of the auto-scaling group. Create an AWS Global Accelerator accelerator and set the load balancer as an endpoint is incorrect. AWS Global Accelerator simply optimizes application performance by routing user traffic to the congestion-free, redundant AWS global network instead of the public internet.

 

**References:**

https://aws.amazon.com/elasticloadbalancing/features

https://aws.amazon.com/elasticloadbalancing/faqs/

 

Check out this AWS Elastic Load Balancing (ELB) Cheat Sheet:

https://tutorialsdojo.com/aws-elastic-load-balancing-elb/

 

Application Load Balancer vs Network Load Balancer vs Gateway Load Balancer:

https://tutorialsdojo.com/application-load-balancer-vs-network-load-balancer-vs-classic-load-balancer/

---

## Question 18

### Problem Statement & Options
A Solutions Architect is working for a large global media company with multiple office locations all around the world. The Architect is instructed to build a system to distribute training videos to all employees.

Using Amazon CloudFront, what method would be used to serve content that is stored in Amazon S3 but not publicly accessible from S3 directly?

Create an S3 bucket policy that lists the CloudFront distribution ID as the principal and the target bucket as the Amazon Resource Name (ARN).
Create an Origin Access Control (OAC) for CloudFront and grant access to the objects in your S3 bucket to that OAC.
Create an Identity and Access Management (IAM) user for CloudFront and grant access to the objects in your S3 bucket to that IAM user.
Create a web ACL in AWS WAF to block any public S3 access and attach it to the CloudFront distribution.

### Detailed Solution Explanation
When you create or update a distribution in CloudFront, you can add an origin access Control (OAC) and automatically update the bucket policy to give the origin access control permission to access your bucket. Alternatively, you can choose to manually change the bucket policy or change ACLs, which control permissions on individual objects in your bucket.

Amazon CloudFront Origin Access Control

You can update the Amazon S3 bucket policy using either the AWS Management Console or the Amazon S3 API:

– Grant the CloudFront origin access control the applicable permissions on the bucket.

– Deny access to anyone that you don’t want to have access using Amazon S3 URLs.

Hence, the correct answer is: Create an Origin Access Control (OAC) for CloudFront and grant access to the objects in your S3 bucket to that OAC.

The option that says: Create an Identity and Access Management (IAM) user for CloudFront and grant access to the objects in your S3 bucket to that IAM user is incorrect because you cannot directly create an IAM User for a specific Amazon CloudFront distribution. You have to use an origin access control (OAC) instead.

The option that says: Create an S3 bucket policy that lists the CloudFront distribution ID as the principal and the target bucket as the Amazon Resource Name (ARN) is incorrect. While you can typically specify AWS accounts, IAM users, and IAM roles as principals in an S3 bucket policy, you cannot directly use a CloudFront distribution ID as a principal in an S3 bucket policy. Instead, you must define the CloudFront service as the Principal and restrict access to your CF distribution using the Condition policy. Therefore, this is not the correct method for the given scenario.

The option that says: Create a web ACL in AWS WAF to block any public S3 access and attach it to the CloudFront distribution is incorrect because AWS WAF is primarily used to protect your applications from common web vulnerabilities and not to ensure exclusive access to CloudFront.

 

**References:**

https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html

https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/SecurityAndPrivateContent.html

 

Check out this Amazon CloudFront Cheat Sheet:

https://tutorialsdojo.com/amazon-cloudfront/

 

Comparison of AWS Services Cheat Sheets:

https://tutorialsdojo.com/comparison-of-aws-services/

---

## Question 19

### Problem Statement & Options
A company deployed an online enrollment system database on a prestigious university, which is hosted in RDS. The Solutions Architect is required to monitor the database metrics in Amazon CloudWatch to ensure the availability of the enrollment system.

What are the enhanced monitoring metrics that Amazon CloudWatch gathers from Amazon RDS DB instances which provide more accurate information? (Select TWO.)

Freeable Memory
Database Connections
OS processes
CPU Utilization
RDS child processes

### Detailed Solution Explanation
Amazon RDS provides metrics in real-time for the operating system (OS) that your DB instance runs on. You can view the metrics for your DB instance using the console or consume the Enhanced Monitoring JSON output from CloudWatch Logs in a monitoring system of your choice.

CloudWatch gathers metrics about CPU utilization from the hypervisor for a DB instance, and Enhanced Monitoring gathers its metrics from an agent on the instance. As a result, you might find differences between the measurements because the hypervisor layer performs a small amount of work. The differences can be greater if your DB instances use smaller instance classes because then there are likely more virtual machines (VMs) that are managed by the hypervisor layer on a single physical instance. Enhanced Monitoring metrics are useful when you want to see how different processes or threads on a DB instance use the CPU.



In RDS, the Enhanced Monitoring metrics shown in the Process List view are organized as follows:

RDS child processes – Shows a summary of the RDS processes that support the DB instance, for example aurora for Amazon Aurora DB clusters and mysqld for MySQL DB instances. Process threads appear nested beneath the parent process. Process threads show CPU utilization only as other metrics are the same for all threads for the process. The console displays a maximum of 100 processes and threads. The results are a combination of the top CPU-consuming and memory-consuming processes and threads. If there are more than 50 processes and more than 50 threads, the console displays the top 50 consumers in each category. This display helps you identify which processes are having the greatest impact on performance.

RDS processes – Shows a summary of the resources used by the RDS management agent, diagnostics monitoring processes, and other AWS processes that are required to support RDS DB instances.

OS processes – Shows a summary of the kernel and system processes, which generally have minimal impact on performance.

CPU Utilization, Database Connections, and Freeable Memory are incorrect because these are just the regular items provided by Amazon RDS Metrics in CloudWatch. Remember that the scenario is asking for the Enhanced Monitoring metrics.

 

**References:** 

https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/rds-metricscollected.html

https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html#USER_Monitoring.OS.CloudWatchLogs

 

Check out this Amazon CloudWatch Cheat Sheet:

https://tutorialsdojo.com/amazon-cloudwatch/

 

Check out this Amazon RDS Cheat Sheet:

https://tutorialsdojo.com/amazon-relational-database-service-amazon-rds/

---

## Question 20

### Problem Statement & Options
A startup is building IoT devices and monitoring applications. They are using IoT sensors to monitor the traffic in real-time by using an Amazon Kinesis Stream that is configured with default settings. It then sends the data to an Amazon S3 bucket every 3 days. When you checked the data in S3 on the 3rd day, only the data for the last day is present and no data is present from 2 days ago.

Which of the following is the MOST likely cause of this issue?

Someone has manually deleted the record in Amazon S3.
The access of the Kinesis stream to the S3 bucket is insufficient.
By default, data records in Kinesis are only accessible for 24 hours from the time they are added to a stream.
Amazon S3 bucket has encountered a data loss.

### Detailed Solution Explanation
By default, records of a stream in Amazon Kinesis are accessible for up to 24 hours from the time they are added to the stream. You can raise this limit to up to 7 days by enabling extended data retention.



Hence, the correct answer is: By default, data records in Kinesis are only accessible for 24 hours from the time they are added to a stream.

The option that says: Amazon S3 bucket has encountered a data loss is incorrect because Amazon S3 rarely experiences data loss. Amazon has an SLA for S3 that it commits to its customers. Amazon S3 Standard, S3 Standard–IA, S3 One Zone-IA, and S3 Glacier are all designed to provide 99.999999999% durability of objects over a given year. This durability level corresponds to an average annual expected loss of 0.000000001% of objects. Hence, Amazon S3 bucket data loss is highly unlikely.

The option that says: Someone has manually deleted the record in Amazon S3 is incorrect because if someone has deleted the data, this should have been visible in CloudTrail. Also, deleting that much data manually shouldn’t have occurred in the first place if you have put in the appropriate security measures.

The option that says: The access of the Kinesis stream to the S3 bucket is insufficient is incorrect because having insufficient access is highly unlikely since you are able to access the bucket and view the contents of the previous day’s data collected by Kinesis.

 

Reference: 

https://aws.amazon.com/kinesis/data-streams/faqs/

https://docs.aws.amazon.com/AmazonS3/latest/dev/DataDurability.html

 

Check out this Amazon Kinesis Cheat Sheet:

https://tutorialsdojo.com/amazon-kinesis/

---

## Question 21

### Problem Statement & Options
A solutions architect is managing an application that runs on a Windows EC2 instance with an attached Amazon FSx for Windows File Server. To save cost, management has decided to stop the instance during off-hours and restart it only when needed. It has been observed that the application takes several minutes to become fully operational which impacts productivity.

How can the solutions architect speed up the instance’s loading time without driving the cost up?

Enable the hibernation mode on the EC2 instance.
Migrate the application to an EC2 instance with hibernation enabled.
Migrate the application to a Linux-based EC2 instance.
Disable the Instance Metadata Service to reduce the things that need to be loaded at startup.

### Detailed Solution Explanation
Hibernation provides the convenience of pausing and resuming the instances, saves time by reducing the startup time taken by applications, and saves effort in setting up the environment or applications all over again. Instead of having to rebuild the memory footprint, hibernation allows applications to pick up exactly where they left off.
While the instance is in hibernation, you pay only for the EBS volumes and Elastic IP Addresses attached to it; there are no other hourly charges (just like any other stopped instance).

Therefore, the correct answer is: Migrate the application to an EC2 instance with hibernation enabled.

The option that says: Migrate the application to a Linux-based EC2 instance is incorrect. This does not guarantee a faster load time. Moreover, it is a risky thing to do as the application might have dependencies tied to the previous operating system that won’t work on a different OS.

The option that says: Enable the hibernation mode on the EC2 instance is incorrect. It is not possible to enable or disable hibernation for an instance after it has been launched.

The option that says: Disable the instance metadata service to reduce the things that need to be loaded at startup is incorrect. This won’t affect the startup load time at all. The Instance Metadata Service is just a service that you can access over the network from within an EC2 instance.

 

**References:**

https://aws.amazon.com/about-aws/whats-new/2019/10/amazon-ec2-hibernation-now-available-on-windows/

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enabling-hibernation.html

https://aws.amazon.com/blogs/aws/new-hibernate-your-ec2-instances/

 

Check out this Amazon EC2 Cheat sheet:

https://tutorialsdojo.com/amazon-elastic-compute-cloud-amazon-ec2/

---

## Question 22

### Problem Statement & Options
A payment processing company plans to migrate its on-premises application to an Amazon EC2 instance. An IPv6 CIDR block is attached to the company’s Amazon VPC. Strict security policy mandates that the production VPC must only allow outbound communication over IPv6 between the instance and the internet but should prevent the internet from initiating an inbound IPv6 connection. The new architecture should also allow traffic flow inspection and traffic filtering.

What should a solutions architect do to meet these requirements?

Launch the EC2 instance to a private subnet and attach AWS PrivateLink interface endpoint to the VPC to control outbound IPv6 communication to the internet. Use Amazon GuardDuty to set up the required rules for traffic inspection and traffic filtering.
Launch the EC2 instance to a private subnet and attach a NAT Gateway to the VPC to allow outbound IPv6 communication to the internet. Use AWS Firewall Manager to set up the required rules for traffic inspection and traffic filtering.
Launch the EC2 instance to a public subnet and attach an Internet Gateway to the VPC to allow outbound IPv6 communication to the internet. Use Traffic Mirroring to set up the required rules for traffic inspection and traffic filtering.
Launch the EC2 instance to a private subnet and attach an Egress-Only Internet Gateway to the VPC to allow outbound IPv6 communication to the internet. Use AWS Network Firewall to set up the required rules for traffic inspection and traffic filtering.

### Detailed Solution Explanation
An egress-only internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows outbound communication over IPv6 from instances in your VPC to the internet and prevents it from initiating an IPv6 connection with your instances.

Egress Only Internet Gateway

IPv6 addresses are globally unique and are therefore public by default. If you want your instance to be able to access the internet, but you want to prevent resources on the internet from initiating communication with your instance, you can use an egress-only internet gateway.

A subnet is a range of IP addresses in your VPC. You can launch AWS resources into a specified subnet. Use a public subnet for resources that must be connected to the internet and a private subnet for resources that won’t be connected to the internet.

AWS Network Firewall is a managed service that makes it easy to deploy essential network protections for all of your Amazon Virtual Private Clouds (VPCs). The service can be set up with just a few clicks and scales automatically with your network traffic, so you don’t have to worry about deploying and managing any infrastructure. AWS Network Firewall includes features that provide protection from common network threats.

AWS Network Firewall Filter & Inspection

AWS Network Firewall’s stateful firewall can incorporate context from traffic flows, like tracking connections and protocol identification, to enforce policies such as preventing your VPCs from accessing domains using an unauthorized protocol. AWS Network Firewall’s intrusion prevention system (IPS) provides active traffic flow inspection so you can identify and block vulnerability exploits using signature-based detection. AWS Network Firewall also offers web filtering that can stop traffic to known bad URLs and monitor fully qualified domain names.

In this scenario, you can use an egress-only internet gateway to allow outbound IPv6 communication to the internet and then use the AWS Network Firewall to set up the required rules for traffic inspection and traffic filtering.

Hence, the correct answer is: Launch the EC2 instance to a private subnet and attach an Egress-Only Internet Gateway to the VPC to allow outbound IPv6 communication to the internet. Use AWS Network Firewall to set up the required rules for traffic inspection and traffic filtering.

The option that says: Launch the EC2 instance to a private subnet and attach AWS PrivateLink interface endpoint to the VPC to control outbound IPv6 communication to the internet. Use Amazon GuardDuty to set up the required rules for traffic inspection and traffic filtering is incorrect because the AWS PrivateLink (which is also known as VPC Endpoint) is just a highly available, scalable technology that enables you to privately connect your VPC to the AWS services as if they were in your VPC. This service is not capable of controlling outbound IPv6 communication to the Internet. Furthermore, the Amazon GuardDuty service doesn’t have the features to do traffic inspection or filtering.

The option that says: Launch the EC2 instance to a public subnet and attach an Internet Gateway to the VPC to allow outbound IPv6 communication to the internet. Use Traffic Mirroring to set up the required rules for traffic inspection and traffic filtering is incorrect because an Internet Gateway does not limit or control any outgoing IPv6 connection. Take note that the requirement is to prevent the Internet from initiating an inbound IPv6 connection to your instance. This solution allows all kinds of traffic to initiate a connection to your EC2 instance hence, this option is wrong. In addition, the use of Traffic Mirroring is not appropriate as well. This is just an Amazon VPC feature that you can use to copy network traffic from an elastic network interface of type interface, not to filter or inspect the incoming/outgoing traffic.

The option that says: Launch the EC2 instance to a private subnet and attach a NAT Gateway to the VPC to allow outbound IPv6 communication to the internet. Use AWS Firewall Manager to set up the required rules for traffic inspection and traffic filtering is incorrect. While NAT Gateway has a NAT64 feature that translates an IPv6 address to IPv4, it will not prevent inbound IPv6 traffic from reaching the EC2 instance. You have to use the egress-only Internet Gateway instead. Moreover, the AWS Firewall Manager is neither capable of doing traffic inspection nor traffic filtering.

 

**References:**

https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html

https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html

https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html

 

Check out this Amazon VPC Cheat Sheet:

https://tutorialsdojo.com/amazon-vpc/

---

## Question 23

### Problem Statement & Options
There was an incident in a production environment where user data stored in an Amazon S3 bucket was accidentally deleted by a Junior DevOps Engineer. The issue was escalated to management, and after a few days, an instruction was given to improve the security and protection of AWS resources.

What combination of the following options will protect the S3 objects in the bucket from both accidental deletion and overwriting? (Select TWO.)

Enable S3 Intelligent-Tiering
Disallow S3 Delete using an IAM bucket policy
Enable Versioning
Provide access to S3 data strictly through pre-signed URL only
Enable Multi-Factor Authentication Delete

### Detailed Solution Explanation
By using Versioning and enabling MFA (Multi-Factor Authentication) Delete, you can secure and recover your S3 objects from accidental deletion or overwrite.

S3 Bucket Versioning

Versioning is a means of keeping multiple variants of an object in the same bucket. Versioning-enabled buckets enable you to recover objects from accidental deletion or overwrite. You can use versioning to preserve, retrieve, and restore every version of every object stored in your Amazon S3 bucket. With versioning, you can easily recover from both unintended user actions and application failures.

S3 Enable MFA

You can also optionally add another layer of security by configuring a bucket to enable MFA (Multi-Factor Authentication) Delete, which requires additional authentication for either of the following operations:

– Change the versioning state of your bucket

– Permanently delete an object version

MFA Delete requires two forms of authentication together:

– Your security credentials

– The concatenation of a valid serial number, a space, and the six-digit code displayed on an approved authentication device.

 

Hence, the correct answers are:

– Enable Versioning

– Enable Multi-Factor Authentication Delete

The option that says: Providing access to S3 data strictly through pre-signed URL only is incorrect since a pre-signed URL gives access to the object identified in the URL. Pre-signed URLs are useful when customers perform an object upload to your S3 bucket, but does not help in preventing accidental deletes.

The option that says: Disallowing S3 Delete using an IAM bucket policy is incorrect since you still want users to be able to delete objects in the bucket, and you just want to prevent accidental deletions. Disallowing S3 Delete using an IAM bucket policy will restrict all delete operations to your bucket.

The option that says: Enabling S3 Intelligent-Tiering is incorrect since S3 intelligent tiering does not help in this situation.

 

**References:**

https://docs.aws.amazon.com/AmazonS3/latest/dev/Versioning.html

https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html

 

Check out this Amazon S3 Cheat Sheet:

https://tutorialsdojo.com/amazon-s3/

---

## Question 24

### Problem Statement & Options
A logistics company based in the USA runs its web application on a fleet of Amazon EC2 instances in an Auto Scaling group. The company uses an Application Load Balancer to distribute traffic among the EC2 instances. The company runs the same application in multiple AWS regions to cater to clients across several countries. A recent government policy has been enacted that prohibits the company from servicing a specific country.

Which of the following options is the recommended action to comply with the government requirement?

Create a Web ACL rule in AWS WAF to block the specified country. Associate the rule to the Application Load Balancers.
Update the route tables to forward all outbound traffic to AWS Network Firewall and configure a stateful domain list rule group to block the specified country
Update the Network Access Control Lists of all subnets used by the Amazon EC2 instances to “deny” all IP addresses from the specific country.
Update the Network Access Control Lists of all subnets used by the Application Load Balancers to “deny” all IP addresses from the specific country.

### Detailed Solution Explanation
AWS WAF is a web application firewall that lets you monitor the HTTP(S) requests that are forwarded to an Amazon CloudFront distribution, an Amazon API Gateway REST API, an Application Load Balancer, or an AWS AppSync GraphQL API.

You use a web access control list (ACL) to protect a set of AWS resources. You create a web ACL and define its protection strategy by adding rules. Rules define criteria for inspecting web requests and specify how to handle requests that match the criteria. A web access control list (web ACL) gives you fine-grained control over all of the HTTP(S) web requests that your protected resource responds to.

You can use criteria like the following to allow or block requests:

-IP address origin of the request

-Country of origin of the request

-String match or regular expression (regex) match in a part of the request

-Size of a particular part of the request

-Detection of malicious SQL code or scripting

You can also test for any combination of these conditions. You can block or count web requests that not only meet the specified conditions but also exceed a specified number of requests in any 5-minute period. You can combine conditions using logical operators. You can also run CAPTCHA controls against requests.

To allow or block web requests based on country of origin, create one or more geographical, or geo, match statements. You can use this to block access to your site from specific countries or to only allow access from specific countries.



Therefore, the correct answer is: Create a Web ACL rule in AWS WAF to block the specified country. Associate this rule to the Application Load Balancers. In AWS WAF, you can use the Geographic match rule statement to block access to your site from specific countries or to allow access only from specific countries.

The option that says: Update the route tables to forward all outbound traffic to AWS Network Firewall and configure a stateful domain list rule group to block the specified country is incorrect. Domain List Rules block HTTP or HTTPS traffic to domains identified as low-reputation, or that are known or suspected to be associated with malware or botnets. This can’t be used to block a particular country.

The option that says: Update the Network Access Control Lists of all subnets used by the Amazon EC2 instances to “deny” all IP addresses from the specific country is incorrect. The EC2 instances are behind the Application Load Balancers, thus, if you need to modify NACL for incoming requests you should modify the ALB subnet NACLs.

The option that says: Update the Network Access Control Lists of all subnets used by the Application Load Balancers to “deny” all IP addresses from the specific country is incorrect. This may be possible, however, this is not recommended as there will be a lot of IP addresses assigned to a country. The IP addresses list may also change regularly which is difficult to track.

 

**References:**

https://aws.amazon.com/premiumsupport/knowledge-center/waf-allow-block-country-geolocation/

https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-geo-match.html

https://docs.aws.amazon.com/waf/latest/developerguide/web-acl.html

 

Check out this AWS WAF Sheet:

https://tutorialsdojo.com/aws-waf/

---

## Question 25

### Problem Statement & Options
A company is using Amazon VPC that has a CIDR block of 10.31.0.0/27 that is connected to the on-premises data center. There was a requirement to create a Lambda function that will process massive amounts of cryptocurrency transactions every minute and then store the results to EFS. After setting up the serverless architecture and connecting the Lambda function to the VPC, the Solutions Architect noticed an increase in invocation errors with EC2 error types such as EC2ThrottledException at certain times of the day.

Which of the following are the possible causes of this issue? (Select TWO.)

Your VPC does not have a NAT gateway.
Your Lambda function exceeds the VPC quota for Elastic Network Interfaces (ENIs) or available IP addresses in the subnet.
The Lambda function is placed in a VPC subnet with limited IP address capacity.
The associated security group of your function does not allow outbound connections.
The attached IAM execution role of your function does not have the necessary permissions to access the resources of your VPC.

### Detailed Solution Explanation
Amazon VPC (Virtual Private Cloud) is a service that enables you to create a virtual network. This virtual network is logically isolated from other networks, giving you full control over your virtual networking environment. It allows you to choose your own IP address range, create subnets, and configure route tables and network gateways. With VPC, you can securely connect your AWS resources to your on-premises data center.



Elastic Network Interfaces (ENIs) are virtual network interfaces that can be attached to instances or Lambda functions within your VPC. When you configure a Lambda function to access resources within a VPC, AWS Lambda creates and manages ENIs on your behalf. These ENIs are required for communication between the Lambda function and resources such as Amazon EFS within the VPC. Properly configuring your VPC and ensuring you have enough IP addresses and ENI capacity is crucial for your Lambda function to scale effectively without encountering errors like EC2ThrottledException.

Service Quotas within Amazon VPC are important, especially when using AWS Lambda. As your Lambda function scales, it requires additional ENIs to maintain connectivity within the VPC. If your VPC reaches its quota limit for ENIs or IP addresses, your Lambda function may fail to scale, leading to invocation errors. Monitoring and adjusting these quotas and ensuring an optimal VPC configuration are essential to maintaining a stable and scalable serverless architecture.

Hence, the correct answers for this scenario are:

– Your Lambda function exceeds the VPC quota for Elastic Network Interfaces (ENIs) or available IP addresses in the subnet.

– The Lambda function is placed in a VPC subnet with limited IP address capacity.

The option that says: Your VPC does not have a NAT gateway is incorrect because an issue in the NAT Gateway is unlikely to cause a request throttling issue or produce an EC2ThrottledException error in Lambda. As per the scenario, the issue is happening only at certain times of the day, which means that the issue is only intermittent and the function works at other times. We can also conclude that an availability issue is not an issue since the application is already using a highly available NAT Gateway and not just a NAT instance.

The option that says: The associated security group of your function does not allow outbound connections is incorrect because if the associated security group does not allow outbound connections, then the Lambda function will not work at all in the first place. Remember that as per the scenario, the issue only happens intermittently. In addition, Internet traffic restrictions do not usually produce EC2ThrottledException errors.

The option that says: The attached IAM execution role of your function does not have the necessary permissions to access the resources of your VPC is incorrect because just as what is explained above, the issue is intermittent and thus, the IAM execution role of the function does have the necessary permissions to access the resources of the VPC since it works at those specific times. In case the issue is indeed caused by a permission problem, then an EC2AccessDeniedException the error would most likely be returned and not an EC2ThrottledException error.

 

**References:**

https://docs.aws.amazon.com/lambda/latest/dg/vpc.html

https://aws.amazon.com/premiumsupport/knowledge-center/internet-access-lambda-function/

https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html

 

Check out this AWS Lambda Cheat Sheet:

https://tutorialsdojo.com/aws-lambda/

---

## Question 26

### Problem Statement & Options
A company is building an automation tool for generating custom reports on its AWS usage. The company must be able to programmatically access and forecast usage costs on specific services.

Which of the following would meet the requirements with the LEAST amount of operational overhead?

Utilize the downloadable AWS Cost Explorer report .csv files to access the cost-related data. Predict usage costs using AWS Budgets.
Configure AWS Budgets to send usage cost data to the company via Amazon SNS.
Use the AWS Cost Explorer API with pagination to programmatically retrieve the usage cost-related data.
Generate AWS Budgets reports for usage cost data and deliver them via Amazon Simple Queue Service (SQS).

### Detailed Solution Explanation
AWS Cost Explorer is a service provided by Amazon Web Services (AWS) that helps you visualize, understand, and analyze your AWS costs and usage. It provides a comprehensive set of tools and features to help you monitor and manage your AWS spending.



The primary purpose of AWS Cost Explorer is to help you gain insights into your AWS costs and usage patterns over time. It lets you view and analyze your historical spending data, forecast future costs, and identify cost-saving opportunities.

You can programmatically query your cost and usage data via the Cost Explorer API. You can query for aggregated data such as total monthly costs or total daily usage. You can also query for granular data, such as the number of daily write operations for DynamoDB database tables in your production environment.

By using the AWS Cost Explorer API, the company can programmatically access the usage cost-related data they need on specific services. The pagination feature allows for the efficient retrieval of large datasets.

Hence the correct answer is: Use the AWS Cost Explorer API with pagination to programmatically retrieve the usage cost-related data.

The option that says: Utilize the downloadable AWS Cost Explorer report .csv files to access the cost-related data. Predict usage costs using AWS Budgets is incorrect. This option involves the process of manually downloading .csv files, which adds significant operational overhead compared to directly accessing data through the AWS Cost Explorer API. This method simply lacks the ability to programmatically and dynamically retrieve usage data, making it a less efficient solution.

The option that says: Configure AWS Budgets to send usage cost data to the company via Amazon SNS is incorrect because this simply helps you get notified on budget thresholds; it does not provide access to the usage of cost-related data.

The option that says: Generate AWS Budgets reports for usage cost data and deliver them via Amazon Simple Queue Service (SQS) is incorrect. AWS Budgets just allows you to set custom cost and usage budgets that alert you when your budget thresholds are exceeded. It won’t give you detailed information on AWS usage and cost.

 

**References:**

https://docs.aws.amazon.com/cost-management/latest/userguide/ce-what-is.html

https://docs.aws.amazon.com/cost-management/latest/userguide/ce-api.html

 

Check out this AWS Billing and Cost Management Cheat Sheet:

https://tutorialsdojo.com/aws-billing-and-cost-management/

---

## Question 27

### Problem Statement & Options
A data analytics company keeps a massive volume of data that they store in their on-premises data center. To scale their storage systems, they are looking for cloud-backed storage volumes that they can mount using Internet Small Computer System Interface (iSCSI) devices from their on-premises application servers. They have an on-site data analytics application that frequently accesses the latest data subsets locally while the older data are rarely accessed. You are required to minimize the need to scale the on-premises storage infrastructure while still providing their web application with low-latency access to the data.

Which type of AWS Storage Gateway service will you use to meet the above requirements?

Volume Gateway in stored mode
Tape Gateway
File Gateway
Volume Gateway in cached mode

### Detailed Solution Explanation
The Volume Gateway is a cloud-based iSCSI block storage volume for your on-premises applications. The Volume Gateway provides either a local cache or full volumes on-premises while also storing full copies of your volumes in the AWS cloud.



There are two options for Volume Gateway:

Cached Volumes – you store volume data in AWS, with a small portion of recently accessed data in the cache on-premises.

Stored Volumes – you store the entire set of volume data on-premises and store periodic point-in-time backups (snapshots) in AWS.

In this scenario, the technology company is looking for a storage service that will enable their analytics application to frequently access the latest data subsets and not the entire data set (as it was mentioned that the old data are rarely being used). This requirement can be fulfilled by setting up a Cached Volume Gateway in AWS Storage Gateway.

By using cached volumes, you can use Amazon S3 as your primary data storage while retaining frequently accessed data locally in your storage gateway. Cached volumes minimize the need to scale your on-premises storage infrastructure while still providing your applications with low-latency access to frequently accessed data. You can create storage volumes up to 32 TiB in size and afterward, attach these volumes as iSCSI devices to your on-premises application servers. When you write to these volumes, your gateway stores the data in Amazon S3. It retains the recently read data in your on-premises storage gateway’s cache and uploads buffer storage.

Cached volumes can range from 1 GiB to 32 TiB in size and must be rounded to the nearest GiB. Each gateway configured for cached volumes can support up to 32 volumes for a total maximum storage volume of 1,024 TiB (1 PiB).

In the cached volumes solution, AWS Storage Gateway stores all your on-premises application data in a storage volume in Amazon S3. Hence, the correct answer is: Volume Gateway in cached mode.

Volume Gateway in stored mode is incorrect because the requirement is to provide low latency access to the frequently accessed data subsets locally. Stored Volumes are used if you need low-latency access to your entire dataset.

Tape Gateway is incorrect because this is just a cost-effective, durable, long-term offsite alternative for data archiving, which is not needed in this scenario.

File Gateway is incorrect because the scenario requires you to mount volumes as iSCSI devices. File Gateway is used to store and retrieve Amazon S3 objects through NFS and SMB protocols.

 

**References:**

https://docs.aws.amazon.com/storagegateway/latest/userguide/StorageGatewayConcepts.html#volume-gateway-concepts

https://docs.aws.amazon.com/storagegateway/latest/userguide/WhatIsStorageGateway.html

 

Check out this AWS Storage Gateway Cheat Sheet:

https://tutorialsdojo.com/aws-storage-gateway/

 

Tutorials Dojo’s AWS Certified Solutions Architect Associate Exam Study Guide:

https://tutorialsdojo.com/aws-certified-solutions-architect-associate-saa-c03/

---

## Question 28

### Problem Statement & Options
A media company is using Amazon EC2, ELB, and S3 for its video-sharing portal for filmmakers. They are using a standard S3 storage class to store all high-quality videos that are frequently accessed only during the first three months of posting.

As a Solutions Architect, what should you do if the company needs to automatically transfer or archive media data from an S3 bucket to Glacier?

Use Amazon SQS
Use a custom shell script that transfers data from the S3 bucket to Glacier
Use Lifecycle Policies
Use Amazon SWF

### Detailed Solution Explanation
You can create a lifecycle policy in S3 to automatically transfer your data to Glacier.

Lifecycle configuration enables you to specify the lifecycle management of objects in a bucket. The configuration is a set of one or more rules, where each rule defines an action for Amazon S3 to apply to a group of objects.



These actions can be classified as follows:

Transition actions – In which you define when objects transition to another storage class. For example, you may choose to transition objects to the STANDARD_IA (IA, for infrequent access) storage class 30 days after creation or archive objects to the GLACIER storage class one year after creation.

Expiration actions – In which you specify when the objects expire. Then Amazon S3 deletes the expired objects on your behalf.

 

Reference:

https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html

 

Check out this Amazon S3 Cheat Sheet:

https://tutorialsdojo.com/amazon-s3/

---

## Question 29

### Problem Statement & Options
A company plans to implement a hybrid architecture. A dedicated connection needs to be created from the Amazon Virtual Private Cloud (VPC) to the on-premises network. This connection must provide high bandwidth throughput and a more consistent network experience than Internet-based solutions.

Which of the following can be used to create a private connection between the VPC and the company’s on-premises network?

AWS Direct Connect
Transit Gateway with equal-cost multipath routing (ECMP)
AWS Site-to-Site VPN
Transit VPC

### Detailed Solution Explanation
AWS Direct Connect links your internal network to an AWS Direct Connect location over a standard Ethernet fiber-optic cable. One end of the cable is connected to your router, the other to an AWS Direct Connect router.

AWS Direct Connect diagram

With this connection, you can create virtual interfaces directly to public AWS services (for example, to Amazon S3) or to Amazon VPC, bypassing internet service providers in your network path. An AWS Direct Connect location provides access to AWS in the region with which it is associated. You can use a single connection in a public Region or AWS GovCloud (US) to access public AWS services in all other public Regions

Hence, the correct answer is: AWS Direct Connect.

Transit VPC is incorrect because this in itself is not enough to integrate your on-premises network to your VPC. You have to either use a VPN or a Direct Connect connection. A transit VPC is primarily used to connect multiple VPCs and remote networks in order to create a global network transit center and not for establishing a dedicated connection to your on-premises network.

Transit Gateway with equal-cost multipath routing (ECMP) is incorrect because a transit gateway is commonly used to connect multiple VPCs and on-premises networks through a central hub. Just like transit VPC, a transit gateway is not capable of establishing a direct and dedicated connection to your on-premises network.

AWS Site-to-Site VPN is incorrect because this type of connection traverses the public Internet. Moreover, it doesn’t provide a high bandwidth throughput and a more consistent network experience than Internet-based solutions.

 

**References:**

https://aws.amazon.com/premiumsupport/knowledge-center/connect-vpc/

https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html

 

Check out this AWS Direct Connect Cheat Sheet:

https://tutorialsdojo.com/aws-direct-connect/

 

Comparison of AWS Services Cheat Sheets:

https://tutorialsdojo.com/comparison-of-aws-services/

---

## Question 30

### Problem Statement & Options
A company has multiple research departments that have deployed several resources to the AWS cloud. Each department is free to provision resources as needed. To ensure normal operations, the company wants to track its AWS resource usage so that it does not reach the AWS service quotas unexpectedly.

Which combination of actions should the Solutions Architect implement to meet the company requirements? (Select TWO.)

Capture the events using Amazon EventBridge (Amazon CloudWatch Events) and use an Amazon Simple Notification Service (Amazon SNS) topic as the target for notifications.
Write an AWS Lambda function that refreshes the AWS Trusted Advisor Service Limits checks and set it to run every 24 hours.
Create an Amazon Simple Notification Service (Amazon SNS) topic and configure it as a target for notifications.
Utilize the AWS managed rule on AWS Config to monitor AWS resource service quotas. Schedule this checking using an AWS Lambda function.

Query the AWS Trusted Advisor Service Limits check every 24 hours by calling the DescribeTrustedAdvisorChecks API operation. Ensure that your AWS account has a Business Support+ plan.

### Detailed Solution Explanation
AWS Trusted Advisor draws upon best practices learned from serving hundreds of thousands of AWS customers. Trusted Advisor inspects your AWS environment and then makes recommendations when opportunities exist to save money, improve system availability and performance, or help close security gaps. If you have a Basic or Developer Support plan, you can use the Trusted Advisor console to access all checks in the Service Limits category and six checks in the Security category.

AWS Trusted Advisor draws upon best practices learned from serving hundreds of thousands of AWS customers. Trusted Advisor inspects your AWS environment and then makes recommendations when opportunities exist to save money, improve system availability and performance, or help close security gaps. If you have a Basic or Developer Support plan, you can use the Trusted Advisor console to access all checks in the Service Limits category and six checks in the Security category.

AWS has an example of the implementation of the Quota Monitor CloudFormation template that you can deploy on your AWS account. The template uses an AWS Lambda function that runs once every 24 hours. The Lambda function refreshes the AWS Trusted Advisor Service Limits checks to retrieve the most current utilization and quota data through API calls. Amazon EventBridge captures the status events from Trusted Advisor. It uses a set of EventBridge rules to send the status events to all the targets you choose during the initial deployment of the solution: an Amazon Simple Queue Service (Amazon SQS) queue, an Amazon Simple Notification Service (Amazon SNS) topic, or a Lambda function for Slack notifications.

Quota Monitor for AWS

The AWS Trusted Advisor Service limit publishes service limits metric to CloudWatch; thus, you can configure an alarm and send a notification to Amazon SNS. You can also create an AWS Lambda function to read data from specific Trusted Advisor checks. A Lambda function invocation can be scheduled using Amazon EventBridge (Amazon CloudWatch Events) to automate the process.

Hence, the following options are correct:

– Capture the events using Amazon EventBridge (Amazon CloudWatch Events) and use an Amazon Simple Notification Service (Amazon SNS) topic as the target for notifications

– Write an AWS Lambda function that refreshes the AWS Trusted Advisor Service Limits checks and set it to run every 24 hours

The option that says: Create an Amazon Simple Notification Service (Amazon SNS) topic and configure it as a target for notifications is incorrect. This option is incomplete as it doesn’t specify where the notification comes from, such as from EventBridge, Lambda functions, etc.

The option that says: Query the AWS Trusted Advisor Service Limits check every 24 hours by calling the DescribeTrustedAdvisorChecks API operation. Ensure that your AWS account has a Business Support+ plan is incorrect because although the Trusted Advisor APIs (AWS Support APIs) are available with a Business Support+ plan, this API only returns information about all available AWS Trusted Advisor checks, making it difficult to extract specific “service limits” data. Additionally, the API doesn’t directly provide a focused view on service limits, requiring extra steps to filter out irrelevant information, which complicates the process.

The option that says: Utilize the AWS managed rule on AWS Config to monitor AWS resource service quotas. Schedule this checking using an AWS Lambda function is incorrect because AWS Config rules are primarily designed for compliance purposes rather than for real-time monitoring of quota usage. Additionally, depending on AWS Config adds both costs and complexity, as it requires a separate service to schedule and trigger these checks.

 

**References:**

https://aws.amazon.com/solutions/implementations/quota-monitor/

https://aws.amazon.com/blogs/mt/monitoring-service-limits-with-trusted-advisor-and-amazon-cloudwatch/

 

Check out these Amazon CloudWatch and AWS Trusted Advisor Cheat Sheets:

https://tutorialsdojo.com/amazon-cloudwatch/

https://tutorialsdojo.com/aws-trusted-advisor/

AWS has an example of the implementation of the Quota Monitor CloudFormation template that you can deploy on your AWS account. The template uses an AWS Lambda function that runs once every 24 hours. The Lambda function refreshes the AWS Trusted Advisor Service Limits checks to retrieve the most current utilization and quota data through API calls. Amazon EventBridge captures the status events from Trusted Advisor. It uses a set of EventBridge rules to send the status events to all the targets you choose during the initial deployment of the solution: an Amazon Simple Queue Service (Amazon SQS) queue, an Amazon Simple Notification Service (Amazon SNS) topic, or a Lambda function for Slack notifications.

Quota Monitor for AWS

The AWS Trusted Advisor Service limit publishes service limits metric to CloudWatch; thus, you can configure an alarm and send a notification to Amazon SNS. You can also create an AWS Lambda function to read data from specific Trusted Advisor checks. A Lambda function invocation can be scheduled using Amazon EventBridge (Amazon CloudWatch Events) to automate the process.

Hence, the following options are correct:

– Capture the events using Amazon EventBridge (Amazon CloudWatch Events) and use an Amazon Simple Notification Service (Amazon SNS) topic as the target for notifications

– Write an AWS Lambda function that refreshes the AWS Trusted Advisor Service Limits checks and set it to run every 24 hours

The option that says: Create an Amazon Simple Notification Service (Amazon SNS) topic and configure it as a target for notifications is incorrect. This option is incomplete as it doesn’t specify where the notification comes from, such as from EventBridge, Lambda functions, etc.

The option that says: Query the AWS Trusted Advisor Service Limits check every 24 hours by calling the DescribeTrustedAdvisorChecks API operation. Ensure that your AWS account has a Developer support plan is incorrect. This API only returns information about all available AWS Trusted Advisor checks, so it will be difficult to extract only “service limits” information from this API call. Moreover, the Trusted Advisor APIs (AWS Support APIs) are only available for Business, Enterprise On-Ramp, or Enterprise Support plans.

The option that says: Utilize the AWS managed rule on AWS Config to monitor AWS resource service quotas. Schedule this checking using an AWS Lambda function is incorrect because AWS Config rules are primarily designed for compliance purposes rather than for real-time monitoring of quota usage. Additionally, depending on AWS Config adds both costs and complexity, as it requires a separate service to schedule and trigger these checks.

 

**References:**

https://aws.amazon.com/solutions/implementations/quota-monitor/

https://aws.amazon.com/blogs/mt/monitoring-service-limits-with-trusted-advisor-and-amazon-cloudwatch/

 

Check out these Amazon CloudWatch and AWS Trusted Advisor Cheat Sheets:

https://tutorialsdojo.com/amazon-cloudwatch/

https://tutorialsdojo.com/aws-trusted-advisor/

---

