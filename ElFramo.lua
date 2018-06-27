local _,eF=...

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

eF.units.checkLoad=eF.rep.unitsLoad

eF.units.createUnitFrame=eF.rep.createUnitFrame
eF.units.onUpdate=eF.rep.unitsFrameOnUpdate
eF.units.onEvent=eF.rep.unitsEventHandler
eF.units.onGroupUpdate=eF.rep.unitsOnGroupUpdate
eF.units.updateSize=eF.rep.updateUnitFrameSize
eF.units:SetScript("OnUpdate",units.onUpdate)
eF.units:RegisterEvent("GROUP_ROSTER_UPDATE")
eF.units:SetScript("OnEvent",units.onEvent)
--apply all relevant non-table parameters
for k,v in pairs(eF.para.units) do
  if type(v)~="table" then eF.units[k]=v end
end 
for k,v in pairs(eF.para.layout) do
  if type(v)~="table" then eF.units[k]=v end
end 

end
eF.rep.initUnitsFrame=initUnitsFrame

local function unitsEventHandler(self,event)
  
  if event=="GROUP_ROSTER_UPDATE" then
    self:onGroupUpdate()    
  end--END OF IF event==GROUP_ROSTER_UDPATE
    
end
eF.rep.unitsEventHandler=unitsEventHandler

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
  local r=eF.para.units.borderR
  local g=eF.para.units.borderG
  local b=eF.para.units.borderG
  local a=eF.para.units.borderA


  if not (size and self.borderRight) then return end 
  
  for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do 
    local loc,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
    self[loc]:SetColorTexture(r,g,b,a)
    self[loc]:SetPoint(p1,self,p1,f11*(size),f12*(size))
    self[loc]:SetPoint(p2,self,p2,f21*(size),f22*(size))
    if w then self[loc]:SetWidth(size); print("done")
    else self[loc]:SetHeight(size); end    
  end
end
eF.rep.updateUnitBorders=updateUnitBorders

local function unitEventHandler(self,event)
  if not self.enabled then return end
  if event=="UNIT_HEALTH_FREQUENT" or event=="UNIT_MAXHEALTH" or event=="UNIT_CONNECTION" or event=="UNIT_FACTION" then
    self:hpUpdate()
    
  elseif event=="UNIT_AURA" then 
    
    local c=self.onAuraList
    for j=1,#c do
      local v=c[j]
      v[1](v[2])
    end
      
    --BUFFS
    for i=1,40 do
      local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss,own=UnitAura(self.id,i)
      if not name then break end   
      
      local c=self.onBuffList
      for j=1,#c do
        local v=c[j]
        v[1](v[2],name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)
      end  
    
    end
    --DEBUFFS
    for i=1,40 do
      local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss,own=UnitAura(self.id,i,"HARMFUL")
      if not name then break end 
      
      local c=self.onDebuffList
      for j=1,#c do
        local v=c[j]
        v[1](v[2],name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)
      end
      
    end 
    
    local c=self.onPostAuraList
    for j=1,#c do
      local v=c[j]
      v[1](v[2])
    end
  
  elseif event=="UNIT_POWER_UPDATE" then
  
    local c=self.onPowerList
    for j=1,#c do
      local v=c[j]
      v[1](v[2])
    end
    
  end 
end
eF.rep.unitEventHandler=unitEventHandler

local function createUnitFrame(self,unit)
  
  --if this unit frame exists already or unit is nil, fuck it
  if self[unit] or not unit then return end  
  

  
  self[unit]=CreateFrame("Button",nil,self,"SecureUnitButtonTemplate")
  self[unit].id=unit
  self[unit].events={"UNIT_HEALTH_FREQUENT","UNIT_MAXHEALTH","UNIT_CONNECTION","UNIT_FACTION","UNIT_AURA","UNIT_POWER_UPDATE"}

  self[unit]:SetAttribute("unit",unit)
  self[unit]:SetAttribute("type1","target")
  
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
  self[unit].checkLoad=eF.rep.unitLoad
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
eF.rep.initUnitsUnits=initUnitsUnits

local function unitUpdateRange(self)
   local r=UnitInRange(self.id)  
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
    
    local c=frame.onUpdateList
    for j=1,#c do
      local v=c[j]
      v[1](v[2])
    end
    
  end--end of for i=1,self.num
end
eF.rep.unitsFrameOnUpdate=unitsFrameOnUpdate

