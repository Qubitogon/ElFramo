_,eF=...

eF.para.families={[1]={displayName="void",
                       smart=false,
                       count=2,
                       [1]={displayName="ReM",
                            type="name",
                            buff=true,
                            arg1="Renewing Mist",
                            xPos=0,
                            yPos=0,
                            height=30,
                            width=30,
                            anchor="CENTER",
                            anchorTo="CENTER",
                            cdWheel=true,
                            cdReverse=true,
                            hasTexture=true,
                            texture=627487,
                            hasText=true,
                            textType="t",
                            textAnchor="CENTER",
                            textAnchorTo="CENTER",
                            textXOS=0,
                            textYOS=0,
                            textFont="Fonts\\FRIZQT__.ttf",
                            textExtra="OUTLINE",
                            textSize=20,
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
                            xPos=32,
                            yPos=0,
                            height=30,
                            width=30,
                            anchor="CENTER",
                            anchorTo="CENTER",
                            cdWheel=true,
                            cdReverse=true,
                            hasTexture=true,
                            texture=606550,
                            hasText=true,
                            textType="t",
                            textAnchor="CENTER",
                            textAnchorTo="CENTER",
                            textXOS=0,
                            textYOS=0,
                            textFont="Fonts\\FRIZQT__.ttf",
                            textExtra="OUTLINE",
                            textSize=20,
                            textR=0.85,
                            textG=0.85,
                            textB=0.85,
                            textA=1,
                            textDecimals=0,
                            ownOnly=false,
                            },                            
                       
                       
                      }, --end of ...families[1]

                 }--end of eF.para.families
                 
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
      frame[j]:SetPoint("CENTER")
      frame[j]:SetSize(1,1)
      
      if frame.families[j].smart then
        frame[j].smart=true
        --add their check function here
      else
        frame[j].para=frame.families[j]
        for k=1,frame.families[j].count do
          frame[j][k]=CreateFrame("Frame",nil,frame[j])
          frame[j][k].para=eF.para.families[j][k]
          frame[j][k]:SetPoint(frame.families[j][k].anchor,frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
          frame[j][k]:SetSize(frame.families[j][k].width,frame.families[j][k].height)
        
          
          frame[j][k].texture=frame[j][k]:CreateTexture()
          frame[j][k].texture:SetDrawLayer("BACKGROUND",-2)
          frame[j][k].texture:SetAllPoints()
          if frame.families[j][k].texture then frame[j][k].texture:SetTexture(frame.families[j][k].texture) end --if frame.families[j][k].texture
          
          
          if frame.families[j][k].type=="name" then frame[j][k].adopt=eF.rep.iconCheckAuraByName end       
          frame[j][k].para=eF.para.families[j][k]
          frame[j][k].adopt=eF.rep.iconAdoptAuraByName
          frame[j][k].disable=eF.rep.iconFrameDisable
          frame[j][k].enable=eF.rep.iconFrameEnable
          frame[j][k]:disable()
          
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
  local s=''
  if self.para.textType=="t" then 
    s=self.expirationTime-t
  end--end of if textType=="t"
  
  local dec=self.para.textDecimals or 1
  s=eF.toDecimal(s,dec)
  self.text:SetText(s)
end
eF.rep.iconTextOnUpdate=iconTextOnUpdate

local function iconAdoptAuraByName(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss)

  if self.filled then return  end
  
  if name==self.para.arg1 then 
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
  end
  
end
eF.rep.iconAdoptAuraByName=iconAdoptAuraByName

local function unitAllAdopt(self,...)

  for j=1,#self.families do
      
      if self[j].smart then

      else
        
        for k=1,self.families[j].count do
          self[j][k]:adopt(...)
      
        end --end for k=1,frame.families.count
      end--end of if frame.families[j].smart else
    end --end of for j=1,#frame.families 
end
eF.rep.unitAllAdopt=unitAllAdopt


local function unitDisableFamilies(self)

  for j=1,#self.families do
      
      if self[j].smart then
        
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

local function iconOnUpdateFunction(self)
  if not self.filled then return end
  
  if self.text then 
    if self.para.textType=="t" then self:textOnUpdate() end
    
  
  end -- end of if self.text 
end
eF.rep.iconOnUpdateFunction=iconOnUpdateFunction

createFamilyFrames()

