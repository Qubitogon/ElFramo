local _,eF=...
               
eF.partyLoop={"player","party1","party2","party3","party4"}
eF.raidLoop={}
eF.positions={"CENTER","RIGHT","TOPRIGHT","TOP","TOPLEFT","LEFT","BOTTOMLEFT","BOTTOM","BOTTOMRIGHT"}
eF.orientations={"up","down","right","left"}
eF.Classes={"Death Knight","Demon Hunter","Druid","Hunter","Mage","Monk","Paladin","Priest","Rogue","Shaman","Warlock","Warrior"}
eF.ROLES={"DAMAGER","HEALER","TANK"}
eF.fonts={"FRIZQT__","ARIALN","skurri","MORPHEUS"}
eF.OOCActions={layoutUpdate=false,groupUpdate=false}
eF.info={}
eF.info.playerClass=UnitClass("player")

for i=1,40 do
  local s="raid"..tostring(i)
  table.insert(eF.raidLoop,s)
end


function MakeMovable(frame)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

function eF.borderInfo(pos)
  local loc,p1,p2,w,f11,f12,f21,f22
  if pos=="RIGHT" then loc="borderRight"; p1="TOPRIGHT"; p2="BOTTOMRIGHT"; w=true; f11=1; f12=0; f21=1; f22=0;
  elseif pos=="TOP" then loc="borderTop"; p1="TOPLEFT"; p2="TOPRIGHT"; w=false; f11=-1; f12=1; f21=1; f22=1;
  elseif pos=="LEFT" then loc="borderLeft"; p1="TOPLEFT"; p2="BOTTOMLEFT";w=true; f11=-1; f12=0; f21=-1; f22=0;
  elseif pos=="BOTTOM" then loc="borderBottom"; p1="BOTTOMLEFT";p2="BOTTOMRIGHT"; w=false; f11=-1; f12=-1; f21=1; f22=-1; end  
  
  return loc,p1,p2,w,f11,f12,f21,f22
end

function eF.toDecimal(f,d)
  if not f then return end
  if not d then return f end
  local m=math.pow(10,d)
  f=f*m
  f=floor(f+0.5)
  f=f/m
  return f
end

function eF.isInList(s,lst)
  if not s or not lst then return false end
  local found=false
  local tostring=tostring
  for i=1,#lst do 
      s=tostring(s)
      if lst[i]==s then
        found=true
        break
      end
    --end
  end
  return found
end

function eF.posInList(s,lst)
  if not s or not lst then return nil end
  for i=1,#lst do 
    if type(lst[i])==type(s) then
      if lst[i]==s then
        break
      end
    end
  end
  return i
end

function eF.posInFamilyButtonsList(j,k)
  if (not eF.familyButtonsList) or #eF.familyButtonsList==0 then return false end
  local lst=eF.familyButtonsList
  local bool=false
  local pos=nil
  for i=1,#lst do
    if j==lst[i].familyIndex and k==lst[i].childIndex then bool=true;pos=i; break end
  end
  return (bool and pos) or false
end



















