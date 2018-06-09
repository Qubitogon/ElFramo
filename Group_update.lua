
function elFramo.groupUpdate()
    --print("elFramo.group_update entered")
    local pairs,ipairs=pairs,ipairs
    elFramo.nameToID={}
    local gType--WILL SAVE THE GROUP TYPE FOR THIS FUNCTION FOR EASY ACCESS
    
    --CHECKS WHETHER IN A RAID OR NOT + SAVES
    if IsInRaid() then elFramo.group.type="raid"; gType="raid"; --local var just to make below shorter to write 
    else elFramo.group.type="party"; gType="party" end
   
    --COUNT GROUP MEMBERS
    -- NOTE THAT GetNumGroupMembers() SAYS 0 IF YOURE ALONE BUT WE SAVE IT AS 1 BECAUSE 0 IS DUMB
    local nMembers=GetNumGroupMembers()
    if nMembers==0 then elFramo.group.type="solo"; elFramo.group.nMembers=1; nMembers=1; gType="solo"
    else elFramo.group.nMembers=nMembers end
    
    
    --CREATE GROUP DICT
    if gType=="raid" then
      
      for i=1,nMembers do
        local name=GetRaidRosterInfo(i)
        elFramo.nameToRaidRosterIndex[name]=i
      end
      
      for i=1,nMembers do
        local id=elFramo.unitID(i)
        local name=GetUnitName(id,true)
        print(i,name)
        elFramo.group[i]={}
        local _,_,subgroup,_,class,_,_,_,_,_,_,role=GetRaidRosterInfo(elFramo.nameToRaidRosterIndex[name]) --does not work if solo
        elFramo.group[i].name=name                                                                      
        elFramo.group[i].subGroup=subgroup
        elFramo.group[i].class=class
        elFramo.group[i].role=role
        --elFramo.nameToID[name]=i       
      end --end of for i=1,nMembers

    end --end of if gType==raid
   
   
    if gType=="party" then
      
      for i=1,nMembers do
        local name=GetRaidRosterInfo(i)
        elFramo.nameToRaidRosterIndex[name]=i
      end
      
      for i=1,nMembers do
        local id=elFramo.unitID(i)
        local name=GetUnitName(id,true)
        elFramo.group[i]={}
        local _,_,subgroup,_,class,_,_,_,_,_,_,role=GetRaidRosterInfo(elFramo.nameToRaidRosterIndex[name]) --does not work if solo
        elFramo.group[i].name=name                                                                      
        elFramo.group[i].subgroup=subgroup
        elFramo.group[i].class=class
        elFramo.group[i].role=role
        --elFramo.nameToID[name]=i
      end --end of for i=1,nMembers

    end --end of if gType==party
    
    if gType=="solo" then
      elFramo.group[1]={}
      elFramo.group[1].name=UnitName("player")
      elFramo.group[1].subgroup=1
      elFramo.group[1].class=UnitClass("player")
      if GetSpecialization() then --somehow necessary to not have a lua error on first login
      elFramo.group[1].role=GetSpecializationRole(GetSpecialization()) end 
      --elFramo.nameToID[tostring(name)]=1

    end
    
  --print("Group_update done")
end --end of function Group_update
 

function elFramo.groupOutput() --used merely for debugging, outputs the entire array in the chat along with possible errors
  
  --print("elFramo.group_output entered")
  
  if not elFramo.group then print("elFramo.group is nil"); return end 
  
  if not elFramo.group.type then print("elFramo.group.type is nil"); return end 
  
  if not elFramo.group.nMembers then print("elFramo.group.nMembers is nil"); return end 
  
  if not elFramo.group[1] then print("elFramo.group[1] is nil"); return end 
  
  local g=elFramo.group
  

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
    
  end --end of for i=1,nMembers

end
 
 

