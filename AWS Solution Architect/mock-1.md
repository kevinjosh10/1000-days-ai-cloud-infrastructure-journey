# AWS Solutions Architect - Mock Exam 1 Review (Detailed Explanations)

This document contains a transcription of the scanned mock exam questions along with highly detailed explanations for study purposes.

---

## Question 1
**Scenario:** A travel company has a suite of web applications hosted in an Auto Scaling group of On-Demand EC2 instances behind an Application Load Balancer that handles traffic from various web domains (e.g., i-love-manila.com, i-love-boracay.com, i-love-cebu.com). To improve security and lessen the overall cost, you are instructed to secure the system by allowing multiple domains to serve SSL traffic without the need to reauthenticate and reprovision your certificate every time you add a new domain. This migration from HTTP to HTTPS will help improve their SEO and Google search ranking. Which of the following is the most cost-effective solution to meet the above requirement?

**Answer:** Use **Server Name Indication (SNI)** on the Application Load Balancer.

**Detailed Explanation:** 
To host multiple TLS/SSL certificates for completely different domains on a single load balancer, AWS supports a technology called **Server Name Indication (SNI)**. SNI is an extension to the TLS protocol by which a client indicates which hostname it is attempting to connect to at the start of the handshaking process. 

*Why this is the correct answer:* By using SNI on the Application Load Balancer (ALB), you can bind multiple distinct SSL certificates (e.g., one for i-love-manila.com and one for i-love-boracay.com) to a single secure listener on port 443. Crucially, when the company acquires a *new* domain, you simply request a new, separate certificate from AWS Certificate Manager (ACM) for that specific domain and attach it to the ALB's SNI certificate list. You do **not** have to touch, reauthenticate, or reprovision the existing certificates. 

*Why other options are wrong:*
- **Subject Alternative Name (SAN) Certificate:** While a SAN certificate can cover multiple different domains, if you add a new domain, you must completely re-request and reprovision the entire certificate to include the new domain. This directly violates the question's requirement.
- **Wildcard Certificate:** A wildcard certificate (e.g., `*.i-love.com`) only covers subdomains of a single root domain. It cannot cover completely different root domains like `i-love-manila.com` and `i-love-boracay.com`.
- **CloudFront with Dedicated IP:** Using CloudFront to serve HTTPS requests using dedicated IP addresses costs a flat fee of $600 per month per edge location. This is extremely expensive and violates the "most cost-effective" requirement. SNI on CloudFront or ALB is free.

---

## Question 2
**Scenario:** A company has a fleet of running Spot EC2 instances behind an Application Load Balancer. The incoming traffic comes from various users across multiple AWS regions, and you would like to have the user's session shared among the fleet of instances. A Solutions Architect is required to set up a distributed session management layer that will provide scalable and shared data storage for the user sessions that supports multithreaded performance. The cache layer must also detect any node failures and replace the failed ones automatically. Which of the following would be the best choice to meet the requirement while still providing sub-millisecond latency for the users?

**Answer:** **Amazon ElastiCache for Memcached with Auto Discovery**

**Detailed Explanation:**
Session state management requires a high-performance, in-memory data store to ensure the application remains stateless and can scale dynamically behind an ALB. 

*Why this is the correct answer:* 
The keywords in this question are **"sub-millisecond latency"**, **"multithreaded performance"**, and **"detect node failures and replace... automatically"**. 
1. Amazon ElastiCache operates strictly in-memory, which guarantees the requested sub-millisecond latency. 
2. **Memcached is inherently multithreaded**, meaning it can make use of multiple cores on a single node for faster compute performance. 
3. ElastiCache for Memcached supports a feature called **Auto Discovery**. This allows client applications to automatically identify all of the nodes in a cache cluster, and automatically connect to any new nodes that are added to replace failed nodes. AWS manages the detection and replacement of these failed nodes.

*Why other options are wrong:*
- **Amazon RDS with RDS Proxy:** RDS is a relational database backed by EBS volumes (disk storage). While fast, disk-backed databases provide millisecond latency, not the *sub-millisecond* latency provided by in-memory engines like Memcached or Redis.
- **Amazon ElastiCache for Redis:** While Redis is a fantastic in-memory cache that supports sub-millisecond latency and high availability via replication, Redis is strictly **single-threaded**. The prompt explicitly requires multithreaded performance.

---

## Question 3
**Scenario:** A company plans to implement a hybrid architecture. A dedicated connection needs to be created from the Amazon Virtual Private Cloud (VPC) to the on-premises network. This connection must provide high bandwidth throughput and a more consistent network experience than Internet-based solutions. Which of the following can be used to create a private connection between the VPC and the company's on-premises network?

**Answer:** **AWS Direct Connect**

**Detailed Explanation:**
Enterprise hybrid architectures require connecting an on-premises data center to the AWS Cloud. There are generally two ways to do this: over the public internet (VPN), or via a dedicated physical fiber-optic line (Direct Connect).

*Why this is the correct answer:*
**AWS Direct Connect** bypasses the public internet entirely. It establishes a dedicated, private, physical network connection from your on-premises facility directly to an AWS Direct Connect location. Because the traffic never touches the public internet, it guarantees **high bandwidth throughput** (up to 100 Gbps) and a highly **consistent network experience** without the unpredictable latency spikes associated with public internet routing.

*Why other options are wrong:*
- **AWS Site-to-Site VPN:** This establishes a secure, encrypted IPSec tunnel from your data center to AWS, but the traffic still travels over the **public internet**. Therefore, it cannot guarantee a consistent network experience or the massive dedicated bandwidth throughput of Direct Connect.
- **Transit Gateway with ECMP:** Transit Gateway is a hub-and-spoke router for connecting VPCs and on-prem networks. However, to connect to on-prem, it still requires either a VPN or Direct Connect attachment. ECMP (Equal-Cost Multi-Path) just provides higher VPN bandwidth by aggregating tunnels, but it still relies on the internet.
- **Transit VPC:** This is a legacy pattern used before Transit Gateway existed. It does not natively provide a dedicated physical connection.

---

## Question 4
**Scenario:** A media company is using Amazon EC2, ELB, and S3 for its video-sharing portal for filmmakers. They are using a standard S3 storage class to store all high-quality videos that are frequently accessed only during the first three months of posting. As a Solutions Architect, what should you do if the company needs to automatically transfer or archive media data from an S3 bucket to Glacier?

