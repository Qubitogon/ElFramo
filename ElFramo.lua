local _,eF=...

for debuffType, color in next, DebuffTypeColor do
	print(debuffType,color.r,color.g,color.b)
end

local function initUnitsFrame()
eF.units=CreateFrame("Frame","units",UIParent)
eF.units:EnableMouse(true)
eF.units:SetPoint("CENTER",UIParent,"CENTER",-300,0)
eF.units:SetHeight(270)
eF.units:SetWidth(70)
eF.units:Show()

MakeMovable(eF.units)

eF.units.texture=eF.units:CreateTexture()
eF.units.texture:SetAllPoints()
eF.units.texture:SetDrawLayer("BACKGROUND",-6)
eF.units.texture:SetColorTexture(0,0,0,0.5)

eF.units.createUnitFrame=eF.rep.createUnitFrame
eF.units.onUpdate=eF.rep.unitsFrameOnUpdate
eF.units:SetScript("OnUpdate",units.onUpdate)

--apply all relevant non-table parameters
for k,v in pairs(eF.para.units) do
  if type(v)~="table" then eF.units[k]=v end
end 

end

local function createUnitAuras(self)
--will contain creation of all auras necessary, probably iwll beed a loop through families and their parameters, see old elFramo
end
eF.rep.createUnitAuras=createUnitAuras

local function unitHPUpdate(self)
  if not (self.hp and self.enabled) then return end --WARN: MIGHT BE UNNECESSARY
  local unit=self.id
  self.hp:SetValue( UnitHealth(unit)/UnitHealthMax(unit))
end
eF.rep.unitHPUpdate=unitHPUpdate

local function unitEnable(self)
  
  if self.enabled then return end
  self.enabled=true
  self:Show()
  RegisterUnitWatch(self)
  local unit=self.id
  for i=1,#self.events do
    self:RegisterUnitEvent(self.events[i],unit)
    --self:RegisterEvent(self.events[i])
  end


end
eF.rep.unitEnable=unitEnable

local function unitDisable(self)
  
  if not self.enabled then return end
  UnregisterUnitWatch(self)
  self.enabled=false
  self:Hide()
  
  local unit=self.id
  for i=1,#self.events do
    self:UnregisterEvent(self.events[i])
    --self:RegisterEvent(self.events[i])
  end
  
end
eF.rep.unitDisable=unitDisable

local function unitUpdateText(self)
  local unit=self.id
  local name=UnitName(unit)
  local units=eF.units
  if units.textLim then name=strsub(name,1,units.textLim) end
  self.text:SetText(name)
  
  if units.textColorByClass then
    local _,CLASS=UnitClass(unit)
    local r,g,b=GetClassColor(CLASS) 
    local a=units.textA or 1
    self.text:SetTextColor(r,g,b,a)
  end
  
end
eF.rep.unitUpdateText=unitUpdateText

local function updateUnitBorders(self)
  local size=eF.units.borderSize
  if not (size and self.borderRight) then return end 
  
  for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do 
    local loc,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
    self[loc]:SetPoint(p1,self,p1,f11*(size),f12*(size))
    self[loc]:SetPoint(p2,self,p2,f21*(size),f22*(size))
    if w then self[loc]:SetWidth(size); 
    else self[loc]:SetHeight(size); end    
  end
end
eF.rep.updateUnitBorders=updateUnitBorders

local function unitEventHandler(self,event)
  if not self.enabled then return end

  if event=="UNIT_HEALTH_FREQUENT" or event=="UNIT_MAXHEALTH" or event=="UNIT_CONNECTION" or event=="UNIT_FACTION" then
    self:hpUpdate()
    
  elseif event=="UNIT_AURA" then 
    self:disableFamilies()
    --BUFFS
    for i=1,40 do
      local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss,own=UnitAura(self.id,i)
      if not name then break end 
      self:allAdopt(true,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)
    end
    --DEBUFFS
    for i=1,40 do
      local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss,own=UnitAura(self.id,i,"HARMFUL")
      if not name then break end 
      self:allAdopt(false,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)
    end 
    
  end 
end
eF.rep.unitEventHandler=unitEventHandler

