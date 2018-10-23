local _,eF=...
local afterDo=C_Timer.After

eF.castWatcher=CreateFrame("Frame")
local cW=eF.castWatcher
cW:SetPoint("CENTER")
cW.casts={}
local events={"UNIT_SPELLCAST_START",
              "UNIT_SPELLCAST_DELAYED",
              "UNIT_SPELLCAST_SUCCEEDED",
              "UNIT_SPELLCAST_STOP",
              "UNIT_SPELLCAST_INTERRUPTED",
              "UNIT_SPELLCAST_FAILED",
              "UNIT_SPELLCAST_FAILED_QUIET",
              "UNIT_TARGET",
              }
              
              
for i=1,#events do
  cW:RegisterEvent(events[i])
end

cW.onEvent=function(self,event,sourceUnit)
  if (not UnitExists(sourceUnit)) or (not UnitIsEnemy(sourceUnit,"player")) then  return end
  local sourceGUID=UnitGUID(sourceUnit)
  local casts=self.casts
  local castID=sourceGUID
  if event=="UNIT_SPELLCAST_START" 
  then
    local units=eF.units
    if casts[sourceGUID] then return end
    local spellName,_,icon,castStart,castEnd,_,_,_,spellId = UnitCastingInfo(sourceUnit)
    local duration
    if castStart and castEnd then 
      castEnd=castEnd/1000
      castStart=castStart/1000
      duration=castEnd-castStart
    end
    --self,name,icon,duration,expirationTime,unitCaster,spellId
    if not castID then print("CastID is nil, source: ",sourceUnit," spellName: ",spellName); return end
    casts[castID]={}
    
    --find the player corresponding to the target
    local target=sourceUnit.."target"

    local lst
    if units.raid then lst=eF.raidLoop else lst=eF.partyLoop end
    local unit
    for i=1,#lst do
      if UnitIsUnit(target,lst[i]) then unit=units[lst[i]]; break end
    end
    
    if not unit then
      casts[castID].list={}
      return 
    end
    
    --apply onCastList
    local l=unit.onCastList
    for j=1,#l do
      local v=l[j]
      v[1](v[2],spellName,icon,duration,castEnd,sourceUnit,spellId,castID)
    end
    
    local l=unit.onPostCastList
    for j=1,#l do
      local v=l[j]
      v[1](v[2])
    end
    
  elseif event== "UNIT_SPELLCAST_STOP"
  or event=="UNIT_SPELLCAST_INTERRUPTED"
  or event=="UNIT_SPELLCAST_FAILED"
  or event=="UNIT_SPELLCAST_FAILED_QUIET"
  or event=="UNIT_SPELLCAST_SUCCEEDED"
  or event=="UNIT_TARGET"
  then
    local c=casts[castID]
    if not c then return end
    if not c.list then return end
    if (c.unit) and (eF.units[c.unit]) then
      local unit=eF.units[c.unit]

      for i=1,#c.list do
        c.list[i][1].castList[c.list[i][2]]=nil
      end
      c.list=nil
      casts[castID]=nil 
      
      local l=unit.onPostCastList
      for j=1,#l do
        local v=l[j]
        v[1](v[2])
      end
    else
      casts[castID].list=nil
      casts[castID]=nil
    end
    
    if event=="UNIT_TARGET"
    then
      self:onEvent("UNIT_SPELLCAST_START",sourceUnit)  
    end
    
  end
  
end

cW:SetScript("OnEvent",cW.onEvent)




