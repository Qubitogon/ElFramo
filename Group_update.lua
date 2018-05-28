print("----EF Group_update.lua init")

function ElFramo.Group_update()
    --print("ElFramo.Group_update entered")
    local pairs,ipairs=pairs,ipairs
    
    local gtype--WILL SAVE THE GROUP TYPE FOR THIS FUNCTION FOR EASY ACCESS
    
    --CHECKS WHETHER IN A RAID OR NOT + SAVES
    if IsInRaid() then ElFramo.Group.type="raid"; gtype="raid"; --local var just to make below shorter to write 
    else ElFramo.Group.type="party"; gtype="party" end
   
    --COUNT GROUP MEMBERS
    -- NOTE THAT GetNumGroupMembers() SAYS 0 IF YOURE ALONE BUT WE SAVE IT AS 1 BECAUSE 0 IS DUMB
    local nMembers=GetNumGroupMembers()
    if nMembers==0 then ElFramo.Group.type="solo"; ElFramo.Group.nMembers=1; nMembers=1; gtype="solo"
    else ElFramo.Group.nMembers=nMembers end
    
    
    --CREATE GROUP DICT
    if gtype=="raid" then
  
      for i=1,nMembers do
        --print("loop: member "..tostring(i))
        ElFramo.Group[i]={}
        local name,_,subgroup,_,class,_,_,_,_,_,_,role=GetRaidRosterInfo(i) --does not work if solo
        ElFramo.Group[i].name=name                                                                      
        ElFramo.Group[i].subgroup=subgroup
        ElFramo.Group[i].class=class
        ElFramo.Group[i].role=role
        
      end --end of for i=1,nMembers

    end --end of if gtype==raid
   
   
    if gtype=="party" then
    
      for i=1,nMembers do
        --print("loop: member "..tostring(i))
        ElFramo.Group[i]={}
        local name,_,subgroup,_,class,_,_,_,_,_,_,role=GetRaidRosterInfo(i) --does not work if solo
        ElFramo.Group[i].name=name
        ElFramo.Group[i].subgroup=subgroup
        ElFramo.Group[i].class=class  
        ElFramo.Group[i].role=role
        
      end --end of for i=1,nMembers

    end --end of if gtype==party
    
    if gtype=="solo" then
      ElFramo.Group[1]={}
      ElFramo.Group[1].name=UnitName("player")
      ElFramo.Group[1].subgroup=1
      ElFramo.Group[1].class=UnitClass("player")
      ElFramo.Group[1].role=GetSpecializationRole(GetSpecialization())
    end
    
  --print("Group_update done")
end --end of function Group_update
 

function ElFramo.Group_output() --used merely for debugging, outputs the entire array in the chat along with possible errors
  
  --print("ElFramo.Group_output entered")
  
  if not ElFramo.Group then print("ElFramo.Group is nil"); return end 
  
  if not ElFramo.Group.type then print("ElFramo.Group.type is nil"); return end 
  
  if not ElFramo.Group.nMembers then print("ElFramo.Group.nMembers is nil"); return end 
  
  if not ElFramo.Group[1] then print("ElFramo.Group[1] is nil"); return end 
  
  local g=ElFramo.Group
  

  print("----Group_output----")
  
  print("Type: "..g.type)
  print("nMembers: "..tostring(g.nMembers))
  
  
  for i=1,g.nMembers do
    local ts="Member "..tostring(i).." ('"..tostring(g[i].name).."')"..": \n"
    
    local key,value
    
    for key,value in pairs(g[i]) do --loops through key/value pairs of the group 
      ts=ts.."     "..tostring(key)..": "..tostring(value).." \n"
    end--end of for key,value in ipairs(g[i])
    print(ts)
    
  end --emd of for i=1,nMembers

end
 
 

