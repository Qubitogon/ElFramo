_,eF=...

eF.para.families={[1]={displayName="void",
                       smart=false,
                       count=2,
                       [1]={displayName="ReM",
                            type="name",
                            buff=true,
                            arg1="Renewing Mist",
                            xPos=-2,
                            yPos=0,
                            height=15,
                            width=15,
                            anchor="TOPRIGHT",
                            anchorTo="TOPRIGHT",
                            cdWheel=false,
                            cdReverse=true,
                            texture=627487,
                            hasText=true,
                            hasTexture=false,
                            textType="t",
                            textAnchor="CENTER",
                            textAnchorTo="CENTER",
                            textXOS=0,
                            textYOS=0,
                            textFont="Fonts\\FRIZQT__.ttf",
                            textExtra="OUTLINE",
                            textSize=14,
                            textR=0.85,
                            textG=0.85,
                            textB=0.85,
                            textA=1,
                            textDecimals=0,
                            ownOnly=false,
                            }, --end of [1][1]
                       [2]={displayName="SooM",
                            type="name",
                            buff=true,
                            arg1="Soothing Mist",
                            xPos=0,
                            yPos=0,
                            height=20,
                            width=20,
                            anchor="TOPLEFT",
                            anchorTo="TOPLEFT",
                            cdWheel=true,
                            cdReverse=true,
                            texture=606550,
                            hasText=true,
                            hasTexture=true,
                            textType="t",
                            textAnchor="CENTER",
                            textAnchorTo="CENTER",
                            textXOS=0,
                            textYOS=0,
                            textFont="Fonts\\FRIZQT__.ttf",
                            textExtra="OUTLINE",
                            textSize=14,
                            textR=0.85,
                            textG=0.85,
                            textB=0.85,
                            textA=1,
                            textDecimals=0,
                            ownOnly=false,
                            },                             
                      }, --end of ...families[1]
                      
                  [2]={displayName="blacktest",
                       smart=true,
                       count=3,
                       type="b",
                       xPos=0,
                       yPos=0,
                       spacing=1,
                       height=15,
                       width=15,
                       anchor="BOTTOMLEFT",
                       anchorTo="BOTTOMLEFT",
                       buff=true,
                       arg1={"Soothing Mist","Renewing Mist"},
                       smartIcons=true,
                       grow="right",
                       growAnchor="BOTTOMLEFT",
                       growAnchorTo="BOTTOMLEFT",
                       cdReverse=true,
                       cdWheel=true,
                       hasText=true,
                       hasTexture=true,
                       ignorePermanents=true,
                       ignoreDurationAbove=20,
                       textType="t",
                       textAnchor="CENTER",
                       textAnchorTo="CENTER",
                       textXOS=0,
                       textYOS=0,
                       textSize=12,
                       textR=0.85,
                       textG=0.85,
                       textB=0.85,
                       textA=1,
                       textDecimals=0,
                       ownOnly=false,
                       },   --end of families[2]  
                  }--end of all
                 
for i=1,40 do
  local frame=eF.units[eF.raidLoop[i]]
  frame.families=eF.para.families
end--end of i
                 
for i=1,5 do
  local frame=eF.units[eF.partyLoop[i]]
  frame.families=eF.para.families
end--end of i

