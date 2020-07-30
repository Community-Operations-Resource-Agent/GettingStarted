<#
The MIT License (MIT)
Copyright (c) Microsoft Corporation  
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
.SYNOPSIS
This script deploys CORA resources to an Azure Subscription in a new Resource Group

.PARAMETER SubscriptionId
Azure Subscription ID
.PARAMETER ProjectName
Project Name (e.g. ContosoNGO).
.PARAMETER ProjectRegion
Azure region to deploy the resources to defaults WESTUS2
.PARAMETER SendGridPassword
SendGrid Password
.PARAMETER EmailAccount
SendGrid Email
.PARAMETER twilio_smsNumber
SMS number from Twilio
.PARAMETER twilio_accountId
Twilio Account ID
.PARAMETER twilio_authentication
Twilio Authentication token
.PARAMETER bingMapsAPI_key
Bing Maps API key
.NOTES
#>

[CmdletBinding()]
param(
    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Subscription Id.")]
    [ValidateNotNullOrEmpty()]
    [string] $SubscriptionId,

    [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Project Name")]
    [ValidateNotNullOrEmpty()]
    [string] $ProjectName,

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "Project Region")]
    [ValidateNotNullOrEmpty()]
    [string] $ProjectRegion = 'WestUS2',

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "SendGrid Password.")]
    [ValidateNotNullOrEmpty()]
    [string] $SendGridPassword,

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "SendGrid Email.")]
    [ValidateNotNullOrEmpty()]
    [string] $EmailAccount,

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "SMS number.")]
    [ValidateNotNullOrEmpty()]
    [string] $twilio_smsNumber,

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "Twilio Account Id.")]
    [ValidateNotNullOrEmpty()]
    [string] $twilio_accountId,

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "Twilio Authentication token.")]
    [ValidateNotNullOrEmpty()]
    [string] $twilio_authentication,

    [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, HelpMessage = "Bing Map API key.")]
    [ValidateNotNullOrEmpty()]
    [string] $bingMapsAPI_key

)

###################################################################################################

# Default exit code
$ExitCode = 0

try {
    
    $ErrorActionPreference = "Stop"

    # Install Powershell Azure Module
    if (Get-Module -Name AzureRM -ListAvailable) {
        Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
    } else {
        Install-Module -Name Az -AllowClobber -Scope CurrentUser
    }

    # Connect to the Azure subscription that CORA will be deployed to
    Connect-AzAccount -SubscriptionId $SubscriptionId

    # New resource group for CORA resources
    New-AzResourceGroup -Location $ProjectRegion -Name $ProjectName

    # This is to accept the SendGrid Terms is there is an account
    if ($SendGridPassword -ne '') {
        Get-AzMarketplaceTerms -Publisher 'Sendgrid' -Product 'sendgrid_azure' -Name 'free' |  Set-AzMarketplaceTerms -Accept
    }

    # Create App Id for Bot
    $sp = New-AzADServicePrincipal -DisplayName ($ProjectName)

    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
    $UnsecureSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    $parametersObject = @{
        'ProjectName' = $ProjectName
        'bot_MsaAppId' = $sp.ApplicationId
        'bot_MsaPassword' = $UnsecureSecret
        'sendGrid_Acct_Password' = $SendGridPassword
        'sendGrid_Email' = $EmailAccount
        'twilio_smsNumber' = $twilio_smsNumber
        'twilio_accountId' = $twilio_accountId
        'twilio_authentication' = $twilio_authentication
        'bingMapsAPI_key' = $bingMapsAPI_key
    }

    
    New-AzResourceGroupDeployment -ResourceGroupName $ProjectName -TemplateFile .\DeploymentScripts\AzureDeploy.json -TemplateParameterObject $parametersObject
    
    #TO DO get publish profiles and input as secrets to the Website and Bot repos.
}
catch {}
finally {}