# AWS Solutions Architect - Mock Exam 1 Review

This document contains a transcription of the scanned mock exam questions along with detailed answers and explanations for study purposes.

## Question 1
**Scenario:** A travel company has a suite of web applications hosted in an Auto Scaling group of On-Demand EC2 instances behind an Application Load Balancer that handles traffic from various web domains (e.g., i-love-manila.com). You need to allow multiple domains to serve SSL traffic without the need to reauthenticate and reprovision your certificate every time you add a new domain.
**Answer:** Use **Server Name Indication (SNI)** on the Application Load Balancer.
**Explanation:** SNI allows you to attach multiple SSL certificates to a single ALB. You just add the new domain's certificate without touching the others. A SAN certificate would require reprovisioning every time you add a domain.

## Question 2
**Scenario:** A company has a fleet of running Spot EC2 instances behind an ALB. You need to set up a distributed session management layer that will provide scalable and shared data storage for user sessions, supports multithreaded performance, provides sub-millisecond latency, and automatically replaces failed nodes.
**Answer:** **Amazon ElastiCache for Memcached with Auto Discovery**
**Explanation:** ElastiCache provides sub-millisecond latency. Memcached is multithreaded, unlike Redis. Auto Discovery helps the application identify all nodes in the cluster dynamically.

## Question 3
**Scenario:** A company plans to implement a hybrid architecture requiring a dedicated connection from the VPC to the on-premises network. It must provide high bandwidth throughput and a more consistent network experience than Internet-based solutions.
**Answer:** **AWS Direct Connect**
**Explanation:** Direct Connect provides a physical, dedicated private connection bypassing the public internet, ensuring consistent high bandwidth. Site-to-Site VPN traverses the public internet.

## Question 4
**Scenario:** A media company stores high-quality videos in an S3 Standard bucket. The videos are frequently accessed only during the first three months. You need to automatically transfer or archive media data from S3 to Glacier after this period.
**Answer:** **Use S3 Lifecycle Policies**
**Explanation:** Lifecycle policies automatically transition objects between storage classes (e.g., from Standard to Glacier) based on their age, without requiring custom scripts or manual intervention.

## Question 5
**Scenario:** A custom messaging service receives thousands of messages per day for an EMR cluster. It is crucial that none of the messages are lost, no duplicates are produced (exactly-once processing), and messages are processed in the exact order of arrival.
**Answer:** **Amazon SQS FIFO queue** 
**Explanation:** If strict ordering and absolute *no duplicates* (exactly-once processing) are required, SQS FIFO is the best choice. Standard SQS can have duplicates and out-of-order delivery. 

## Question 6
**Scenario:** An S3 bucket is changed from Standard to Standard-Infrequent Access (Standard-IA) to save costs. Which statements about Standard-IA are true? (Select TWO)
**Answer:** 
1. **It is designed for data that is accessed less frequently.**
2. **It is designed for data that requires rapid access when needed.**
**Explanation:** Standard-IA offers the same low latency and high throughput as Standard, making it perfect for rapid access, but it charges a retrieval fee, making it ideal for less frequently accessed data.

## Question 7
**Scenario:** You are trying to enable Cross-Region Replication (CRR) on an S3 bucket, but the option is disabled. 
**Answer:** **In order to use the Cross-Region Replication feature in S3, you need to first enable versioning on the bucket.**
**Explanation:** AWS requires versioning to be enabled on both the source and destination buckets before you can configure any replication rules.

## Question 8
**Scenario:** You need to estimate AWS costs. Which of the following will incur costs? (Select TWO)
**Answer:** 
1. **A running EC2 Instance**
2. **EBS Volumes attached to stopped EC2 Instances**
**Explanation:** Stopped EC2 instances do not incur compute charges, but you are still charged for the storage space consumed by the attached EBS volumes. VPCs are free. 

## Question 9
**Scenario:** An EC2 application polls a queue for video transcoding. If interrupted, another instance picks it up. You need to add more EC2 instances just to clear a large backlog. What is the most cost-effective instance type?
**Answer:** **Spot Instances**
**Explanation:** Because the workload is asynchronous (uses a queue) and resilient to interruptions, Spot instances are perfectly suited and provide up to 90% discount compared to On-Demand.

## Question 10
**Scenario:** IoT data is sent to a Kinesis Stream with default settings. Every 3 days, data is sent to S3, but only the last day's data is present. Where did the older data go?
**Answer:** **By default, data records in Kinesis are only accessible for 24 hours from the time they are added to a stream.**
**Explanation:** Kinesis Data Streams have a default retention period of 24 hours. Data older than that is automatically deleted unless you explicitly increase the retention period.

