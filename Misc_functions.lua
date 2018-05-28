print("----Misc_functions.lua init")

function ElFramo.TargetUnit(n) --USELESS CAUSE PROECTED (OFC) COULD DELETE BUT ITS A NICE REMINDER OF MY FAILURE
  
  if not n then print("No target was given!"); return else print("Trying to target at index: "..tostring(n)) end 
 
  local unit
  local g=ElFramo.Group
  
    print("Group type is:"..g.type)

  
  if n==1 then unit="player"
  elseif g.type=="raid" then unit="raid"..tostring(n)
  else unit="party"..tostring(n-1) end
  

  TargetUnit(unit)
  print("trying to target "..unit)
  
end

function ElFramo.SayShit()
  print("Shit")
end

function ElFramo.Unitid(n)

  local g = ElFramo.Group
  local id=""
  if not g then print("Tried to find UnitId but ElFramo.Group empty"); return end
  
  if n==1 then id="player" 
  elseif g.type=="raid" then id="raid"..tostring(n)
  else id="party"..tostring(n-1) end 
  
  return id
  
end


function ElFramo.GetCLASS(class)
  local a
  if ElFramo.ClassTable[class] then a =ElFramo.ClassTable[class]
  elseif class=="Death Knight" then a="DEATH KNIGHT" 
  elseif class=="Demon Hunter" then a="DEMON HUNTER" end 
  return a
end


function ElFramo.Test(n)
  
  n=tonumber(n) or 2
  print("for "..tostring(n).."members")
  for i=1,n do
    local name1=GetRaidRosterInfo(i)
    local name2=UnitName(ElFramo.Unitid(i))
    print("RaidRosterIndex:"..tostring(i).." "..name1.."   ;  "..ElFramo.Unitid(i) .." "..name2)
  
  end
end