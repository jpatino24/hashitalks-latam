<h1 align="center">
    Terraform AWS Subnet
</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create public, private and public-private subnet with network acl, route table, Elastic IP, nat gateway, flow log.
     </p>

<hr>

## Prerequisites

This module has a few dependencies: 

- [Terraform 0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)


## Examples

### Simple Example
Here is an example of how you can use this module in your inventory structure:
  ```hcl
  module "vpc" {
      source      = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=tags/0.12.5"
      name        = "vpc"
      application = "clouddrove"
      environment = "test"
      label_order = ["environment", "name", "application"]
      cidr_block  = "10.0.0.0/16"
    }
  ```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application | Application (e.g. `cd` or `clouddrove`). | string | `` | no |
| attributes | Additional attributes (e.g. `1`). | list | `<list>` | no |
| availability_zones | List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`). | list(string) | `<list>` | no |
| az_ngw_count | Count of items in the `az_ngw_ids` map. Needs to be explicitly provided since Terraform currently can't use dynamic count on computed resources from different modules. https://github.com/hashicorp/terraform/issues/10857. | number | `0` | no |
| az_ngw_ids | Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets. | map(string) | `<map>` | no |
| cidr_block | Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`). | string | - | yes |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | string | `-` | no |
| enable_acl | Set to false to prevent the module from creating any resources. | bool | `true` | no |
| enable_flow_log | Enable subnet_flow_log logs. | bool | `false` | no |
| enabled | Set to false to prevent the module from creating any resources. | bool | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | string | `` | no |
| igw_id | Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`). | string | `` | no |
| label_order | Label order, e.g. `name`,`application`. | list | `<list>` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | string | `anmol@clouddrove.com` | no |
| map_public_ip_on_launch | Specify true to indicate that instances launched into the subnet should be assigned a public IP address. | bool | `true` | no |
| max_subnets | Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation. | number | `6` | no |
| name | Name  (e.g. `app` or `cluster`). | string | `` | no |
| nat_gateway_enabled | Flag to enable/disable NAT Gateways creation in public subnets. | bool | `false` | no |
| private_network_acl_id | Network ACL ID that is added to the private subnets. If empty, a new ACL will be created. | string | `` | no |
| public_network_acl_id | Network ACL ID that is added to the public subnets. If empty, a new ACL will be created. | string | `` | no |
| public_subnet_ids | A list of public subnet ids. | list(string) | `<list>` | no |
| s3_bucket_arn | S3 ARN for vpc logs. | string | `` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | map | `<map>` | no |
| traffic_type | Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL. | string | `ALL` | no |
| type | Type of subnets to create (`private` or `public`). | string | `` | no |
| vpc_id | VPC ID. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| private_route_tables_id | The ID of the routing table. |
| private_subnet_cidrs | CIDR blocks of the created private subnets. |
| private_subnet_id | The ID of the private subnet. |
| private_tags | A mapping of private tags to assign to the resource. |
| public_route_tables_id | The ID of the routing table. |
| public_subnet_cidrs | CIDR blocks of the created public subnets. |
| public_subnet_id | The ID of the subnet. |
| public_tags | A mapping of public tags to assign to the resource. |




## Testing


## Feedback 
If you come accross a bug or have any feedback, feel free to drop us an email at [otrs@summan.com](mailto:otrs@summan.com).

## About us

At [Summan][website]

<p align="center">We are <b> Data, Cloud and DevOps Experts!</b></p>
<hr />

  [website]: https://www.summan.com/
  [github]: 
  [linkedin]: 
  [twitter]: 
  [email]: https://www.summan.com/contactanos/
  [terraform_modules]: 