**Answer:** **Use S3 Lifecycle Policies**

**Detailed Explanation:**
Data temperature changes over time. In this scenario, video files are "hot" (frequently accessed) for the first 90 days, and then become "cold" (rarely accessed archival data). Keeping cold data in S3 Standard is extremely expensive.

*Why this is the correct answer:*
**Amazon S3 Lifecycle Policies** provide an automated, rule-based mechanism to manage the lifecycle of your objects. You can define a lifecycle rule that says: "Keep objects in S3 Standard for 90 days, and on day 91, automatically transition them to Amazon S3 Glacier." This transition happens natively in the background without any manual intervention, compute overhead, or custom code, making it perfectly aligned with the Operational Excellence pillar.

*Why other options are wrong:*
- **Custom Shell Script:** While you could technically write a script running on EC2 or Lambda to move data to Glacier, this introduces significant operational overhead, maintenance burdens, and compute costs. AWS Well-Architected principles dictate using managed services whenever possible.
- **Amazon SQS / Amazon SWF:** Simple Queue Service (SQS) and Simple Workflow Service (SWF) are message brokering and task coordination services. They have absolutely nothing to do with managing object storage tiers in S3.

---

## Question 5
**Scenario:** A company plans to develop a custom messaging service that will be used to train an AI for an automatic response feature. The service is expected to receive thousands of messages per day, all of which will be processed by an Amazon EMR cluster. It is crucial that none of the messages are lost, no duplicates are produced, and that the messages are processed in EMR in the same order as arrival. Which of the following options can satisfy the given requirement?

**Answer:** **Set up an Amazon SQS FIFO queue** (Note: Assuming the correct unseen option was SQS FIFO).

**Detailed Explanation:**
Message queuing architectures decouple producers (message senders) from consumers (EMR processing). However, standard distributed queues do not guarantee the exact order of messages or prevent duplicate deliveries.

*Why this is the correct answer:*
The keywords here are **"no duplicates are produced"** (exactly-once processing) and **"processed... in the same order as arrival"** (First-In-First-Out).
**Amazon SQS FIFO (First-In-First-Out) Queues** are explicitly designed for this exact use case. They enhance the standard SQS offering by guaranteeing that messages are processed strictly in the exact order they were sent. Furthermore, SQS FIFO provides exactly-once processing by utilizing message deduplication IDs, ensuring that even if a producer accidentally sends the same message twice, the queue will drop the duplicate. 

*Why other options are wrong:*
- **Amazon SQS Standard Queue:** Standard queues provide "at-least-once" delivery (which means duplicates can occur) and "best-effort" ordering (messages might arrive out of order). This directly violates the requirements.
- **Amazon SNS:** SNS is a pub/sub notification service. It pushes messages to subscribers but does not natively queue them for processing by a cluster like EMR in a controlled, ordered, exactly-once manner.
- **Amazon Kinesis Data Firehose:** Firehose is used to stream data into destinations like S3 or Redshift. It does not guarantee strict ordering or exact-once deduplication (it is at-least-once).

---

## Question 6
**Scenario:** A Solutions Architect created a new Standard-class Amazon S3 bucket to store financial reports that are not frequently accessed but should immediately be available when an auditor requests the reports. To save costs, the Architect changed the storage class of the S3 bucket from Standard to Infrequent Access storage class. In S3 Standard – Infrequent Access storage class, which of the following statements are true? (Select TWO.)

**Answer:** 
1. **It is designed for data that is accessed less frequently.**
2. **It is designed for data that requires rapid access when needed.**

**Detailed Explanation:**
Amazon S3 offers various storage classes tailored to specific use cases to optimize costs. Standard-IA (Infrequent Access) sits between S3 Standard and S3 Glacier in terms of cost and performance.

*Why this is the correct answer:*
**S3 Standard-IA** physically stores data on the exact same high-performance hardware as S3 Standard. Therefore, it provides the exact same **low latency and high throughput** performance (millisecond rapid access). The catch is the pricing model: it charges a much lower monthly storage fee, but applies a per-GB retrieval fee when you access the data. Thus, it is mathematically designed for data that is **accessed less frequently** (saving money on storage) but still requires **rapid access when needed** (because there is no retrieval delay, unlike Glacier).

*Why other options are wrong:*
- **"It automatically moves data to the most cost-effective access tier without any operational overhead."** This is a description of **S3 Intelligent-Tiering**, not Standard-IA. Standard-IA requires you to manually place data there or use a Lifecycle Policy.
- **"It provides high latency and low throughput performance."** This is false. Standard-IA provides low latency and high throughput, identical to S3 Standard.

---

## Question 7
**Scenario:** A Solutions Architect is trying to enable Cross-Region Replication to an Amazon S3 bucket but this option is disabled. The bucket has been configured with a Multi-Region Access Point to manage incoming requests. Which of the following options is a valid reason for this?

**Answer:** **In order to use the Cross-Region Replication feature in S3, you need to first enable versioning on the bucket.**

**Detailed Explanation:**
Cross-Region Replication (CRR) is a feature in S3 that automatically and asynchronously copies every object uploaded to a source bucket in one AWS region to a destination bucket in a different AWS region.

*Why this is the correct answer:*
At an architectural level, S3 replication relies heavily on tracking the exact state of objects, including updates and deletions. To ensure that the replication engine can accurately replicate object modifications without race conditions or data loss, **AWS strictly requires Versioning to be enabled on BOTH the source and destination buckets**. If versioning is turned off or suspended on the source bucket, the AWS Console will grey out and disable the replication configuration options entirely.

*Why other options are wrong:*
- **"The Cross-Region Replication feature is only available for S3 – Infrequent Access / One Zone-IA."** False. CRR works across all standard S3 storage classes.
- **"This is a premium feature which is only for AWS Enterprise accounts."** False. S3 Replication is a standard feature available to all AWS account tiers. 

---

## Question 8
**Scenario:** To save costs, your manager instructed you to analyze and review the setup of your AWS cloud infrastructure. You should also provide an estimate of how much your company will pay for all of the AWS resources that they are using. In this scenario, which of the following will incur costs? (Select TWO.)

