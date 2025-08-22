# CloudLaunch Assessment – AltSchool Cloud Engineering

This repository contains my solution for the **AltSchool Cloud Engineering Tinyuka 2024 Semester 3, Month 1 Assessment**.  
It covers **Task 1 (S3 + IAM)** and **Task 2 (VPC Design)**, implemented using **Terraform**.

---

## 🚀 Task 1 – S3 Buckets + IAM

### What I Implemented
- **3 S3 Buckets**:
  - `cloudlaunch-site-bucket-so7` → Hosts a static website (with index.html and other supporting files).
  - `cloudlaunch-private-bucket-so7` → For private storage (user can upload/download but not delete).
  - `cloudlaunch-visible-only-bucket-so7` → Listed in S3 console but without object-level access.
- **Static Website Hosting** enabled on the `site-bucket`.
- **IAM User (`cloudlaunch-user`)** created with a **custom JSON policy**:
  - ✅ Can **list buckets**.
  - ✅ Can **read** from `site-bucket`.
  - ✅ Can **upload/download** in `private-bucket`.
  - ✅ Can **see but not read objects** in `visible-only-bucket`.
  - ✅ Can **view VPC components** (`Describe*` permissions). 
- **Created CloudFront distribution** to redirect HTTP → HTTPS using S3 website endpoint with default root `index.html`

### Outputs and Important links
- S3 Static Site Endpoint → `http://cloudlaunch-site-bucket-so7.s3-website.eu-west-2.amazonaws.com`  
- IAM User → `cloudlaunch-user`
- CloudFront URL → `d3gfuscbbsuxy8.cloudfront.net` 
- AWS Console URL → `https://904233113291.signin.aws.amazon.com/console`
- AWS Account ID → `904233113291`
- IAM Username → `cloudlaunch-user`
- IAM Password → `UmU(Us7!`
- JSON Policy:
```JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AccessCloudlaunchBucketsList",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::cloudlaunch-site-bucket-so7",
        "arn:aws:s3:::cloudlaunch-private-bucket-so7",
        "arn:aws:s3:::cloudlaunch-visible-only-bucket-so7"
      ]
    },
    {
      "Sid": "CloudlaunchSiteGet",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::cloudlaunch-site-bucket/*"
    },
    {
      "Sid": "CloudlaunchPrivateAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::cloudlaunch-private-bucket/*"
    },
    {
      "Sid": "ViewVPCResources",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeInternetGateways"
      ],
      "Resource": "*"
    }
  ]
}
```
---

## 🌐 Task 2 – VPC Design

### What I Implemented
- **Custom VPC** (`10.0.0.0/16`).
- **Subnets**:
  - Public Subnet (`10.0.1.0/24`) → With Internet Gateway access.
  - Application Subnet (`10.0.2.0/24`) → For app servers.
  - Database Subnet (`10.0.3.0/24`) → For database servers.
- **Internet Gateway** attached for public access.
- **Route Tables**:
  - Public route table routes internet traffic via IGW.
- **Security Groups**:
  - App SG → Allows inbound HTTP (port 80).
  - DB SG → Only allows MySQL (port 3306) traffic **from App SG**.

### Outputs
- VPC ID  
- Public, App, and DB subnet IDs  
- Security Group IDs (App + DB)  

---

## 🌍 Deployment Instructions
1. Navigate to the folder:
   - `cd cloudlaunch-assessment`
2. Initialize Terraform:
   ```bash
   terraform init 
3. Validate/Plan
   ```bash
   terraform validate
   terraform plan
4. Apply the configuration
   ```bash
   terraform apply
5. Tear down resource later
   ```bash
   terraform destroy 
