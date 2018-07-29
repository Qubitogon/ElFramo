local _,eF=...

function initialise(self)
  if _eF_savVar then eF.profiles=_eF_savVar.profiles end
  local set=_eF_initProfile or "test" 
  eF.rep.setProfile(set)
  


  --eLFramo.lua
  eF.rep.initUnitsFrame()
  eF.rep.initUnitsUnits()

  --layout.lua
  eF.rep.initLayoutFrame()

  for i=1,40 do
    local frame=eF.units[eF.raidLoop[i]]
    frame.families=eF.para.families
  end--end of i
                   
  for i=1,5 do
    local frame=eF.units[eF.partyLoop[i]]
    frame.families=eF.para.families
  end--end of i

  --families.lua
  eF.rep.initCreateFamilyFrames()
  eF.layout:update()
  
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  self=nil
  
  eF.rep.intSetInitValues()
end


local initFrame=CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
initFrame:SetScript("OnEvent",initialise)