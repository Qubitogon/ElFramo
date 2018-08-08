local _,eF=...
print("initiating Testing.lua")
local afterDo=C_Timer.After

eF.watcher=CreateFrame("Frame")
local w=eF.watcher
w:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
w:SetScript("OnUpdate",function(self,elapsed) self:onUpdate(elapsed) end)
w:SetPoint("CENTER")

local throttle=0.1
local eT=10
w.onUpdate=function(self,elapsed)
  eT=eT+elapsed
  if eT<throttle then return end
  eT=0

  for i=1,40 do
    local unit="nameplate"..i
    if not UnitExists(unit) then return end
    local _,_,_,texture,castStart,castEnd,_,_,spellName,spellId = UnitCastingInfo(unit)
    if not spellId then
      local _,_,_,texture,castStart,castEnd,_,_,spellName,spellId = UnitChannelInfo(unit)
    end
    
    local name=UnitName(unit)
  end
    
end
