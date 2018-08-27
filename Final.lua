local _,eF=...

function initialise(self)
  if _eF_savVar then eF.profiles=_eF_savVar.profiles end
  local set=_eF_initProfile or "default" 
  if not eF.rep.setProfile(set) then print("elFramo: Profile'",set,"'not found, set to 'default' instead"); eF.rep.setProfile("default") end
  
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


--performance
--[[

some benchmarking vs grid 2 (same features as far as I can tell / could parametrise)
https://i.imgur.com/R9KxF1K.jpg
https://i.imgur.com/Y7wucYk.jpg
older screenshots not included due to me being shit and not saving them

INCLUDING OLDER RUNS, SEEMS TO PERFORM 20-25% BETTER OVERALL THAN GRID2 USING "Addons CPU Usage" SINCE THE -BIG UPDATE-

Would require SIGNFICANTLY more testing, with medium/large/insane amount of elements to compare scaling
Furthermore it's kinda unfair since grid2 has more features as *options* which could tax performance (although shouldnt most of the time if not selected)

]]

--notes on frame layout / updating (macro)
--[[
2 LFR tests of a total of 5 bosses since the RegisterUnitWatch / Show / Hide restructuring:
No lua errors, thank god <--- needed 4 more fixes because fuck me
 ^---nvm they're back! Might be related to when pets spawn (for some FUCKING REASON??)
  ---really need to fix it eventually
  ---SHOULD BE FIXED NOW! UI_DropDownMenu is a piece of SHIT!!?!
No late updating of offline/dead etc
No duplicating of "player" and "party*" frames
No range updating issues
]]

--notes on elements (micro)
--[[
Nothing relevant to say atm
]]

--TBA 1!!!
--[[

]]

--TBA 2 !
--[[

--changing frame level
--Cast tracking
--HEAL ABSORB/ABSORB option for bars
--Groups can set loading conditions to children 
--"Other stuff" frame to include things in TBA3 whenever needed

]]

--TBA 3
--[[

--Tooltip option for raid frames
--option to hide when solo
--MAYBE tooltips to explain wtf some parameters do

]]