**Answer:** 
1. **A running EC2 Instance**
2. **EBS Volumes attached to stopped EC2 Instances**

**Detailed Explanation:**
Understanding the AWS billing model is fundamental to the Cost Optimization pillar of the Well-Architected Framework. You must differentiate between compute costs and storage costs.

*Why this is the correct answer:*
1. **A running EC2 instance** consumes physical compute hardware (CPU and RAM) in the AWS data center, so you are billed for every second it remains in the "Running" state.
2. When you stop an EC2 instance, you stop paying for the compute power. However, the data stored on the Elastic Block Store (EBS) volume attached to that instance remains persistently stored on AWS storage arrays. **EBS volumes are billed by provisioned gigabytes per month**, regardless of whether the EC2 instance attached to them is running or stopped.

*Why other options are wrong:*
- **A stopped On-Demand EC2 Instance:** Once an instance transitions to the "Stopped" state, AWS releases the physical hardware back to the pool, and you are no longer billed for compute hours.
- **Using an Amazon VPC:** The foundational components of a Virtual Private Cloud (VPCs, Subnets, Route Tables, Internet Gateways) are provided completely free of charge by AWS. (Note: NAT Gateways and PrivateLink endpoints do incur charges, but the VPC itself does not).
- **Public Data Set:** AWS hosts a registry of open data (like genomics data, satellite imagery). Accessing this data does not incur storage costs for your account.

---

## Question 9
**Scenario:** The media company that you are working for has a video transcoding application running on Amazon EC2. Each EC2 instance polls a queue to find out which video should be transcoded, and then runs a transcoding process. If this process is interrupted, the video will be transcoded by another instance based on the queuing system. This application has a large backlog of videos which need to be transcoded. Your manager would like to reduce this backlog by adding more EC2 instances, however, these instances are only needed until the backlog is reduced. In this scenario, which type of Amazon EC2 instance is the most cost-effective type to use?

**Answer:** **Spot instances**

**Detailed Explanation:**
AWS offers different EC2 purchasing options depending on the workload's flexibility regarding time and interruptions.

*Why this is the correct answer:*
The keywords defining this workload are: **"polls a queue"** (asynchronous processing), **"if... interrupted, transcoded by another instance"** (fault-tolerant and stateless), and **"only needed until the backlog is reduced"** (temporary burst workload). 
**Spot Instances** allow you to bid on spare Amazon EC2 computing capacity for up to a 90% discount compared to On-Demand pricing. The only catch is that AWS can terminate (interrupt) Spot instances with a 2-minute warning if they need the capacity back. Because this transcoding application uses a queue to track work, it is inherently designed to handle interruptions gracefully. If a Spot instance is terminated mid-transcode, the message simply goes back onto the queue for another instance to pick up. Therefore, Spot instances offer the absolute maximum cost savings with no risk to data integrity.

*Why other options are wrong:*
- **On-demand instances:** You pay a premium flat rate. While it guarantees the instance won't be interrupted, it is significantly more expensive than Spot and unnecessary for an interruptible workload.
- **Reserved instances:** These require a 1-year or 3-year upfront commitment. The scenario states the instances are "only needed until the backlog is reduced" (a short-term requirement), making a long-term contract a massive waste of money.

---

## Question 10
**Scenario:** A startup is building IoT devices and monitoring applications. They are using IoT sensors to monitor traffic in real-time by using an Amazon Kinesis Stream that is configured with default settings. It then sends the data to an Amazon S3 bucket every 3 days. When you checked the data in S3 on the 3rd day, only the data for the last day is present and no data is present from 2 days ago. Which of the following is the MOST likely cause of this issue?

**Answer:** **By default, data records in Kinesis are only accessible for 24 hours from the time they are added to a stream.**

**Detailed Explanation:**
Amazon Kinesis Data Streams is a highly scalable service for ingesting real-time streaming data. However, it is not a permanent storage database; it is a temporary buffer.

*Why this is the correct answer:*
When data is written to a Kinesis Data Stream, AWS holds onto that data for a specific retention period, allowing consumer applications time to read and process it. **By default, the data retention period for Kinesis Data Streams is exactly 24 hours.** 
In this scenario, the startup is waiting 3 days (72 hours) before extracting the data to S3. Because the retention is set to the default 24 hours, any data older than 24 hours is automatically and permanently purged from the stream by AWS. Therefore, on day 3, days 1 and 2 have already been deleted. (Note: You can easily fix this by API call to increase the retention period up to 365 days, for an additional fee).

*Why other options are wrong:*
- **The access of the Kinesis stream to the S3 bucket is insufficient:** If this were true, *no* data would be present in S3 at all.
- **Someone manually deleted the record in Amazon S3:** While possible, it is highly improbable as the "most likely cause" in an architecture exam testing your knowledge of service defaults.

---

## Question 11
**Scenario:** A company deployed an online enrollment system database on a prestigious university, which is hosted in RDS. The Solutions Architect is required to monitor the database metrics in Amazon CloudWatch to ensure the availability of the enrollment system. What are the enhanced monitoring metrics that Amazon CloudWatch gathers from Amazon RDS DB instances which provide more accurate information? (Select TWO.)

**Answer:**
1. **RDS child processes**
2. **OS processes**

**Detailed Explanation:**
Monitoring RDS involves looking at two different layers of metrics: standard CloudWatch metrics and RDS Enhanced Monitoring.

*Why this is the correct answer:*
By default, Amazon CloudWatch gathers metrics about your DB instance directly from the **hypervisor** level (the virtualization layer). From the hypervisor's perspective, the entire database instance is just a single black box consuming CPU, Memory, and Disk IO. 
However, **Enhanced Monitoring** installs an agent directly onto the underlying operating system of the RDS instance. Because the agent lives inside the OS, it can see exactly what the OS sees. This allows Enhanced Monitoring to gather highly granular metrics down to the process level, specifically providing visibility into **OS processes** and individual **RDS child processes**, which hypervisor-level CloudWatch fundamentally cannot see.

*Why other options are wrong:*
- **CPU Utilization, Freeable Memory, Database Connections:** These are all standard metrics gathered at the hypervisor or database engine level and reported by default CloudWatch without needing Enhanced Monitoring enabled.

---

