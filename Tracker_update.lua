
print("----EF Tracker_update.lua init")
function elFramo.trackerUpdate()
    --print("got called")
    local nMembers=elFramo.group.nMembers
    local gType=elFramo.group.type
    local trk=elFramo.tracker --SINCE THEY ARE POINTERS, CHANGING tkr IS CHANGING THE GLOBAL DICT
    local pairs,ipairs=pairs,ipairs
    
    if gType=="raid" then  
      for i=1,nMembers do
        local id=gType..tostring(i)
        
        trk[i]={}
        trk[i].health=UnitHealth(id)
        trk[i].maxHealth=UnitHealthMax(id)
        trk[i].power=UnitPower(id)
        trk[i].maxPower=UnitPowerMax(id)
        _,trk[i].powerType=UnitPowerType(id)
        
        
        trk[i].range=UnitInRange(id)
        trk[i].offline= not UnitIsConnected(id)
        trk[i].ghost=UnitIsGhost(id)
        trk[i].dead=UnitIsDead(id)      
        
        trk[i].absorb=UnitGetTotalAbsorbs(id)
        
        --BUFF TRACKING
        trk[i].buffs={}
        trk[i].buffs.count=0 --counts how many buffs they have
        
        --print("health:",tostring(health))
        
        for j=1,40 do
          --NOTE THAT IN BFA UnitBuff() HAS NO "rank" ARGUMENT ANY MORE, SO ALL OUTPUTS SLIDE DOWN BY 1
          local name,icon,count,mType,dur,expT,source,canSteal,_,spellID,_,boss=UnitBuff(id,j)
          if not name then break 
          else 
            trk[i].buffs.count=trk[i].buffs.count+1
            
            trk[i].buffs[j]={}
            trk[i].buffs[j].name=name
            trk[i].buffs[j].icon=icon
            trk[i].buffs[j].count=count
            trk[i].buffs[j].mType=mType
            trk[i].buffs[j].duration=dur
            trk[i].buffs[j].expirationTime=expT
            trk[i].buffs[j].source=source
            trk[i].buffs[j].canSteal=canSteal
            trk[i].buffs[j].spellID=spellID
            trk[i].buffs[j].boss=boss
        
          end --end of if not name "" else
          
        end --emd of for j=1,40
        
        --print("buff count:",tostring(trk[i].buffs.count))
        
        --DEBUFF TRACKING
        trk[i].debuffs={}
        trk[i].debuffs.count=0 --counts how many buffs they have
        for j=1,40 do
          --NOTE THAT IN BFA UnitDebuff() HAS NO "rank" ARGUMENT ANY MORE, SO ALL OUTPUTS SLIDE DOWN BY 1
          local name,icon,count,mType,dur,expT,source,canSteal,_,spellID,_,boss=UnitDebuff(id,j)
          if not name then break
          else 
            trk[i].debuffs.count=trk[i].debuffs.count+1
            
            trk[i].debuffs[j]={}
            trk[i].debuffs[j].name=name
            trk[i].debuffs[j].icon=icon
            trk[i].debuffs[j].count=count
            trk[i].debuffs[j].mType=mType
            trk[i].debuffs[j].duration=dur
            trk[i].debuffs[j].expirationTime=expT
            trk[i].debuffs[j].source=source
            trk[i].debuffs[j].canSteal=canSteal
            trk[i].debuffs[j].spellID=spellID
            trk[i].debuffs[j].boss=boss
        
          end --end of if not name "" else
          
        end --end of for j=1,40
        
        --print()

      end --end of for i=1,nMembers

    end --end of if gtype==raid
   

   
    if gType=="party" or gType=="solo" then
      for i=1,nMembers do
        local id=gType..tostring(i-1)
        if i==1 then id="player" end
        --print(id)
        trk[i]={}
        trk[i].health=UnitHealth(id)
        trk[i].maxHealth=UnitHealthMax(id)
        trk[i].power=UnitPower(id)
        trk[i].maxPower=UnitPowerMax(id)
        _,trk[i].powerType=UnitPowerType(id)
        
        
        trk[i].range=UnitInRange(id)
        trk[i].offline= not UnitIsConnected(id)
        trk[i].ghost=UnitIsGhost(id)
        trk[i].dead=UnitIsDead(id)      
        
        trk[i].absorb=UnitGetTotalAbsorbs(id)
        

        --BUFF TRACKING
        trk[i].buffs={}
        trk[i].buffs.count=0 --counts how many buffs they have
        
        --print("health:",tostring(health))
        
        for j=1,40 do
          --NOTE THAT IN BFA UnitBuff() HAS NO "rank" ARGUMENT ANY MORE, SO ALL OUTPUTS SLIDE DOWN BY 1
          local name,icon,count,mType,dur,expT,source,canSteal,_,spellID,_,boss=UnitBuff(id,j)
          if not name then break 
          else 
            trk[i].buffs.count=trk[i].buffs.count+1
            
            trk[i].buffs[j]={}
            trk[i].buffs[j].name=name
            trk[i].buffs[j].icon=icon
            trk[i].buffs[j].count=count
            trk[i].buffs[j].mType=mType
            trk[i].buffs[j].duration=dur
            trk[i].buffs[j].expirationTime=expT
            trk[i].buffs[j].source=source
            trk[i].buffs[j].canSteal=canSteal
            trk[i].buffs[j].spellID=spellID
            trk[i].buffs[j].boss=boss
        
          end --end of if not name "" else
          
        end --emd of for j=1,40
        
        --print("buff count:",tostring(trk[i].buffs.count))
        
        --DEBUFF TRACKING
        trk[i].debuffs={}
        trk[i].debuffs.count=0 --counts how many buffs they have
        for j=1,40 do
          --NOTE THAT IN BFA UnitDebuff() HAS NO "rank" ARGUMENT ANY MORE, SO ALL OUTPUTS SLIDE DOWN BY 1
          local name,icon,count,mType,dur,expT,source,canSteal,_,spellID,_,boss=UnitDebuff(id,j)
          if not name then break
          else 
            trk[i].debuffs.count=trk[i].debuffs.count+1
            
            trk[i].debuffs[j]={}
            trk[i].debuffs[j].name=name
            trk[i].debuffs[j].icon=icon
            trk[i].debuffs[j].count=count
            trk[i].debuffs[j].mType=mType
            trk[i].debuffs[j].duration=dur
            trk[i].debuffs[j].expirationTime=expT
            trk[i].debuffs[j].source=source
            trk[i].debuffs[j].canSteal=canSteal
            trk[i].debuffs[j].spellID=spellID
            trk[i].debuffs[j].boss=boss
        
          end --end of if not name "" else
          
        end --end of for j=1,40
        
        
      end --end of for i=1,nMembers

    end --end of if gtype==party
  
  
  --print("finished tracker_update")
