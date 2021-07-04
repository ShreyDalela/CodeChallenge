
This Repo contains all data related to Challenge-3. 

 
## Problem Statement
---

We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you.<br>
Bonus Points <br>
The code allows for a particular data key to be retrieved individually<br>
Hints<br>
·         Aws Documentation (https://docs.aws.amazon.com/)<br>
·         Azure Documentation (https://docs.microsoft.com/en-us/azure/?product=featured)<br>
·         Google Documentation (https://cloud.google.com/docs)<br>


&nbsp;
&nbsp;

---

## Solution Overview
 The problem statement requires to fetch AWS EC2 instance data, also it must have a feature where a user can select the value it wants as an output. The Output for the activity   is in JSON format as requested.
The script requires your AccessKey and Secret to process this data from your AWS account. All Integrations in the Scripts are specific to a region so you can choose the system to run on a region of your choice.

&nbsp;
&nbsp;

## Usage

### How to Import
1. Open the *Get-InstanceMetadataAWS.ps1* in a Powershell.ise tab
2. You can Interactively pass the AccessKey and SecretKey to the respective Variable or hardcode against the variables.
3. The script also Imports 3 modules *AWS.Tools.Installer*, *AWS.Tools.EC2* and *AWS.Tools.Common* to enhance its capabilities


### Inputs\Outputs
The script contains 2 Inputs in which only region is mandatory and returns information against these instances. For ease of use, you get autocomplete options in both of them.
if you don't define the DataKey Input the function returns all data related to the instance
* [String] AWSRegion
* [String] DataKey
* [Json]   InstanceDetails - Output

Here are few trigger examples

Get-InstanceMetadata -AWSRegion <Region> -DataKey <KeyName>
  
 ```
PS C:\> Get-InstanceMetadata -AWSRegion us-west-2
[
    {
        "Name":  null,
        "InstanceID":  "i-0bc9fecd396d06192",
        "PrivateIP":  "172.31.18.78",
        "LaunchTime":  "\/Date(1616609066000)\/",
        "Licenses":  [

                     ],
        "Monitoring":  {
                           "State":  "disabled"
                       },
        "NetworkInterfaces":  [
                                  "Amazon.EC2.Model.InstanceNetworkInterface"
                              ],
        "Staten":  {
                       "Code":  16,
                       "Name":  "running"
                   },
        "SubnetId":  "subnet-56ef5a2e",
        "Architecture":  {
                             "Value":  "x86_64"
                         },
        "BootMode":  null,
        "ClientToken":  "161660906076766290",
        "Hypervisor":  {
                           "Value":  "xen"
                       },
        "KeyName":  "sql",
        "PublicIpAddress":  "34.213.232.75",
        "SecurityGroups":  [
                               "Amazon.EC2.Model.GroupIdentifier"
                           ],
        "InstanceType":  {
                             "Value":  "t2.micro"
                         },
        "AmiID":  "ami-052ff42ae3be02b6a",
        "ImageName":  "CentOS Linux 6 x86_64 HVM EBS 2002_1-74e73035-3435-48d6-88e0-89cc02ad83ee-ami-011efcc998732b7cd.4"
    },
    {
        "Name":  null,
        "InstanceID":  "i-05ec9dc4c81b23cea",
        "PrivateIP":  "172.31.36.27",
        "LaunchTime":  "\/Date(1616608912000)\/",
        "Licenses":  [

                     ],
        "Monitoring":  {
                           "State":  "disabled"
                       },
        "NetworkInterfaces":  [
                                  "Amazon.EC2.Model.InstanceNetworkInterface"
                              ],
        "Staten":  {
                       "Code":  16,
                       "Name":  "running"
                   },
        "SubnetId":  "subnet-4330e709",
        "Architecture":  {
                             "Value":  "x86_64"
                         },
        "BootMode":  null,
        "ClientToken":  "161660882621772935",
        "Hypervisor":  {
                           "Value":  "xen"
                       },
        "KeyName":  "login ansible",
        "PublicIpAddress":  "34.220.14.208",
        "SecurityGroups":  [
                               "Amazon.EC2.Model.GroupIdentifier"
                           ],
        "InstanceType":  {
                             "Value":  "t2.micro"
                         },
        "AmiID":  "ami-052ff42ae3be02b6a",
        "ImageName":  "CentOS Linux 6 x86_64 HVM EBS 2002_1-74e73035-3435-48d6-88e0-89cc02ad83ee-ami-011efcc998732b7cd.4"
    }
]   
```
  
```
PS C:\> Get-InstanceMetadata -AWSRegion us-west-2 -DataKey AmiID
[
    "ami-052ff42ae3be02b6a",
    "ami-052ff42ae3be02b6a"
]
  
```
  
### Exceptions & Tests

- [x] When Access Key or Secret is incorrect
```
PS C:\>Get-InstanceMetadata -AWSRegion us-east-1
       Get-EC2Instance : AWS was not able to validate the provided access credentials
```
  
 - [x] When requested key data is not present in the fetched data
```
PS C:\> Get-InstanceMetadata -AWSRegion us-west-2 -DataKey AmiI
       Cannot validate argument on parameter 'DataKey'. The argument "AmiI" does not belong to the set 
```

- [x] For incorrect region in is not present in the fetched data
```
PS C:\> Get-InstanceMetadata -AWSRegion us-west 
        Get-InstanceMetadata : Cannot validate argument on parameter 'AWSRegion'.
```
