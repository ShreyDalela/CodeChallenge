# CodeChallenge

# File Structure
The below graph will help you traverse through the directories

      .                
      ├── Challenge-1                         #Solution For Challenge 1                         
      |   ├── 3-Tier App
      |   |    ├── LB
      |   |    ├── VM
      |   |    ├── dsc
      |   |    ├── Set-Credentials.ps1
      |   |    ├── outputs.tf
      |   |    ├── var-declaration.tf
      |   |    └── vnet.tf   
      |   └── Readme.md
      ├── Challenge-2                         #Solution For Challenge 2                          
      |   ├── Get-InstanceMetadataAWS.ps1
      |   ├── Readme.md 
      |   └── Tests
      ├── Challenge-3                         #Solution For Challenge 3                          
      |   ├── Readme.md
      |   ├── Return-Value.ps1
      |   └── Tests
      └── ...



### Challenge #1
---

A 3-tier environment is a common setup. Use a tool of your choosing/familiarity create these resources. Please remember we will not be judged on the outcome but more focusing on the approach, style and reproducibility.
 
 
 
 
 
 
### Challenge #2
---

We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you.
Bonus Points
The code allows for a particular data key to be retrieved individually
Hints:
>        *  Aws Documentation (https://docs.aws.amazon.com/)
>        *  Azure Documentation (https://docs.microsoft.com/en-us/azure/?product=featured)
>        *  Google Documentation (https://cloud.google.com/docs)
 
 
 
 
 
### Challenge #3
---

We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
>        Example Inputs : 
>        object = {“a”:{“b”:{“c”:”d”}}}
>        key = a/b/c
>        
>        object = {“x”:{“y”:{“z”:”a”}}}
>        key = x/y/z
>        value = a
Hints:
We would like to see some tests. A quick read to help you along the way
We would expect it in any other language apart from elixir.
A quick read to help you along the way 