## Question 12
**Scenario:** A Solutions Architect is working for a large global media company with multiple office locations all around the world. The Architect is instructed to build a system to distribute training videos to all employees. Using Amazon CloudFront, what method would be used to serve content that is stored in Amazon S3 but not publicly accessible from S3 directly?

**Answer:** **Create an Origin Access Control (OAC) for CloudFront and grant access to the objects in your S3 bucket to that OAC.**

**Detailed Explanation:**
When using CloudFront as a Content Delivery Network (CDN) in front of an S3 bucket, a massive security risk is users bypassing CloudFront entirely and accessing the S3 bucket URLs directly. 

*Why this is the correct answer:*
To prevent users from bypassing CloudFront, you must block public access to the S3 bucket, but still allow CloudFront to read the files. You do this using **Origin Access Control (OAC)** (the modern replacement for Origin Access Identity or OAI). 
You create an OAC in CloudFront, attach it to the CloudFront distribution, and then update the S3 bucket policy to state: "Deny all access to everyone, EXCEPT allow the CloudFront OAC to read objects." This guarantees that the training videos can only be fetched through CloudFront's secure, globally distributed edge locations.

*Why other options are wrong:*
- **Create a web ACL in AWS WAF to block any public S3 access:** WAF can be attached to CloudFront to block malicious traffic, but WAF cannot be attached directly to an S3 bucket to block direct bucket access. 
- **Create an IAM user for CloudFront:** CloudFront is a managed AWS service; you do not create standard IAM Users (with access keys/passwords) for it to use. AWS handles the identity authentication securely under the hood via OAC.

---

## Question 13
**Scenario:** An operations team has an application running on EC2 instances inside two custom VPCs. The VPCs are located in the Ohio and N.Virginia Region respectively. The team wants to transfer data between the instances without traversing the public internet. Which combination of steps will achieve this? (Select TWO.)

**Answer:**
1. **Set up a VPC peering connection between the VPCs.**
2. **Re-configure the route table's target and destination of the instances' subnet.**

**Detailed Explanation:**
By default, VPCs are completely isolated network environments. To allow private IP communication between them across different regions, you must explicitly link them.

*Why this is the correct answer:*
**VPC Peering** is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 or IPv6 addresses. AWS supports Inter-Region VPC Peering (e.g., Ohio to N. Virginia). The traffic runs entirely over the AWS global fiber backbone, never traversing the public internet, ensuring maximum security and high performance.
However, simply creating the peering connection is not enough. You must also update the **Route Tables** in both VPCs. You must add a route in the Ohio subnet that points traffic destined for the N. Virginia CIDR block to the Peering Connection ID (`pcx-...`), and vice versa. 

*Why other options are wrong:*
- **Create an Egress-only Internet Gateway:** This is strictly used for allowing IPv6 traffic to reach the internet. It does not connect two VPCs.
- **Launch a NAT Gateway:** NAT Gateways allow private subnets to access the public internet. The requirement explicitly states traffic must *not* traverse the internet.
- **Deploy a VPC endpoint:** VPC Endpoints (PrivateLink) are used to connect a VPC to AWS managed services (like S3 or DynamoDB), not to bridge two entire VPCs together.

---

## Question 14
**Scenario:** A GraphQL API hosted in an Amazon EKS cluster with AWS Fargate launch type... is connected to an Amazon DynamoDB table with DynamoDB Accelerator (DAX) as its data store. Both resources are hosted in the us-east-1 region. A solutions architect must improve network security by preventing database calls from traversing the public internet. An automated cross-account backup for the DynamoDB table is also required for long-term retention. Which of the following should the solutions architect implement?

**Answer:** **Create a DynamoDB Gateway/Interface endpoint. Enable Point-in-Time Recovery / AWS Backup.**

**Detailed Explanation:**
DynamoDB is a public AWS service, meaning its API endpoints resolve to public IP addresses. By default, resources in a private subnet (like Fargate containers) must use a NAT Gateway and traverse the public internet to reach DynamoDB.

*Why this is the correct answer:*
To force traffic to DynamoDB to remain on the private AWS network, you must deploy a **VPC Endpoint** for DynamoDB (either a Gateway Endpoint via route tables, or an Interface Endpoint via PrivateLink ENIs). This completely isolates the database traffic from the public internet.
For the second requirement (automated cross-account backups for long term retention), **AWS Backup** natively integrates with DynamoDB to provide centralized, automated backup plans that can easily copy backups to a completely different AWS account for disaster recovery compliance.

*Why other options are wrong:*
Any option suggesting the use of a NAT Gateway or Internet Gateway violates the core requirement of "preventing database calls from traversing the public internet."

---

## Question 15
**Scenario:** A company has multiple research departments that have deployed several resources to the AWS cloud. Each department is free to provision resources as needed. To ensure normal operations, the company wants to track its AWS resource usage so that it does not reach the AWS service quotas unexpectedly. Which combination of actions should the Solutions Architect implement? (Select TWO.)

**Answer:**
1. **Capture the events using Amazon EventBridge.**
2. **Create an Amazon Simple Notification Service (Amazon SNS) topic and configure it as a target for notifications.**

**Detailed Explanation:**
AWS imposes Service Quotas (limits) on every account to prevent accidental massive billing spikes (e.g., a default limit of 5 VPCs per region). Proactive monitoring of these quotas is essential in decentralized enterprise environments.

*Why this is the correct answer:*
**AWS Trusted Advisor** constantly evaluates your AWS environment and includes a "Service Limits" check that flags when you use more than 80% of a quota. However, Trusted Advisor doesn't natively send emails.
To automate alerting, you use **Amazon EventBridge** (formerly CloudWatch Events). EventBridge can listen for state changes from Trusted Advisor (e.g., when a limit check changes from "OK" to "WARNING"). When EventBridge detects this event, it triggers a target. By setting the target as an **Amazon SNS** topic, SNS will immediately push an email or SMS notification to the IT team, allowing them to request a quota increase before an outage occurs.

*Why other options are wrong:*
- **Write an AWS Lambda function that refreshes Trusted Advisor every 24 hours:** This is completely unnecessary overhead. EventBridge integrates natively with Trusted Advisor and handles the event triggering automatically without requiring you to maintain custom Python/Node.js code.

---