local function unitsOnGroupUpdate(self)
    local raid=IsInRaid()
    self.raid=IsInRaid() --is used for the updatefunction
    local num=GetNumGroupMembers() --for some reason gives 0 when solo
    if num==0 then num=1 end
    self.num=num
    local lst
    if raid then lst=eF.raidLoop
    else lst=eF.partyLoop end  
      
    for n=1,num do
      local unit=lst[n]  
      local class,CLASS=UnitClass(unit)
      if self.byClassColor then

        local alpha=units.hpA or 1
        local r,g,b=GetClassColor(CLASS)       
        if units.hpTexture then 
          units[unit].hp:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar",0,0.8,0)        
          if units.hpR then 
            local alpha=units.hpA or 1 
            units[unit].hp:SetStatusBarColor(units.hpR,units.hpG,units.hpB,alpha)    
          end          
        else 
          units[unit].hp:SetStatusBarTexture(r,g,b,alpha)  
        end    
          
        local hpTexture=units[unit].hp:GetStatusBarTexture()       
        if units.hpGrad then 
          hpTexture:SetGradientAlpha(units.hpGradOrientation,units.hpGrad1R,units.hpGrad1G,units.hpGrad1B,units.hpGrad1A,units.hpGrad2R,units.hpGrad2G,units.hpGrad2B,units.hpGrad2A)
        end
        --units[unit].hp:SetStatusBarColor(r,g,b,hpA)
      end--end of byClassColor
        
      units[unit]:enable()
      if units[unit].text then units[unit]:updateText() end 
      
      local role=UnitGroupRolesAssigned(unit)
      units[unit].role=role      
      units[unit].class=class
      print(class)
      --DO ALL THE FAMILY DEPENDENCIES
      units:checkLoad()
      
    end --end of for n=1,num
      
    --Hide all others
    if not raid then     
      for i=num+1,5 do
        local unit=eF.partyLoop[i]; if units[unit].enabled then units[unit]:disable();  else break end
      end    
      for i=1,40 do
        local unit=eF.raidLoop[i]; if units[unit].enabled then units[unit]:disable(); else break end
      end
     
    else  
    
      for i=1,5 do
        local unit=eF.partyLoop[i]; if units[unit].enabled then units[unit]:disable(); else break end
      end
    
      for i=num+1,40 do
        local unit=eF.raidLoop[i]; if units[unit].enabled then units[unit]:disable() ; else break end
      end
    end
end
eF.rep.unitsOnGroupUpdate=unitsOnGroupUpdate

local function unitsLoad(self,ins,enc) ---self here is eF.units !!!
  
  local tbl
  if self.raid then tbl=eF.raidLoop else tbl=eF.partyLoop end
  for i=1,self.num do 
    local unit=tbl[i]
    self[unit]:checkLoad(ins,enc)    
  end 
end
eF.rep.unitsLoad=unitsLoad

local function unitLoad(self,ins,enc)
  local insert=table.insert
  local nj=#self.families
  local role=self.role
  local class=self.class
  self.onAuraList={}
  self.onBuffList={}
  self.onDebuffList={}
  self.onUpdateList={}
  self.onPowerList={}
  self.onPostAuraList={}
  for j=1,nj do 
    if self[j].smart then 
      if self[j]:checkLoad(role,ins,enc,class) then
        local onAura=self[j].onAuraList
        local onBuff=self[j].onBuffList
        local onDebuff=self[j].onDebuffList
        local onPower=self[j].onPowerList
        local onUpdate=self[j].onUpdateList
        local onPostAura=self[j].onPostAuraList
        
        for l=1,#onAura do
          insert(self.onAuraList,onAura[l])
        end
        
        for l=1,#onBuff do
          insert(self.onBuffList,onBuff[l])
        end
        
        for l=1,#onDebuff do
          insert(self.onDebuffList,onDebuff[l])
        end
        
        for l=1,#onPower do
          insert(self.onPowerList,onPower[l])
        end
        
        for l=1,#onUpdate do
          insert(self.onUpdateList,onUpdate[l])
        end
        
        for l=1,#onPostAura do
          insert(self.onPostAuraList,onPostAura[l])
        end
        
        
      end --end of if self[j]:checkLoad
      
    else --else of if selfj.smart
      local nk=self[j].para.count
      for k=1,nk do       
          if self[j][k]:checkLoad(role,ins,enc,class) then
            local onAura=self[j][k].onAuraList
            local onBuff=self[j][k].onBuffList
            local onDebuff=self[j][k].onDebuffList
            local onPower=self[j][k].onPowerList
            local onUpdate=self[j][k].onUpdateList
            local onPostAura=self[j][k].onPostAuraList
            
            if self.static then self:enable() end
            
            for l=1,#onAura do
              insert(self.onAuraList,onAura[l])
            end
            
            for l=1,#onBuff do
              insert(self.onBuffList,onBuff[l])
            end
            
            for l=1,#onDebuff do
              insert(self.onDebuffList,onDebuff[l])
            end
            
            for l=1,#onPower do
              insert(self.onPowerList,onPower[l])
            end
            
            for l=1,#onUpdate do
              insert(self.onUpdateList,onUpdate[l])
            end
            
            for l=1,#onPostAura do
              insert(self.onPostAuraList,onPostAura[l])
            end
                
          end --end of if selfjk.checkLoad
        
      end --end of for k=1,nk
      
    end--end of if smart else 
    
  end--end of for j=1,nj
  
  
  
end
eF.rep.unitLoad=unitLoad

local function updateUnitFrameSize(self)
  local h,w
  local para=eF.para.units
  h=para.height or 50
  w=para.width or 50
  
  for i=1,45 do
    local id
    if i<6 then id=eF.partyLoop[i] else id=eF.raidLoop[i-5] end
    self[id]:SetHeight(h)
    self[id]:SetWidth(w)
    local o=self[id].hp:GetOrientation()
    if o=="VERTICAL" then self[id].hp:SetHeight(h)
    else self[id].hp:SetWidth(w) end 
  end
end
eF.rep.updateUnitFrameSize=updateUnitFrameSize




--initUnitsFrame()
--initUnitsUnits()










