param (
    [string]$UnauthorizedUser = "",
    [string]$ProfileName = ""
)

# Get federated credentials
try {
    $output = aws sts get-federation-token --name $UnauthorizedUser --policy-arns arn=arn:aws:iam::aws:policy/AdministratorAccess --profile $ProfileName
    if ($LASTEXITCODE -ne 0) {
        Write-Error "The command 'aws sts get-federation-token --name $UnauthorizedUser' failed with exit status $LASTEXITCODE"
        exit $LASTEXITCODE
    }
} catch {
    Write-Error $_.Exception.Message
    exit 1
}

# Parse the output
$session_id = ($output | ConvertFrom-Json).Credentials.AccessKeyId
$session_key = ($output | ConvertFrom-Json).Credentials.SecretAccessKey
$session_token = ($output | ConvertFrom-Json).Credentials.SessionToken

# Construct the JSON credentials string
$json_creds = @{
    sessionId = $session_id
    sessionKey = $session_key
    sessionToken = $session_token
} | ConvertTo-Json -Compress

# Define the AWS federation endpoint
$federation_endpoint = "https://signin.aws.amazon.com/federation"

# Make the HTTP request to get the sign-in token
try {
    $response = Invoke-RestMethod -Uri $federation_endpoint -Method Get -Body @{
        Action = "getSigninToken"
        SessionDuration = 43200
        Session = $json_creds
    }
    $signin_token = ($response.SigninToken -replace "`n", "") -replace "`r", ""
} catch {
    Write-Error $_.Exception.Message
    exit 1
}

# Construct and display the login URL
$login_url = "https://signin.aws.amazon.com/federation?Action=login&Issuer=example.com&Destination=https%3A%2F%2Fconsole.aws.amazon.com%2F&SigninToken=$signin_token"
Write-Output $login_url