local function createUnitFrame(self,unit)
  
  --if this unit frame exists already or unit is nil, fuck it
  if self[unit] or not unit then return end  
  

  
  self[unit]=CreateFrame("Button",nil,self,"SecureUnitButtonTemplate")
  self[unit].id=unit
  
  self[unit]:SetAttribute("unit",unit)
  self[unit]:SetAttribute("type1","target")
  
  --TBA: positional table
  self[unit]:SetPoint("TOPLEFT",self,"TOPLEFT",0,0)
  
  self[unit]:SetSize(self.width,self.height)
  self[unit]:SetFrameStrata("MEDIUM")
  self[unit]:Hide()
  self[unit].enabled=false
  
  self[unit].oor=false
  self[unit].oorA=eF.para.units.oorA
  self[unit].nA=eF.para.units.nA
  if eF.units.checkOOR then self[unit].updateRange=eF.rep.unitUpdateRange end
  
  if self.bg then 
    self[unit].bg=self[unit]:CreateTexture()
    self[unit].bg:SetAllPoints()
    if self.bgR then self[unit].bg:SetColorTexture(self.bgR,self.bgG,self.bgB)
    else self[unit].bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background") end 
    
    self[unit].bg:SetDrawLayer("BACKGROUND",-4)
  end --end of if self.bg
  
  --status bar health: https://us.battle.net/forums/en/wow/topic/8796680765
  
  do --create HP bar
  self[unit].hp=CreateFrame("StatusBar",nil,self[unit],"TextStatusBar") 
  if self.healthGrow=="up" then 
    self[unit].hp:SetPoint("BOTTOMLEFT"); self[unit].hp:SetPoint("BOTTOMRIGHT");  self[unit].hp:SetHeight(self.height); self[unit].hp:SetOrientation("VERTICAL")
  elseif self.healthGrow=="right" then
    self[unit].hp:SetPoint("BOTTOMLEFT"); self[unit].hp:SetPoint("TOPLEFT"); self[unit].hp:SetWidth(self.width); self[unit].hp:SetOrientation("HORIZONTAL")
  elseif self.healthGrow=="down" then
    self[unit].hp:SetPoint("TOPRIGHT"); self[unit].hp:SetPoint("TOPLEFT"); self[unit].hp:SetHeight(self.height); self[unit].hp:SetOrientation("VERTICAL")
  elseif self.healthGrow=="left" then
    self[unit].hp:SetPoint("TOPRIGHT"); self[unit].hp:SetPoint("BOTTOMRIGHT"); self[unit].hp:SetWidth(self.width); self[unit].hp:SetOrientation("HORIZONTAL")
  end

  if self.hpTexture then 
    self[unit].hp:SetStatusBarTexture(self.hpTexture,0,0.8,0)
   
    if self.hpR then 
      local alpha=self.hpA or 1 
      self[unit].hp:SetStatusBarColor(self.hpR,self.hpG,self.hpB,alpha)    
    end   
  
  else 
    local alpha=self.hpA or 1
    self[unit].hp:SetStatusBarTexture(self.hpR,self.hpG,self.hpB,alpha)  
  end
  
  self[unit].hp:SetMinMaxValues(0,1) 
  self[unit].hp:SetFrameLevel( self[unit]:GetFrameLevel())
  
  local hpTexture=self[unit].hp:GetStatusBarTexture()
  
  if self.hpGrad then 
    hpTexture:SetGradientAlpha(self.hpGradOrientation,self.hpGrad1R,self.hpGrad1G,self.hpGrad1B,self.hpGrad1A,self.hpGrad2R,self.hpGrad2G,self.hpGrad2B,self.hpGrad2A)
  end
  
  self[unit].hpUpdate=eF.rep.unitHPUpdate
  self[unit].events={"UNIT_HEALTH_FREQUENT","UNIT_MAXHEALTH","UNIT_CONNECTION","UNIT_FACTION","UNIT_AURA"}
  end  
  
  do --create name string
  self[unit].text=self[unit]:CreateFontString(nil,"OVERLAY",-1)
  self[unit].text:SetFont(self.textFont,self.textSize,self.textExtra)
  self[unit].text:SetPoint(self.textPos,self[unit],self.textPos)
  local r=self.textR or 1
  local g=self.textG or 1
  local b=self.textB or 1
  local a=self.textA or 1
  self[unit].text:SetTextColor(r,g,b,a)
  self[unit].updateText=eF.rep.unitUpdateText
  end
  
  --create border
  self[unit].updateBorders=eF.rep.updateUnitBorders
  if self.borderSize then 
    local r=self.borderR or 0
    local g=self.borderG or 0
    local b=self.borderB or 0
    local a=self.borderA or 1 
    for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do
      local bn=eF.borderInfo(v)      
      self[unit][bn]=self[unit]:CreateTexture("BACKGROUND",-4)
      self[unit][bn]:SetColorTexture(r,g,b,a)
    end
  self[unit]:updateBorders()
  end

  
  self[unit].enable=eF.rep.unitEnable
  self[unit].disable=eF.rep.unitDisable
  self[unit].eventHandler=eF.rep.unitEventHandler
  self[unit]:SetScript("OnEvent",self[unit].eventHandler)
  
end --end of CreateUnitFrame()
eF.rep.createUnitFrame=createUnitFrame

local function initUnitsUnits()

  for i=1,5 do
    eF.units:createUnitFrame(eF.partyLoop[i])
  end
  
  for i=1,40 do
    eF.units:createUnitFrame(eF.raidLoop[i])
  end
  
end

local function unitUpdateRange(self)
   local r=UnitInRange(self.id)  
   --print(self.id,r,self.oor)
   if not r and not self.oor then 
    self:SetAlpha(self.oorA)
    self.oor=true
   elseif self.oor and r then
    self:SetAlpha(self.nA)
    self.oor=false
   end
end
eF.rep.unitUpdateRange=unitUpdateRange

local throttle=eF.para.throttle
local eT=0
local function unitsFrameOnUpdate(self,elapsed)
  if eT<throttle then eT=eT+elapsed; return end
  eT=0
  local tbl
  if self.raid then tbl=eF.raidLoop else tbl=eF.partyLoop end
  
  for i=1,self.num do
    local frame=self[tbl[i]]
    if frame.updateRange and self.num>1 then frame:updateRange() end   --if youre alone in the group it's fucked  
    
    
    for j=1,self.familyCount do
      if frame[j].onUpdate and frame[j].filled then frame[j]:onUpdate() end
    end
    
  end--end of for i=1,self.num
end
eF.rep.unitsFrameOnUpdate=unitsFrameOnUpdate

initUnitsFrame()
initUnitsUnits()