end --end of function Tracker_update
  
  
function elFramo.trackerOutput() --used merely for debugging, outputs the entire array in the chat along with possible errors
  
  print("elFramo.trackerOutput entered")
  
  if not elFramo.tracker then print("elFramo.tracker is nil"); return end 
  
  if not elFramo.group then print("elFramo.group is nil"); return end
  
  if not elFramo.group.type then print("elFramo.group.type is nil"); return end 
  
  if not elFramo.group.nMembers then print("elFramo.group.nMembers is nil"); return end 
  
  if not elFramo.tracker[1] then print("elFramo.tracker[1] is nil"); return end 
  
  
  local g=elFramo.group

  local t=elFramo.tracker
  
  
  --local hs="" --helping string

  print("----Tracker_output----")
  
  for i=1,g.nMembers do
  

    print("Member "..tostring(i).." ('"..tostring(g[i].name).."')"..":")  
    local key,value
    
    for key,value in pairs(t[i]) do --loops through key/value pairs of the Tracker 
      print("     "..tostring(key)..": "..tostring(value))
    end--end of for key,value in ipairs(t[i])

    
    --local next=next --efficiency: for some reason it's faster for lua to load functions from a local table
                    --so we redeclare the function as itself and save it locally (not really necessary here but oh well)
    
    print("---BUFF LIST---:")
    if #t[i].buffs==0 then print("      No buffs") 
    else     
      local j,bf
      for j,bf in ipairs(t[i].buffs) do --loops through buffs, ipairs for an array ([1/2/3..]), pairs for a list (["key"])
        print("   Buff "..tostring(j)..": ('"..tostring(t[i].buffs[j].name).."')")
        
        local k,v
        for k,v in pairs(bf) do
          print("      "..tostring(k)..": "..tostring(v))    
        end --end of for k,v in pairs(bf))s
        
      end --end of for j,v in ipairs(t[i].buffs)
    end --end of if next(...) else
    

    print("---DEBUFF LIST---:")
    if #t[i].debuffs==0 then print("      No debuffs") 
    else     
      local j,dbf
      for j,dbf in ipairs(t[i].debuffs) do --loops through debuffs, ipairs for an array ([1/2/3..]), pairs for a list (["key"])
        print("   Debuff "..tostring(j)..": ('"..tostring(t[i].debuffs[j].name).."')")
        
        local k,v
        for k,v in pairs(dbf) do
          print("      "..tostring(k)..": "..tostring(v))    
        end --end of for k,v in pairs(dbf))s
        
      end --end of for j,v in ipairs(t[i].debuffs)
    end --end of if next(...) else
    
    print("\n")
    
  end --end of for i=1,nMembers

end























