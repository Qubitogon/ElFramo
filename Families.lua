local _,eF=...

local function initCreateFamilyFrames()
  local units=eF.units
  local insert=table.insert  
  
  for i=1,45 do
    local frame

    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame.onAuraList={}
    frame.onBuffList={}
    frame.onDebuffList={}
    frame.onUpdateList={}
    frame.onPowerList={}
    frame.createFamily=eF.rep.createFamilyFrame
    frame.applyFamilyParas=eF.rep.applyFamilyParas
    frame.applyChildParas=eF.rep.applyChildParas
    frame.updateFamilyLayout=eF.rep.updateFamilyLayout
    eF.units.familyCount=#frame.families
    for j=1,#frame.families do
      frame:createFamily(j)
      if eF.para.families[j].smart then frame:applyFamilyParas(j)
      else
        for k=1,eF.para.families[j].count do frame:applyChildParas(j,k) end
      end
    end --end of for j=1,#frame.families
 
  end--end of for i=1,45
  
end --end of createFamilyFrames()
eF.rep.initCreateFamilyFrames=initCreateFamilyFrames

local function iconAdoptAuraByName(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
  if self.filled then return  end
  if name==self.para.arg1 then
  
    if self.para.ownOnly and not (unitCaster=="player") then return end    
    
    self.name=name
    self.icon=icon
    self.count=count
    self.debuffType=debuffType
    self.duration=duration
    self.expirationTime=expirationTime
    self.unitCaster=unitCaster
    self.canSteal=canSteal
    self.spellId=spellId
    self.isBoss=isBoss
    self.filled=true
    self:enable()
    return true
  end
end
eF.rep.iconAdoptAuraByName=iconAdoptAuraByName

local function iconUnconditionalAdopt(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)

  if self.filled then return  end
    
    if self.para.ownOnly and not (unitCaster=="player") then return end    

    self.name=name
    self.icon=icon
    self.count=count
    self.debuffType=debuffType
    self.duration=duration
    self.expirationTime=expirationTime
    self.unitCaster=unitCaster
    self.canSteal=canSteal
    self.spellId=spellId
    self.isBoss=isBoss
    self.filled=true
    self:enable()
  return true
  
end
eF.rep.iconUnconditionalAdopt=iconUnconditionalAdopt

local function blacklistFamilyAdopt(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
  if self.full or eF.isInList(name,self.para.arg1) then return end
  if self.para.ignorePermanents and duration==0 then return end
  if self.para.ownOnly and not (unitCaster=="player") then return end
  local iDA=self.para.ignoreDurationAbove
  if iDA then if duration>iDA then return end end 
  self.active=self.active+1
  self.filled=true
  self[self.active]:adopt(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
  if self.active==self.para.count then self.full=true end
  
end
eF.rep.blacklistFamilyAdopt=blacklistFamilyAdopt

local function whitelistFamilyAdopt(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
  if self.full or not eF.isInList(name,self.para.arg1) then return end
  if self.para.ignorePermanents and duration==0 then return end
  if self.para.ownOnly and not (unitCaster=="player") then return end
  local iDA=self.para.ignoreDurationAbove
  if iDA then if duration>iDA then return end end 
  self.active=self.active+1
  self.filled=true
  self[self.active]:adopt(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
  if self.active==self.para.count then self.full=true end
  
end
eF.rep.whitelistFamilyAdopt=whitelistFamilyAdopt

local function smartFamilyDisableAll(self)
  self.full=false
  for k=1,self.active do self[k]:disable() end
  self.active=0
end
eF.rep.smartFamilyDisableAll=smartFamilyDisableAll

local function smartFamilyEnableAll(self)
  self.full=false
  for k=1,self.active do self[k]:enable() end
  self.active=0
end
eF.rep.smartFamilyEnableAll=smartFamilyEnableAll

local function iconFrameDisable(self)
  self:Hide()
  self.filled=false
end
eF.rep.iconFrameDisable=iconFrameDisable

local function iconFrameEnable(self)
  self:Show()
  self.filled=true
end
eF.rep.iconFrameEnable=iconFrameEnable

local function smartFamilyUpdateTexts(self)
  for i=1,self.active do
    self[i]:updateText()
  end
end
eF.rep.smartFamilyUpdateTexts=smartFamilyUpdateTexts

local function iconUpdateTextTypeT(self)
  local t=GetTime()
  local s
  local iDA=self.textIgnoreDurationAbove

  s=self.expirationTime-t
  
  if s<0 or (iDA and s>iDA ) then s='';
  else local dec=self.para.textDecimals or 1; s=eF.toDecimal(s,dec) end

  self.text:SetText(s)
end
eF.rep.iconUpdateTextTypeT=iconUpdateTextTypeT

local function iconApplySmartIcon(self)
  if not self.filled then return end
  self.texture:SetTexture(self.icon)
end
eF.rep.iconApplySmartIcon=iconApplySmartIcon

local function smartFamilyApplySmartIcons(self)
  if not self.filled then return end
  for i=1,self.active do
    self[i]:updateTexture()
  end
end
eF.rep.smartFamilyApplySmartIcons=smartFamilyApplySmartIcons

local function updateBorderColorDebuffType(self)
  if not self.filled then return end
  local c=self.borderColor[self.debuffType] 
  if c then self.border:SetVertexColor(c[1],c[2],c[3])
  else self.border:Hide() end 
end
eF.rep.updateBorderColorDebuffType=updateBorderColorDebuffType

local function smartFamilyDebuffTypeBorderColor(self)
  for i=1,self.active do
    self[i]:updateBorder()
  end
end
eF.rep.smartFamilyDebuffTypeBorderColor=smartFamilyDebuffTypeBorderColor

local function iconUpdateCDWheel(self)
  if not self.filled then return end
  local dur=self.duration
  self.cdFrame:SetCooldown(self.expirationTime-dur,dur)
end
eF.rep.iconUpdateCDWheel=iconUpdateCDWheel

local function smartFamilyUpdateCDWheels(self)
  for i=1,self.active do
    self[i]:updateCDWheel()
  end
end
eF.rep.smartFamilyUpdateCDWheels=smartFamilyUpdateCDWheels

local function statusBarPowerUpdate(self)
  local unit=self.id
  self:SetValue(UnitPower(unit)/UnitPowerMax(unit))
end
eF.rep.statusBarPowerUpdate=statusBarPowerUpdate

local function createFamilyFrame(self,j)
  local insert=table.insert
  if self[j] then self[j]=nil end
  self[j]=CreateFrame("Frame",nil,self)
  local f=self[j]
  f.unitFrame=self
  f.id=self.id
  f:SetSize(1,1)
  f.filled=false
  f.para=self.families[j]

  --------------------SMART FAMILIES
  if f.para.smart then
    f.disable=eF.rep.smartFamilyDisableAll
    f.enable=eF.rep.smartFamilyEnableAll
    f.smart=true       
    f:SetFrameLevel(f.para.frameLevel+self:GetFrameLevel()-1)
    f.active=0
    f:SetPoint(f.para.anchor, self, f.para.anchorTo, f.para.xPos, f.para.yPos)

    ------LOAD STUFF
    f.checkLoad=eF.rep.checkLoad
    f.loaded=false
    f.onAuraList={}
    f.onBuffList={}
    f.onDebuffList={}
    f.onUpdateList={}
    f.onPowerList={}
    f.onPostAuraList={}
        
    if f.para.loadAlways then f.loadAlways=true 
    else 
      if f.para.loadRole then f.loadRole=true; f.loadRoleList=f.para.loadRoleList end
      if f.para.loadInstance then f.loadInstance=true; f.loadInstanceList = f.para.loadInstanceList end
      if f.para.loadEncounter then f.loadEncounter=true; f.loadEncounterList=f.para.loadEncounterList end 
      if f.para.loadClass then f.loadClass=true; f.loadClassList=f.para.loadClassList end
    end  
               
    if f.para.type=="b" then 
      if f.para.trackType=="Buffs" then insert(f.onBuffList,{eF.rep.blacklistFamilyAdopt,f})  
      elseif f.para.trackType=="Debuffs" then insert(f.onDebuffList,{eF.rep.blacklistFamilyAdopt,f}) end
      insert(f.onAuraList,{eF.rep.smartFamilyDisableAll,f})
    end
        
    if f.para.type=="w" then 
      if f.para.trackType=="Buffs" then insert(f.onBuffList,{eF.rep.whitelistFamilyAdopt,f})  
      elseif f.para.trackType=="Debuffs" then insert(f.onDebuffList,{eF.rep.whitelistFamilyAdopt,f}) end
      insert(f.onAuraList,{eF.rep.smartFamilyDisableAll,f})
    end
        
    if f.para.hasBorder and f.para.borderType=="debuffColor" then 
      insert(f.onPostAuraList,{eF.rep.smartFamilyDebuffTypeBorderColor,f})
    end
        
    if f.para.hasTexture and (not f.para.texture or f.para.smartIcon) then
      insert(f.onPostAuraList,{eF.rep.smartFamilyApplySmartIcons,f})
    end
        
    if f.para.cdWheel then
      insert(f.onPostAuraList,{eF.rep.smartFamilyUpdateCDWheels,f})
    end
    
               
    for k=1,f.para.count do
      local xOS=0
      local yOS=0
      if f.para.grow=="down" then yOS=(1-k)*(f.para.spacing+f.para.height)
      elseif f.para.grow=="up" then yOS=(k-1)*(f.para.spacing+f.para.height)
      elseif f.para.grow=="right" then xOS=(k-1)*(f.para.spacing+f.para.width)
      elseif f.para.grow=="left" then xOS=(1-k)*(f.para.spacing+f.para.width) end
        
      if f[k] then f[k]=nil end
      f[k]=CreateFrame("Frame",nil,f)
      local c=f[k]
      c.para=eF.para.families[j]
      c:SetPoint(f.para.growAnchor,f,"CENTER",xOS,yOS)
      c:SetSize(f.para.width,f.para.height)
      c.adopt=eF.rep.iconUnconditionalAdopt        
      c.disable=eF.rep.iconFrameDisable
      c.enable=eF.rep.iconFrameEnable
      c:disable()
      c.onUpdateList={}

      ----------------------VISUALS
        
      c.texture=c:CreateTexture()
      c.texture:SetDrawLayer("BACKGROUND",-2)
      c.texture:SetAllPoints()
      if f.para.hasTexture and (not f.para.texture or f.para.smartIcon) then c.smartIcon=true; c.updateTexture=eF.rep.iconApplySmartIcon
      else c.texture:SetTexture(f.para.texture) end
      c.texture:Hide()
          
      
      c.border=c:CreateTexture(nil,'OVERLAY')
      c.border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
      c.border:SetAllPoints()                     
      c.border:SetTexCoord(.296875, .5703125, 0, .515625)
      if f.para.borderType=="debuffColor" then
        c.updateBorder=eF.rep.updateBorderColorDebuffType
        c.borderColor=eF.para.colors.debuff
      end
      c.border:Hide()
      
          


      if c.cdFrame then c.cdFrame = nil end 
      c.cdFrame=CreateFrame("Cooldown",nil,c,"CooldownFrameTemplate")
      if f.para.cdReverse then c.cdFrame:SetReverse(true) end
      c.cdFrame:SetAllPoints()
      c.cdFrame:SetFrameLevel( c:GetFrameLevel())
      c.updateCDWheel=eF.rep.iconUpdateCDWheel
      c.cdFrame:Hide()
      
      --text
      if f.para.hasText then
        c.text=c:CreateFontString()
        local font=f.para.textFont or "Fonts\\FRIZQT__.ttf"
        local size=f.para.textSize or 20
        local xOS=f.para.textXOS or 0
        local yOS=f.para.textYOS or 0
        local r=f.para.textR
        local g=f.para.textG
        local b=f.para.textB
        local a=f.para.textA
        local extra=f.para.textExtra or "OUTLINE"
        local iDA=c.para.textIgnoreDurationAbove
        c.text:SetFont(font,size,extra)    
        c.text:SetPoint(f.para.textAnchor,c,f.para.textAnchorTo,xOS,yOS)
        c.text:SetTextColor(r,g,b,a)
        if iDA then c.textIgnoreDurationAbove=iDA end
        if c.para.textType=="t" then insert(c.onUpdateList,eF.rep.iconUpdateTextTypeT) end 
      end--end of if frame.hasText
    
      --give the OnUpdate function to the frame
      c.onUpdateFunc=eF.rep.frameOnUpdateFunction
      if #c.onUpdateList>0 then c:SetScript("OnUpdate",eF.rep.frameOnUpdateFunction) end
      
    end --end for k=1,frame.families.count
       
              
  else --else of if smart 
      
    f:SetPoint("CENTER")
    f.createChild=eF.rep.createFamilyChild
    for k=1,f.para.count do
      f:createChild(k)
    end --end for k=1,frame.families.count
  end--end of if frame.families[j].smart else

  f.loaded=true
end
eF.rep.createFamilyFrame=createFamilyFrame

local function applyFamilyParas(self,j)
  local insert=table.insert
  local f=self[j]
  f.para=self.families[j]
  
  --------------------SMART FAMILIES
  if f.para.smart then
    f.onAuraList={}
    f.onBuffList={}
    f.onDebuffList={}
    f.onPowerList={}
    f.onPostAuraList={}

    if f.para.type=="b" then 
      if f.para.trackType=="Buffs" then insert(f.onBuffList,{eF.rep.blacklistFamilyAdopt,f})  
      elseif f.para.trackType=="Debuffs" then insert(f.onDebuffList,{eF.rep.blacklistFamilyAdopt,f}) end
      insert(f.onAuraList,{eF.rep.smartFamilyDisableAll,f})
    end
            
    if f.para.type=="w" then 
      if f.para.trackType=="Buffs" then insert(f.onBuffList,{eF.rep.whitelistFamilyAdopt,f})  
      elseif f.para.trackType=="Debuffs" then insert(f.onDebuffList,{eF.rep.whitelistFamilyAdopt,f}) end
      insert(f.onAuraList,{eF.rep.smartFamilyDisableAll,f})
    end

    if f.para.hasBorder and f.para.borderType=="debuffColor" then 
      insert(f.onPostAuraList,{eF.rep.smartFamilyDebuffTypeBorderColor,f})
    end

    if f.para.hasTexture and (not f.para.texture or f.para.smartIcon) then
      insert(f.onPostAuraList,{eF.rep.smartFamilyApplySmartIcons,f})
    end
            
    if f.para.cdWheel then
      insert(f.onPostAuraList,{eF.rep.smartFamilyUpdateCDWheels,f})
    end
   
    for k=1,f.para.count do
      local xOS=0
      local yOS=0
      if f.para.grow=="down" then yOS=(1-k)*(f.para.spacing+f.para.height)
      elseif f.para.grow=="up" then yOS=(k-1)*(f.para.spacing+f.para.height)
      elseif f.para.grow=="right" then xOS=(k-1)*(f.para.spacing+f.para.width)
      elseif f.para.grow=="left" then xOS=(1-k)*(f.para.spacing+f.para.width) end
      local c=f[k]
      
      c:SetWidth(f.para.width)
      c:SetHeight(f.para.height)
      c:ClearAllPoints()
      c:SetPoint(f.para.anchor,self,f.para.anchorTo,xOS,yOS)
      
      c.onUpdateList={}
      if f.para.hasTexture then
        c.texture:Show()
        if (not f.para.texture or f.para.smartIcon) then c.smartIcon=true; c.updateTexture=eF.rep.iconApplySmartIcon
        else c.texture:SetTexture(f.para.texture) end
      else
        c.texture:Hide()
      end        
              
      if f.para.hasBorder then
        if f.para.borderType=="debuffColor" then
          c.updateBorder=eF.rep.updateBorderColorDebuffType
          c.borderColor=eF.para.colors.debuff
        end
        c.border:Show()
      else
        c.border:Hide()
      end
              

      if f.para.cdWheel then
        if f.para.cdReverse then c.cdFrame:SetReverse(true) end
        c.cdFrame:Show()
      else
        c.cdFrame:Hide()
      end--end of if .cdwheel
              
      if f.para.hasText then
        local iDA=c.para.textIgnoreDurationAbove
        if iDA then c.textIgnoreDurationAbove=iDA end
        local font=c.para.textFont or "Fonts\\FRIZQT__.ttf"
        local size=c.para.textSize or 20
        local xOS=c.para.textXOS or 0
        local yOS=c.para.textYOS or 0
        local r=c.para.textR
        local g=c.para.textG
        local b=c.para.textB
        local a=c.para.textA
        local extra=c.para.textExtra or "OUTLINE"
        c.text:SetFont(font,size,extra)  
        c.text:ClearAllPoints()
        c.text:SetPoint(c.para.textAnchor,c,c.para.textAnchorTo,xOS,yOS)
        c.text:SetTextColor(r,g,b,a)
        if c.para.textType=="Time left" then insert(c.onUpdateList,eF.rep.iconUpdateTextTypeT) end
        c.text:Show()
      else
        c.text:Hide()
      end--end of if frame.hasText
      
      if #c.onUpdateList>0 then c:SetScript("OnUpdate",eF.rep.frameOnUpdateFunction) end
      
    end --end for k=1,frame.families.count
  
  
  else --ELSE OF IF SMART
    return 
  end --END OF IF SMART ELSE 

end
eF.rep.applyFamilyParas=applyFamilyParas

local function applyChildParas(self,j,k)
  local insert=table.insert
  local c=self[j][k]
  if not c then return end
  
  c.para=self.families[j][k]
  

  c.onAuraList={}
  c.onPostAuraList={}
  c.onBuffList={}
  c.onDebuffList={}
  c.onPowerList={}
  c.onUpdateList={}

  if c.para.type=="icon" then
    
    c:SetWidth(c.para.width)
    c:SetHeight(c.para.height)
    c:ClearAllPoints()
    c:SetPoint(c.para.anchor,self,c.para.anchorTo,c.para.xPos,c.para.yPos)
    
    if c.para.trackType=="Buffs" then
      insert(c.onAuraList,{eF.rep.iconFrameDisable,c})
      if c.para.trackBy=="Name" then 
        insert(c.onBuffList,{eF.rep.iconAdoptAuraByName,c})
      end
    end

    if c.para.trackType=="Debuffs" then
      insert(c.onAuraList,{eF.rep.iconFrameDisable,c})
      if c.para.trackBy=="Name" then 
        insert(c.onDebuffList,{eF.rep.iconAdoptAuraByName,c})
      end
    end
    
    if c.para.trackType=="Static" then
      c:Show()
      c.static=true
    end
    
    if c.para.hasTexture then
      c.texture:Show()
      local r=c.para.textureR or 0
      local g=c.para.textureG or 0
      local b=c.para.textureB or 0
      local a=c.para.textureA or 1
      
      if c.para.texture and not (c.para.texture=="") then 
        c.texture:SetTexture(c.para.texture)  
        c.texture:SetVertexColor(r,g,b)
      elseif not c.para.smartIcon then
        c.texture:SetColorTexture(r,g,b,a)  
      else 
        c.smartIcon=true; 
        c.texture:SetVertexColor(r,g,b)
        insert(c.onPostAuraList,{eF.rep.iconApplySmartIcon,c})
      end     
    else
      c.texture:Hide()
    end

    if c.para.hasBorder then
      c.border:Show()
      if c.para.borderType=="debuffColor" then 
        insert(c.onPostAuraList,{eF.rep.updateBorderColorDebuffType,c})
        c.borderColor=eF.para.colors.debuff
        c.updateBorder=eF.rep.updateBorderColorDebuffType
      end
    else
      c.border:Hide()
    end
    
    if c.para.cdWheel then
      c.cdFrame:Show()
      if c.para.cdReverse then c.cdFrame:SetReverse(true) else c.cdFrame:SetReverse(false) end
      insert(c.onPostAuraList,{eF.rep.iconUpdateCDWheel,c})
    else
      c.cdFrame:Hide()
    end
    
    if c.para.hasText then
      c.text:Show()
      local font=c.para.textFont or "Fonts\\FRIZQT__.ttf"
      local size=c.para.textSize or 20
      local xOS=c.para.textXOS or 0
      local yOS=c.para.textYOS or 0
      local r=c.para.textR
      local g=c.para.textG
      local b=c.para.textB
      local a=c.para.textA
      local extra=c.para.textExtra or "OUTLINE"
      c.text:SetFont(font,size,extra)  
      c.text:ClearAllPoints()
      c.text:SetPoint(c.para.textAnchor,c,c.para.textAnchorTo,xOS,yOS)
      c.text:SetTextColor(r,g,b,a)
      if c.para.textType=="Time left" then
        insert(c.onUpdateList,eF.rep.iconUpdateTextTypeT)
      end
    else
      c.text:Hide()
    end--end of if frame.hasText
    
    --give the OnUdpate function to the frame
    c.onUpdateFunc=eF.rep.frameOnUpdateFunction
    if #c.onUpdateList>0 then
      c:SetScript("OnUpdate",eF.rep.frameOnUpdateFunction)
    end

   end
    
  ------------BAR-------------------
  if c.para.type=="bar" then
    
    --c:SetWidth(c.para.width)
    --c:SetHeight(c.para.height)
    c:ClearAllPoints()
    --c:SetPoint(c.para.anchor,self,c.para.anchorTo,c.para.xPos,c.para.yPos)
    
    if c.para.trackType=="power" then
      insert(c.onPowerList,{eF.rep.statusBarPowerUpdate,c})
      c.id=self.id
      c.static=true
      c:Show()
    end

    if c.para.grow=="up" or not c.para.grow then 
      c:SetPoint("BOTTOM",self,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lFix)
      c:SetHeight(c.para.lMax)
      c:SetOrientation("VERTICAL")
    elseif c.para.grow=="down" then 
      c:SetPoint("TOP",self,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lFix)
      c:SetHeight(c.para.lMax)
      c:SetOrientation("VERTICAL")
    elseif c.para.grow=="right" then 
      c:SetPoint("LEFT",self,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lMax)
      c:SetHeight(c.para.lFix)
      c:SetOrientation("HORIZONTAL") 
    else
      c:SetPoint("RIGHT",self,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lMax)
      c:SetHeight(c.para.lFix)
      c:SetOrientation("HORIZONTAL")
    end
    
    local r,g,b,a=c.para.textureR or 1,c.para.textureG or 1,c.para.textureB or 1, c.para.textureA or 1
    c:SetStatusBarTexture(r,g,b,a)  
    c:SetMinMaxValues(0,1)  
    
  end
  
  
end
eF.rep.applyChildParas=applyChildParas

local function updateFamilyLayout(self,j)
  local f=self[j]
  f.para=self.families[j]
  f:ClearAllPoints()
  f:SetPoint(f.para.anchor or "CENTER", self, f.para.anchorTo or "CENTER", f.para.xPos or 0, f.para.yPos or 0)
  
  if f.para.smart then  
    for k=1,f.para.count do
      local xOS=0
      local yOS=0
      if f.para.grow=="down" then yOS=(1-k)*(f.para.spacing+f.para.height)
      elseif f.para.grow=="up" then yOS=(k-1)*(f.para.spacing+f.para.height)
      elseif f.para.grow=="right" then xOS=(k-1)*(f.para.spacing+f.para.width)
      elseif f.para.grow=="left" then xOS=(1-k)*(f.para.spacing+f.para.width) end
        
      local c=f[k]
      c:ClearAllPoints()
      c:SetPoint(f.para.growAnchor,f,"CENTER",xOS,yOS)
      c:SetSize(f.para.width,f.para.height)
    end--end of for j=1,f.para.count
    
  else --else of if f.para.smart
  end  --if else end of if f.para.smart
  
end
eF.rep.updateFamilyLayout=updateFamilyLayout

function createFamilyChild(self,k)
  local insert=table.insert
  if not self.para[k] then return end
  
  if self.para[k].type=="icon" then
    if self[k] then self[k]=nil end
    self[k]=CreateFrame("Frame",nil,self)
    local c=self[k]
    c.para=self.para[k]
    c:SetPoint(c.para.anchor,self.unitFrame,c.para.anchorTo,c.para.xPos,c.para.yPos)
    c:SetSize(c.para.width,c.para.height)
    c:SetFrameLevel(c.para.frameLevel+self:GetFrameLevel())

    c.disable=eF.rep.iconFrameDisable
    c.enable=eF.rep.iconFrameEnable
    c:disable()
          
    -----------LOADING STUFF
    c.checkLoad=eF.rep.checkLoad
    c.loaded=false
    c.onAuraList={}
    c.onPostAuraList={}
    c.onBuffList={}
    c.onDebuffList={}
    c.onUpdateList={}
    c.onPowerList={}
    
    
    if c.para.trackType=="Buffs" then
      insert(c.onAuraList,{eF.rep.iconFrameDisable,c})
      if c.para.trackBy=="Name" then 
        insert(c.onBuffList,{eF.rep.iconAdoptAuraByName,c})
      end
    end

    if c.para.trackType=="Debuffs" then
      insert(c.onAuraList,{eF.rep.iconFrameDisable,c})
      if c.para.trackBy=="Name" then 
        insert(c.onDebuffList,{eF.rep.iconAdoptAuraByName,c})
      end
    end

    if c.para.hasTexture and (not c.para.texture or c.para.smartIcon) and not c.para.hasColorTexture then
      insert(c.onPostAuraList,{eF.rep.iconApplySmartIcon,c})
    end

    if c.para.hasBorder and c.para.borderType=="debuffColor" then 
      insert(c.onPostAuraList,{eF.rep.updateBorderColorDebuffType,c})
    end
        
    if c.para.cdWheel then
      insert(c.onPostAuraList,{eF.rep.iconUpdateCDWheel,c})
    end
        
          
    -------------VISUAL STUFF
    c.texture=c:CreateTexture()
    c.texture:SetDrawLayer("BACKGROUND",-2)
    c.texture:SetAllPoints()
        
    if c.para.texture then c.texture:SetTexture(c.para.texture)  --if c.para.texture
    elseif c.para.hasColorTexture then 
      local r=c.para.textureR or 0
      local g=c.para.textureG or 0
      local b=c.para.textureB or 0
      local a=c.para.textureA or 1
      c.texture:SetColorTexture(r,g,b,a)               
    else c.smartIcon=true;  
    end     
    c.texture:Hide()                    
               
    c.border=c:CreateTexture(nil,'OVERLAY')
    c.border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
    c.border:SetAllPoints()                     
    c.border:SetTexCoord(.296875, .5703125, 0, .515625)
    if c.para.borderType=="debuffColor" then
        c.updateBorder=eF.rep.updateBorderColorDebuffType
        c.borderColor=eF.para.colors.debuff
      end            
        
    c.cdFrame=CreateFrame("Cooldown",nil,c,"CooldownFrameTemplate")
    if c.para.cdReverse then c.cdFrame:SetReverse(true) end
    c.cdFrame:SetAllPoints()
    c.cdFrame:SetFrameLevel( c:GetFrameLevel())
    
    --text
    c.text=c:CreateFontString()
    local font=c.para.textFont or "Fonts\\FRIZQT__.ttf"
    local size=c.para.textSize or 20
    local xOS=c.para.textXOS or 0
    local yOS=c.para.textYOS or 0
    local r=c.para.textR
    local g=c.para.textG
    local b=c.para.textB
    local a=c.para.textA
    local extra=c.para.textExtra or "OUTLINE"
    c.text:SetFont(font,size,extra)    
    c.text:SetPoint(c.para.textAnchor or "CENTER",c,c.para.textAnchorTo or "CENTER",xOS,yOS)
    c.text:SetTextColor(r,g,b,a)
      
  end --end of if type=="icon"
            
  if self.para[k].type=="bar" then
    if self[k] then self[k]=nil end
    self[k]=CreateFrame("StatusBar",nil,self.unitFrame,"TextStatusBar")
    local c=self[k]
    c.para=self.para[k]

    c:SetFrameLevel(c.para.frameLevel+self:GetFrameLevel())

    c.disable=eF.rep.iconFrameDisable
    c.enable=eF.rep.iconFrameEnable
    c:disable()
    
    -----------LOADING STUFF
    c.checkLoad=eF.rep.checkLoad
    c.loaded=false
    c.onAuraList={}
    c.onPostAuraList={}
    c.onBuffList={}
    c.onDebuffList={}
    c.onUpdateList={}
    c.onPowerList={}

    
    if c.para.loadAlways then c.loadAlways=true 
    else 
      if c.para.loadRole then c.loadRole=true; c.loadRoleList=c.para.loadRoleList end
      if c.para.loadInstance then c.loadInstance=true; c.loadInstanceList = c.para.loadInstanceList end
      if c.para.loadEncounter then c.loadEncounter=true; c.loadEncounter=c.para.loadEncounter end 
      if c.para.loadClass then c.loadClass=true; c.loadClassList=c.para.loadClassList end
    end
               
    if c.para.trackType=="power" then  
      insert(c.onPowerList,{eF.rep.statusBarPowerUpdate,c})    
      c.id=self.id
      c.static=true
    end 
    
    --VISUALS
    
   
    if c.para.grow=="up" or not c.para.grow then 
      c:SetPoint("BOTTOM",frame,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lFix)
      c:SetHeight(c.para.lMax)
      c:SetOrientation("VERTICAL")
    elseif c.para.grow=="down" then 
      c:SetPoint("TOP",frame,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lFix)
      c:SetHeight(c.para.lMax)
      c:SetOrientation("VERTICAL")
    elseif c.para.grow=="right" then 
      c:SetPoint("LEFT",frame,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lMax)
      c:SetHeight(c.para.lFix)
      c:SetOrientation("HORIZONTAL") 
    else
      c:SetPoint("RIGHT",frame,c.para.anchorTo,c.para.xPos,c.para.yPos)
      c:SetWidth(c.para.lMax)
      c:SetHeight(c.para.lFix)
      c:SetOrientation("HORIZONTAL")
    end
    
    c:SetStatusBarTexture(0.1,0.1,0.7,1)  
    c:SetMinMaxValues(0,1)
    
  end--end of if bar
  
  local c=self[k]
  
  do  --loading conditions
  if c.para.loadAlways then c.loadAlways=true 
  else 
    if c.para.loadRole then c.loadRole=true; c.loadRoleList=c.para.loadRoleList end
    if c.para.loadInstance then c.loadInstance=true; c.loadInstanceList = c.para.loadInstanceList end
    if c.para.loadEncounter then c.loadEncounter=true; c.loadEncounter=c.para.loadEncounter end 
    if c.para.loadClass then c.loadClass=true; c.loadClassList=c.para.loadClassList end
  end
  end --end of loading conditons

  --give the OnUdpate function to the frame
  c.onUpdateFunc=eF.rep.frameOnUpdateFunction
  if #c.onUpdateList>0 then
    c:SetScript("OnUpdate",eF.rep.frameOnUpdateFunction)
  end

  c.loaded=true --initially youre always loaded, you get checked afterwards
end
eF.rep.createFamilyChild=createFamilyChild

local function frameOnUpdateFunction(self)
  local lst=self.onUpdateList
  for i=1,#lst do
    lst[i](self)
  end
end
eF.rep.frameOnUpdateFunction=frameOnUpdateFunction






















