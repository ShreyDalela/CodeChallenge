configuration IISInstall 
{ 
    Import-DscResource â€“ModuleName â€™PSDesiredStateConfigurationâ€™;
    Node "webserver"
    { 
        WindowsFeature InstallIIS 
        { 
            
            Name = "Web-Server"   
            Ensure = "Present" 
                    
        } 
         WindowsFeature InstallIISConsole
        {
            Name = "Web-Mgmt-Console"
            Ensure = "Present"
        }
    } 

}