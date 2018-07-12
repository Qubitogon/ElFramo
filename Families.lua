local _,eF=...

local function createFamilyFrames()
  local units=eF.units
  local insert=table.insert  
  
  for i=1,45 do
    local frame

    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame.onAuraList={}
    frame.onBuffList={}
    --frame.onDebuffList={}
    frame.onUpdateList={}
    frame.onPowerList={}
    
    eF.units.familyCount=#frame.families
    for j=1,#frame.families do
      frame[j]=CreateFrame("Frame",nil,frame)
      frame[j]:SetSize(1,1)
      frame[j].filled=false
      
      --------------------SMART FAMILIES
      if frame.families[j].smart then
        frame[j].disable=eF.rep.smartFamilyDisableAll
        frame[j].enable=eF.rep.smartFamilyEnableAll
        frame[j].smart=true       
        frame[j].para=frame.families[j]
        frame[j]:SetFrameLevel(frame[j].para.frameLevel+frame:GetFrameLevel()-1)
        frame[j].active=0
        frame[j]:SetPoint(frame.families[j].anchor, frame, frame.families[j].anchorTo,frame.families[j].xPos,frame.families[j].yPos)
        
        ------LOAD STUFF
        frame[j].checkLoad=eF.rep.checkLoad
        frame[j].loaded=false
        frame[j].onAuraList={}
        frame[j].onBuffList={}
        frame[j].onDebuffList={}
        --frame[j].onUpdateList={}
        frame[j].onPowerList={}
        frame[j].onPostAuraList={}
        
        if frame[j].para.loadAlways then frame[j].loadAlways=true 
        else 
          if frame[j].para.loadRole then frame[j].loadRole=true; frame[j].loadRoleList=frame[j].para.loadRoleList end
          if frame[j].para.loadInstance then frame[j].loadInstance=true; frame[j].loadInstanceList = frame[j].para.loadInstanceList end
          if frame[j].para.loadEncounter then frame[j].loadEncounter=true; frame[j].loadEncounterList=frame[j].para.loadEncounterList end 
          if frame[j].para.loadClass then frame[j].loadClass=true; frame[j].loadClassList=frame[j].para.loadClassList end
        end  
               
        if frame[j].para.type=="b" then 
          if frame[j].para.trackType=="Buffs" then insert(frame[j].onBuffList,{eF.rep.blacklistFamilyAdopt,frame[j]})  
          elseif frame[j].para.trackType=="Debuffs" then insert(frame[j].onDebuffList,{eF.rep.blacklistFamilyAdopt,frame[j]}) end
          insert(frame[j].onAuraList,{eF.rep.smartFamilyDisableAll,frame[j]})
        end
        
         if frame[j].para.type=="w" then 
          if frame[j].para.trackType=="Buffs" then insert(frame[j].onBuffList,{eF.rep.whitelistFamilyAdopt,frame[j]})  
          elseif frame[j].para.trackType=="Debuffs" then insert(frame[j].onDebuffList,{eF.rep.whitelistFamilyAdopt,frame[j]}) end
          insert(frame[j].onAuraList,{eF.rep.smartFamilyDisableAll,frame[j]})
        end
        
        
        if frame[j].para.hasBorder and frame[j].para.borderType=="debuffColor" then 
          insert(frame[j].onPostAuraList,{eF.rep.smartFamilyDebuffTypeBorderColor,frame[j]})
        end
        
        if frame[j].para.hasTexture and (not frame[j].para.texture or frame[j].para.smartIcon) then
          insert(frame[j].onPostAuraList,{eF.rep.smartFamilyApplySmartIcons,frame[j]})
        end
        
        if frame[j].para.cdWheel then
          insert(frame[j].onPostAuraList,{eF.rep.smartFamilyUpdateCDWheels,frame[j]})
        end
        
        
        for k=1,frame.families[j].count do
          local xOS=0
          local yOS=0
          if frame[j].para.grow=="down" then yOS=(k-1)*(frame[j].para.spacing+frame[j].para.height)
          elseif frame[j].para.grow=="up" then yOS=(1-k)*(frame[j].para.spacing+frame[j].para.height)
          elseif frame[j].para.grow=="right" then xOS=(k-1)*(frame[j].para.spacing+frame[j].para.width)
          elseif frame[j].para.grow=="right" then xOS=(1-k)*(frame[j].para.spacing+frame[j].para.width) end
          
          frame[j][k]=CreateFrame("Frame",nil,frame[j])
          frame[j][k].para=eF.para.families[j]
          frame[j][k]:SetPoint(frame.families[j].growAnchor,frame[j],frame.families[j].growAnchorTo,xOS,yOS)
          frame[j][k]:SetSize(frame.families[j].width,frame.families[j].height)
          frame[j][k].adopt=eF.rep.iconUnconditionalAdopt        
          frame[j][k].disable=eF.rep.iconFrameDisable
          frame[j][k].enable=eF.rep.iconFrameEnable
          frame[j][k]:disable()
          frame[j][k].onUpdateList={}
          
          ----------------------VISUALS
        
          if frame[j].para.hasTexture then
            frame[j][k].texture=frame[j][k]:CreateTexture()
            frame[j][k].texture:SetDrawLayer("BACKGROUND",-2)
            frame[j][k].texture:SetAllPoints()
            if frame.families[j].texture then frame[j][k].texture:SetTexture(frame.families[j].texture)  --if frame.families[j][k].texture
            else frame[j][k].smartIcon=true; frame[j][k].updateTexture=eF.rep.iconApplySmartIcon end
          end        
          
          if frame[j].para.hasBorder then
            frame[j][k].border=frame[j][k]:CreateTexture(nil,'OVERLAY')
            frame[j][k].border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
            frame[j][k].border:SetAllPoints()                     
            frame[j][k].border:SetTexCoord(.296875, .5703125, 0, .515625)
            if frame[j].para.borderType=="debuffColor" then
              frame[j][k].updateBorder=eF.rep.updateBorderColorDebuffType
              frame[j][k].borderColor=eF.para.colors.debuff
            end
          end
          

          if frame.families[j].cdWheel then
            frame[j][k].cdFrame=CreateFrame("Cooldown",nil,frame[j][k],"CooldownFrameTemplate")
            if frame.families[j].cdReverse then frame[j][k].cdFrame:SetReverse(true) end
            frame[j][k].cdFrame:SetAllPoints()
            frame[j][k].cdFrame:SetFrameLevel( frame[j][k]:GetFrameLevel())
            frame[j][k].updateCDWheel=eF.rep.iconUpdateCDWheel 
          end--end of if .cdwheel
          
          --text
          if frame.families[j].hasText then
            frame[j][k].text=frame[j][k]:CreateFontString()
            local font=frame.families[j].textFont or "Fonts\\FRIZQT__.ttf"
            local size=frame.families[j].textSize or 20
            local xOS=frame.families[j].textXOS or 0
            local yOS=frame.families[j].textYOS or 0
            local r=frame.families[j].textR
            local g=frame.families[j].textG
            local b=frame.families[j].textB
            local a=frame.families[j].textA
            local extra=frame.families[j].textExtra or "OUTLINE"
            local iDA=frame[j][k].para.textIgnoreDurationAbove
            frame[j][k].text:SetFont(font,size,extra)    
            frame[j][k].text:SetPoint(frame.families[j].textAnchor,frame[j][k],frame.families[j].textAnchorTo,xOS,yOS)
            frame[j][k].text:SetTextColor(r,g,b,a)
            if iDA then frame[j][k].textIgnoreDurationAbove=iDA end
            
            if frame[j][k].para.textType=="t" then insert(frame[j][k].onUpdateList,eF.rep.iconUpdateTextTypeT) end 
          end--end of if frame.hasText
                    
                
        --give the OnUpdate function to the frame
        frame[j][k].onUpdateFunc=eF.rep.frameOnUpdateFunction
        frame[j][k]:SetScript("OnUpdate",eF.rep.frameOnUpdateFunction)
        
        end --end for k=1,frame.families.count
       
  
        
              
      else --------------------------------else of if smart 
      
        frame[j].para=frame.families[j]
        frame[j]:SetPoint("CENTER")
        
        for k=1,frame.families[j].count do
 
          if frame.families[j][k].type=="icon" then
                    
            frame[j][k]=CreateFrame("Frame",nil,frame[j])
            frame[j][k].para=frame.families[j][k]
            frame[j][k]:SetPoint(frame.families[j][k].anchor,frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
            frame[j][k]:SetSize(frame.families[j][k].width,frame.families[j][k].height)
            frame[j][k]:SetFrameLevel(frame[j][k].para.frameLevel+frame:GetFrameLevel())

           
            frame[j][k].disable=eF.rep.iconFrameDisable
            frame[j][k].enable=eF.rep.iconFrameEnable
            frame[j][k]:disable()
            
            -----------LOADING STUFF
            frame[j][k].checkLoad=eF.rep.checkLoad
            frame[j][k].loaded=false
            frame[j][k].onAuraList={}
            frame[j][k].onPostAuraList={}
            frame[j][k].onBuffList={}
            frame[j][k].onDebuffList={}
            frame[j][k].onUpdateList={}
            frame[j][k].onPowerList={}
            
            
            if frame.families[j][k].trackType=="name" then  
              insert(frame[j][k].onAuraList,{eF.rep.iconFrameDisable,frame[j][k]})
              if frame[j][k].para.trackGroup=="Buffs" then insert(frame[j][k].onBuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]})
              elseif frame[j][k].para.trackGroup=="Debuffs" then insert(frame[j][k].onDebuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]}) end           
            elseif frame[j][k].para.trackGroup=="static" then            
               frame[j][k].static=true
            end
            
            
            if frame.families[j][k].trackType=="Buffs" then
              insert(frame[j][k].onAuraList,{eF.rep.iconFrameDisable,frame[j][k]})
              if frame.families[j][k].trackBy=="Name" then      
                insert(frame[j][k].onBuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]})
              end
            end
            
            if frame.families[j][k].trackType=="Debuffs" then
              insert(frame[j][k].onAuraList,{eF.rep.iconFrameDisable,frame[j][k]})
              if frame.families[j][k].trackBy=="Name" then      
                insert(frame[j][k].onDebuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]})
              end
            end
                                                         
            if frame[j][k].para.hasText and frame[j][k].para.textType=="t" then
              insert(frame[j][k].onUpdateList,eF.rep.iconUpdateTextTypeT)
            end
            
            if frame[j][k].para.hasTexture and (not frame[j][k].para.texture or frame[j][k].para.smartIcon) and not frame[j][k].para.hasColorTexture then
              insert(frame[j][k].onPostAuraList,{eF.rep.iconApplySmartIcon,frame[j][k]})
            end

            if frame[j][k].para.hasBorder and frame[j][k].para.borderType=="debuffColor" then 
              insert(frame[j][k].onPostAuraList,{eF.rep.updateBorderColorDebuffType,frame[j][k]})
            end
            
            if frame[j][k].para.cdWheel then
              insert(frame[j][k].onPostAuraList,{eF.rep.iconUpdateCDWheel,frame[j][k]})
            end
            
            
            -------------VISUAL STUFF
            if frame[j][k].para.hasTexture then 
              frame[j][k].texture=frame[j][k]:CreateTexture()
              frame[j][k].texture:SetDrawLayer("BACKGROUND",-2)
              frame[j][k].texture:SetAllPoints()
              
              if frame.families[j][k].texture then frame[j][k].texture:SetTexture(frame.families[j][k].texture)  --if frame.families[j][k].texture
              elseif frame[j][k].para.hasColorTexture then 
                local r=frame[j][k].para.textureR or 0
                local g=frame[j][k].para.textureG or 0
                local b=frame[j][k].para.textureB or 0
                local a=frame[j][k].para.textureA or 1
                frame[j][k].texture:SetColorTexture(r,g,b,a)               
                else frame[j][k].smartIcon=true;  
              end
                            
            end
                   
            if frame[j][k].para.hasBorder then
              frame[j][k].border=frame[j][k]:CreateTexture(nil,'OVERLAY')
              frame[j][k].border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
              frame[j][k].border:SetAllPoints()                     
              frame[j][k].border:SetTexCoord(.296875, .5703125, 0, .515625)
              if frame[j][k].para.borderType=="debuffColor" then
                frame[j][k].updateBorder=eF.rep.updateBorderColorDebuffType
                frame[j][k].borderColor=eF.para.colors.debuff
              end            
            end
            
            if frame.families[j][k].cdWheel then
              frame[j][k].cdFrame=CreateFrame("Cooldown",nil,frame[j][k],"CooldownFrameTemplate")
              if frame.families[j][k].cdReverse then frame[j][k].cdFrame:SetReverse(true) end
              frame[j][k].cdFrame:SetAllPoints()
              frame[j][k].cdFrame:SetFrameLevel( frame[j][k]:GetFrameLevel())
            end--end of if .cdwheel
            
            --text
            if frame.families[j][k].hasText then
              frame[j][k].text=frame[j][k]:CreateFontString()
              local font=frame.families[j][k].textFont or "Fonts\\FRIZQT__.ttf"
              local size=frame.families[j][k].textSize or 20
              local xOS=frame.families[j][k].textXOS or 0
              local yOS=frame.families[j][k].textYOS or 0
              local r=frame.families[j][k].textR
              local g=frame.families[j][k].textG
              local b=frame.families[j][k].textB
              local a=frame.families[j][k].textA
              local extra=frame.families[j][k].textExtra or "OUTLINE"
              frame[j][k].text:SetFont(font,size,extra)    
              frame[j][k].text:SetPoint(frame.families[j][k].textAnchor,frame[j][k],frame.families[j][k].textAnchorTo,xOS,yOS)
              frame[j][k].text:SetTextColor(r,g,b,a)
            end--end of if frame.hasText
          end --end of if type=="icon"         
          
          if frame.families[j][k].type=="bar" then
          
            frame[j][k]=CreateFrame("StatusBar",nil,frame[j],"TextStatusBar")
            frame[j][k].para=frame.families[j][k]
            frame[j][k]:SetFrameLevel(frame[j][k].para.frameLevel+frame:GetFrameLevel())

            frame[j][k].disable=eF.rep.iconFrameDisable
            frame[j][k].enable=eF.rep.iconFrameEnable
            frame[j][k]:disable()
            
            -----------LOADING STUFF
            frame[j][k].checkLoad=eF.rep.checkLoad
            frame[j][k].loaded=false
            frame[j][k].onAuraList={}
            frame[j][k].onBuffList={}
            frame[j][k].onDebuffList={}
            frame[j][k].onUpdateList={}
            frame[j][k].onPowerList={}
            frame[j][k].onPostAuraList={}
            
            if frame[j][k].para.loadAlways then frame[j][k].loadAlways=true 
            else 
              if frame[j][k].para.loadRole then frame[j][k].loadRole=true; frame[j][k].loadRoleList=frame[j][k].para.loadRoleList end
              if frame[j][k].para.loadInstance then frame[j][k].loadInstance=true; frame[j][k].loadInstanceList = frame[j][k].para.loadInstanceList end
              if frame[j][k].para.loadEncounter then frame[j][k].loadEncounter=true; frame[j][k].loadEncounter=frame[j][k].para.loadEncounter end 
              if frame[j][k].para.loadClass then frame[j][k].loadClass=true; frame[j][k].loadClassList=frame[j][k].para.loadClassList end
            end
                       
            if frame.families[j][k].trackType=="power" then  
              insert(frame[j][k].onPowerList,{eF.rep.statusBarPowerUpdate,frame[j][k]})    
              frame[j][k].id=frame.id
              frame[j][k].static=true
            end 
            
            --VISUALS
            
           
            if frame[j][k].para.grow=="up" or not frame[j][k].para.grow then 
              frame[j][k]:SetPoint("BOTTOM",frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
              frame[j][k]:SetWidth(frame[j][k].para.lFix)
              frame[j][k]:SetHeight(frame[j][k].para.lMax)
              frame[j][k]:SetOrientation("VERTICAL")
            elseif frame[j][k].para.grow=="down" then 
              frame[j][k]:SetPoint("TOP",frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
              frame[j][k]:SetWidth(frame[j][k].para.lFix)
              frame[j][k]:SetHeight(frame[j][k].para.lMax)
              frame[j][k]:SetOrientation("VERTICAL")
            elseif frame[j][k].para.grow=="right" then 
              frame[j][k]:SetPoint("LEFT",frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
              frame[j][k]:SetWidth(frame[j][k].para.lMax)
              frame[j][k]:SetHeight(frame[j][k].para.lFix)
              frame[j][k]:SetOrientation("HORIZONTAL") 
            else
              frame[j][k]:SetPoint("RIGHT",frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
              frame[j][k]:SetWidth(frame[j][k].para.lMax)
              frame[j][k]:SetHeight(frame[j][k].para.lFix)
              frame[j][k]:SetOrientation("HORIZONTAL")
            end
            
            frame[j][k]:SetStatusBarTexture(0.1,0.1,0.7,1)  
            frame[j][k]:SetMinMaxValues(0,1)
            
          end--end of if bar
          
          
          do  --loading conditions
          if frame[j][k].para.loadAlways then frame[j][k].loadAlways=true 
          else 
            if frame[j][k].para.loadRole then frame[j][k].loadRole=true; frame[j][k].loadRoleList=frame[j][k].para.loadRoleList end
            if frame[j][k].para.loadInstance then frame[j][k].loadInstance=true; frame[j][k].loadInstanceList = frame[j][k].para.loadInstanceList end
            if frame[j][k].para.loadEncounter then frame[j][k].loadEncounter=true; frame[j][k].loadEncounter=frame[j][k].para.loadEncounter end 
            if frame[j][k].para.loadClass then frame[j][k].loadClass=true; frame[j][k].loadClassList=frame[j][k].para.loadClassList end
          end
          
          end--end of do
          
          
          --give the OnUpdate function to the frame
          frame[j][k].onUpdateFunc=eF.rep.frameOnUpdateFunction
          if #frame[j][k].onUpdateList>0 then
            frame[j][k]:SetScript("OnUpdate",eF.rep.frameOnUpdateFunction)
          end
          
        end --end for k=1,frame.families.count
      end--end of if frame.families[j].smart else
      
    end --end of for j=1,#frame.families
    
    
    
  end--end of for i=1,40
  
end --end of createFamilyFrames()
eF.rep.createFamilyFrames=createFamilyFrames

local function iconAdoptAuraByName(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)

  if self.filled then return  end
  if name==self.para.arg1 then
    self.name=name
    self.icon=icon
    self.count=count
    self.debuffType=debuffType
    self.duration=duration
    self.expirationTime=expirationTime
    self.own=own
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

local function iconUnconditionalAdopt(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)

  if self.filled then return  end
    self.name=name
    self.icon=icon
    self.count=count
    self.debuffType=debuffType
 
    self.duration=duration
    self.expirationTime=expirationTime
    self.own=own
    self.unitCaster=unitCaster
    self.canSteal=canSteal
    self.spellId=spellId
    self.isBoss=isBoss
    self.filled=true
    self:enable()
  return true
  
end
eF.rep.iconUnconditionalAdopt=iconUnconditionalAdopt

local function blacklistFamilyAdopt(self,name,...)
  if self.full or eF.isInList(name,self.para.arg1) then return end
  local dur=select(4,...)
  if self.para.ignorePermanents and dur==0 then return end
  local own=select(10,...)
  if self.para.ownOnly and not oO then return end
  local iDA=self.para.ignoreDurationAbove
  if iDA then if dur>iDA then return end end 
  
  self.active=self.active+1
  self.filled=true
  self[self.active]:adopt(name,...)
  if self.active==self.para.count then self.full=true end
  
end
eF.rep.blacklistFamilyAdopt=blacklistFamilyAdopt

local function whitelistFamilyAdopt(self,name,...)

  if self.full or not eF.isInList(name,self.para.arg1) then return end
  local dur=select(4,...)
  if self.para.ignorePermanents and dur==0 then return end
  local own=select(10,...)
  if self.para.ownOnly and not oO then return end
  local iDA=self.para.ignoreDurationAbove
  if iDA then if dur>iDA then return end end 
  
  self.active=self.active+1
  self.filled=true
  self[self.active]:adopt(name,...)
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

local function checkLoad(self,role,enc,ins,class)
  if self.loadAlways then 
    if not self.loaded then 
      self.loaded=true; 
      if self.static then self:enable() end
    end
    return true 
  end 
  
  local inList=eF.isInList
  local b=true
  if self.loadRole and not inList(role,self.loadRoleList) then b=false
  elseif self.loadEncounter and not inList(enc,self.loadEncounterList) then b=false 
  elseif self.loadInstance and not inList(ins,self.loadInstanceList) then b=false
  elseif self.loadClass and not inList(class,self.loadClassList) then b=false
  end
  
  if not b and self.loaded then self.loaded=false; self:disable() end
  if b and not self.loaded then 
    if self.static then self:enable() end
    self.loaded=true
  end
  
  return b
end
eF.rep.checkLoad=checkLoad

local function frameOnUpdateFunction(self)
  local lst=self.onUpdateList
  for i=1,#lst do
    lst[i](self)
  end
end
eF.rep.frameOnUpdateFunction=frameOnUpdateFunction
--createFamilyFrames()