## Question 11
**Scenario:** What enhanced monitoring metrics does CloudWatch gather from Amazon RDS DB instances to provide more accurate OS-level information? (Select TWO)
**Answer:**
1. **RDS child processes**
2. **OS processes**
**Explanation:** Standard CloudWatch only sees the hypervisor level. Enhanced Monitoring gives you visibility into the underlying OS, allowing you to monitor OS processes and RDS child processes.

## Question 12
**Scenario:** Using Amazon CloudFront, what method would be used to serve content that is stored in Amazon S3 but not publicly accessible from S3 directly?
**Answer:** **Create an Origin Access Control (OAC) / Origin Access Identity (OAI) for CloudFront and grant access to the S3 bucket.**
**Explanation:** OAC/OAI ensures that users can only access the files through CloudFront, preventing them from bypassing the CDN and accessing the S3 URLs directly.

## Question 13
**Scenario:** An application spans two custom VPCs in Ohio and N. Virginia. You must transfer data between instances without traversing the public internet. (Select TWO)
**Answer:**
1. **Set up a VPC peering connection between the VPCs.**
2. **Re-configure the route table's target and destination of the instances' subnet.**
**Explanation:** Inter-region VPC peering securely connects two VPCs over the AWS global network. After peering, you must update the route tables in both VPCs to direct traffic to the peering connection.

## Question 14
**Scenario:** A GraphQL API on EKS connects to a DynamoDB table with DAX. You must prevent database calls from traversing the public internet and automate cross-account backups.
**Answer:** **Create a DynamoDB Gateway/Interface endpoint and enable Point-in-Time Recovery / AWS Backup.**
**Explanation:** VPC Endpoints keep traffic between the VPC and DynamoDB strictly within the AWS network. AWS Backup natively supports cross-account backups for supported services like DynamoDB.

## Question 15
**Scenario:** Multiple departments provision resources freely. You need to track usage so it doesn't unexpectedly reach AWS service quotas. (Select TWO)
**Answer:**
1. **Capture the events using Amazon EventBridge.**
2. **Create an Amazon SNS topic and configure it as a target for notifications.**
**Explanation:** AWS Trusted Advisor monitors service limits. You can use EventBridge to capture Trusted Advisor limit alerts and trigger an SNS topic to notify the IT team automatically.

## Question 16
**Scenario:** A company is building a custom reporting automation tool. They must programmatically access and forecast usage costs with the LEAST amount of operational overhead.
**Answer:** **Use the AWS Cost Explorer API with pagination.**
**Explanation:** The Cost Explorer API is a native, managed way to query cost and usage data programmatically, eliminating the need to parse CSVs manually or manage complex budgets.

## Question 17 & 18
**Scenario:** An IAM policy allows Lambda creation globally, but explicitly denies creation/deletion for the source IP `187.5.104.11/32`. Which action is allowed?
**Answer:** **Create an AWS Lambda function using the 100.220.0.11/32 address.**
**Explanation:** In IAM, an explicit DENY always trumps an ALLOW. Since the specific IP (187.5.104.11) is explicitly denied, it cannot perform the actions. Any other IP (like 100.220.0.11) falls back to the ALLOW statement.

## Question 19
**Scenario:** A government policy prohibits your web application (hosted behind an ALB) from servicing a specific country. How do you comply?
**Answer:** **Create a Web ACL rule in AWS WAF to block the specified country. Associate the rule to the Application Load Balancers.**
**Explanation:** AWS WAF features geographic match conditions, allowing you to easily block or allow traffic based on the country of origin. You can attach WAF directly to an ALB.

## Question 20
**Scenario:** A dashboard app on a Spot EC2 instance is reachable via a private IPv4 domain name. You need to quickly allow traffic flow to resume in another instance if the primary is terminated.
**Answer:** **Create a secondary elastic network interface (ENI) and point its private IPv4 address to the domain name. If the instance goes down, move the ENI to another instance.**
**Explanation:** ENIs can be detached and attached to different instances on the fly. Since the private IP is tied to the ENI, moving the ENI seamlessly redirects traffic to the backup instance.

## Question 21
**Scenario:** A Lambda function in a VPC with a /27 CIDR block processes massive transactions to EFS. You notice `EC2ThrottledException` errors. What are the causes? (Select TWO)
**Answer:**
1. **The Lambda function is placed in a VPC subnet with limited IP address capacity.**
2. **Your Lambda function exceeds the VPC quota for Elastic Network Interfaces (ENIs) or available IP addresses.**
**Explanation:** A /27 subnet only has 27 usable IPs. During high concurrency, Lambda attempts to create ENIs for scaling, which consumes IPs. Running out of IPs or hitting the ENI creation rate limit causes throttling exceptions.

