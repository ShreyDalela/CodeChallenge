   configuration WSFCInstall
{ 
    Import-DscResource â€“ModuleName â€™PSDesiredStateConfigurationâ€™;
    Node "sqlserver"
    { 
        WindowsFeature FailoverFeature 
        { 
            Ensure = "Present" 
            Name      = "Failover-clustering" 
        } 
 
        WindowsFeature RSATClusteringPowerShell 
        { 
            Ensure = "Present" 
            Name   = "RSAT-Clustering-PowerShell"    
 
            DependsOn = "[WindowsFeature]FailoverFeature" 
        } 
 
        WindowsFeature RSATClusteringCmdInterface 
        { 
            Ensure = "Present" 
            Name   = "RSAT-Clustering-CmdInterface" 
 
            DependsOn = "[WindowsFeature]RSATClusteringPowerShell" 
        }
    } 

}