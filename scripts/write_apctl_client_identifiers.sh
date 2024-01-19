#!/usr/bin/env bash
set -eo pipefail

# instance_name=$(jq -er .instance_name "$cluster_name".auto.tfvars.json)
# aws_account_id=$(jq -er .aws_account_id "$cluster_name".auto.tfvars.json)
# aws_region_current=$(jq -er .aws_region "$cluster_name".auto.tfvars.json)
# aws_assume_role=$(jq -er .aws_assume_role "$cluster_name".auto.tfvars.json)

# echo $instance_name
# echo $aws_account_id
# echo $aws_region_current
# echo $aws_assume_role


aws sts get-caller-identity

cat <<EOF > .teller.yml
project: apctl-auth0-management

carry_env: true

opts:
  region: us-east-1

providers:
  aws_secretsmanager:
    env:
      APCTL_CLIENT_ID:
        path: poc/auth0
        field: apctl-client-id
      
      APCTL_CLIENT_SECRET:
        path: poc/auth0
        field: apctl-client-secret

EOF

# # Assume the role and capture the temporary credentials
# CREDS=$(aws sts assume-role --role-arn arn:aws:iam::"${aws_account_id}":role/"${aws_assume_role}" --role-session-name "$instance_name")

# # Extract and export the temporary credentials
# export AWS_ACCESS_KEY_ID=$(echo "$CREDS" | jq -r .Credentials.AccessKeyId)
# export AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | jq -r .Credentials.SecretAccessKey)
# export AWS_SESSION_TOKEN=$(echo "$CREDS" | jq -r .Credentials.SessionToken)

# # write cluster url and pubic certificate to AWS secrets manager
teller put APCTL_CLIENT_ID="$(jq -er .client_id client_credentials.json)" --providers aws_secretsmanager -c .teller.yml
teller put APCTL_CLIENT_SECRET="$(jq -er .client_secret client_credentials.json)" --providers aws_secretsmanager -c .teller.yml
