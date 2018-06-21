_,eF=...

eF.para.families={[1]={displayName="void",
                       smart=false,
                       count=3,
                       [1]={displayName="ReM",
                            type="icon",
                            trackType="name",
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
                            loadAlways=true,
                            }, --end of [1][1]
                       [2]={displayName="SooM",
                            type="icon",
                            trackType="name",
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
                            hasText=false,
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
                            loadAlways=true,
                            },    
                       [3]={displayName="RoleSquare",
                            type="icon",
                            trackType="static",
                            --roleIgnore="",      TBA CAN BE DONE WITH ALPHA=0 TBH                
                            xPos=0,
                            yPos=0,
                            height=5,
                            width=5,
                            anchor="TOPLEFT",
                            anchorTo="TOPLEFT",
                            hasTexture=true,
                            hasColorTexture=true,
                            loadRole=true,
                            loadRoleList={"HEALER"},
                            textureColor={0.1,0.5,0.1,1},
                            loadAlways=false,                     
                            },
                       [4]={displayName="PowerBar",
                            type="bar",
                            trackType="power",
                            --roleIgnore="",      TBA CAN BE DONE WITH ALPHA=0 TBH                
                            xPos=0,
                            yPos=0,
                            lFix=5,
                            lMax=50,
                            grow="up",
                            anchor="BOTTOMLEFT",
                            anchorTo="BOTTOMLEFT",
                            loadAlways=true,                            
                            },                      
                         }, --end of ...families[1] 
                  [2]={displayName="blacktest",
                       smart=true,
                       count=3,
                       type="b",
                       xPos=0,
                       yPos=0,
                       spacing=1,
                       height=20,
                       width=20,
                       anchor="BOTTOMLEFT",
                       anchorTo="BOTTOMLEFT",
                       buff=false,
                       arg1={"Soothing Mist","Renewing Mist","Enveloping Mist","Essence Font"},
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
                       textSize=15,
                       textR=0.85,
                       textG=0.85,
                       textB=0.85,
                       textA=1,
                       textDecimals=0,
                       ownOnly=false,
                       loadAlways=true,
                       },   --end of families[2]  
                  [3]={displayName="white",
                       smart=true,
                       count=3,
                       type="w",
                       arg1={"Essence Font","Enveloping Mist"},
                       xPos=0,
                       yPos=0,
                       spacing=1,
                       height=20,
                       width=20,
                       anchor="LEFT",
                       anchorTo="LEFT",
                       buff=true,
                       hasBorder=false,
                       smartIcons=true,
                       grow="right",
                       growAnchor="LEFT",
                       growAnchorTo="LEFT",
                       cdReverse=true,
                       cdWheel=true,
                       hasText=true,
                       hasTexture=true,
                       ignorePermanents=true,
                       ignoreDurationAbove=nil,
                       textType="t",
                       textAnchor="CENTER",
                       textAnchorTo="CENTER",
                       textIgnoreDurationAbove=99,
                       textXOS=0,
                       textYOS=0,
                       textSize=15,
                       textR=0.85,
                       textG=0.85,
                       textB=0.85,
                       textA=1,
                       textDecimals=0,
                       ownOnly=false,
                       loadAlways=true,
                       },   --end of families[2]  ]]
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
  local insert=table.insert  
  
  for i=1,45 do
    local frame

    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame.onAuraList={}
    frame.onBuffList={}
    frame.onDebuffList={}
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
        frame[j].smart=true       
        frame[j].para=frame.families[j]
        frame[j].active=0
        frame[j]:SetPoint(frame.families[j].anchor, frame, frame.families[j].anchorTo,frame.families[j].xPos,frame.families[j].yPos)
        
        ------LOAD STUFF
        frame[j].checkLoad=eF.rep.checkLoad
        frame[j].loaded=false
        frame[j].onAuraList={}
        frame[j].onBuffList={}
        frame[j].onDebuffList={}
        frame[j].onUpdateList={}
        frame[j].onPowerList={}
        
        if frame[j].para.loadAlways then frame[j].loadAlways=true 
        else 
          if frame[j].para.loadRole then frame[j].loadRole=true; frame[j].loadRoleList=frame[j].para.loadRoleList end
          if frame[j].para.loadInstance then frame[j].loadInstance=true; frame[j].loadInstanceList = frame[j].para.loadInstanceList end
          if frame[j].para.loadEncounter then frame[j].loadEncounter=true; frame[j].loadEncounter=frame[j].para.loadEncounter end 
        end  
        
        
        if frame[j].para.type=="b" then 
          if frame[j].para.buff then insert(frame[j].onBuffList,{eF.rep.blacklistFamilyAdopt,frame[j]})  
          else insert(frame[j].onDebuffList,{eF.rep.blacklistFamilyAdopt,frame[j]}) end
          insert(frame[j].onAuraList,{eF.rep.smartFamilyDisableAll,frame[j]})
        end
        
         if frame[j].para.type=="w" then 
          if frame[j].para.buff then insert(frame[j].onBuffList,{eF.rep.whitelistFamilyAdopt,frame[j]})  
          else insert(frame[j].onDebuffList,{eF.rep.whitelistFamilyAdopt,frame[j]}) end
          insert(frame[j].onAuraList,{eF.rep.smartFamilyDisableAll,frame[j]})
        end
        
        if frame[j].para.hasText then 
          insert(frame[j].onUpdateList,{eF.rep.smartFamilyUpdateTexts,frame[j]})
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
          
        --iconUpdateTextTypeT
          ----------------------VISUALS
        
          if frame[j].para.hasTexture then
            frame[j][k].texture=frame[j][k]:CreateTexture()
            frame[j][k].texture:SetDrawLayer("BACKGROUND",-2)
            frame[j][k].texture:SetAllPoints()
            if frame.families[j].texture then frame[j][k].texture:SetTexture(frame.families[j].texture)  --if frame.families[j][k].texture
            else frame[j][k].smartIcon=true end
          end
          
          if frame[j].para.hasBorder then
            frame[j][k].border=frame[j][k]:CreateTexture(nil,'OVERLAY')
            frame[j][k].border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
            frame[j][k].border:SetAllPoints()                     
            frame[j][k].border:SetTexCoord(.296875, .5703125, 0, .515625)
            frame[j][k].borderColor=eF.para.colors.debuff
          end
          

          if frame.families[j].cdWheel then
            frame[j][k].cdFrame=CreateFrame("Cooldown",nil,frame[j][k],"CooldownFrameTemplate")
            if frame.families[j].cdReverse then frame[j][k].cdFrame:SetReverse(true) end
            frame[j][k].cdFrame:SetAllPoints()
            frame[j][k].cdFrame:SetFrameLevel( frame[j][k]:GetFrameLevel())
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
            if frame[j][k].para.textType=="t" then frame[j][k].updateText= eF.rep.iconUpdateTextTypeT end 
          end--end of if frame.hasText
          
          --LOAD CONDITIONS??
          
          
        end --end for k=1,frame.families.count
       
              
      else --else of if smart 
      
        frame[j].para=frame.families[j]
        frame[j]:SetPoint("CENTER")
        
        for k=1,frame.families[j].count do
 
          if frame.families[j][k].type=="icon" then
                    
            frame[j][k]=CreateFrame("Frame",nil,frame[j])
            frame[j][k].para=frame.families[j][k]
            frame[j][k]:SetPoint(frame.families[j][k].anchor,frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
            frame[j][k]:SetSize(frame.families[j][k].width,frame.families[j][k].height)
           
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
            if frame[j][k].para.loadAlways then frame[j][k].loadAlways=true 
            else 
              if frame[j][k].para.loadRole then frame[j][k].loadRole=true; frame[j][k].loadRoleList=frame[j][k].para.loadRoleList end
              if frame[j][k].para.loadInstance then frame[j][k].loadInstance=true; frame[j][k].loadInstanceList = frame[j][k].para.loadInstanceList end
              if frame[j][k].para.loadEncounter then frame[j][k].loadEncounter=true; frame[j][k].loadEncounter=frame[j][k].para.loadEncounter end 
            end
            
            if frame.families[j][k].trackType=="name" then  
              insert(frame[j][k].onAuraList,{eF.rep.iconFrameDisable,frame[j][k]})
              if frame[j][k].para.buff then insert(frame[j][k].onBuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]})
              else insert(frame[j][k].onDebuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]}) end           
            end 
            
            if frame[j][k].para.hasText and frame[j][k].para.textType=="t" then
              insert(frame[j][k].onUpdateList,{eF.rep.iconUpdateTextTypeT,frame[j][k]})
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
              else frame[j][k].smartIcon=true 
              end
                            
              if frame[j][k].para.textureColorBasedOnRole then
                frame[j][k].texture:SetAlpha(0) --it will get changed based on what needed if group_event_udpate is called, but default is invis
                frame[j][k].roleColors=frame[j][k].para.textureColors
              end
            end
                   
            if frame[j][k].para.hasBorder then
              frame[j][k].border=frame[j][k]:CreateTexture(nil,'OVERLAY')
              frame[j][k].border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
              frame[j][k].border:SetAllPoints()                     
              frame[j][k].border:SetTexCoord(.296875, .5703125, 0, .515625)
              frame[j][k].borderColor=eF.para.colors.debuff
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
            frame[j][k]:SetPoint(frame.families[j][k].anchor,frame,frame.families[j][k].anchorTo,frame.families[j][k].xPos,frame.families[j][k].yPos)
            frame[j][k]:SetSize(frame.families[j][k].width,frame.families[j][k].height)
           
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
            if frame[j][k].para.loadAlways then frame[j][k].loadAlways=true 
            else 
              if frame[j][k].para.loadRole then frame[j][k].loadRole=true; frame[j][k].loadRoleList=frame[j][k].para.loadRoleList end
              if frame[j][k].para.loadInstance then frame[j][k].loadInstance=true; frame[j][k].loadInstanceList = frame[j][k].para.loadInstanceList end
              if frame[j][k].para.loadEncounter then frame[j][k].loadEncounter=true; frame[j][k].loadEncounter=frame[j][k].para.loadEncounter end 
            end
            
            if frame.families[j][k].trackType=="name" then  
              insert(frame[j][k].onAuraList,{eF.rep.iconFrameDisable,frame[j][k]})
              if frame[j][k].para.buff then insert(frame[j][k].onBuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]})
              else insert(frame[j][k].onDebuffList,{eF.rep.iconAdoptAuraByName,frame[j][k]}) end           
            end 

            
            if frame.families[j][k].trackType=="power" then  
              insert(frame[j][k].onPowerList,{eF.rep.statusBarPowerUpdate,frame[j][k]})                   
            end 
            
            --VISUALS
            
          end--end of if bar
          
          
          
        end --end for k=1,frame.families.count
      end--end of if frame.families[j].smart else
      
    end --end of for j=1,#frame.families
    
    
    
  end--end of for i=1,40
  
