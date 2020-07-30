
# GettingStarted
If you're not sure what to do, start here!

# Overview
There are four projects; 
- Getting Started focuses on getting the infrastructure created in the least amount of effort.  This will include scripts, ARM templates, and documents.
- CoraBot contains the code for the bot and the messaging.
- Website has the web site code.
- DataModel, will eventually have a generalized data interface.  NYI

Fork each of the repositories and clone to your local machine to customize for your specific needs.

# Create Azure Resources
The DeployResource Powershell script will do the initial deployment of the Azure resource to get your version of the CORA project site up and running.

The following parameters are available for the script
ProjectName - This is the name that will be used for the Web site, and as a prefix for the other resources to allow easier management, ie CORAProject
ProjectRegion - The region that the resources will be deployed to, the default region is WestUS2.  For more information https://azure.microsoft.com/en-us/global-infrastructure/geographies/

sendGrid_Email - If you want to include WebChat we use SendGrid to interface with, for more details see the SendGrid section below.
sendGrid_Acct_Password - The SendGrid password.

twilio_smsNumber - If you want to include SMS, we use Twilio to interact with, for more details see the Twilio SMS section below.
twilio_accountId - The Twilio Account ID
twilio_authentication - A Twilio Authentication token.

bingMapsAPI_key - For the maps functionality a Bing Maps key is required, see the Bing Map API below

Some of the functionality Email and SMS management require seperate accounts.
## SendGrid
    - If you don't have a SendGrid account don't enter an email account and the deployment will occur without the SendGrid resource.
    - We use SendGrid to manage email, you can setup a free account. https://sendgrid.com/marketing/sendgrid-services-cro/?extProvId=56&extPu=72368-bingads&extLi=110161520&extCr=1649139542-&extSi=&extTg=&keyword=sendgrid&extAP=&extMT=e&pub=BingAds&msclkid=1327b646baa312de836fe96745dd587c&utm_medium=cpc&utm_source=bing
    - 
    
## Twilio SMS 
    - If you don't have a Twilio account don't enter a phone number and the deployment will occur without the SMS resource.
    - You can setup a free account: https://www.twilio.com/try-twilio
    - To secure the account id and authentication token will need to be updated "Twilio_Account_ID" and "Twilio_Account_Token"
## Bing Map API
    - Bing Map API
    - Setup https://www.bingmapsportal.com/
    - Secret API key "Bing_Map_API_KEY"
    - 
# Manual TO DO

In the Website and CoraBot repositories there are existing action file, to get these working there are a few steps that we hope to eventually automate.

For the Website:
- In Azure open the Project Name App service and select "Get Publish Profile", this will download the file to your computer.
- In the Website repo add a secret named "PROJECTCORAWEBSITE_PUBLISHPROFILE" the value for that secret will be the data in the file from above.
    - Modify the file "BuildAndDeployWebsite.yml" go to line 66 and replace CoraProject with the project name you used for the Powershell script.
    - Enable actions on the repo, and commit the changes.  The action will run on changes to Main.
- In Azure open the Project Name bot App service (if the project name is foo look for 'foobot') and select "Get Publish Profile", this will download the file to your computer.
- In the CoraBot repo we will do something similiar, add a secret named "AZURE_FUNCTIONAPP_PUBLISH_PROFILE" the value for that secret will be the data in the file from above.
    - Modify the file "BotBuildAndDeploy.yml" go to line 8 and replace CoraProject with the project name you used for the Powershell script.
    - Enable actions on the repo, and commit the changes.  The action will run on changes to Main.