## Question 22
**Scenario:** A strict security policy mandates that a production VPC must only allow outbound communication over IPv6 between instances and the internet, but prevent inbound IPv6 connections.
**Answer:** **Launch the EC2 instance to a private subnet and attach an Egress-Only Internet Gateway to the VPC.**
**Explanation:** An Egress-Only Internet Gateway acts identically to a NAT Gateway, but specifically for IPv6. It allows outbound IPv6 traffic while blocking inbound internet requests.

## Question 23
**Scenario:** An online accounting application requires path-based routing, host-based routing, and bi-directional streaming using Remote Procedure Call (gRPC).
**Answer:** **Configure an Application Load Balancer in front of the auto-scaling group. Select gRPC as the protocol version.**
**Explanation:** The ALB operates at Layer 7 and natively supports path-based routing, host-based routing, and the gRPC protocol for microservices. Network Load Balancers (Layer 4) do not support path routing.

## Question 24
**Scenario:** You need to mitigate DDoS attacks on a publicly accessible HPC application. Which options are NOT suitable? (Select TWO)
**Answer:**
1. **Add multiple Elastic Fabric Adapters (EFA) to each EC2 instance.**
2. **Use Dedicated EC2 instances to ensure maximum performance.**
**Explanation:** EFAs are for high-speed inter-node communication (HPC clusters) and Dedicated instances simply change the tenancy of the hardware. Neither provides any mechanism to stop or absorb a DDoS attack.

## Question 25
**Scenario:** To protect confidential data, an Amazon RDS MySQL database must only be accessible using an authentication token specific to the profile credentials of the querying EC2 instances.
**Answer:** **Enable IAM DB Authentication.**
**Explanation:** IAM DB Authentication allows you to authenticate to MySQL or PostgreSQL RDS databases using an IAM role/token instead of traditional static database passwords. 

## Question 26
**Scenario:** After an accidental data deletion, you must protect S3 objects from BOTH accidental deletion and overwriting. (Select TWO)
**Answer:**
1. **Enable Versioning**
2. **Enable Multi-Factor Authentication (MFA) Delete**
**Explanation:** Versioning ensures that overwriting or deleting an object simply creates a new version or delete marker, preserving the original. MFA Delete requires a physical MFA code to permanently delete an object version.

## Question 27
**Scenario:** An Aurora read replica faces difficulties keeping up with increasing read traffic during peak periods, causing bottlenecks. Most cost-effective solution?
**Answer:** **Use automatic scaling for the Aurora read replica using Aurora Auto Scaling.**
**Explanation:** Aurora Auto Scaling dynamically adds or removes Aurora Replicas based on CloudWatch metrics (like CPU or Connections). This ensures performance during peaks and saves money when traffic drops.

## Question 28
**Scenario:** A monitoring application requires audit logs to be retained for exactly 5 years before they can be deleted to meet compliance mandates. 
**Answer:** **Store the audit logs in a Glacier vault and use the Vault Lock feature.**
**Explanation:** Glacier Vault Lock allows you to deploy and enforce strict compliance controls (like Write Once Read Many - WORM). Once a 5-year lock is applied, the data literally cannot be deleted by anyone until the time expires.

## Question 29
**Scenario:** An on-premises application frequently accesses the latest data subsets locally while older data is rarely accessed. You need to minimize on-premises storage scaling by using cloud-backed iSCSI volumes.
**Answer:** **AWS Storage Gateway - Volume Gateway in Cached Mode**
**Explanation:** Cached volumes store your primary data in S3 but keep a small portion of recently accessed data locally on-premises. This provides low-latency access to hot data while utilizing infinite cloud storage for cold data. 

## Question 30
**Scenario:** A Windows EC2 instance takes several minutes to become fully operational on startup, impacting productivity. How can you speed up the loading time without driving up cost?
**Answer:** **Migrate the application to an EC2 instance with hibernation enabled.**
**Explanation:** Hibernation saves the contents of the instance memory (RAM) to the EBS volume. When the instance is started again, the memory state is restored immediately, entirely bypassing the lengthy OS boot process.

## Question 31
**Scenario:** An IT manager wants to stop over-provisioning in an EC2 Auto Scaling group to save costs without affecting performance. Which dynamic scaling policy is best?
**Answer:** **Use target tracking scaling.**
**Explanation:** Target tracking allows you to set a target (e.g., maintain average CPU utilization at 60%). The ASG will automatically calculate and adjust the capacity needed to maintain that exact target, preventing over-provisioning.
