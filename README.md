# Ruby on Rails AWS Infrastructure with Terraform

This repository provides a Terraform template to quickly provision a robust and scalable infrastructure on AWS for a Ruby on Rails application.
It leverages custom Terraform modules to create a VPC, subnets, an Application Load Balancer (ALB), ECR repository, ECS cluster, RDS PostgreSQL database, and an ElastiCache Redis cluster.

The ECS module includes functionality to build your Docker image from a local Dockerfile and push it to the ECR repository if specified.

## Features

* **Modular Design:** Infrastructure components are defined in reusable custom modules.
* **VPC & Networking:** Sets up a custom VPC with public and private subnets across multiple Availability Zones.
* **Application Load Balancer:** Distributes incoming traffic to your ECS services.
* **ECR (Elastic Container Registry):** Private Docker image registry for your application images.
* **ECS (Elastic Container Service):** Manages and runs your Dockerized Ruby on Rails application.
  * **Optional Docker Build & Push:** Can build your application's Docker image and push it to ECR.
* **RDS (Relational Database Service):** Provisions a PostgreSQL database instance.
* **ElastiCache:** Provisions a Redis cluster for caching or session storage.
* **Security Groups:** Configured for controlled access between services.
* **CloudWatch Logs:** Centralized logging for your ECS services.
* **Auto Scaling:** Basic Auto Scaling Group for ECS container instances

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1. **Terraform:**
    * **Installation:** Follow the official HashiCorp guide: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. **Docker:**
    * **Installation:** Follow the official Docker guide: [Install Docker Engine](https://docs.docker.com/engine/install/)
    * **Docker Daemon:** Ensure the Docker daemon is running. Terraform will use it to build the image if `build_image` and push the image if `push_image` is true in the ECS module.
3. **AWS CLI:**
    * **Installation:** Follow the official AWS guide: [Installing or updating the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    * **Configuration:** Configure your AWS CLI with a default profile. Terraform will use these credentials for authentication.

        ```bash
        aws configure
        ```

        You'll be prompted for your AWS Access Key ID, Secret Access Key, default region, and default output format. The `profile` specified in `provider.tf` (via `config.json`) will be used. If it's "default", the standard AWS CLI default profile is used.

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration orchestrating modules
├── variables.tf            # Define input variables here
├── outputs.tf              # Defines outputs from the Terraform stack
├── provider.tf             # Configures the AWS provider
├── config.json             # Configuration file for region, profile, subnets etc.
├── modules/                # Directory for custom Terraform modules
│   ├── vpc/
│   ├── subnets/
│   ├── build_image/        # Need to have the docker daemon running
│   ├── push_image/         # Need to have the docker daemon running
│   ├── sns/
│   ├── s3/
│   ├── ecr/
│   ├── sg/                 # Security Group module
│   ├── rds/
│   ├── elasticache/
│   ├── cloudwatch_logs/
│   ├── ecs/                # ECS module, handles Docker build/push
│   ├── auto_scaling_group/ # For ECS EC2 instances
│   └── sg_rule/            # For specific security group rules
└── app/                    # Ruby on Rails application with healthcheck API
    ├── Dockerfile          # Dockerfile for Rails application
    └── config/
        └── master.key      # Rails master key (if used)
```

## Config.json

```json
{
  "aws_region":,
  "profile":,
  "vpc": {
    "subnets": {
      "public": [
      ],
      "private": [
      ]
    }
  }
}
```

* `aws_region`: The AWS region where resources will be deployed.
* `profile`: The AWS CLI profile to use for authentication.
* `vpc.subnets`: Defines CIDR blocks and availability zones for public and private subnets. Ensure the number of public and private subnets match and their AZs align for resources that might need them (like ALBs or multi-AZ RDS).

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/NeoCoast/terraform-ror-template.git
    cd terraform-ror-template
    ```

2. **Prepare your Ruby on Rails Application:**
    * Ensure your Ruby on Rails application is in a directory specified in the [main.tf](./prod/main.tf).
    * Make sure Dockerfile exists and is correctly configured to build your application.
    * If your Rails application uses encrypted credentials, ensure the master key is present.

3. **Create/Update `config.json`:**
    Create or update `config.json` in the root of the Terraform project with your desired AWS region, profile, and subnet configurations.

4. **Initialize Terraform:**
    This command downloads the necessary provider plugins and modules.

    ```bash
    terraform init
    ```

5. **Review the Execution Plan:**
    This command shows you what resources Terraform will create, modify, or destroy. It's crucial to review this before applying changes.

    ```bash
    terraform plan
    ```

    If you defined `secret_key_base` as a variable, you might run:

    ```bash
    terraform plan -var="secret_key_base=your_actual_secret_key_base_value"
    ```

    Or, create a `terraform.tfvars` file:

    ```
    secret_key_base = "your_actual_secret_key_base_value"
    ```

    And then just run `terraform plan`.

6. **Apply the Configuration:**
    This command provisions the resources defined in your Terraform files on AWS.

    ```bash
    terraform apply
    ```

    Confirm by typing `yes` when prompted. For non-interactive application:

    ```bash
    terraform apply -auto-approve
    ```

    If using variables:

    ```bash
    terraform apply -var="secret_key_base=your_actual_secret_key_base_value"
    ```

    Or rely on `terraform.tfvars`.

## Terraform Commands

Here are the main Terraform commands you'll use:

* **`terraform init`**
  * **Purpose:** Initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one. It downloads provider plugins and modules.
  * **Usage:** `terraform init`
  * **Documentation:** [Terraform Init](https://developer.hashicorp.com/terraform/cli/commands/init)

* **`terraform plan`**
  * **Purpose:** Creates an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files. This is a dry run and does not make any actual changes to your infrastructure.
  * **Usage:** `terraform plan`
  * **Usage with variables file:** `terraform plan -var-file="terraform.tfvars"`
  * **Documentation:** [Terraform Plan](https://developer.hashicorp.com/terraform/cli/commands/plan)

* **`terraform apply`**
  * **Purpose:** Applies the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a `terraform plan` execution plan.
  * **Usage:** `terraform apply` (will prompt for confirmation)
  * **Usage with auto-approve:** `terraform apply -auto-approve`
  * **Usage with plan file:** `terraform plan -out=tfplan && terraform apply tfplan`
  * **Documentation:** [Terraform Apply](https://developer.hashicorp.com/terraform/cli/commands/apply)

* **`terraform destroy`**
  * **Purpose:** Destroys all remote objects managed by a particular Terraform configuration. Use this command with caution.
  * **Usage:** `terraform destroy` (will prompt for confirmation)
  * **Usage with auto-approve:** `terraform destroy -auto-approve`
  * **Documentation:** [Terraform Destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy)

## Docker Image Build & Push (ECS Module)

The `ecs` module has built-in capabilities to manage your Docker image:

* `build_image = true`: If set to true, Terraform will attempt to build a Docker image.
  * It uses the `dockerfile_path` variable (e.g., `../app`) to find the directory containing your `Dockerfile`.
* `push_image = true`: If set to true (and `build_image` is also true), Terraform will push the built image to the ECR repository specified by `ecr_repository_url`.
* `image_tag`: Specifies the tag for the Docker image (e.g., `ruby-template-image:latest`).
* `image_uri`: If you want to use an existing image from ECR (or another registry), set `build_image` and `push_image` to `false` and provide the full URI here.

Terraform uses the local Docker daemon for these operations. Ensure it's running and authenticated with ECR if pushing. The AWS provider handles ECR authentication for the push.

## Outputs

Once `terraform apply` is successful, the following outputs will be displayed:

* `vpc_id`: The ID of the created VPC.
* `public_subnet_ids`: A list of public subnet IDs.
* `private_subnet_ids`: A list of private subnet IDs.
* `rds_subnet_group_id`: The ID of the RDS DB Subnet Group.
* `alb_dns_name`: The DNS name of the Application Load Balancer. Access your application using this URL.
* `alb_listener_port`: The port the ALB is listening on (e.g., 80).
* `cloudwatch_log_group_name`: The name of the CloudWatch Log Group where ECS task logs are sent.

You can also retrieve these outputs at any time using `terraform output`.

## Important Security Considerations

* **Default Passwords:** The RDS instance is configured with a default username (`root`) and password (`rootpasswordchangepls`).
* **`secret_key_base`:** This is a sensitive Rails credential.
* **Rails `master.key`:** If your application uses Rails encrypted credentials, the `master.key` is highly sensitive. The current setup copies it from `../app/config/master.key`.
* **Security Group Rules:**
  * The `ecs_instance_sg` has a very permissive ingress rule (`0.0.0.0/0` for all TCP ports).
  * The `rds_security_group` allows ingress from a specific CIDR (`10.0.5.0/24`).
* **Publicly Accessible Resources:** The ALB is public by design.
* **IAM Roles & Policies:** IAM roles and policies created by Terraform (especially for ECS tasks and EC2 instances) to ensure they follow the principle of least privilege.