## Question 16
**Scenario:** A company is building an automation tool for generating custom reports on its AWS usage. The company must be able to programmatically access and forecast usage costs on specific services. Which of the following would meet the requirements with the LEAST amount of operational overhead?

**Answer:** **Use the AWS Cost Explorer API with pagination to programmatically retrieve the usage cost-related data.**

**Detailed Explanation:**
The requirement is to build an "automation tool" that "programmatically accesses" cost data, prioritizing the "least amount of operational overhead".

*Why this is the correct answer:*
The **AWS Cost Explorer API** is a fully managed API provided by AWS specifically designed for programmatic access to your granular cost and usage data. Because it is a native API, your custom automation tool can simply make HTTP/SDK requests to retrieve exactly the data it needs, including cost forecasts. Handling pagination ensures the tool can ingest massive amounts of cost data cleanly. This requires virtually zero operational overhead because AWS manages the data aggregation backend.

*Why other options are wrong:*
- **Utilize the downloadable AWS Cost Explorer report .csv files:** Parsing CSV files is a manual, legacy approach. Building a tool to ingest and parse CSVs involves high operational overhead and is fragile compared to querying a structured REST API.
- **Configure AWS Budgets to send usage cost data to the company via Amazon SNS:** AWS Budgets are used to send alerts when you exceed a monetary threshold (e.g., "Alert me if I spend $100"). They do not provide raw, granular programmatic data for generating custom reports.

---

## Question 17 & 18
**Scenario:** A company is using AWS IAM. The Solutions Architect created an IAM policy for AWS Lambda. The policy contains two statements:
Statement 1: `Allow` actions `lambda:CreateFunction` and `lambda:DeleteFunction` on Resource `*`.
Statement 2: `Deny` actions `lambda:CreateFunction`, `lambda:DeleteFunction`, `lambda:InvokeFunction`, `lambda:TagResource` on Resource `*` with a Condition that the Source IP is `187.5.104.11/32`.
Which of the following options is allowed by this policy?

**Answer:** **Create an AWS Lambda function using the 100.220.0.11/32 address.**

**Detailed Explanation:**
IAM policy evaluation follows extremely strict rules. The most important rule to remember for the SAA exam is: **An explicit DENY always overrides an ALLOW.**