local function createFamilyFrames()
  local units=eF.units
  
  
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame.disableFamilies=eF.rep.unitDisableFamilies
    frame.allAdopt=eF.rep.unitAllAdopt    
    eF.units.familyCount=#frame.families
    for j=1,#frame.families do
      frame[j]=CreateFrame("Frame",nil,frame)
      frame[j]:SetSize(1,1)
      frame[j].filled=false
      
      if frame.families[j].smart then
        frame[j].smart=true       
        frame[j].para=frame.families[j]
        frame[j].active=0
        frame[j]:SetPoint(frame.families[j].anchor, frame, frame.families[j].anchorTo,frame.families[j].xPos,frame.families[j].yPos)
        
        if frame[j].para.type=="b" then frame[j].adopt=eF.rep.blacklistFamilyAdopt end
        
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
        
          if frame[j].para.hasTexture then
            frame[j][k].texture=frame[j][k]:CreateTexture()
            frame[j][k].texture:SetDrawLayer("BACKGROUND",-2)
            frame[j][k].texture:SetAllPoints()
            if frame.families[j].texture then frame[j][k].texture:SetTexture(frame.families[j].texture)  --if frame.families[j][k].texture
            else frame[j][k].smartIcon=true end
          end
          
          frame[j][k].adopt=eF.rep.iconUnconditionalAdopt        
          frame[j][k].disable=eF.rep.iconFrameDisable
          frame[j][k].enable=eF.rep.iconFrameEnable
          frame[j][k]:disable()
          
          if frame.families[j].cdWheel then
            frame[j][k].cdFrame=CreateFrame("Cooldown",nil,frame[j][k],"CooldownFrameTemplate")
            if frame.families[j].cdReverse then frame[j][k].cdFrame:SetReverse(true) end
            frame[j][k].cdFrame:SetAllPoints()
            frame[j][k].cdFrame:SetFrameLevel( frame[j][k]:GetFrameLevel())
          end--end of if .cdwheel
          
          --text
          if frame.families[j].hasText then
            if not frame[j].onUpdate then frame[j].onUpdate=eF.rep.smartFamilyOnUpdateFunction end
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
            frame[j][k].text:SetFont(font,size,extra)    
            frame[j][k].text:SetPoint(frame.families[j].textAnchor,frame[j][k],frame.families[j].textAnchorTo,xOS,yOS)
            frame[j][k].text:SetTextColor(r,g,b,a)
            frame[j][k].onUpdate=eF.rep.iconOnUpdateFunction
            frame[j][k].textOnUpdate=eF.rep.iconTextOnUpdate
          end--end of if frame.hasText
          
        end --end for k=1,frame.families.count
       
              
      else --else of if smart 
      
        frame[j].para=frame.families[j]
        frame[j]:SetPoint("CENTER")
        
        for k=1,frame.families[j].count do
          frame[j][k]=CreateFrame("Frame",nil,frame[j])
          frame[j][k].para=eF.para.families[j][k]
          frame[j][k]:SetPoint(frame.families[j][k].anchor,frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
          frame[j][k]:SetSize(frame.families[j][k].width,frame.families[j][k].height)
          
          if frame[j][k].para.hasTexture then 
            frame[j][k].texture=frame[j][k]:CreateTexture()
            frame[j][k].texture:SetDrawLayer("BACKGROUND",-2)
            frame[j][k].texture:SetAllPoints()
            if frame.families[j][k].texture then frame[j][k].texture:SetTexture(frame.families[j][k].texture)  --if frame.families[j][k].texture
            else frame[j][k].smartIcon=true end
          end
          
          if frame.families[j][k].type=="name" then frame[j][k].adopt=eF.rep.iconAdoptAuraByName end 
          frame[j][k].para=eF.para.families[j][k]
          frame[j][k].disable=eF.rep.iconFrameDisable
          frame[j][k].enable=eF.rep.iconFrameEnable
          frame[j][k]:disable()
          
          if frame.families[j][k].cdWheel then
            frame[j][k].cdFrame=CreateFrame("Cooldown",nil,frame[j][k],"CooldownFrameTemplate")
            if frame.families[j][k].cdReverse then frame[j][k].cdFrame:SetReverse(true) end
            frame[j][k].cdFrame:SetAllPoints()
            frame[j][k].cdFrame:SetFrameLevel( frame[j][k]:GetFrameLevel())
          end--end of if .cdwheel
          
          --text
          if frame.families[j][k].hasText then
            if not frame[j].onUpdate then frame[j].onUpdate=eF.rep.dumbFamilyOnUpdateFunction end
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
            frame[j][k].onUpdate=eF.rep.iconOnUpdateFunction
            frame[j][k].textOnUpdate=eF.rep.iconTextOnUpdate
          end--end of if frame.hasText
          
        end --end for k=1,frame.families.count
      end--end of if frame.families[j].smart else
    end --end of for j=1,#frame.families
  end--end of for i=1,40
end


local function iconTextOnUpdate(self)
  local t=GetTime()
  local s
  if self.para.textType=="t" then 
    s=self.expirationTime-t
  end--end of if textType=="t"
  
  local dec=self.para.textDecimals or 1
  s=eF.toDecimal(s,dec)
  self.text:SetText(s)
end
eF.rep.iconTextOnUpdate=iconTextOnUpdate

local function iconAdoptAuraByName(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)

  if self.filled then return  end
  
  if name==self.para.arg1 then 
    self.name=name
    self.icon=icon
    if self.smartIcon then self.texture:SetTexture(icon) end
    if self.cdFrame then self.cdFrame:SetCooldown(expirationTime-duration,duration) end
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
    if self.smartIcon then self.texture:SetTexture(icon) end
    if self.cdFrame then self.cdFrame:SetCooldown(expirationTime-duration,duration) end
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

local function unitAllAdopt(self,...)
  local fam=self.families
  for j=1,#fam do
      if fam[j].smart then if self[j]:adopt(...) then self[j].filled=true end
        
      else
        for k=1,fam[j].count do
          if self[j][k]:adopt(...) then self[j].filled=true end 
        end --end for k=1,frame.families.count
        
      end--end of if frame.families[j].smart else
    end --end of for j=1,#frame.families 
end
eF.rep.unitAllAdopt=unitAllAdopt

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

local function unitDisableFamilies(self)

  for j=1,#self.families do
      self[j].filled=false
      if self[j].smart then
        self[j].active=0
        self[j].full=false
        
        for k=1,self.families[j].count do
          self[j][k]:disable()
        end --end for k=1,frame.families.count
        
      else
        
        for k=1,self.families[j].count do
          self[j][k]:disable()
        end --end for k=1,frame.families.count
        
      end--end of if frame.families[j].smart else
    end --end of for j=1,#frame.families
end
eF.rep.unitDisableFamilies=unitDisableFamilies

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

local function dumbFamilyOnUpdateFunction(self)

  for i=1,self.para.count do
    if self[i].onUpdate then self[i]:onUpdate() end
  end
  
end --end of familyUpdateFunction
eF.rep.dumbFamilyOnUpdateFunction=dumbFamilyOnUpdateFunction

local function smartFamilyOnUpdateFunction(self)

  for i=1,self.active do
    if self[i].onUpdate then self[i]:onUpdate() end
  end
  
end --end of familyUpdateFunction
eF.rep.smartFamilyOnUpdateFunction=smartFamilyOnUpdateFunction


local function iconOnUpdateFunction(self)

  if not self.filled then return end
  if self.text then 
    if self.para.textType=="t" then self:textOnUpdate() end
  end -- end of if self.text 
  
end
eF.rep.iconOnUpdateFunction=iconOnUpdateFunction

createFamilyFrames()

