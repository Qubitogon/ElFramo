print("----Misc_functions.lua init")

function elFramo.targetUnit(n) --USELESS CAUSE PROECTED (OFC) COULD DELETE BUT ITS A NICE REMINDER OF MY FAILURE
  
  if not n then print("No target was given!"); return else print("Trying to target at index: "..tostring(n)) end 
 
  local unit
  local g=elFramo.group
  
    print("Group type is:"..g.type)

  
  if n==1 then unit="player"
  elseif g.type=="raid" then unit="raid"..tostring(n)
  else unit="party"..tostring(n-1) end
  

  TargetUnit(unit)
  print("trying to target "..unit)
  
end

function elFramo.sayShit()
  print("Shit")
end

function elFramo.unitID(n)

  local g = elFramo.group
  local id=""
  if not g then print("Tried to find UnitId but elFramo.group empty"); return end
  
  if n==1 then id="player" 
  elseif g.type=="raid" then id="raid"..tostring(n)
  else id="party"..tostring(n-1) end 
  
  return id
  
end


function elFramo.getCLASS(class)
  local a
  if elFramo.classTable[class] then a =elFramo.classTable[class]
  elseif class=="Death Knight" then a="DEATH KNIGHT" 
  elseif class=="Demon Hunter" then a="DEMON HUNTER" end 
  return a
end


function elFramo.test(n)
  
  n=tonumber(n) or 2
  print("for "..tostring(n).."members")
  for i=1,n do
    local name1=GetRaidRosterInfo(i)
    local name2=UnitName(elFramo.unitID(i))
    print("RaidRosterIndex:"..tostring(i).." "..name1.."   ;  "..elFramo.unitID(i) .." "..name2)
  
  end
end