end --end of createFamilyFrames()

local function iconUpdateTextTypeT(self)
  if not self.filled then return end
  local t=GetTime()
  local s
  local iDA=self.textIgnoreDurationAbove

  s=self.expirationTime-t
  
  if s<0 or (iDA and s>iDA ) then s='';
  else local dec=self.para.textDecimals or 1; s=eF.toDecimal(s,dec) end

  self.text:SetText(s)
end
eF.rep.iconUpdateTextTypeT=iconUpdateTextTypeT

local function iconAdoptAuraByName(self,name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss,own)

  if self.filled then return  end
  if name==self.para.arg1 then
    self.name=name
    self.icon=icon
    if self.smartIcon then self.texture:SetTexture(icon) end
    if self.cdFrame then self.cdFrame:SetCooldown(expirationTime-duration,duration) end
    self.count=count
    self.debuffType=debuffType
    if self.border then
      local c=self.borderColor[debuffType] 
      if c then self.border:SetVertexColor(c.r,c.g,c.b)
      else self.border:Hide() end
    end
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
    if self.border then
      local c=self.borderColor[debuffType] 
      if c then self.border:SetVertexColor(c[1],c[2],c[3]); self.border:Show()
      else self.border:Hide(); end
    end  
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

local function updateTextureRoleColor(self,role,...)
  local c=self.roleColors[role] or {0,0,0,0}
  if self.para.hasColorTexture then self.texture:SetColorTexture(c[1],c[2],c[3]); self.texture:SetAlpha(c[4])
  else self.texture:SetVertexColor(c[1],c[2],c[3]); self.texture:SetAlpha(c[4]) end
end
eF.rep.updateTextureRoleColor=updateTextureRoleColor

local function statusBarPowerUpdate(self)
  local unit=self.id
  self:SetValue(UnitPower(unit)/UnitPowerMax(unit))
end
eF.rep.statusBarPowerUpdate=statusBarPowerUpdate

local function checkLoad(self,role,enc,ins)
  if self.loadAlways then return true end 
  local inList=eF.isInList
  local b=true
  
  if self.loadRole and not inList(role,self.loadRoleList) then b=false 
  elseif self.loadEncounter and not inList(enc,self.loadEncounterList) then b=false 
  elseif self.loadInstance and not inList(ins,self.loadInstanceList) then b=false 
  end
  
  if not b and eF.loaded then eF.loaded=false; eF:disable() end
  if b and not eF.loaded then eF.loaded=true end
  
  return b
end
eF.rep.checkLoad=checkLoad

createFamilyFrames()







