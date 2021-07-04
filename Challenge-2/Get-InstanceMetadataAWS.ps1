$ErrorActionPreference = "Stop"

#Installing AWS Tools
Install-Module -Name AWS.Tools.Installer -Force -AllowClobber

#Installing required modules 'EC2' FOr Instance & 'Common' for managing access 
Install-MOdule AWS.Tools.EC2,AWS.Tools.Common -force -AllowClobber


#Mandatory Input For AWS connections
$AccessKey = Read-Host "Kindly Provide your Access Key"
$SecretKey = Read-Host "Enter Client Secret" 
$reg

#Function to Get Metadata with 2 values AWS Region and Data Key
function Get-InstanceMetadata
{
            param(

                [ValidateSet('Name','InstanceID','PrivateIP','LaunchTime','Licenses','Monitoring','NetworkInterfaces','Staten','SubnetId','Architecture','BootMode','ClientToken','Hypervisor','KeyName','PublicIpAddress','SecurityGroups','InstanceType','AmiID')]
                [string] $DataKey

            )
                        Initialize-AWSDefaults -Region $AWSRegion -AccessKey 'AKIARA7G5AZGV6EGPRPV' -SecretKey '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'

                                #Fetches instances in current region
                                $ListOfInstances = Get-EC2Instance 

                                #Creating Custom Objects for all values
                                $InstanceDetails = $ListOfInstances.Instances| ForEach-Object {
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
