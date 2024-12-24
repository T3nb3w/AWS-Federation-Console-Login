# AWS Federation Console Login Script

This repository provides a PowerShell script to generate a federated AWS Management Console login URL using temporary credentials. It leverages the AWS CLI and AWS STS to facilitate secure, time-bound access to the AWS Console.

## Features
- **Federated Access**: Dynamically retrieves temporary session credentials using the `aws sts get-federation-token` command.
- **Customizable Parameters**: Accepts IAM user and AWS CLI profile as input for flexibility.
- **Login URL Generation**: Produces a one-time URL for accessing the AWS Management Console.
- **AdministratorAccess Policy**: By specifying the `AdministratorAccess` policy ARN, which allows all API actions, the federated session will inherit all the permissions of the calling user.

## Prerequisites
1. **AWS CLI**: Ensure the AWS CLI is installed and configured with valid profiles.
2. **Permissions**: 
   - The user or role must have the `sts:GetFederationToken` permission.
   - The policy ARN specified (e.g., `AdministratorAccess`) must align with your permissions.
3. **PowerShell**: Run the script in a compatible PowerShell environment.

## Parameters
- `-UnauthorizedUser` (string): IAM user name for federated token generation.
- `-ProfileName` (string): AWS CLI profile to use for authentication.

## Usage Example
Run the script with parameters for the IAM user and AWS CLI profile:
```powershell
.\GenerateAWSConsoleURL.ps1 -UnauthorizedUser "targeted_unauthorized_user" -ProfileName "AWS_profile"
```
### Output
The script generates a URL for AWS Console login:
```https://signin.aws.amazon.com/federation?Action=login&Issuer=example.com&Destination=https%3A%2F%2Fconsole.aws.amazon.com%2F&SigninToken=<Token>```
## References
HackTricks: AWS STS Post Exploitation
[Detailed guide on AWS STS token exploitation and console access](https://cloud.hacktricks.xyz/pentesting-cloud/aws-security/aws-post-exploitation/aws-sts-post-exploitation#from-iam-creds-to-console).

CrowdStrike Blog: AWS User Federation
[Insights into adversarial persistence techniques using AWS user federation](https://www.crowdstrike.com/en-us/blog/how-adversaries-persist-with-aws-user-federation/).
