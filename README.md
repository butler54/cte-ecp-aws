# cte-ecp-aws
Terraform to deploy the CTE AMI on aws for encrypted-control-planes demo. Presumes RHDPS deployments

## pre-conditions
1. Use of RHDPS open environment w/ openshift installed.
1. Install `opentofu` and `direnv`

## Use
1. Login to aws ui
   1. navigate to subnets (e.g. https://ap-southeast-1.console.aws.amazon.com/vpcconsole/home?region=ap-southeast-1#subnets)
      1. get the subnet id for the *public* subnet
      2. get the corresponding vpc id
   2. Navigate to security groups (e.g. https://ap-southeast-1.console.aws.amazon.com/vpcconsole/home?region=ap-southeast-1#SecurityGroups:)
      1. Get the worker security group id e.g. similar for the group named similar to `cluster-mv2lh-jtng4-worker-sg`

2. `cp sample.envrc .envrc`
   1. Fill in the blanks
   2. The public access subnets should initially correspond to your public facing IP address.
   3. 
3. `tofu init`
4. `tofu apply`
5. Visit `https://{{public_ip_address}}` and immediately change the admin password (default horribly is admin/admin)
