$ErrorActionPreference = "Stop"

#Installing AWS Tools
Install-Module -Name AWS.Tools.Installer -Force -AllowClobber

#Installing required modules 'EC2' FOr Instance & 'Common' for managing access 
Install-MOdule AWS.Tools.EC2,AWS.Tools.Common -force -AllowClobber


#Mandatory Input For AWS connections
$AccessKey =  Read-Host "Kindly Provide your Access Key"
$SecretKey = Read-Host "Enter Client Secret" -AsSecureString


#Function to Get Metadata with 2 values AWS Region and Data Key
function Get-InstanceMetadata
{
            param(
                [Parameter(mandatory=$true)]
                [ValidateSet('af-south-1','ap-east-1','ap-northeast-1','ap-northeast-2','ap-northeast-3','ap-south-1','ap-southeast-1','ap-southeast-2','eu-central-1','eu-North-1','eu-south-1','eu-west-1','eu-west-2','eu-west-1','us-east-1','us-east-2','us-west-1','us-west-2')]
                [string[]]
                $AWSRegion,

                [ValidateSet('Name','InstanceID','PrivateIP','LaunchTime','Licenses','Monitoring','NetworkInterfaces','Staten','SubnetId','Architecture','BootMode','ClientToken','Hypervisor','KeyName','PublicIpAddress','SecurityGroups','InstanceType','AmiID')]
                [string] $DataKey

            )


                        Initialize-AWSDefaults -Region  $AWSRegion -AccessKey $AccessKey -SecretKey $SecretKey 

                                #Fetches instances in current region
                                $ListOfInstances = Get-EC2Instance 

                                #Creating Custom Objects for all values
                                $InstanceDetails = $ec2List.Instances| ForEach-Object {
                                    $properties = [ordered]@{
                                    Name         = ($_ | Select-Object -ExpandProperty tags | Where-Object -Property Key -eq Name).value
                                    InstanceID    = $_.InstanceId
                                    PrivateIP    = $_.PrivateIpAddress
                                    LaunchTime    = $_.LaunchTime
                                    Licenses    = $_.Licenses
                                    Monitoring   = $_.Monitoring
                                    NetworkInterfaces = $_.NetworkInterfaces
                                    Staten = $_.State
                                    SubnetId = $_.SubnetId
                                    Architecture = $_.Architecture 
                                    BootMode = $_.BootMode
                                    ClientToken = $_.ClientToken
                                    Hypervisor = $_.Hypervisor 
                                    KeyName = $_.KeyName
                                    PublicIpAddress = $_.PublicIpAddress
                                    SecurityGroups = $_.SecurityGroups
                                    InstanceType = $_.InstanceType
                                    AmiID = $_.ImageID
                                    ImageName = (Get-EC2Image -ImageId $_.ImageID).Name
                                    }
                                    New-Object -TypeName PSObject -Property $properties
                                }

                        if ($DataKey)
                        {
 
                            return $InstanceDetails.$DataKey | ConvertTo-Json
                        }

                             return $InstanceDetails | ConvertTo-Json
}
