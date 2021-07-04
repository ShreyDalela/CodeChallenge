

This Repo contains all data related to Challenge-3. 


      .                                                            
      ├── Bastion-vm.tf          # Configuration of bastion host and vm
      ├── tier1-lb.tf            # Tier-1 Loadbalancer Configuration
      ├── tier1-vm.tf            # Tier-1 VM
      ├── tier1-web.ps1          # Powershell DSC to Configure Web tier
      ├── tier2-app.ps1          # Powershell DSC to Configure App and Settings
      ├── tier2-lb.tf            # Tier-3 Loadbalancer Configuration
      ├── tier2-vm.tf            # Tier-2 VM
      ├── tier3-lb.tf            # Tier-3 Loadbalancer Configuration
      ├── tier3-sql.ps1          # Powershell DSC to Configure DB and Settings
      ├── tier3-vm.tf            # Tier-3 VM
      ├── outputs.tf             # Deployment Outputs
      ├── var-declaration.tf     # Deployment Input
      ├── vnet.tf                # Deployment Network Configurations
      └── Readme.md              
 
 
## Problem Statement
---


A 3-tier environment is a common setup. Use a tool of your choosing/familiarity create these resources. Please remember we will not be judged on the outcome but more focusing on the approach, style and reproducibility.

&nbsp;
&nbsp;
&nbsp;

---

## Solution Overview
The infrastructure deployed whing the defined configuration can be seen as in the picture below. It is a **bare minimum** 3-Tier Architecture some alternates can be seen in the recomendation folders. Also to keep the configurations easier to read the use of modules was not considered.

![Arch](https://github.com/ShreyDalela/CodeChallenge/blob/2dbf5b1574bf0eec97815413b3a789acf9e9bfcc/Challenge-1/Tire.png)

* Tier 1 is the front-end tier installed with IIS.
* Tier 2 is the Business or middleware tier.
* Tire 3 is our Data Tier containing databases.
* We have and additional Management containing a Azure Bastion host connected to a VM to manage configurations on the VM on each tier.
* Standard load balancers have been configured between each layer.
* Only Front-End load balancer and the Bastion Host are exposed to the internet using public IP.
* By placing VMs across zones, the application becomes resilient to failures within a zone.
* SQL Server in the data tier is in Always on Availability Group.
* NSGs have been configured on each layer with minimum exposer to only the services that too present on the Load balancer backend pool.
* Probes have been configured on the LBs for their respective services.
* Configuration on all the nodes is managed using Powershell DSC from bastion host on WinRM

&nbsp;
&nbsp;