*Why this is the correct answer:*
Let's break down the policy logic:
1. The `Allow` block gives the user permission to create and delete Lambda functions universally (from any IP address).
2. The `Deny` block explicitly strips away those permissions (and others) **ONLY IF** the user is making the request from the IP address `187.5.104.11`.
Therefore, if a user attempts to create a Lambda function from the IP `187.5.104.11`, the explicit Deny catches it and blocks the request. 
However, if the user makes the request from IP `100.220.0.11`, the Deny condition is completely ignored (because the IPs don't match). The evaluation falls back to the original `Allow` block, and the creation is successfully executed.

---

## Question 19
**Scenario:** A logistics company based in the USA runs its web application on a fleet of Amazon EC2 instances in an Auto Scaling group. The company uses an Application Load Balancer to distribute traffic. A recent government policy prohibits the company from servicing a specific country. Which of the following options is the recommended action to comply with the government requirement?

**Answer:** **Create a Web ACL rule in AWS WAF to block the specified country. Associate the rule to the Application Load Balancers.**

**Detailed Explanation:**
Compliance requirements often mandate Geo-blocking (restricting access based on the geographic location of the user's IP address).

*Why this is the correct answer:*
**AWS WAF (Web Application Firewall)** natively includes a **Geo Match condition**. This feature automatically looks at the originating IP address of incoming HTTP/HTTPS requests, compares it against a managed database of country IPs, and either blocks or allows the traffic based on your rules. You can directly associate WAF with an Application Load Balancer (ALB), CloudFront distribution, or API Gateway. This is the simplest, most scalable, and recommended way to achieve country-level blocking.

*Why other options are wrong:*
- **Update the Network Access Control Lists (NACLs) of all subnets to "deny" all IP addresses from the specific country:** A country possesses hundreds of thousands of IP CIDR blocks. NACLs have a hard limit of 20-40 rules per subnet. It is mathematically impossible to fit an entire country's IP blocks into a NACL. Furthermore, maintaining IP lists manually is an operational nightmare.
- **Update route tables to forward traffic to Network Firewall:** While AWS Network Firewall is powerful, WAF is purpose-built for Layer 7 web traffic and offers native Geo-blocking out of the box with zero routing complexity.

---

## Question 20
**Scenario:** A company is running a dashboard application on a Spot EC2 instance inside a private subnet. The dashboard is reachable via a domain name that maps to the private IPv4 address of the instance’s network interface. A solutions architect needs to increase network availability by allowing the traffic flow to resume in another instance if the primary instance is terminated. Which solution accomplishes these requirements?

**Answer:** **Create a secondary elastic network interface (ENI) and point its private IPv4 address to the application's domain name. Attach the new network interface to the primary instance. If the instance goes down, move the secondary network interface to another instance.**

**Detailed Explanation:**
High availability typically relies on Load Balancers, but this scenario explores manual IP mobility for cost-saving architectures using single Spot instances.

*Why this is the correct answer:*
An **Elastic Network Interface (ENI)** is a logical networking component in a VPC that represents a virtual network card. Private IP addresses are permanently assigned to ENIs, not directly to the EC2 hardware. 
If you bind the dashboard's domain name to the private IP of a *secondary* ENI, you decouple the network identity from the EC2 instance lifecycle. If the underlying Spot instance is terminated by AWS, the secondary ENI simply detaches. You can immediately attach that exact same ENI (which still holds the same private IP address) to a brand new EC2 instance. Traffic resumes instantly without needing to update any DNS records, because the domain still points to that same private IP.

*Why other options are wrong:*
- **Attach an Elastic IP (EIP) address:** Elastic IPs are exclusively public IPv4 addresses used for internet routing. The scenario explicitly states the dashboard uses a *private* IPv4 address inside a private subnet.

---

## Question 21
**Scenario:** A company is using an Amazon VPC that has a CIDR block of 10.31.0.0/27. There was a requirement to create a Lambda function that will process massive amounts of cryptocurrency transactions every minute and then store the results to EFS. After setting up the serverless architecture and connecting the Lambda function to the VPC, the Solutions Architect noticed an increase in invocation errors with EC2 error types such as `EC2ThrottledException` at certain times of the day. Which of the following are the possible causes of this issue? (Select TWO.)

**Answer:**
1. **The Lambda function is placed in a VPC subnet with limited IP address capacity.**
2. **Your Lambda function exceeds the VPC quota for Elastic Network Interfaces (ENIs) or available IP addresses in the subnet.**

**Detailed Explanation:**
Connecting a Lambda function to a VPC allows it to access private resources (like EFS). However, to bridge into the VPC, Lambda must create Hyperplane ENIs inside the subnets you specify.

*Why this is the correct answer:*
A VPC CIDR block of `10.31.0.0/27` provides exactly 32 total IP addresses. AWS reserves 5 IPs per subnet, leaving a maximum of **27 usable IP addresses**. 
During "certain times of the day" (traffic spikes), Lambda scales up concurrently to handle the massive cryptocurrency transactions. As it scales, it attempts to provision ENIs in the subnet. 
If the subnet simply runs out of those 27 IPs, Lambda cannot create new ENIs to scale, resulting in execution failures. Additionally, if the scaling is extremely rapid, AWS EC2 API rate limits may throttle the frantic ENI creation requests, throwing the explicit `EC2ThrottledException`.

*Why other options are wrong:*
- **The associated security group... does not allow outbound connections:** This would result in network timeout errors when the code executes, not an `EC2ThrottledException` during invocation setup.
- **The attached IAM execution role... does not have necessary permissions:** This would result in an immediate `AccessDeniedException`, blocking the function from even attempting to attach to the VPC.

---

## Question 22
**Scenario:** A payment processing company plans to migrate its on-premises application to an Amazon EC2 instance. An IPv6 CIDR block is attached to the company's Amazon VPC. Strict security policy mandates that the production VPC must only allow outbound communication over IPv6 between the instance and the internet but should prevent the internet from initiating an inbound IPv6 connection. The new architecture should also allow traffic flow inspection and traffic filtering. What should a solutions architect do to meet these requirements?

**Answer:** **Launch the EC2 instance to a private subnet and attach an Egress-Only Internet Gateway to the VPC to allow outbound IPv6 communication to the internet. Use AWS Network Firewall to set up the required rules for traffic inspection and traffic filtering.**

**Detailed Explanation:**
Networking over IPv4 vs IPv6 involves fundamentally different gateway resources in AWS.

*Why this is the correct answer:*
In IPv4, to allow private instances to access the internet while blocking inbound requests, you use a NAT Gateway. However, **IPv6 addresses are globally routable** (there is no private IPv6 space equivalent that uses NAT). 
To achieve the exact same one-way outbound security for IPv6, AWS provides the **Egress-Only Internet Gateway (EOIG)**. An EOIG allows outbound IPv6 traffic to reach the internet, but acts as a stateful firewall that outright drops any inbound IPv6 traffic initiated from the internet. 
To meet the final requirement for deep packet inspection and filtering, **AWS Network Firewall** is the managed service deployed within the VPC routing path to inspect both IPv4 and IPv6 traffic.

*Why other options are wrong:*
- **Attach a NAT Gateway:** NAT Gateways are exclusively for IPv4 address translation. They do not support or route IPv6 traffic.
- **Attach an Internet Gateway (IGW):** An IGW is bi-directional. It allows outbound traffic, but critically, it also allows the internet to initiate inbound connections to the instance, directly violating the strict security policy.

---

## Question 23
**Scenario:** A DevOps Engineer is required to design a cloud architecture in AWS. The Engineer is planning to develop a highly available and fault-tolerant architecture consisting of an Elastic Load Balancer and an Auto Scaling group of EC2 instances deployed across multiple Availability Zones. This will be used by an online accounting application that requires path-based routing, host-based routing, and bi-directional streaming using Remote Procedure Call (gRPC). Which configuration will satisfy the given requirement?

**Answer:** **Configure an Application Load Balancer in front of the auto-scaling group. Select gRPC as the protocol version.**

**Detailed Explanation:**
AWS provides three main types of load balancers (ALB, NLB, GLB), each operating at different layers of the OSI model with different capabilities.

*Why this is the correct answer:*
The defining requirements of the application are **path-based routing** (e.g., routing `/images` to one target group and `/api` to another), **host-based routing**, and **gRPC** support.
The **Application Load Balancer (ALB)** operates at Layer 7 (the application layer) of the OSI model. Because it understands HTTP/HTTPS traffic, it is the *only* load balancer capable of looking inside the URL to make intelligent routing decisions based on paths and host headers. Furthermore, ALB provides native, end-to-end support for gRPC, which uses HTTP/2 for bi-directional streaming.

*Why other options are wrong:*
- **Network Load Balancer (NLB):** NLBs operate at Layer 4 (the transport layer) focusing purely on TCP/UDP IP addresses and ports. Because they do not look at HTTP headers, they are completely incapable of performing path-based or host-based routing.
- **Gateway Load Balancer (GLB):** GLBs operate at Layer 3 and are exclusively used for deploying and scaling third-party virtual network appliances (like firewalls or intrusion detection systems), not for routing web application traffic.

---

## Question 24
**Scenario:** A Solutions Architect working for a startup is designing a High Performance Computing (HPC) application which is publicly accessible for their customers. The startup founders want to mitigate distributed denial-of-service (DDoS) attacks on their application. Which of the following options are NOT suitable to be implemented in this scenario? (Select TWO.)

**Answer:**
1. **Add multiple Elastic Fabric Adapters (EFA) to each EC2 instance to increase the network bandwidth.**
2. **Use Dedicated EC2 instances to ensure that each instance has the maximum performance possible.**

**Detailed Explanation:**
This is a negative question. We must identify which features provide absolutely no benefit for DDoS mitigation.

*Why this is the correct answer:*
1. **Elastic Fabric Adapters (EFA):** An EFA is a specialized network interface for Amazon EC2 instances that enables you to run HPC applications requiring high levels of inter-node communications at scale (bypassing the OS kernel). EFAs only work for traffic *within* the cluster. They do nothing to block or absorb malicious traffic coming from the public internet.
2. **Dedicated EC2 Instances:** Dedicated Instances are Amazon EC2 instances that run in a VPC on hardware that's dedicated to a single customer. This is purely a compliance and tenancy feature. Changing the physical server tenancy does absolutely nothing to protect the application from a volumetric DDoS attack targeting the network layer.

*Why other options ARE suitable (and thus incorrect choices):*
- **AWS Shield and AWS WAF:** These are the primary managed services for DDoS mitigation and Layer 7 protection.
- **ALB with Auto Scaling:** An ALB absorbs connection floods, while ASG scales out to absorb the traffic load.
- **Amazon CloudFront:** CloudFront distributes traffic globally across hundreds of edge locations, easily absorbing massive volumetric attacks before they ever reach your EC2 instances.

---

## Question 25
**Scenario:** A financial application consists of an Auto Scaling group of Amazon EC2 instances, an Application Load Balancer, and a MySQL RDS instance set up in a Multi-AZ Deployment configuration. To protect customers’ confidential data, it must be ensured that the Amazon RDS database is only accessible using an authentication token specific to the profile credentials of EC2 instances. Which of the following actions should be taken to meet this requirement?

**Answer:** **Enable the IAM DB Authentication.**

**Detailed Explanation:**
Traditional databases use static passwords for authentication (e.g., `admin / password123`), which introduces security risks if the credentials are leaked or hardcoded in application source code.

*Why this is the correct answer:*
AWS provides a feature called **IAM Database Authentication** specifically for MySQL and PostgreSQL RDS databases. When enabled, your EC2 instances do not need a static database password. Instead, the application requests a temporary authentication token from the AWS Security Token Service (STS) using the EC2 instance's attached IAM Role profile. The application passes this token to RDS in place of a password. This ensures seamless, password-less authentication that relies entirely on secure, temporary, and rotated IAM credentials, fulfilling the strict security requirement.

*Why other options are wrong:*
- **Configure SSL in your application:** SSL encrypts data in transit between the EC2 instance and the database. While vital for security, it does not handle user *authentication* or replace passwords with tokens.
- **Create an IAM Role... which will grant exclusive access:** While you do need an IAM role attached to the EC2 instance, simply attaching the role is not enough. You specifically have to *Enable IAM DB Authentication* on the RDS instance itself to instruct the database engine to accept those IAM tokens.

---

## Question 26
**Scenario:** There was an incident in a production environment where user data stored in an Amazon S3 bucket was accidentally deleted by a Junior DevOps Engineer. The issue was escalated to management, and after a few days, an instruction was given to improve the security and protection of AWS resources. What combination of the following options will protect the S3 objects in the bucket from BOTH accidental deletion and overwriting? (Select TWO.)

**Answer:**
1. **Enable Versioning**
2. **Enable Multi-Factor Authentication (MFA) Delete**

**Detailed Explanation:**
Protecting data in S3 requires guarding against two vectors: overwriting existing data with bad data, and permanently deleting data. 

*Why this is the correct answer:*
1. **Enable Versioning:** When versioning is enabled, modifying or deleting an object does not actually destroy the data. If a user overwrites `file.txt`, S3 simply saves it as a new version, preserving the original data. If a user deletes `file.txt`, S3 simply places a "Delete Marker" on top of the object, hiding it from view, but the underlying data remains fully intact and recoverable. This comprehensively protects against both overwrites and accidental deletes.
2. **Enable MFA Delete:** While versioning protects against standard deletes, a malicious actor or careless admin could still explicitly request to permanently delete a specific historical version of a file. MFA Delete adds an extra layer of security. To permanently delete an object version or to suspend versioning, the user must provide a valid code from a physical MFA (Multi-Factor Authentication) device.

*Why other options are wrong:*
- **Disallow S3 Delete using an IAM bucket policy:** While this stops accidental deletion, it does nothing to prevent accidental *overwriting* (uploading a bad file with the same name).
- **Enable S3 Intelligent-Tiering:** This is a cost optimization storage class, completely unrelated to data protection or security.

---

## Question 27
**Scenario:** An e-commerce company runs a highly scalable web application that depends on an Amazon Aurora database. As the number of users increases, the read replica faces difficulties keeping up with the increasing read traffic, causing performance bottlenecks during peak periods. Which of the following will resolve the issue with the most cost-effective solution?

**Answer:** **Use automatic scaling for the Aurora read replica using Aurora Auto Scaling.**

**Detailed Explanation:**
Database performance issues are typically split between read-heavy workloads (reporting, querying) and write-heavy workloads (transactions). E-commerce sites are notoriously read-heavy.

*Why this is the correct answer:*
Amazon Aurora provides a native feature called **Aurora Auto Scaling**. You can configure a target metric, such as maintaining average CPU utilization across all Replicas at 70%. When a massive traffic spike hits and the CPU exceeds 70%, Aurora Auto Scaling automatically provisions and spins up new Aurora Read Replicas to share the load. When the peak period ends, it automatically terminates the excess replicas. Because it dynamically scales in and out based on demand, it perfectly resolves the bottleneck while remaining extremely cost-effective (you only pay for extra replicas during the actual peak).

*Why other options are wrong:*
- **Increase the size of the Aurora DB cluster:** Scaling vertically (upgrading the instance type from `db.r5.large` to `db.r5.2xlarge`) requires manual intervention, causes temporary downtime during the reboot, and leaves you permanently paying for a massive instance even during off-peak hours (violating cost-effectiveness).
- **Implement read scaling with Aurora Global Database:** Global Databases replicate data across entirely different geographical regions. It is designed for disaster recovery and local latency for global users, not for handling localized traffic spikes. It is significantly more expensive.

---

## Question 28
**Scenario:** A Solutions Architect is designing a monitoring application which generates audit logs of all operational activities of the company's cloud infrastructure. Their IT Security and Compliance team mandates that the application retain the logs for 5 years before the data can be deleted. How can the Architect meet the above requirement?

**Answer:** **Store the audit logs in a Glacier vault and use the Vault Lock feature.**

**Detailed Explanation:**
Strict compliance mandates (often seen in financial or healthcare sectors) require data to be stored in a WORM (Write-Once-Read-Many) format, meaning it mathematically cannot be altered or deleted by anyone, even the root account administrator.

*Why this is the correct answer:*
**Amazon S3 Glacier Vault Lock** allows you to easily deploy and enforce compliance controls for individual Glacier vaults. You define a Vault Lock policy (e.g., "Deny any Delete actions if the archive is less than 5 years old") and lock it. Once locked, the policy becomes immutable. AWS physically enforces this at the infrastructure level. No one can delete the logs until the exact 5-year timer expires, perfectly satisfying the IT Security mandate. *(Note: S3 Object Lock provides similar WORM functionality in standard S3 buckets and is also a valid architectural choice, but Glacier Vault Lock was the option presented).*

*Why other options are wrong:*
- **Store the audit logs in an Amazon S3 bucket and enable MFA Delete:** MFA Delete prevents accidental deletion, but an administrator who possesses the MFA token can still freely delete the data at any time. It does not strictly enforce the mandatory 5-year retention period.
- **Store the audit logs in an EBS volume and take snapshots:** EBS snapshots can be manually deleted at any time by anyone with the right IAM permissions. There is no immutable retention lock.

---

## Question 29
**Scenario:** A data analytics company keeps a massive volume of data that they store in their on-premises data center. To scale their storage systems, they are looking for cloud-backed storage volumes that they can mount using Internet Small Computer System Interface (iSCSI) devices from their on-premises application servers. They have an on-site data analytics application that frequently accesses the latest data subsets locally while the older data are rarely accessed. You are required to minimize the need to scale the on-premises storage infrastructure while still providing their web application with low-latency access to the data. Which type of AWS Storage Gateway service will you use to meet the above requirements?

**Answer:** **Volume Gateway in cached mode**

**Detailed Explanation:**
AWS Storage Gateway bridges on-premises environments with AWS cloud storage. The Volume Gateway type presents cloud-backed storage volumes to your on-premises servers as standard iSCSI block storage devices. 

*Why this is the correct answer:*
Volume Gateways operate in two distinct modes: Stored mode and Cached mode. 
The scenario explicitly requires minimizing on-prem scaling while providing low-latency access to *only* the frequently accessed (hot) data. 
In **Cached Mode**, the primary copy of all your data (the massive volume) is stored in Amazon S3. However, the Storage Gateway retains a small, localized cache of the most recently accessed data on your on-premises hardware. This guarantees that when the analytics application requests the latest data, it reads it directly from the local cache at LAN speeds (low latency). If it requests rare, old data, the Gateway fetches it from S3. This perfectly solves the problem of scaling storage infinitely in the cloud while keeping hot data fast.

*Why other options are wrong:*
- **Volume Gateway in stored mode:** In stored mode, your entire dataset is stored physically on your on-premises hardware, and it is asynchronously backed up to S3. This violates the requirement to "minimize the need to scale the on-premises storage infrastructure", because you still have to buy hard drives for 100% of your data.
- **File Gateway:** File Gateway presents an NFS or SMB interface for file-based access, not iSCSI block storage as strictly required in the prompt.

---

## Question 30
**Scenario:** A solutions architect is managing an application that runs on a Windows EC2 instance with an attached Amazon FSx for Windows File Server. To save cost, management has decided to stop the instance during off-hours and restart it only when needed. It has been observed that the application takes several minutes to become fully operational which impacts productivity. How can the solutions architect speed up the instance's loading time without driving the cost up?

**Answer:** **Migrate the application to an EC2 instance with hibernation enabled.**

**Detailed Explanation:**
Heavy enterprise applications (especially on Windows) often take a long time to boot up because they have to load the OS, start background services, initialize the application, and load data from disk into RAM.

*Why this is the correct answer:*
**EC2 Hibernation** functions exactly like closing the lid on a laptop. When you initiate hibernation, AWS takes everything currently loaded in the instance's memory (RAM) and writes it safely to the root EBS volume. The instance is then shut down, and you stop paying for compute costs.
When you restart the instance, AWS boots the hardware, pulls the RAM contents directly from the EBS volume back into memory, and the instance resumes exactly where it left off. By bypassing the entire Windows boot sequence and application initialization phase, the instance becomes fully operational in seconds instead of minutes.

*Why other options are wrong:*
- **Migrate the application to a Linux-based EC2 instance:** The scenario explicitly relies on Amazon FSx for Windows File Server (which requires Active Directory and Windows environments). You cannot arbitrarily migrate a heavy Windows legacy app to Linux.
- **Enable the hibernation mode on the EC2 instance:** This is a trick answer based on AWS implementation details. You **cannot** simply check a box to enable hibernation on an already running, existing EC2 instance. Hibernation must be explicitly enabled at the exact moment the instance is launched. Therefore, you must "migrate" to a new instance launched with hibernation enabled.

---

## Question 31
**Scenario:** A company hosted a web application in an Auto Scaling group of EC2 instances. The IT manager is concerned about the over-provisioning of the resources that can cause higher operating costs. A Solutions Architect has been instructed to create a cost-effective solution without affecting the performance of the application. Which dynamic scaling policy should be used to satisfy this requirement?

**Answer:** **Use target tracking scaling.**

**Detailed Explanation:**
Auto Scaling Groups (ASG) ensure you have the right amount of compute capacity, but choosing the right scaling policy determines how efficiently you respond to load.

*Why this is the correct answer:*
**Target Tracking Scaling Policies** operate identically to a thermostat in a house. You simply choose a metric and set a target value—for example, "Keep the average CPU utilization across all instances at exactly 60%." 
If traffic spikes and the average CPU hits 80%, the ASG calculates exactly how many instances it needs to add to bring the average back down to 60%, and launches them. If traffic dies down and CPU drops to 30%, it automatically terminates instances to raise the average back to 60%. This mathematically guarantees that you have exactly the resources you need (no performance drops) while entirely eliminating over-provisioning (no wasted costs).

*Why other options are wrong:*
- **Simple scaling:** Simple scaling requires you to manually define thresholds and wait periods (e.g., "If CPU > 80%, add 1 instance and wait 5 minutes"). It is rigid, slow to respond to massive spikes, and often results in over-provisioning because it steps up capacity blindly. Target tracking is much more intelligent and hands-off.
- **Scheduled scaling:** Scheduled scaling adds instances at a specific time of day (e.g., 9:00 AM every Monday). It is useless for unpredictable traffic spikes and does not solve dynamic over-provisioning. 
