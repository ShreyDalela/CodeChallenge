
function Return-Value ($ObjectStr, $Key)
{

                $Validation = $ObjectStr -replace '[\s{\}\:\^a-zA-Z\”\“]+'

                     #Object Check
                     if ($Validation.length -ge 1)
                                            {
        throw "Object Contains special charactersout of defination
        " 
    }

                 #Handelling Key Typo
                $key = $key.Replace("\","/")

                #handeling key Depth exception
                $Key_Depth =$positionlast = ForEach ( $match in ($key | select-String "/" -allMatches).matches ){$match.Index}
                $Depth = $positionlast = ForEach ( $match in ($object | select-String "}" -allMatches).matches ){$match.Index}

                if ($Key_Depth.count -ge $Depth.Count)
                                        {
     throw "Depth of key Greater than Depth of object"   
    }


                #Creating Nested Object parser as per powershell 
                $object = $ObjectStr
                $object = $object.Replace(":"," = ")
                $object = $object.Replace(",","; ")
                $object = $object.Replace("{","@{ ")
                $position = ForEach ( $match in ($object | select-String "@{" -allMatches).matches ){$match.Index}

                #Final Input Encoded
                $final = Invoke-Expression $object

                #traversing depth as per request
                $key = $key.Replace("/", ".")
                $op = '$final.'+$key
                $value = Invoke-Expression $op
                return $value
                if ($value.length -eq 0)
                {
                 throw "Cannot find key in provided Object"   
                }
}
