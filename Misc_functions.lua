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
  
  if g.type=="party" then if n==1 then id="player" else id="party"..tostring(n-1) end elseif g.type=="raid" then id="raid"..tostring(n) else id="player" end
  
  
  return id
  
end


function elFramo.getCLASS(class)
  local a
  if elFramo.classTable[class] then a =elFramo.classTable[class]
  elseif class=="Death Knight" then a="DEATHKNIGHT" 
  elseif class=="Demon Hunter" then a="DEMONHUNTER" end 
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

function elFramo.isInList(s,lst)

  if not s or not lst then return false end
  local found=false
  for i=1,#lst do 
    if type(lst[i])==type(s) then
      if lst[i]==s then
        found=true
        break
      end
    end
  end
  return found
end


function elFramo.toDecimal(f,d)
  local m=math.pow(10,d)
  f=f*m
  f=floor(f)
  f=f/m
  return f
end


function MakeMovable(frame)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end




