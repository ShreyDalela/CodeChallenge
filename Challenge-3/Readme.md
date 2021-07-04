This Repo contains all data related to Challenge-3. 

 
## Problem Statement
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

&nbsp;
&nbsp;

---

## Solution Overview
 Looking at the problem statement is is a use case of nested object where the user should get its child value as per the input key. Making the codewalkthrough easier we'll take an illustration of a Class where we have students named John and his respective attributes.
>     {“a”:{“b”:{“c”:”d”}}} = '{“Class”:{“john”:{“age”:”13”,"height":"172"}}}'



&nbsp;
&nbsp;

## Usage

### How to Import
1. Copy the *Return-Value.ps1*
2. Run in a Powershell.ise tab

### Inputs\Outputs
The script contains 2 Mandatory Inputs and returns value of the child at levels
* ObjectStr
* Key
* Value

To trigger the script use the below code

Return-Value -ObjectStr '<Input Object>' -Key '<Key seperated at "\" level>'
  
 ```
PS C:\> Return-Value -ObjectStr '{“Class”:{“john”:{“age”:”13”,"height":"172"}}}' -Key "Class"
Name                      Value                                                                                                                                             
----                      -----                                                                                                                                             
john                      {age, height}    
```
  
```
PS C:\> Return-Value -ObjectStr '{“Class”:{“john”:{“age”:”13”,"height":"172"}}}' -Key "Class/John"
Name                           Value                                                                                                                                             
----                           -----                                                                                                                                             
age                            13                                                                                                                                                 
height                         172      
```
  
```
PS C:\> Return-Value -ObjectStr '{“Class”:{“john”:{“age”:”13”,"height":"172"}}}' -Key "Class/John/age"
13
```
  
### Exceptions & Tests

- [x] When requested a key outside object depth
```
PS C:\> Return-Value -ObjectStr '{“Class”:{“john”:{“age”:”13”,"height":"172"}}}' -Key "Class/John/age/group"
        Depth of key Greater than Depth of object
```
  
 - [x] When object contains special characters out of set ['"','A-Z','0-9',':',':',',']
```
PS C:\> Return-Value -ObjectStr '{“Class”:{“john”:{“age”:”13”,"height*":"172"}}}' -Key "Class/John/age"
        Object Contains special charactersout of defination
```

- [x] Typo in key Defination
```
PS C:\> Return-Value -ObjectStr '{“Class”:{“john”:{“age”:”13”,"height":"172"}}}' -Key "Class\John\age"
13        
```
