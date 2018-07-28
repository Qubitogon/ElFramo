local _,eF=...
--see OptionsPanelTemplates.xml
local font="Fonts\\FRIZQT__.ttf"
local font2="Fonts\\ARIALN.ttf"
local border1="Interface\\Tooltips\\UI-Tooltip-Border"
local fontExtra="OUTLINE"
local smallBreak="Interface\\QUESTFRAME\\UI-HorizontalBreak"
local largeBreak="Interface\\MailFrame\\MailPopup-Divider"
local afterDo=C_Timer.After
local div="Interface\\HELPFRAME\\HelpFrameDivider"
local titleFont="Fonts\\ARIALN.ttf"
local titleFontExtra="OUTLINE"
local titleFontColor={0.9,0.9,0.1}
local titleFontColor2={0.9,0.9,0.6}
local titleSpacer="Interface\\OPTIONSFRAME\\UI-OptionsFrame-Spacer"
local bd2={edgeFile ="Interface\\Tooltips\\UI-Tooltip-Border" ,edgeSize = 10, insets ={ left = 0, right = 0, top = 0, bottom = 0 }}
local bd={edgeFile ="Interface\\DialogFrame\\UI-DialogBox-Border",edgeSize = 20, insets ={ left = 0, right = 0, top = 0, bottom = 0 }}
local int,tb,hd1,hd1b1,hd1b2,hd1b3,gf,ff
local ySpacing=25
local initSpacing=15
local familyHeight=30
local ssub,trem=string.sub,table.remove
local plusTexture="Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab"
local destroyTexture="Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Opaque"
local arrowDownTexture="Interface\\Calendar\\MoreArrow"

eF.familyButtonsList={}
eF.para.familyButtonsIndexList={}
eF.activeConfirmMove=nil
--  local sc=eF.interface.familiesFrame.famList.scrollChild

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function ScrollFrame_OnMouseWheel(self,delta)
  local v=self:GetVerticalScroll() - (delta*familyHeight/2)
  if (v<0) then
    v=0;
  elseif (v>self:GetVerticalScrollRange()) then
    v=self:GetVerticalScrollRange();
  end
  
  self:SetVerticalScroll(v)
end

local function releaseAllFamilies()
  local lst=eF.familyButtonsList
  
  for i=1,#lst do
    --if lst[i]:GetButtonState()=="PUSHED" then lst[i]:SetButtonState("NORMAL") end
    lst[i]:Enable()
  end
  
end

local function header1ReleaseAll()
  hd1.button1:Enable()
  hd1.button2:Enable()
  hd1.button3:Enable()
  if hd1.button1.relatedFrame then hd1.button1.relatedFrame:Hide() end
  if hd1.button2.relatedFrame then hd1.button2.relatedFrame:Hide() end
  if hd1.button3.relatedFrame then hd1.button3.relatedFrame:Hide() end
end

local function makeHeader1Button(self)
  self:SetHeight(39)
  self:SetWidth(100)
  self:SetBackdrop(bd)

  self.text=self:CreateFontString(nil,"OVERLAY")
  self.text:SetPoint("CENTER")
  self.text:SetFont(font2,17,fontExtra)
  self.text:SetText("General")
  self.text:SetTextColor(0.9,0.9,0.1)

  self.nTexture=self:CreateTexture(nil,"BACKGROUND")
  self.nTexture:SetPoint("TOPLEFT",self,"TOPLEFT",6,-6)
  self.nTexture:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-6,6)
  self.nTexture:SetColorTexture(0.07,0.07,0.07)
  self:SetNormalTexture(self.nTexture)

  self.pTexture=self:CreateTexture(nil,"BACKGROUND")
  self.pTexture:SetPoint("TOPLEFT",self,"TOPLEFT",6,-6)
  self.pTexture:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-6,0)
  self.pTexture:SetColorTexture(0.1,0.1,0.1)
  self:SetPushedTexture(self.pTexture)

  self:SetScript("OnClick",function(self)
    header1ReleaseAll()
    self:Disable()
    if self.relatedFrame then self.relatedFrame:Show() end
    end)
end

local function createNumberEB(self,name,tab)
  self[name]=CreateFrame("EditBox",nil,tab,"InputBoxTemplate")
  local eb=self[name]
  eb:SetWidth(30)
  eb:SetHeight(20)
  eb:SetAutoFocus(false)

  eb.text=eb:CreateFontString()
  local tx=eb.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)
  --tx:SetPoint("RIGHT",eb,"LEFT",-12,0)
  
  eb:SetPoint("LEFT",tx,"RIGHT",12,0)
end

local function createListCB(self,name,tab)

  self[name]=CreateFrame("ScrollFrame",nil,tab,"UIPanelScrollFrameTemplate")
  local f=self[name]
  f:SetClipsChildren(true)
  f:SetScript("OnMouseWheel",ScrollFrame_OnMouseWheel)
  f:SetWidth(200) 
  f:SetHeight(120)
  f.border=CreateFrame("Frame",nil,tab)
  f.border:SetPoint("TOPLEFT",f,"TOPLEFT",-4,4)
  f.border:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",4,-4)
  f.border:SetBackdrop(bd)
  
  
  f.ScrollBar:ClearAllPoints()
  f.ScrollBar:SetPoint("TOPRIGHT")
  f.ScrollBar:SetPoint("BOTTOMRIGHT")
  f.ScrollBar.bg=f.ScrollBar:CreateTexture(nil,"BACKGROUND")
  f.ScrollBar.bg:SetAllPoints()
  f.ScrollBar.bg:SetColorTexture(0,0,0,0.5)

  f.scrollChild=CreateFrame("Button",nil,f)
  local fsc=f.scrollChild
  f:SetScrollChild(fsc)
  fsc:SetWidth(200)
  fsc:SetHeight(500)
  
  f.eb=CreateFrame("EditBox",nil,fsc)
  f.eb:SetMultiLine(true)
  f.eb:SetWidth(190)
  f.eb:SetCursorPosition(0)
  f.eb:SetAutoFocus(false)
  f.eb:SetFont("Fonts\\FRIZQT__.TTF",12)
  f.eb:SetJustifyH("LEFT")
  f.eb:SetJustifyV("CENTER")
  f.eb:SetPoint("TOPLEFT",fsc,"TOPLEFT",6,-5) 
  f.scrollChild:SetScript("OnClick",function() f.eb:SetFocus() end )
  
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT")
  f.bg:SetPoint("BOTTOMRIGHT")
  f.bg:SetColorTexture(0,0,0,0.4)
  
  f.button=CreateFrame("Button",nil,f.border,"UIPanelButtonTemplate")
  f.button:SetSize(80,25)
  f.button:SetText("Okay")
  f.button:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,-30)
  f.button.eb=f.eb
  f.eb:SetScript("OnTextChanged",function(self) 
    f.button:Enable()
    local _,nls=self:GetText():gsub('\n','\n')
    f:adjustHeight(nls+1)
    
  end)
  
  f.eb:HookScript("OnEnterPressed",function(self)
    self:Insert('\n')
    if f:GetVerticalScrollRange()>0 then f:SetVerticalScroll(f:GetVerticalScroll() +13) end
  end)
  
  f.adjustHeight= function(self,ni)
    self.scrollChild:SetHeight(ni*13) 
  end

end

local function createDD(self,name,tab)
  self[name]=CreateFrame("Frame","eFDropDown"..name,tab,"UIDropDownMenuTemplate")
  local dd=self[name]
  UIDropDownMenu_SetWidth(dd,70)


  dd.text=dd:CreateFontString()
  local tx=dd.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)

  dd:SetPoint("LEFT",tx,"RIGHT",-10,0)
end

local function updateAllFramesFamilyParas(j)
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame:applyFamilyParas(j)
    frame:checkLoad()
    frame:eventHandler("UNIT_AURA")
  end--end of for i=1,45
end

local function updateAllFramesChildParas(j,k)
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame:applyChildParas(j,k)
    frame:checkLoad()
    frame:eventHandler("UNIT_AURA")

  end--end of for i=1,45
end

local function exterminateChild(j,k)
  
  
  local count=eF.para.families[j].count
  eF.para.families[j].count=count-1
  
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    local c=frame[j][k]
    c.onAuraList={}
    c.onPostAuraList={}
    c.onBuffList={}
    c.onDebuffList={}
    c.onPowerList={}
    c.onUpdateList={}
    c:Hide()
    c=nil
    
    for i=k,count-1 do
      frame[j][i]=nil
      frame[j][i]=frame[j][i+1]      
    end
    frame[j][count]=nil
    
    frame:checkLoad()
    frame:eventHandler("UNIT_AURA")
  end--end of for i=1,45
  
  for i=k,count-1 do
    eF.para.families[j][i]=nil
    eF.para.families[j][i]=eF.para.families[j][i+1]
  end

  
  local n=eF.posInFamilyButtonsList(j,k)
  local bl=eF.familyButtonsList
  local mmax=#bl
  bl[n]:Hide()
  
  for m=n,mmax-1 do
    bl[m]=nil
    bl[m]=bl[m+1]
  end
  bl[mmax]=nil
  
  for m=1,#bl do
    if bl[m].familyIndex==j and (bl[m].childIndex) and (bl[m].childIndex>k) then bl[m].childIndex=bl[m].childIndex-1 end
  end
  
  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:setFamilyPositions()
  sc:updateFamilyButtonsIndexList()
end

local function exterminateSmartFamily(j)

  local fc=#eF.para.families
  local count=eF.para.families[j].count
  for i=1,count do
    eF.para.families[j][i]=nil
  end
  
  for i=j,fc-1 do
    eF.para.families[i]=nil
    eF.para.families[i]=eF.para.families[i-1]
  end
  eF.para.families[fc]=nil
  
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    local f=frame[j]
    f.onAuraList={}
    f.onPostAuraList={}
    f.onBuffList={}
    f.onDebuffList={}
    f.onPowerList={}
    f.onUpdateList={}
    f:Hide()
    f=nil
    
    for i=j,fc-1 do
      frame[i]=nil
      frame[i]=frame[i+1]      
    end
    frame[fc]=nil
    
    frame:checkLoad()
    frame:eventHandler("UNIT_AURA")
  end--end of for i=1,45
  
 
  
  local n=eF.posInFamilyButtonsList(j)
  local bl=eF.familyButtonsList
  local mmax=#bl
  bl[n]:Hide()
  
  for m=n,mmax-1 do
    bl[m]=nil
    bl[m]=bl[m+1]
  end
  bl[mmax]=nil
  
  for m=1,#bl do
    if bl[m].familyIndex>j then bl[m].familyIndex=bl[m].familyIndex-1 end
  end
  
  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:setFamilyPositions()
  sc:updateFamilyButtonsIndexList()
end

local function exterminateDumbFamily(j)
 
  local fc=#eF.para.families
  local count=eF.para.families[j].count
  for i=1,count do
    eF.para.families[j][i]=nil
  end
  
  for i=j,fc-1 do
    eF.para.families[i]=nil
    eF.para.families[i]=eF.para.families[i-1]
  end
  eF.para.families[fc]=nil
  
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    local f=frame[j]
    f.onAuraList={}
    f.onPostAuraList={}
    f.onBuffList={}
    f.onDebuffList={}
    f.onPowerList={}
    f.onUpdateList={}
    f:Hide()

    
    for k=1,count do
      local c=frame[j][k]
      c.onAuraList={}
      c.onPostAuraList={}
      c.onBuffList={}
      c.onDebuffList={}
      c.onPowerList={}
      c.onUpdateList={}
      c:Hide()
      c=nil
    end
        
    for i=j,fc-1 do
      frame[i]=nil
      frame[i]=frame[i+1]      
    end
    frame[fc]=nil
    f=nil
    
    frame:checkLoad()
    frame:eventHandler("UNIT_AURA")
  end--end of for i=1,45
  
  
  local n=eF.posInFamilyButtonsList(j)
  local bl=eF.familyButtonsList
  local mmax=#bl
  bl[n]:Hide()
  
  for m=n,mmax-1 do
    bl[m]=nil
    bl[m]=bl[m+1]
  end
  bl[mmax]=nil
  
  for m=1,#bl do
    if bl[m].familyIndex>j then bl[m].familyIndex=bl[m].familyIndex-1 end
  end
  
  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:setFamilyPositions()
  sc:updateFamilyButtonsIndexList()
end

local function findGroupByName(s)
  local lst=eF.para.families
  local ind=nil
  local tostring=tostring
  
  for i=1,#lst do 
    if lst[i].displayName==s then ind=i; break end
  end
  return ind
end

local function copyChildTo(oj,ok,nj,nk)
  if (not oj) or (not ok) or (not nj) or (not nk) then return nil end
  local paraFam=eF.para.families
  local sc=eF.interface.familiesFrame.famList.scrollChild
  
  if paraFam[nj].smart then return nil end
  if nk>paraFam[nj].count then paraFam[nj].count=nk end
  
  paraFam[nj][nk]=deepcopy(paraFam[oj][ok])
  eF.rep.createAllIconFrame(nj,nk)
  sc:createChild(nj,nk)

  sc:setFamilyPositions()
end

local function moveOrphanToGroup(oj,ok,name)
  local nj=findGroupByName(name)
  if not nj then return nil end
  local paraFam=eF.para.families
  local nk=paraFam[nj].count+1
  paraFam[nj].count=nk

  copyChildTo(oj,ok,nj,nk)
  exterminateChild(oj,ok)
  
  return true
  
end

local function makeOrphan(oj,ok)

  if (not oj) or (not ok) then return nil end
  local paraFam=eF.para.families
  
  if not paraFam[oj][ok] then return nil end
  local nk=paraFam[1].count+1
  paraFam[1].count=nk
  
  copyChildTo(oj,ok,1,nk)
  exterminateChild(oj,ok)

  return true
  
end

local function updateAllFramesFamilyLayout(j)
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    frame:updateFamilyLayout(j)
    frame:checkLoad()
  end--end of for i=1,45
end

local function createCB(self,name,tab)
  self[name]=CreateFrame("CheckButton",nil,tab,"ChatConfigCheckButtonTemplate")
  local cb=self[name]
  cb:SetSize(20,20)
  cb:SetHitRectInsets(0,0,0,0)

  cb.text=cb:CreateFontString()
  local tx=cb.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)

  cb:SetPoint("LEFT",tx,"RIGHT",12,0)
  
end

local function frameToggle(self) 
  if not self then return end
  if self:IsShown() then self:Hide() else self:Show()end
end

local function createHDel(self,name)
  self[name]=CreateFrame("Frame",nil,self)
  local f=self[name]
  f:SetWidth(self:GetWidth()*0.9)
  f:SetHeight(20)
  
  f.t1=f:CreateTexture(nil,"BACKGROUND")
  f.t1:SetPoint("LEFT")
  f.t1:SetTexture(div)
  f.t1:SetTexCoord(0,1,0,1/3)
  f.t1:SetSize(256,21.3)
  
  f.t2=f:CreateTexture(nil,"BACKGROUND")
  f.t2:SetPoint("LEFT",f.t1,"RIGHT")
  f.t2:SetTexture(div)
  f.t2:SetTexCoord(0,1,1/3-0.01,2/3)
  f.t2:SetSize(256,21.3)
  
  f.t4=f:CreateTexture(nil,"BACKGROUND")
  f.t4:SetPoint("RIGHT")
  f.t4:SetTexture(div)
  f.t4:SetTexCoord(0,0.27,2/3-0.04,1)
  f.t4:SetSize(256*0.27,21.3)
  
  f.t3=f:CreateTexture(nil,"BACKGROUND")
  f.t3:SetPoint("RIGHT",f.t4,"LEFT")
  f.t3:SetTexture(div)
  f.t3:SetTexCoord(0,1,1/3-0.01,2/3)
  f.t3:SetSize(256,21.3)
  
end

local function hideAllFamilyParas()
  local ff=eF.interface.familiesFrame
  ff.dumbFamilyFrame:Hide()
  ff.smartFamilyScrollFrame:Hide()
  ff.childIconScrollFrame:Hide()
  ff.childBarFrame:Hide()
  ff.elementCreationScrollFrame:Hide()
end

local function showSmartFamilyPara()
  local ff=eF.interface.familiesFrame
  ff.smartFamilyFrame:setValues()
  ff.smartFamilyScrollFrame:Show()
end

local function showDumbFamilyPara()
  local dff=eF.interface.familiesFrame.dumbFamilyFrame
  dff:Show()
end

local function showChildIconPara()
  local ff=eF.interface.familiesFrame
  ff.childIconScrollFrame:Show()
  ff.childIconFrame:setValues()
end

local function showChildBarPara()
  local cBF=eF.interface.familiesFrame.childBarFrame
  cBF:Show()
end

local function createIP(self,name,tab) --icon picker
  self[name]=CreateFrame("EditBox",nil,tab,"InputBoxTemplate")
  local eb=self[name]
  eb:SetWidth(60)
  eb:SetHeight(20)
  eb:SetAutoFocus(false)

  eb.text=eb:CreateFontString()
  local tx=eb.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)
  --tx:SetPoint("RIGHT",eb,"LEFT",-12,0)
  
  eb:SetPoint("LEFT",tx,"RIGHT",12,0)

  eb.preview=CreateFrame("Frame",nil,tab)
  eb.preview:SetPoint("LEFT",eb,"RIGHT",10,0)
  eb.preview:SetHeight(30)
  eb.preview:SetWidth(30)
  
  eb.pTexture=eb.preview:CreateTexture(nil,"BACKGROUND")
  eb.pTexture:SetAllPoints()
end

local function createCS(self,name,tab)
  self[name]=CreateFrame("Button",nil,tab)
  local cp=self[name]
  cp:SetWidth(35)
  cp:SetHeight(20)
  
  cp.opacityFunc=function()  end
  cp.cancelFunc=function()   end
  cp.func=function()  end
  
  cp.hasOpacity=false
  cp.getOldRGBA=function() return 1,1,1,1 end
  
  cp:SetScript("OnClick",function(self)
    if self.blocked then return end 
    local r,g,b,a=self:getOldRGBA()
    ColorPickerFrame:SetColorRGB(r,g,b)
    if self.hasOpacity then ColorPickerFrame.opacity=a end
    
    ColorPickerFrame.func=self.func; 
    ColorPickerFrame.cancelFunc=self.cancelFunc; 
    ColorPickerFrame.opacityFunc=self.opacityFunc; 
    
    ColorPickerFrame:Show() 
    end)
  
  cp.thumb=cp:CreateTexture(nil,"ARTWORK")
  cp.thumb:SetAllPoints()
  cp.thumb:SetColorTexture(1,1,1)
  
  cp.text=cp:CreateFontString()
  local tx=cp.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)
  
  cp:SetPoint("LEFT",tx,"RIGHT",8,1)
end

local function intSetInitValues()
  local int=eF.interface
  local gF=int.generalFrame
  local fD=gF.frameDim
  local para=eF.para
  local units=para.units
  local layout=para.layout
  local ff=int.familiesFrame
  local fL=ff.famList
  local sc=ff.famList.scrollChild
  local paraFam=eF.para.families
  local bil=eF.para.familyButtonsIndexList
  --eF.interface.familiesFrame.famList.scrollChild.families
  
  --general frame
  do
  fD.ebHeight:SetText(units.height)
  fD.ebWidth:SetText(units.width)
  UIDropDownMenu_SetSelectedName(fD.hDir,units.healthGrow)
  UIDropDownMenu_SetText(fD.hDir,units.healthGrow)
  fD.gradStart:SetText( eF.toDecimal(units.hpGrad1R,2) or "nd")
  fD.gradFinal:SetText( eF.toDecimal(units.hpGrad2R,2) or "nd")
  fD.nMax:SetText(units.textLim)
  fD.nSize:SetText(units.textSize)
  
  fD.hClassColor:SetChecked(layout.byClassColor)
  fD.hColor.blocked=layout.byClassColor
  if layout.byClassColor then fD.hColor.blocker:Show() else fD.hColor.blocker:Hide() end
  fD.hColor.thumb:SetVertexColor(units.hpR,units.hpG,units.hpB)
  
  fD.nClassColor:SetChecked(units.textColorByClass)
  fD.nColor.blocked=units.textColorByClass
  if units.textColorByClass then fD.nColor.blocker:Show() else fD.nColor.blocker:Hide() end
  fD.nColor.thumb:SetVertexColor(units.textR,units.textG,units.textB)
  
  local font=ssub(units.textFont,7,-5)
  UIDropDownMenu_SetSelectedName(fD.nFont,font)
  UIDropDownMenu_SetText(fD.nFont,font)
  
  fD.nAlpha:SetText(eF.toDecimal(units.textA,2) or "nd")
  UIDropDownMenu_SetSelectedName(fD.nPos,units.textPos)
  UIDropDownMenu_SetText(fD.nPos,units.textPos)

  fD.bColor.thumb:SetVertexColor(units.borderR,units.borderG,units.borderB)
  fD.bWid:SetText(units.borderSize)
  end
  
  --family frame
  do 
  
  for i=1,#bil do
    local j=bil[i][1]
    local k=bil[i][2]
    if k then sc:createChild(j,k) 
    else  
      if paraFam[j].smart then sc:createFamily(j) 
      else
        sc:createGroup(j)
        for l=1,paraFam[j].count do 
          sc:createChild(j,l)
        end--end of for l=1,paraFamj.count
      end
      
    end--end of if
  end
  
  for i=2,#paraFam do
    if not eF.posInFamilyButtonsList(i) then sc:createFamily(i) end
  end

  for i=1,paraFam[1].count do
    if not eF.posInFamilyButtonsList(1,i) then sc:createChild(1,i) end
  end
  
  
  sc:setFamilyPositions()
  
  hideAllFamilyParas()
  
  end
  
end
eF.rep.intSetInitValues=intSetInitValues

local function createAllFamilyFrame(j)
  local units=eF.units
  local insert=table.insert  
  
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    
    eF.units.familyCount=#frame.families

    frame:createFamily(j)
    if eF.para.families[j].smart then frame:applyFamilyParas(j)
    else
      for k=1,eF.para.families[j].count do frame:applyChildParas(j,k) end
    end
 
  end--end of for i=1,45
end

local function createAllIconFrame(j,k)
  local units=eF.units
  local insert=table.insert  
  
  for i=1,45 do
    local frame
    if i<41 then frame=eF.units[eF.raidLoop[i]] else frame=eF.units[eF.partyLoop[i-40]] end
    
    frame[j]:createChild(k)
    frame:applyChildParas(j,k) 
  end--end of for i=1,45
end
eF.rep.createAllIconFrame=createAllIconFrame

local function createNewWhitelistParas(j)
  eF.para.families[j]={displayName="New Whitelist",
     smart=true,
     count=3,
     type="w",
     xPos=0,
     yPos=0,
     spacing=1,
     height=15,
     frameLevel=4,
     width=15,
     anchor="CENTER",
     anchorTo="CENTER",
     trackType="Buffs",
     arg1={},
     smartIcons=true,
     grow="right",
     growAnchor="LEFT",
     growAnchorTo="LEFT",
     cdReverse=false,
     cdWheel=true,
     hasBorder=false,
     borderType="debuffColor",
     hasText=true,
     hasTexture=true,
     ignorePermanents=true,
     ignoreDurationAbove=nil,
     textType="Time left",                                     
     textAnchor="CENTER",
     textAnchorTo="CENTER",
     textXOS=0,
     textYOS=0,
     textSize=15,
     textR=1,
     textG=1,
     textB=1,
     textA=1,
     textDecimals=1,
     ownOnly=false,
     loadAlways=true,
     }
end

local function createNewBlacklistParas(j)
  eF.para.families[j]={displayName="New Blacklist",
     smart=true,
     count=3,
     type="b",
     xPos=0,
     yPos=0,
     spacing=1,
     height=15,
     frameLevel=4,
     width=15,
     anchor="CENTER",
     anchorTo="CENTER",
     trackType="Buffs",
     arg1={},
     smartIcons=true,
     grow="right",
     growAnchor="LEFT",
     growAnchorTo="LEFT",
     cdReverse=false,
     cdWheel=true,
     hasBorder=false,
     borderType="debuffColor",
     hasText=true,
     hasTexture=true,
     ignorePermanents=true,
     ignoreDurationAbove=nil,
     textType="Time left",                                     
     textAnchor="CENTER",
     textAnchorTo="CENTER",
     textXOS=0,
     textYOS=0,
     textSize=15,
     textR=1,
     textG=1,
     textB=1,
     textA=1,
     textDecimals=1,
     ownOnly=false,
     loadAlways=true,
     }
end

local function createNewGroupParas(j)
  eF.para.families[j]={
    displayName="G",
    smart=false,
    count=0,
    buttonsIndexList={},
     }
end

local function createNewIconParas(j,k)
  eF.para.families[j][k]={
  displayName="New Icon",
  type="icon",
  trackType="Buffs",
  trackBy="Name",
  arg1="",
  xPos=0,
  yPos=0,
  frameLevel=4,
  height=20,
  width=20,
  anchor="CENTER",
  anchorTo="CENTER",
  cdWheel=true,
  cdReverse=true,
  hasBorder=false,
  smartIcon=true,
  hasText=true,
  hasTexture=true,
  textType="Time left",
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
  ownOnly=true,
  loadAlways=true,
  }
end

local function moveButtonUpList(self)
  local j,k=self.parentButton.familyIndex,self.parentButton.childIndex
  local n=eF.posInFamilyButtonsList(j,k)
  if n==1 then return end
  local m=n-1
  local bl=eF.familyButtonsList
  
  local justInCase=0
  while m>0 and justInCase<1000 do
    justInCase=justInCase+1
    if not bl[m].collapsible then break end
    m=m-1
  end
  
  local save=bl[m]
  bl[m]=bl[n]
  bl[n]=save
  
  
  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:updateFamilyButtonsIndexList()
  sc:setFamilyPositions()
  
end

local function moveButtonDownList(self)
  local j,k=self.parentButton.familyIndex,self.parentButton.childIndex
  local n=eF.posInFamilyButtonsList(j,k)
  local bl=eF.familyButtonsList
  local mmax=#bl
  
  if n==mmax then return end
  local m=n+1
  
  local justInCase=0
  while m<mmax+1 and justInCase<1000 do
    justInCase=justInCase+1
    if not bl[m].collapsible then break end
    m=m+1
  end
  
  local save=bl[m]
  bl[m]=bl[n]
  bl[n]=save
  

  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:updateFamilyButtonsIndexList()
  sc:setFamilyPositions()
  
end

local function createFamily(self,n,pos)

  local para=eF.para.families[n]
  if self.families[n] then self.families[n]=nil end
  
  --button creation
  self.families[n]=CreateFrame("Button",nil,self)
  local f=self.families[n]
  f:SetWidth(eF.interface.familiesFrame.famList:GetWidth()-25)
  f:SetHeight(familyHeight)
  f:SetPoint("TOPRIGHT",self,"TOPRIGHT")
  f:SetBackdrop(bd2)
  f.para=para
  f.familyIndex=n
  f.smart=true
  
  if not pos then table.insert(eF.familyButtonsList,f) else table.insert(eF.familyButtonsList,pos,f) end
  
  f:SetScript("OnClick",function(self)
    releaseAllFamilies()
    hideAllFamilyParas()
    eF.activePara=para
    eF.activeButton=self
    eF.activeFamilyIndex=self.familyIndex
    if self.para.smart then showSmartFamilyPara() else showDumbFamilyPara() end
    self:Disable()
    end)
  
  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:updateFamilyButtonsIndexList()
  
  -- normal texture
  do
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
  f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
  f.bg:SetColorTexture(0.2,0.25,0.2,1)
  f.bg:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
  f:SetNormalTexture(f.bg)
  end
   
  --pushed texture
  do
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
  f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
  f.bg:SetColorTexture(0.6,0.8,0.4)
  f.bg:SetGradient("vertical",0.4,0.4,0.4,0.7,0.7,0.7)
  f:SetPushedTexture(f.bg)
  end
   
  --Highlight creation
  do
  f.hl=f:CreateTexture(nil,"BACKGROUND")
  f.hl:SetPoint("BOTTOM",f,"BOTTOM",0,-1)
  f.hl:SetHeight(f:GetHeight()*0.3)
  f.hl:SetWidth(f:GetWidth()*0.8)
  f.hl:SetTexture("Interface\\BUTTONS\\UI-SILVER-BUTTON-HIGHLIGHT")
  f:SetHighlightTexture(f.hl)
  end
  
  --text creation
  do
  f.text=f:CreateFontString()
  f.text:SetPoint("CENTER")
  f.text:SetFont("Fonts\\ARIALN.ttf",17,fontExtra)
  f.text:SetTextColor(0.9,0.9,0.9)
  f.text:SetText(para.displayName)
  end
      
  --up and down buttons    
  do
    local text
    f.up=CreateFrame("Button",nil,f)
    f.up:SetPoint("TOPRIGHT",f,"TOPRIGHT",-1,0)
    f.up:SetSize(f:GetHeight()/2,f:GetHeight()/2)
    f.up.parentButton=f

    text=f.up:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
    text:SetRotation(math.pi/2)
    f.up:SetNormalTexture(text)
    
    text=nil
    text=f.up:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
    text:SetRotation(math.pi/2)
    f.up:SetPushedTexture(text)   
    f.up:SetScript("OnClick",moveButtonUpList)
    
    f.down=CreateFrame("Button",nil,f)
    f.down:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-1,2)
    f.down:SetSize(f:GetHeight()/2,f:GetHeight()/2)
    f.down.parentButton=f
    
    text=nil
    text=f.down:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
    text:SetRotation(math.pi/2)
    f.down:SetNormalTexture(text)
    
    text=nil
    text=f.down:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
    text:SetRotation(math.pi/2)
    f.down:SetPushedTexture(text)   
    f.down:SetScript("OnClick",moveButtonDownList)
  end    
  
end

local function createChild(self,j,k,pos)

  local para=eF.para.families[j][k]
  if self.families[j] then if self.families[j][k] then self.families[j][k]=nil end else self.families[j]={} end

  --button creation
  self.families[j][k]=CreateFrame("Button",nil,self)
  local f=self.families[j][k]
  if j==1 then f:SetWidth((eF.interface.familiesFrame.famList:GetWidth()-25)) else f:SetWidth((eF.interface.familiesFrame.famList:GetWidth()-25)*0.92) end
  f:SetHeight(familyHeight)
  --f:SetPoint("TOPRIGHT",self,"TOPRIGHT",-4,-5-(familyHeight+2)*(n-1))
  f:SetPoint("TOPRIGHT",self,"TOPRIGHT")
  f:SetBackdrop(bd2)
  f.para=para
  f.familyIndex=j
  f.childIndex=k

  
  if not pos then table.insert(eF.familyButtonsList,f)else table.insert(eF.familyButtonsList,pos,f) end
  
  f:SetScript("OnClick",function(self)
    releaseAllFamilies()
    hideAllFamilyParas()
    eF.activePara=para
    eF.activeButton=self
    eF.activeFamilyIndex=self.familyIndex
    eF.activeChildIndex=self.childIndex
    if self.para.type=="icon" then showChildIconPara() elseif self.para.type=="bar" then showChildBarPara() end
    self:Disable()
    end)

  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:updateFamilyButtonsIndexList()
  
  if j==1 then
    -- normal texture
    do
    f.bg=f:CreateTexture(nil,"BACKGROUND")
    f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
    f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
    f.bg:SetColorTexture(0.28,0.2,0.2,1)
    f.bg:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
    f:SetNormalTexture(f.bg)
    end
     
    --pushed texture
    do
    f.bg=f:CreateTexture(nil,"BACKGROUND")
    f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
    f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
    f.bg:SetColorTexture(0.8,0.4,0.4)
    f.bg:SetGradient("vertical",0.4,0.4,0.4,0.7,0.7,0.7)
    f:SetPushedTexture(f.bg)
    end
     
    --Highlight creation
    do
    f.hl=f:CreateTexture(nil,"BACKGROUND")
    f.hl:SetPoint("BOTTOM",f,"BOTTOM",0,-1)
    f.hl:SetHeight(f:GetHeight()*0.3)
    f.hl:SetWidth(f:GetWidth()*0.8)
    f.hl:SetTexture("Interface\\BUTTONS\\UI-SILVER-BUTTON-HIGHLIGHT")
    f:SetHighlightTexture(f.hl)
    end

    --text creation
    do
    f.text=f:CreateFontString()
    f.text:SetPoint("CENTER")
    f.text:SetFont("Fonts\\ARIALN.ttf",17,fontExtra)
    f.text:SetTextColor(0.9,0.9,0.9)
    f.text:SetText(para.displayName)
    end

    --up and down buttons
    do
      local text
      f.up=CreateFrame("Button",nil,f)
      f.up:SetPoint("TOPRIGHT",f,"TOPRIGHT",-1,0)
      f.up:SetSize(f:GetHeight()/2,f:GetHeight()/2)
      f.up.parentButton=f

      text=f.up:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
      text:SetRotation(math.pi/2)
      f.up:SetNormalTexture(text)
      
      text=nil
      text=f.up:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
      text:SetRotation(math.pi/2)
      f.up:SetPushedTexture(text)   
      f.up:SetScript("OnClick",moveButtonUpList)
      
      f.down=CreateFrame("Button",nil,f)
      f.down:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-1,2)
      f.down:SetSize(f:GetHeight()/2,f:GetHeight()/2)
      f.down.parentButton=f
      
      text=nil
      text=f.down:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
      text:SetRotation(math.pi/2)
      f.down:SetNormalTexture(text)
      
      text=nil
      text=f.down:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
      text:SetRotation(math.pi/2)
      f.down:SetPushedTexture(text)   
      f.down:SetScript("OnClick",moveButtonDownList)
    end

    --move to group button
    do
    local mb
    f.moveButton=CreateFrame("Button",nil,f)
    mb=f.moveButton
    mb:SetPoint("LEFT",f,"LEFT",1,0)
    mb:SetSize(15,f:GetHeight()*0.5)
    mb.buttonPointer=f

    local ftex

    ftex=mb:CreateTexture(nil,"BACKGROUND")
    ftex:SetPoint("LEFT",mb,"LEFT")
    ftex:SetSize(12,12)
    ftex:SetTexture(arrowDownTexture)
    ftex:SetTexCoord(0,1,0,0.5)
    ftex:SetRotation(-math.pi/2)
    mb:SetNormalTexture(ftex)

    ftex=nil
    ftex=mb:CreateTexture(nil,"BACKGROUND")
    ftex:SetPoint("LEFT",mb,"LEFT")
    ftex:SetSize(12,12)
    ftex:SetTexture("Interface\\BUTTONS\\Arrow-Down-Down")
    ftex:SetTexCoord(0,1,0,0.5)
    ftex:SetRotation(-math.pi/2)
    ftex:SetVertexColor(0.5,0.5,0.5)
    mb:SetPushedTexture(ftex)  


    mb:SetScript("OnClick",function(self)
      local cm=self.buttonPointer.confirmMove
      if cm:IsShown() then cm:Hide() else cm:Show() end   
    end)

    end --end of move to group cutton

    --confirm moving frame
    do
      f.confirmMove=CreateFrame("Frame",nil,eF.interface.familiesFrame)
      local cm=f.confirmMove
      cm:SetSize(f:GetWidth()*1.2,f:GetHeight()*2)
      cm:SetPoint("RIGHT",f,"LEFT",-10)
      cm:Hide()
      cm:SetBackdrop(bd2)
      cm:SetFrameLevel(f:GetFrameLevel()+1)
      cm:SetScript("OnShow",function(self) 
        self.groupNameEB:SetText("") 
        if eF.activeConfirmMove then eF.activeConfirmMove:Hide() ; eF.activeConfirmMove=nil end
        eF.activeConfirmMove=self
        self.groupNameEB:SetFocus()
      end)
      
      cm:SetScript("OnHide",function(self)  
        eF.activeConfirmMove=nil 
      end)
      
      cm.bg=cm:CreateTexture(nil,"BACKGROUND")
      cm.bg:SetAllPoints(true)
      cm.bg:SetColorTexture(0,0,0,0.7)
      
      cm.text=cm:CreateFontString(nil,"OVERLAY")
      cm.text:SetFont(font,12)
      cm.text:SetText("Move element to group:")
      cm.text:SetPoint("TOPLEFT",cm,"TOPLEFT",4,-2)
      
      createNumberEB(cm,"groupNameEB",cm)
      local eb=cm.groupNameEB
      eb:SetPoint("TOPLEFT",cm.text,"BOTTOMLEFT",3,-2)
      eb:SetWidth(cm:GetWidth()*0.8)
      eb:SetScript("OnEnterPressed",function(self) self:ClearFocus() end)
      
      cm.confirmButton=CreateFrame("Button",nil,cm,"UIPanelButtonTemplate")
      local cmcb=cm.confirmButton
      cmcb.ebPointer=eb
      cmcb.parentPointer=cm
      cmcb.buttonPointer=f
      cmcb:SetText("Confirm")
      cmcb:SetPoint("BOTTOMLEFT",cm,"BOTTOMLEFT",2,2)
      cmcb:SetWidth(60)
      cmcb:SetScript("OnClick",function(self)
      local name=self.ebPointer:GetText()
      if moveOrphanToGroup(self.buttonPointer.familyIndex,self.buttonPointer.childIndex,name) then 
        self.parentPointer:Hide() 
      else      
        self.ebPointer:SetText('"'..name..'" not found')
      end   
      
      end)
      
      cm.cancelButton=CreateFrame("Button",nil,cm,"UIPanelButtonTemplate")
      local clb=cm.cancelButton
      clb.parentPointer=cm
      clb:SetText("Cancel")
      clb:SetPoint("LEFT",cmcb,"RIGHT",2,0)
      clb:SetWidth(60)
      clb:SetScript("OnClick",function(self)  self.parentPointer:Hide()   end)
      
    end --end of confirm moving frame

  else --else of if j==1
    f.collapsible=true
    local bPos=eF.posInFamilyButtonsList(j)
    local grpButton=eF.familyButtonsList[bPos]
    if grpButton then f.collapsed=grpButton.elementsCollapsed end
    
    -- normal texture
    do
    f.bg=f:CreateTexture(nil,"BACKGROUND")
    f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
    f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
    f.bg:SetColorTexture(0.15,0.22,0.4,1)
    f.bg:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
    f:SetNormalTexture(f.bg)
    end
     
    --pushed texture
    do
    f.bg=f:CreateTexture(nil,"BACKGROUND")
    f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
    f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
    f.bg:SetColorTexture(0.32,0.51,0.8)
    f.bg:SetGradient("vertical",0.4,0.4,0.4,0.7,0.7,0.7)
    f:SetPushedTexture(f.bg)
    end
     
    --Highlight creation
    do
    f.hl=f:CreateTexture(nil,"BACKGROUND")
    f.hl:SetPoint("BOTTOM",f,"BOTTOM",0,-1)
    f.hl:SetHeight(f:GetHeight()*0.3)
    f.hl:SetWidth(f:GetWidth()*0.8)
    f.hl:SetTexture("Interface\\BUTTONS\\UI-SILVER-BUTTON-HIGHLIGHT")
    f:SetHighlightTexture(f.hl)
    end
    
    --text creation
    do
    f.text=f:CreateFontString()
    f.text:SetPoint("CENTER")
    f.text:SetFont("Fonts\\ARIALN.ttf",17,fontExtra)
    f.text:SetTextColor(0.9,0.9,0.9)
    f.text:SetText(para.displayName)
    end
    
    --sideline
    do
      f.sideline=f:CreateTexture(nil,"BACKGROUND")
      local sl=f.sideline
      sl:SetSize(2,f:GetHeight()+4)
      sl:SetPoint("LEFT",f,"LEFT",-6,10)
      sl:SetColorTexture(0.86,0.83,0.4)     
    end --end of sideline
    
    --up and down buttons
    do
      local text
      f.up=CreateFrame("Button",nil,f)
      f.up:SetPoint("TOPRIGHT",f,"TOPRIGHT",-1,0)
      f.up:SetSize(f:GetHeight()/2,f:GetHeight()/2)
      f.up.parentButton=f

      text=f.up:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
      text:SetRotation(math.pi/2)
      f.up:SetNormalTexture(text)
      
      text=nil
      text=f.up:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
      text:SetRotation(math.pi/2)
      f.up:SetPushedTexture(text)   
      --f.up:SetScript("OnClick",moveButtonUpList) NYI
      
      f.down=CreateFrame("Button",nil,f)
      f.down:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-1,2)
      f.down:SetSize(f:GetHeight()/2,f:GetHeight()/2)
      f.down.parentButton=f
      
      text=nil
      text=f.down:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
      text:SetRotation(math.pi/2)
      f.down:SetNormalTexture(text)
      
      text=nil
      text=f.down:CreateTexture(nil,"BACKGROUND")
      text:SetAllPoints()
      text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
      text:SetRotation(math.pi/2)
      f.down:SetPushedTexture(text)   
      --f.down:SetScript("OnClick",moveButtonDownList) NYI
    end
    
    --move to group button
    do
    local mb
    f.moveButton=CreateFrame("Button",nil,f)
    mb=f.moveButton
    mb:SetPoint("LEFT",f,"LEFT",1,0)
    mb:SetSize(15,f:GetHeight()*0.5)
    mb.buttonPointer=f
    
    local ftex
   
    ftex=mb:CreateTexture(nil,"BACKGROUND")
    ftex:SetPoint("LEFT",mb,"LEFT")
    ftex:SetSize(12,12)
    ftex:SetTexture(arrowDownTexture)
    ftex:SetTexCoord(0,1,0,0.5)
    ftex:SetRotation(-math.pi/2)
    mb:SetNormalTexture(ftex)
    
    ftex=nil
    ftex=mb:CreateTexture(nil,"BACKGROUND")
    ftex:SetPoint("LEFT",mb,"LEFT")
    ftex:SetSize(12,12)
    ftex:SetTexture("Interface\\BUTTONS\\Arrow-Down-Down")
    ftex:SetTexCoord(0,1,0,0.5)
    ftex:SetRotation(-math.pi/2)
    ftex:SetVertexColor(0.5,0.5,0.5)
    mb:SetPushedTexture(ftex)  
    
    
    mb:SetScript("OnClick",function(self)
      makeOrphan(self.buttonPointer.familyIndex,self.buttonPointer.childIndex)
    end)
    
    end --end of move to group cutton
      
  end
  
end

local function createGroup(self,n,pos)

  local para=eF.para.families[n]
  if self.families[n] then self.families[n]=nil end
  
  --button creationchr
  self.families[n]=CreateFrame("Button",nil,self)
  local f=self.families[n]
  f:SetWidth(eF.interface.familiesFrame.famList:GetWidth()-25)
  f:SetHeight(familyHeight)
  f:SetPoint("TOPRIGHT",self,"TOPRIGHT")
  f:SetBackdrop(bd2)
  f.para=para
  f.familyIndex=n
  f.group=true
  f.elementsCollapsed=true
  
  if not pos then table.insert(eF.familyButtonsList,f) else table.insert(eF.familyButtonsList,pos,f) end
  
  f:SetScript("OnClick",function(self)
    releaseAllFamilies()
    hideAllFamilyParas()
    eF.activePara=para
    eF.activeButton=self
    eF.activeFamilyIndex=self.familyIndex
    if self.para.smart then showSmartFamilyPara() else showDumbFamilyPara() end
    self:Disable()
    end)
  
  f.collapse=function(self) 
    local j=self.familyIndex
    local lst=eF.familyButtonsList
    local cl=not self.elementsCollapsed
    
    for i=1,#lst do
      if (lst[i].familyIndex==j) and lst[i].childIndex then lst[i].collapsed=cl end  
    end
    local sc=eF.interface.familiesFrame.famList.scrollChild
    sc:setFamilyPositions()
    
    self.elementsCollapsed=cl
  end
  
  local sc=eF.interface.familiesFrame.famList.scrollChild
  sc:updateFamilyButtonsIndexList()
  
  -- normal texture
  do
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
  f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
  f.bg:SetColorTexture(0.15,0.22,0.4,1)
  f.bg:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
  f:SetNormalTexture(f.bg)
  end
   
  --pushed texture
  do
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
  f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
  f.bg:SetColorTexture(0.32,0.51,0.8)
  f.bg:SetGradient("vertical",0.4,0.4,0.4,0.7,0.7,0.7)
  f:SetPushedTexture(f.bg)
  end
   
  --Highlight creation
  do
  f.hl=f:CreateTexture(nil,"BACKGROUND")
  f.hl:SetPoint("BOTTOM",f,"BOTTOM",0,-1)
  f.hl:SetHeight(f:GetHeight()*0.3)
  f.hl:SetWidth(f:GetWidth()*0.8)
  f.hl:SetTexture("Interface\\BUTTONS\\UI-SILVER-BUTTON-HIGHLIGHT")
  f:SetHighlightTexture(f.hl)
  end
  
  --text creation
  do
  f.text=f:CreateFontString()
  f.text:SetPoint("CENTER")
  f.text:SetFont("Fonts\\ARIALN.ttf",17,fontExtra)
  f.text:SetTextColor(0.9,0.9,0.9)
  f.text:SetText(para.displayName)
  end
      
  --up and down buttons    
  do
    local text
    f.up=CreateFrame("Button",nil,f)
    f.up:SetPoint("TOPRIGHT",f,"TOPRIGHT",-1,0)
    f.up:SetSize(f:GetHeight()/2,f:GetHeight()/2)
    f.up.parentButton=f

    text=f.up:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
    text:SetRotation(math.pi/2)
    f.up:SetNormalTexture(text)
    
    text=nil
    text=f.up:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
    text:SetRotation(math.pi/2)
    f.up:SetPushedTexture(text)   
    f.up:SetScript("OnClick",moveButtonUpList)

    
    f.down=CreateFrame("Button",nil,f)
    f.down:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-1,2)
    f.down:SetSize(f:GetHeight()/2,f:GetHeight()/2)
    f.down.parentButton=f
    
    text=nil
    text=f.down:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
    text:SetRotation(math.pi/2)
    f.down:SetNormalTexture(text)
    
    text=nil
    text=f.down:CreateTexture(nil,"BACKGROUND")
    text:SetAllPoints()
    text:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
    text:SetRotation(math.pi/2)
    f.down:SetPushedTexture(text)   
    f.down:SetScript("OnClick",moveButtonDownList) 
  end    
  
  --collapsoid
  do
  local cpd
  f.collapsoid=CreateFrame("Button",nil,f)
  cpd=f.collapsoid
  cpd:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",-1,-1)
  cpd:SetSize(15,f:GetHeight()*0.5)
  cpd.buttonIndex=f
  
  local ftex
 
  ftex=cpd:CreateTexture(nil,"BACKGROUND")
  ftex:SetPoint("BOTTOMLEFT",cpd,"BOTTOMLEFT",2,2)
  ftex:SetTexture(arrowDownTexture)
  ftex:SetTexCoord(0,1,0,0.5)
  ftex:SetSize(12,12)
  cpd:SetNormalTexture(ftex)
  
  ftex=nil
  ftex=cpd:CreateTexture(nil,"BACKGROUND")
  ftex:SetPoint("BOTTOMLEFT",cpd,"BOTTOMLEFT",2,2)
  ftex:SetTexture(arrowDownTexture)
  ftex:SetVertexColor(0.5,0.5,0.5)
  ftex:SetTexCoord(0,1,0,0.5)
  ftex:SetSize(12,12)
  cpd:SetPushedTexture(ftex)  
  
  
  cpd:SetScript("OnClick",function()
    cpd.buttonIndex:collapse()
  end)
  
  
  end --end of collapsoid
  
  
end

local function updateFamilyButtonsIndexList()
  local bl=eF.familyButtonsList
  eF.para.familyButtonsIndexList={}
  local bil=eF.para.familyButtonsIndexList
  
  for i=1,#bl do
    if not bl[i].collapsible then table.insert(bil,{bl[i].familyIndex,bl[i].childIndex}) end
  end
  
end

local function setFamilyPositions(self)
  --f:SetPoint("TOPRIGHT",self,"TOPRIGHT",-4,-5-(familyHeight+2)*(n-1))
  local h=0
  local lst=eF.familyButtonsList
  local insert=table.insert
  local rem=table.remove
  local l={}
  local lc={}
  --make sure gorups and children are in line
  for i=1,#lst do
    if lst[i].collapsible then insert(lc,lst[i]) else insert(l,lst[i]) end
  end
  
  for i=1,#l do
    if l[i].group then 
      local j=l[i].familyIndex
      for k=#lc,1,-1 do
        local ce=lc[k]
        if (ce) and (ce.familyIndex==j) then insert(l,i+1,ce); rem(lc,k) end  
      end   
    end 
  end
  
  --hide remaining bastards that were deleted
  for i=1,#lc do lc[i]:Hide() end
  
  --render
  for i=1,#l do
  
    if not l[i].collapsed then
      l[i]:SetPoint("TOPRIGHT",self,"TOPRIGHT",-4,-5-h)
      h=h+l[i]:GetHeight()+2
      if not l[i]:IsShown() then l[i]:Show() end
      
    else
    
      if l[i]:IsShown() then l[i]:Hide() end
      
    end   
  end
  self:SetHeight(h)
  
  eF.familyButtonsList=l
end

local function setSFFActiveValues(self)
  local para=eF.activePara

  --general
  do
  self.name:SetText(para.displayName)
  local typ=para.type
  if typ=="b" then typ="Blacklist" elseif typ=="w" then typ="Whitelist" end
  UIDropDownMenu_SetSelectedName(self.type,typ)
  UIDropDownMenu_SetText(self.type,typ)
  
  UIDropDownMenu_SetSelectedName(self.trackType,para.trackType)
  UIDropDownMenu_SetText(self.trackType,para.trackType)

  self.ignorePermanents:SetChecked(para.ignorePermanents)
  if para.ignoreDurationAbove then self.ignoreDurationAbove:SetText(para.ignoreDurationAbove) else self.ignoreDurationAbove:SetText("nil") end
  self.ownOnly:SetChecked(para.ownOnly)
  
  end

  --layout
  do 
  self.count:SetText(para.count)
  UIDropDownMenu_SetSelectedName(self.grow,para.grow)
  UIDropDownMenu_SetText(self.grow,para.grow)
  self.width:SetText(para.width)
  self.height:SetText(para.height)
  self.spacing:SetText(para.spacing)
  end

  --position
  do
  self.xPos:SetText(para.xPos)
  self.yPos:SetText(para.yPos)
  UIDropDownMenu_SetSelectedName(self.anchor,para.anchor)
  UIDropDownMenu_SetText(self.anchor,para.anchor)
  end
  
  --icon
  do
  self.iconCB:SetChecked(para.hasTexture)
  if not para.hasTexture then self.iconBlocker1:Show(); self.iconBlocker2:Show() else self.iconBlocker1:Hide(); self.iconBlocker2:Hide() end

  self.smartIcon:SetChecked(para.smartIcon)
  if para.hasTexture then if para.smartIcon then self.iconBlocker2:Show() else self.iconBlocker2:Hide() end end
  
  if para.texture then self.icon:SetText(para.texture);self.icon.pTexture:SetTexture(para.texture) end
  
  
  end

  --list
  do
  if para.arg1 and #para.arg1>0 then
    local temps=para.arg1[1]
    for i=2,#para.arg1 do
      temps=temps.."\n"..para.arg1[i]
    end--end of for i=1,#para.arg1 
    self.list.eb:SetText(temps)
  else
    self.list.eb:SetText("")
  end--end of if#para.arg1>0 else
  
  C_Timer.After(0.05,function() self.list.button:Disable()end );

  end--end of list

  --cdWheel
  do
  self.cdWheel:SetChecked(para.cdWheel)
  if not para.cdWheel then self.iconBlocker3:Show() else self.iconBlocker3:Hide() end
  self.cdReverse:SetChecked(para.cdReverse)
  end --end of cdWheel

  --border
  do
  self.hasBorder:SetChecked(para.hasBorder)
  if not para.hasBorder then self.iconBlocker4:Show() else self.iconBlocker4:Hide() end
  UIDropDownMenu_SetSelectedName(self.borderType,para.borderType)
  UIDropDownMenu_SetText(self.borderType,para.borderType)
  end --end of border

  --text1
  do
  self.hasText1:SetChecked(para.hasText)
  if not para.hasText then self.iconBlocker5:Show() else self.iconBlocker5:Hide() end
  UIDropDownMenu_SetSelectedName(self.textType1,para.textType)
  UIDropDownMenu_SetText(self.textType1,para.textType)
  
  self.textColor1.thumb:SetVertexColor(para.textR,para.textG,para.textB)
  self.textDecimals1:SetText(para.textDecimals or 0)

  self.fontSize1:SetText(para.textSize or 12)
  self.textA1:SetText(para.textA or 1)
  
  local font=ssub(para.textFont or "Fonts\\FRIZQT__.ttf",7,-5)
  UIDropDownMenu_SetSelectedName(self.textFont1,font)
  UIDropDownMenu_SetText(self.textFont1,font)
  
  UIDropDownMenu_SetSelectedName(self.textAnchor1,para.textAnchor)
  UIDropDownMenu_SetText(self.textAnchor1,para.textAnchor)
  
  self.textXOS1:SetText(para.textXOS or 0)
  self.textYOS1:SetText(para.textYOS or 0)
  
  
  end --end of text1
  
end --end of setSFFActiveValues func  

local function setCIFActiveValues(self)
  local para=eF.activePara

  --general
  do
  self.name:SetText(para.displayName)
  
  UIDropDownMenu_SetSelectedName(self.trackType,para.trackType)
  UIDropDownMenu_SetText(self.trackType,para.trackType)

  if para.trackType=="Static" then self.iconBlocker6:Show() else self.iconBlocker6:Hide() end

  
  UIDropDownMenu_SetSelectedName(self.trackBy,para.trackBy)
  UIDropDownMenu_SetText(self.trackBy,para.trackBy)
  
  if para.arg1 then self.spell:SetText(para.arg1) else self.spell:SetText("") end
  
  self.ownOnly:SetChecked(para.ownOnly)
  
  end

  --layout
  do 
  self.width:SetText(para.width)
  self.height:SetText(para.height)
  self.xPos:SetText(para.xPos)
  self.yPos:SetText(para.yPos)
  UIDropDownMenu_SetSelectedName(self.anchor,para.anchor)
  UIDropDownMenu_SetText(self.anchor,para.anchor)
  
  end
  
  --icon
  do
  self.iconCB:SetChecked(para.hasTexture)
  if not para.hasTexture then self.iconBlocker1:Show(); self.iconBlocker2:Show() else self.iconBlocker1:Hide(); self.iconBlocker2:Hide() end

  self.smartIcon:SetChecked(para.smartIcon)
  if para.hasTexture then if para.smartIcon then self.iconBlocker2:Show() else self.iconBlocker2:Hide() end end
  
  if para.texture then self.icon:SetText(para.texture);self.icon.pTexture:SetTexture(para.texture) end
  
  
  end

  --cdWheel
  do
  self.cdWheel:SetChecked(para.cdWheel)
  if not para.cdWheel then self.iconBlocker3:Show() else self.iconBlocker3:Hide() end
  self.cdReverse:SetChecked(para.cdReverse)
  end --end of cdWheel

  --border
  do
  self.hasBorder:SetChecked(para.hasBorder)
  if not para.hasBorder then self.iconBlocker4:Show() else self.iconBlocker4:Hide() end
  UIDropDownMenu_SetSelectedName(self.borderType,para.borderType)
  UIDropDownMenu_SetText(self.borderType,para.borderType)
  end --end of border

  --text1
  do
  self.hasText1:SetChecked(para.hasText)
  if not para.hasText then self.iconBlocker5:Show() else self.iconBlocker5:Hide()  end
  UIDropDownMenu_SetSelectedName(self.textType1,para.textType)
  UIDropDownMenu_SetText(self.textType1,para.textType)
  
  self.textColor1.thumb:SetVertexColor(para.textR,para.textG,para.textB)
  self.textDecimals1:SetText(para.textDecimals or 0)

  self.fontSize1:SetText(para.textSize or 12)
  self.textA1:SetText(para.textA or 1)
  
  local font=ssub(para.textFont or "Fonts\\FRIZQT__.ttf",7,-5)
  UIDropDownMenu_SetSelectedName(self.textFont1,font)
  UIDropDownMenu_SetText(self.textFont1,font)
  
  UIDropDownMenu_SetSelectedName(self.textAnchor1,para.textAnchor)
  UIDropDownMenu_SetText(self.textAnchor1,para.textAnchor)
  
  self.textXOS1:SetText(para.textXOS or 0)
  self.textYOS1:SetText(para.textYOS or 0)
  
  
  end --end of text1
  
end --end of setCIFActiveValues func 

--create main frame
do
eF.interface=CreateFrame("Frame","eFInterface",UIParent)
int=eF.interface
int:SetPoint("LEFT",UIParent,"LEFT",200,0)
int:SetHeight(600)
int:SetWidth(850)
int:SetBackdrop(bd)
int:EnableMouse(true)
int:SetAlpha(1)

int.bg=int:CreateTexture(nil,"BACKGROUND")
int.bg:SetPoint("TOPLEFT",int,"TOPLEFT",5,-5)
int.bg:SetPoint("BOTTOMRIGHT",int,"BOTTOMRIGHT",-5,5)
int.bg:SetColorTexture(0.05,0.05,0.05)

MakeMovable(int)
int:Hide()
int.tgl=frameToggle
int:SetFrameLevel(15)
SLASH_ELFRAMO1="/eF"
SlashCmdList["ELFRAMO"]= function(arg)
  int:tgl()
end

end

--create titleframe
do
int.titleBox=CreateFrame("Frame","eFTitle",int)
tb=int.titleBox
tb:SetPoint("RIGHT",int,"TOPRIGHT",9,-8)
tb:SetHeight(35)
tb:SetWidth(100)
tb:SetBackdrop(bd)

tb.text=tb:CreateFontString(nil,"OVERLAY")
tb.text:SetPoint("CENTER",tb,"CENTER",2,0)
tb.text:SetFont(font,17,fontExtra)
tb.text:SetTextColor(0.8,0.8,0.1,1)
tb.text:SetText("elFramo")

tb.bg=tb:CreateTexture(nil,"BACKGROUND")
tb.bg:SetPoint("TOPLEFT",tb,"TOPLEFT",5,-5)
tb.bg:SetPoint("BOTTOMRIGHT",tb,"BOTTOMRIGHT",-5,5)
tb.bg:SetColorTexture(218/250*(1/3),165/250*(1/3),32/250*(1/3))
end

--create header1
do 
int.header1=CreateFrame("Frame","eFHeader",int)
hd1=int.header1
hd1:SetPoint("TOPLEFT",int,"TOPLEFT",15,-25)
hd1:SetPoint("BOTTOMRIGHT",int,"BOTTOMRIGHT",-15,10)
hd1:SetBackdrop(bd)
hd1:SetBackdropColor(0,0,0,0)

hd1.bg=hd1:CreateTexture(nil,"BACKGROUND")
hd1.bg:SetPoint("TOPLEFT",hd1,"TOPLEFT",5,-5)
hd1.bg:SetPoint("BOTTOMRIGHT",hd1,"BOTTOMRIGHT",-5,5)
hd1.bg:SetColorTexture(0.1,0.1,0.1)
end

--create header 1 buttons
do
hd1.button1=CreateFrame("Button","eFHeader1Button1",hd1)
hd1b1=hd1.button1
hd1b1:SetPoint("BOTTOMLEFT",hd1,"TOPLEFT",35,-9)
makeHeader1Button(hd1b1)


hd1.button2=CreateFrame("Button","eFHeader1Button2",hd1)
hd1b2=hd1.button2
hd1b2:SetPoint("BOTTOMLEFT",hd1,"TOPLEFT",140,-9)
makeHeader1Button(hd1b2)
hd1b2.text:SetText("Other stuff")

hd1.button3=CreateFrame("Button","eFHeader1Button3",hd1)
hd1b3=hd1.button3
hd1b3:SetPoint("BOTTOMLEFT",hd1,"TOPLEFT",245,-9)
makeHeader1Button(hd1b3)
hd1b3.text:SetText("Families")
end

--create general settings frame
do
int.generalFrame=CreateFrame("Frame","eFGeneral",hd1)
gf=int.generalFrame
gf:Hide()
hd1b1.relatedFrame=gf
gf:SetAllPoints()
end

--UNIT FRAME
do

gf.frameDim=CreateFrame("Frame",nil,gf)
local fD=gf.frameDim
fD:SetPoint("TOPLEFT",gf,"TOPLEFT",gf:GetWidth()*0.04,-30)
fD:SetHeight(250)
fD:SetWidth(gf:GetWidth()*0.92 )
fD:SetBackdrop(bd2)

--header/title
do
fD.mainTitle=fD:CreateFontString(nil,"OVERLAY")
local t=fD.mainTitle
t:SetFont(titleFont,15,titleFontExtra)
t:SetTextColor(titleFontColor2[1],titleFontColor2[2],titleFontColor2[3])
t:SetText("UNIT FRAME")
t:SetPoint("TOPLEFT",fD,"TOPLEFT",8,-8)

fD.mainTitleSpacer=fD:CreateTexture(nil,"BACKGROUND")
local tS=fD.mainTitleSpacer
tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
tS:SetHeight(9)
tS:SetTexture(titleSpacer)
tS:SetWidth(fD:GetWidth()*0.95)
tS:SetVertexColor(titleFontColor2[1],titleFontColor2[2],titleFontColor2[3])
end 

--Dimensions
do 
fD.title=fD:CreateFontString(nil,"OVERLAY")
local t=fD.title
t:SetFont(titleFont,15,titleFontExtra)
t:SetTextColor(1,1,1)
t:SetText("Dimensions")
t:SetPoint("TOPLEFT",fD,"TOPLEFT",8,-48)

fD.titleSpacer=fD:CreateTexture(nil,"BACKGROUND")
local tS=fD.titleSpacer
tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
tS:SetHeight(8)
tS:SetTexture(titleSpacer)
tS:SetWidth(110)

createNumberEB(fD,"ebHeight",fD)
fD.ebHeight.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
fD.ebHeight.text:SetText("Height:")
fD.ebHeight:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
h=self:GetNumber()
if h==0 then h=eF.para.units.height; self:SetText(h)
else eF.para.units.height=h; eF.units:updateAllParas() end
end)

createNumberEB(fD,"ebWidth",fD)
fD.ebWidth.text:SetPoint("RIGHT",fD.ebHeight.text,"RIGHT",0,-ySpacing)
--fD.ebWidth:SetText(eF.para.units.width) ebWidth:SetText(eF.para.units.width)
fD.ebWidth.text:SetText("Width:")
fD.ebWidth:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
w=self:GetNumber()
if w==0 then w=eF.para.units.width; self:SetText(w)
else eF.para.units.width=w; eF.units:updateAllParas() end
end)

end

--Health Frame
do
fD.title2=fD:CreateFontString(nil,"OVERLAY")
local t=fD.title2
t:SetFont(titleFont,15,titleFontExtra)
t:SetTextColor(1,1,1)
t:SetText("Health Frame")
t:SetPoint("LEFT",fD.title,"LEFT",155,0)

fD.titleSpacer2=fD:CreateTexture(nil,"BACKGROUND")
local tS=fD.titleSpacer2
tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
tS:SetHeight(8)
tS:SetTexture(titleSpacer)
tS:SetWidth(130)

createCB(fD,"hClassColor",fD)
fD.hClassColor.text:SetPoint("TOPLEFT",tS,"TOPLEFT",30,-initSpacing)
--fD.hColor:SetText("byClass")
fD.hClassColor.text:SetText("Class color:")
fD.hClassColor:SetScript("OnClick",function(self)
  local ch=self:GetChecked()
  self:SetChecked(ch)
  fD.hColor.blocked=ch
  eF.para.layout.byClassColor=ch
  if ch then fD.hColor.blocker:Show() else fD.hColor.blocker:Hide() end 
  eF.units.byClassColor=ch
  eF.units:updateAllParas()
end)

createCS(fD,"hColor",fD)
fD.hColor.text:SetPoint("RIGHT",fD.hClassColor.text,"RIGHT",0,-ySpacing)
fD.hColor.text:SetText("Color:")
fD.hColor.getOldRGBA=function(self)
  local r=eF.para.units.hpR
  local g=eF.para.units.hpG
  local b=eF.para.units.hpB
  return r,g,b
end

fD.hColor.opacityFunc=function()
  local r,g,b=ColorPickerFrame:GetColorRGB()
  local a=OpacitySliderFrame:GetValue()
  fD.hColor.thumb:SetVertexColor(r,g,b)
  eF.para.units.hpR=r
  eF.para.units.hpG=g
  eF.para.units.hpB=b
  eF.units.hpR=r
  eF.units.hpG=g
  eF.units.hpB=b
  eF.units:updateAllParas()
end

fD.hColor.blocker=CreateFrame("Frame",nil,fD)
local hCB=fD.hColor.blocker
hCB:SetFrameLevel(fD.hColor:GetFrameLevel()+1)
hCB:SetPoint("TOPRIGHT",fD.hColor,"TOPRIGHT",2,2)
hCB:SetHeight(22)
hCB:SetWidth(120)
hCB.texture=hCB:CreateTexture(nil,"OVERLAY")
hCB.texture:SetAllPoints()
hCB.texture:SetColorTexture(0.1,0.1,0.1,0.5)


createDD(fD,"hDir",fD)
fD.hDir.text:SetPoint("RIGHT",fD.hColor.text,"RIGHT",0,-ySpacing)
--fD.hDir:SetText(eF.para.units.healthGrow) --SETTING INIT VAL
fD.hDir.text:SetText("Orientation:")
fD.hDir.initialize=function(frame,level,menuList)
 local info = UIDropDownMenu_CreateInfo()
 for i=1,#eF.orientations do
   local v=eF.orientations[i]
   info.text, info.checked, info.arg1 = v,false,v
   info.func=function(self,arg1,arg2,checked)
     eF.para.units.healthGrow=arg1
     eF.units.healthGrow=arg1
     eF.units:updateAllParas()
     UIDropDownMenu_SetText(frame,v)
     UIDropDownMenu_SetSelectedName(frame,v)
     CloseDropDownMenus()
   end
   UIDropDownMenu_AddButton(info)
 end
end
UIDropDownMenu_SetWidth(fD.hDir,55)

createNumberEB(fD,"gradStart",fD)
fD.gradStart.text:SetPoint("RIGHT",fD.hDir.text,"RIGHT",0,-ySpacing)
fD.gradStart.text:SetText("Start grad.:")
fD.gradStart:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
eF.para.units.hpGrad1R=n;
eF.para.units.hpGrad1G=n;
eF.para.units.hpGrad1B=n;
eF.units.hpGrad1R=n;
eF.units.hpGrad1G=n;
eF.units.hpGrad1B=n;
eF.units:updateAllParas()
end)

createNumberEB(fD,"gradFinal",fD)
fD.gradFinal.text:SetPoint("RIGHT",fD.gradStart.text,"RIGHT",0,-ySpacing)
fD.gradFinal.text:SetText("Final grad.:")
fD.gradFinal:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
eF.para.units.hpGrad2R=n;
eF.para.units.hpGrad2G=n;
eF.para.units.hpGrad2B=n;
eF.units.hpGrad2R=n;
eF.units.hpGrad2G=n;
eF.units.hpGrad2B=n;
eF.units:updateAllParas()
end)

end--end of Health Frame

--Name
do
fD.title3=fD:CreateFontString(nil,"OVERLAY")
local t=fD.title3
t:SetFont(titleFont,15,titleFontExtra)
t:SetTextColor(1,1,1)
t:SetText("Name")
t:SetPoint("LEFT",fD.title2,"LEFT",185,0)

fD.titleSpacer3=fD:CreateTexture(nil,"BACKGROUND")
local tS=fD.titleSpacer3
tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
tS:SetHeight(8)
tS:SetTexture(titleSpacer)
tS:SetWidth(130)


createCB(fD,"nClassColor",fD)
fD.nClassColor.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
--fD.nColor:SetText("byClass")
fD.nClassColor.text:SetText("Class color:")
fD.nClassColor:SetScript("OnClick",function(self)
  local ch=self:GetChecked()
  self:SetChecked(ch)
  fD.nColor.blocked=ch
  eF.para.units.textColorByClass=ch
  eF.units.textColorByClass=ch
  if ch then fD.nColor.blocker:Show() else fD.nColor.blocker:Hide() end 
  eF.units:updateAllParas()
end)


createCS(fD,"nColor",fD)
fD.nColor.text:SetPoint("RIGHT",fD.nClassColor.text,"RIGHT",0,-ySpacing)
fD.nColor.text:SetText("Color:")
fD.nColor.getOldRGBA=function(self)
  local r=eF.para.units.textR
  local g=eF.para.units.textG
  local b=eF.para.units.textB
  return r,g,b
end

fD.nColor.opacityFunc=function()
  local r,g,b=ColorPickerFrame:GetColorRGB()
  local a=OpacitySliderFrame:GetValue()
  fD.nColor.thumb:SetVertexColor(r,g,b)
  eF.para.units.textR=r
  eF.para.units.textG=g
  eF.para.units.textB=b
  eF.units.textR=r
  eF.units.textG=g
  eF.units.textB=b
  eF.units:updateAllParas()
end

fD.nColor.blocker=CreateFrame("Frame",nil,fD)
local nCB=fD.nColor.blocker
nCB:SetFrameLevel(fD.nColor:GetFrameLevel()+1)
nCB:SetPoint("TOPRIGHT",fD.nColor,"TOPRIGHT",2,2)
nCB:SetHeight(22)
nCB:SetWidth(120)
nCB.texture=nCB:CreateTexture(nil,"OVERLAY")
nCB.texture:SetAllPoints()
nCB.texture:SetColorTexture(0.1,0.1,0.1,0.5)

createNumberEB(fD,"nMax",fD)
fD.nMax.text:SetPoint("RIGHT",fD.nColor.text,"RIGHT",0,-ySpacing)
fD.nMax.text:SetText("Characters:")
fD.nMax:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
if n==0 then n=eF.para.units.textLim; self:SetText(n)
else eF.para.units.textLim=n; eF.units.textLim=n; eF.units:updateAllParas() end
end)

createNumberEB(fD,"nSize",fD)
fD.nSize.text:SetPoint("RIGHT",fD.nMax.text,"RIGHT",0,-ySpacing)
fD.nSize.text:SetText("Font size:")
fD.nSize:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
if n==0 then n=eF.para.units.textSize; self:SetText(n)
else eF.para.units.textSize=n; eF.units.textSize=n; eF.units:updateAllParas() end
end)


createNumberEB(fD,"nAlpha",fD)
fD.nAlpha.text:SetPoint("RIGHT",fD.nSize.text,"RIGHT",0,-ySpacing)
fD.nAlpha.text:SetText("Alpha:")
fD.nAlpha:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
a=self:GetNumber()
eF.para.units.textA=a; eF.units.textA=a; eF.units:updateAllParas()
end)


createDD(fD,"nFont",fD)
fD.nFont.text:SetPoint("RIGHT",fD.nAlpha.text,"RIGHT",0,-ySpacing)
fD.nFont.text:SetText("Font:")
fD.nFont.initialize=function(frame,level,menuList)
 local info = UIDropDownMenu_CreateInfo()
 for i=1,#eF.fonts do
   local v=eF.fonts[i]
   info.text, info.checked, info.arg1 = v,false,v
   info.func=function(self,arg1,arg2,checked)
     eF.para.units.textFont="Fonts\\"..arg1..".ttf"
     eF.units.textFont="Fonts\\"..arg1..".ttf"
     eF.units:updateAllParas()
     UIDropDownMenu_SetText(frame,v)
     UIDropDownMenu_SetSelectedName(frame,v)
     CloseDropDownMenus()
     eF.units:updateAllParas()
   end
   
   UIDropDownMenu_AddButton(info)
 end
end

createDD(fD,"nPos",fD)
fD.nPos.text:SetPoint("RIGHT",fD.nFont.text,"RIGHT",0,-ySpacing)
fD.nPos.text:SetText("Position:")
fD.nPos.initialize=function(frame,level,menuList)
 local info = UIDropDownMenu_CreateInfo()
 for i=1,#eF.positions do
   local v=eF.positions[i]
   info.text, info.checked, info.arg1 = v,false,v
   info.func=function(self,arg1,arg2,checked)
     eF.para.units.textPos=arg1
     eF.units.textPos=arg1
     eF.units:updateAllParas()
     UIDropDownMenu_SetText(frame,v)
     UIDropDownMenu_SetSelectedName(frame,v)
     CloseDropDownMenus()
   end
   UIDropDownMenu_AddButton(info)
 end
end



end--end of Name

--Border
do
fD.title4=fD:CreateFontString(nil,"OVERLAY")
local t=fD.title4
t:SetFont(titleFont,15,titleFontExtra)
t:SetTextColor(1,1,1)
t:SetText("Border")
t:SetPoint("LEFT",fD.title,"LEFT",0,-85)

fD.titleSpacer4=fD:CreateTexture(nil,"BACKGROUND")
local tS=fD.titleSpacer4
tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
tS:SetHeight(8)
tS:SetTexture(titleSpacer)
tS:SetWidth(fD.titleSpacer:GetWidth())

createCS(fD,"bColor",fD)
fD.bColor.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
fD.bColor.text:SetText("Color:")
fD.bColor.getOldRGBA=function(self)
  local r=eF.para.units.borderR
  local g=eF.para.units.borderG
  local b=eF.para.units.borderB
  return r,g,b
end

fD.bColor.opacityFunc=function()
  local r,g,b=ColorPickerFrame:GetColorRGB()
  local a=OpacitySliderFrame:GetValue()
  fD.bColor.thumb:SetVertexColor(r,g,b)
  eF.para.units.borderR=r
  eF.para.units.borderG=g
  eF.para.units.borderB=b
  for i=1,45 do
    local id
    if i<6 then id=eF.partyLoop[i] else id=eF.raidLoop[i-5] end
    eF.units[id]:updateBorders();
  end
end


createNumberEB(fD,"bWid",fD)
fD.bWid.text:SetPoint("RIGHT",fD.bColor.text,"RIGHT",0,-ySpacing)
fD.bWid.text:SetText("Width:")
fD.bWid:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
w=self:GetNumber()
eF.para.units.borderSize=w
eF.units.borderSize=w
for i=1,45 do
  local id
  if i<6 then id=eF.partyLoop[i] else id=eF.raidLoop[i-5] end
  eF.units[id]:updateBorders();
end
end)

end--end of border

end

--FAMILIES FRAME
do
int.familiesFrame=CreateFrame("Frame","eFFamilies",hd1)
ff=int.familiesFrame
ff:Hide()
hd1b3.relatedFrame=ff
ff:SetAllPoints()

local fL,sc

--create Scroll Frame
do
ff.famList=CreateFrame("ScrollFrame","eFFamScroll",ff,"UIPanelScrollFrameTemplate")
fL=ff.famList
fL:SetPoint("TOPLEFT",ff,"TOPLEFT",ff:GetWidth()*0.02,-60)
fL:SetPoint("BOTTOMRIGHT",ff,"BOTTOMLEFT",ff:GetWidth()*0.22,20)
fL:SetClipsChildren(true)
fL:SetScript("OnMouseWheel",ScrollFrame_OnMouseWheel)

--create Border
fL.border=CreateFrame("Frame",nil,ff)
fL.border:SetPoint("TOPLEFT",fL,"TOPLEFT",-5,5)
fL.border:SetPoint("BOTTOMRIGHT",fL,"BOTTOMRIGHT",5,-5)
fL.border:SetBackdrop(bd)


--reposition scrollbar and craete its texture
fL.ScrollBar:ClearAllPoints()
fL.ScrollBar:SetPoint("TOPLEFT",fL,"TOPLEFT",6,-18)
fL.ScrollBar:SetPoint("BOTTOMRIGHT",fL,"BOTTOMLEFT",16,18)
fL.ScrollBar.bg=fL.ScrollBar:CreateTexture(nil,"BACKGROUND")
fL.ScrollBar.bg:SetAllPoints()
fL.ScrollBar.bg:SetColorTexture(0,0,0,0.5) 

--make background
fL.bg=fL:CreateTexture(nil,"BACKGROUND")
fL.bg:SetAllPoints()
fL.bg:SetColorTexture(0,0,0,0.3)

--create scrollchild
fL.scrollChild=CreateFrame("Frame","eFFamScrollChild",fL)
sc=fL.scrollChild
fL:SetScrollChild(sc)
sc.createFamily=createFamily
sc.createChild=createChild
sc.createGroup=createGroup
sc.updateFamilyButtonsIndexList=updateFamilyButtonsIndexList
sc.setFamilyPositions=setFamilyPositions
sc:SetWidth(fL:GetWidth())
sc:SetHeight(600)
sc:SetPoint("TOP",fL,"TOP")
sc.families={}
end

--create smart Family Frame
do
  
  local sff,sfsf
  --create scroll frame + box etc
  do
  ff.smartFamilyScrollFrame=CreateFrame("ScrollFrame","eFSmartFamilyScrollFrame",ff,"UIPanelScrollFrameTemplate")
  sfsf=ff.smartFamilyScrollFrame
  sfsf:SetPoint("TOPLEFT",ff.famList,"TOPRIGHT",20,0)
  sfsf:SetPoint("BOTTOMRIGHT",ff.famList,"BOTTOMRIGHT",20+ff:GetWidth()*0.72,0)
  sfsf:SetClipsChildren(true)
  sfsf:SetScript("OnMouseWheel",ScrollFrame_OnMouseWheel)
  
  sfsf.border=CreateFrame("Frame",nil,ff)
  sfsf.border:SetPoint("TOPLEFT",sfsf,"TOPLEFT",-5,5)
  sfsf.border:SetPoint("BOTTOMRIGHT",sfsf,"BOTTOMRIGHT",5,-5)
  sfsf.border:SetBackdrop(bd)
  
  ff.smartFamilyFrame=CreateFrame("Frame","eFsff",ff)
  sff=ff.smartFamilyFrame
  sff:SetPoint("TOP",sfsf,"TOP",0,-20)
  sff:SetWidth(sfsf:GetWidth()*0.8)
  sff:SetHeight(sfsf:GetHeight()*1.2)
 
  sfsf.ScrollBar:ClearAllPoints()
  sfsf.ScrollBar:SetPoint("TOPRIGHT",sfsf,"TOPRIGHT",-6,-18)
  sfsf.ScrollBar:SetPoint("BOTTOMLEFT",sfsf,"BOTTOMRIGHT",-16,18)
  sfsf.ScrollBar.bg=sfsf.ScrollBar:CreateTexture(nil,"BACKGROUND")
  sfsf.ScrollBar.bg:SetAllPoints()
  sfsf.ScrollBar.bg:SetColorTexture(0,0,0,0.5)
  
  sfsf:SetScrollChild(sff)
  
  sfsf.bg=sfsf:CreateTexture(nil,"BACKGROUND")
  sfsf.bg:SetAllPoints()
  sfsf.bg:SetColorTexture(0.07,0.07,0.07,1)

  sff.setValues=setSFFActiveValues
  end --end of scroll frame + box etc


  --create general settings stuff
  do
  sff.title1=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title1
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("General")
  t:SetPoint("TOPLEFT",sff,"TOPLEFT",50,-25)

  sff.title1Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title1Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createNumberEB(sff,"name",sff)
  sff.name.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.name.text:SetText("Name:")
  sff.name:SetWidth(80)
  sff.name:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  name=self:GetText()
  if not name or name=="" then name=eF.activePara.displayName; self:SetText(name)
  else 
    eF.activePara.displayName=name; 
    eF.activeButton.text:SetText(name)
  end
  end)

  createDD(sff,"type",sff)
  sff.type.text:SetPoint("RIGHT",sff.name.text,"RIGHT",0,-ySpacing)
  sff.type.text:SetText("Type:")
  sff.type.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"Blacklist","Whitelist"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       local rv
       if arg1=="Blacklist" then rv="b" elseif arg1=="Whitelist" then rv="w" end
       eF.activePara.type=rv
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesFamilyParas(eF.activeFamilyIndex)
       
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.type,80)

  createDD(sff,"trackType",sff)
  sff.trackType.text:SetPoint("RIGHT",sff.type.text,"RIGHT",0,-ySpacing)
  sff.trackType.text:SetText("Tracks:")
  sff.trackType.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"Buffs","Debuffs"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.trackType=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesFamilyParas(eF.activeFamilyIndex)

     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.trackType,80)
  
  createCB(sff,"ignorePermanents",sff)
  sff.ignorePermanents.text:SetPoint("RIGHT",sff.trackType.text,"RIGHT",0,-ySpacing)
  sff.ignorePermanents.text:SetText("Ignore permanents:")
  sff.ignorePermanents:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.ignorePermanents=ch
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)

  createNumberEB(sff,"ignoreDurationAbove",sff)
  sff.ignoreDurationAbove.text:SetPoint("RIGHT",sff.ignorePermanents.text,"RIGHT",0,-ySpacing)
  sff.ignoreDurationAbove.text:SetText("Max duration:")
  sff.ignoreDurationAbove:SetWidth(30)
  sff.ignoreDurationAbove:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  count=self:GetText()
  if not count or count=="nil" or count=="" then eF.activePara.ignoreDurationAbove=nil; self:SetText("nil")
  else 
    eF.activePara.ignoreDurationAbove=tonumber(count);
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end
  end)

  createCB(sff,"ownOnly",sff)
  sff.ownOnly.text:SetPoint("RIGHT",sff.ignoreDurationAbove.text,"RIGHT",0,-ySpacing)
  sff.ownOnly.text:SetText("Own only:")
  sff.ownOnly:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.ownOnly=ch
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)
  
  end--end of general settings

  --create layout settings
  do
  sff.title2=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title2
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Layout")
  t:SetPoint("TOPLEFT",sff.title1,"TOPLEFT",220,0)

  sff.title2Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title2Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createNumberEB(sff,"count",sff)
  sff.count.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.count.text:SetText("Count:")
  sff.count:SetWidth(30)
  sff.count:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  count=self:GetNumber()
  if not count or count==0 then count=eF.activePara.count; self:SetText(count)
  else 
    eF.activePara.count=count;
  end
  updateAllFramesFamilyLayout(eF.activeFamilyIndex)

  end)
  --NYI: update without reload

  createDD(sff,"grow",sff)
  sff.grow.text:SetPoint("RIGHT",sff.count.text,"RIGHT",0,-ySpacing)
  sff.grow.text:SetText("Grows:")
  sff.grow.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst=eF.orientations
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.grow=v
       
       if v=="right" then eF.activePara.growAnchor="LEFT"
       elseif v=="left" then eF.activePara.growAnchor="RIGHT"
       elseif v=="up" then eF.activePara.growAnchor="BOTTOM"
       elseif v=="down" then eF.activePara.growAnchor="TOP" end
       
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesFamilyLayout(eF.activeFamilyIndex)

     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.grow,60)

  createNumberEB(sff,"width",sff)
  sff.width.text:SetPoint("RIGHT",sff.grow.text,"RIGHT",0,-ySpacing)
  sff.width.text:SetText("Width:")
  sff.width:SetWidth(30)
  sff.width:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  w=self:GetNumber()
  if not w or w==0 then w=eF.activePara.width; self:SetText(w)
  else 
    eF.activePara.width=w;
  end
  updateAllFramesFamilyLayout(eF.activeFamilyIndex)
  end)

  createNumberEB(sff,"height",sff)
  sff.height.text:SetPoint("RIGHT",sff.width.text,"RIGHT",0,-ySpacing)
  sff.height.text:SetText("Height:")
  sff.height:SetWidth(30)
  sff.height:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  h=self:GetNumber()
  if not h or h==0 then h=eF.activePara.height; self:SetText(h)
  else 
    eF.activePara.height=h;
  end
  updateAllFramesFamilyLayout(eF.activeFamilyIndex)
  end)

  createNumberEB(sff,"spacing",sff)
  sff.spacing.text:SetPoint("RIGHT",sff.height.text,"RIGHT",0,-ySpacing)
  sff.spacing.text:SetText("Spacing:")
  sff.spacing:SetWidth(30)
  sff.spacing:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  s=self:GetNumber()
  if not s or s==0 then s=eF.activePara.spacing; self:SetText(s)
  else 
    eF.activePara.spacing=s;
  end
  updateAllFramesFamilyLayout(eF.activeFamilyIndex)
  end)

  end--end of layout settings

  --create position settings
  do
  sff.title3=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title3
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Position")
  t:SetPoint("TOPLEFT",sff.title1,"TOPLEFT",25,-185)

  sff.title3Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title3Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createNumberEB(sff,"xPos",sff)
  sff.xPos.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.xPos.text:SetText("X Offset:")
  sff.xPos:SetWidth(30)
  sff.xPos:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x then x=eF.activePara.xPos; self:SetText(x); 
  else 
    eF.activePara.xPos=x;
  end
  updateAllFramesFamilyLayout(eF.activeFamilyIndex)
  end)

  createNumberEB(sff,"yPos",sff)
  sff.yPos.text:SetPoint("RIGHT",sff.xPos.text,"RIGHT",0,-ySpacing)
  sff.yPos.text:SetText("Y Offset:")
  sff.yPos:SetWidth(30)
  sff.yPos:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x  then x=eF.activePara.yPos; self:SetText(x)
  else 
    eF.activePara.yPos=x;
  end
  updateAllFramesFamilyLayout(eF.activeFamilyIndex)
  end)

  createDD(sff,"anchor",sff)
  sff.anchor.text:SetPoint("RIGHT",sff.yPos.text,"RIGHT",0,-ySpacing)
  sff.anchor.text:SetText("Position:")
  sff.anchor.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst=eF.positions
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.anchor=v
       eF.activePara.anchorTo=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus() 
       updateAllFramesFamilyLayout(eF.activeFamilyIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.anchor,60)

  end--end of position settings

  --create icon settings
  do
  sff.title4=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title4
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Icon")
  t:SetPoint("TOPLEFT",sff.title3,"TOPLEFT",250,-15)

  sff.title4Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title4Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(sff,"iconCB",sff)
  sff.iconCB.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.iconCB.text:SetText("Has Icon:")
  sff.iconCB:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.hasTexture=ch
    if not ch then sff.iconBlocker1:Show();sff.iconBlocker2:Show() else sff.iconBlocker1:Hide();sff.iconBlocker2:Hide() end
    if eF.activePara.smartIcon then sff.iconBlocker2:Show() end
    eF.activePara.hasTexture=ch
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)


  createCB(sff,"smartIcon",sff)
  sff.smartIcon.text:SetPoint("RIGHT",sff.iconCB.text,"RIGHT",0,-ySpacing)
  sff.smartIcon.text:SetText("Smart Icon:")
  sff.smartIcon:SetScript("OnClick",function(self)
    if sff.iconBlocked1 then self.SetChecked(not self:GetChecked());return end
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.smartIcon=ch
    if ch then sff.iconBlocker2:Show() else sff.iconBlocker2:Hide() end
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)


  sff.iconBlocker1=CreateFrame("Button",nil,sff)
  local iB1=sff.iconBlocker1
  iB1:SetFrameLevel(sff:GetFrameLevel()+3)
  iB1:SetPoint("TOPRIGHT",sff.smartIcon,"TOPRIGHT",2,2)
  iB1:SetPoint("BOTTOMLEFT",sff.smartIcon.text,"BOTTOMLEFT",-2,-2)
  iB1.texture=iB1:CreateTexture(nil,"OVERLAY")
  iB1.texture:SetAllPoints()
  iB1.texture:SetColorTexture(0.07,0.07,0.07,0.4)


  createIP(sff,"icon",sff)
  sff.icon.text:SetPoint("RIGHT",sff.smartIcon.text,"RIGHT",0,-ySpacing)
  sff.icon.text:SetText("Texture:")
  sff.icon:SetWidth(60)
  sff.icon:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  if not x  then x=eF.activePara.texture; self:SetText(x)
  else 
    eF.activePara.texture=x;
    self.pTexture:SetTexture(x)
  end
  end)
  --NYI: update without reload

  sff.iconBlocker2=CreateFrame("Button",nil,sff)
  local iB2=sff.iconBlocker2
  iB2:SetFrameLevel(sff:GetFrameLevel()+3)
  iB2:SetPoint("TOPLEFT",sff.icon.text,"TOPLEFT",-2,12)
  iB2:SetHeight(50)
  iB2:SetWidth(200)
  iB2.texture=iB2:CreateTexture(nil,"OVERLAY")
  iB2.texture:SetAllPoints()
  iB2.texture:SetColorTexture(0.07,0.07,0.07,0.4)



  end --end of icon settings

  --create list EB
  do
  sff.title5=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title5
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("List")
  t:SetPoint("TOPLEFT",sff.title3,"TOPLEFT",-10,-125)

  sff.title5Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title5Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createListCB(sff,"list",sff)
  sff.list:SetPoint("TOPLEFT",tS,"TOPLEFT",0,-initSpacing)
  sff.list.button:SetScript("OnClick", function(self)
  local sfind,ssub,insert=strfind,strsub,table.insert
  local x=self.eb:GetText()
  self:Disable()
  self.eb:ClearFocus()
  local old=0
  local new=0
  local antiCrash=0
  local rtbl={}
  while new do
    new=sfind(x,"\n",old+1)
    local ss=ssub(x,old,new)
    insert(rtbl,ss:match("^%s*(.-)%s*$"))
    old=new
    antiCrash=antiCrash+1
    if antiCrash>500 then break end
  end
  eF.activePara.arg1=rtbl
  updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end) 


  end --end of list EB

  --create CDwheel settings
  do
  sff.title6=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title6
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("CD Wheel")
  t:SetPoint("TOPLEFT",sff.title5,"TOPLEFT",225,0)

  sff.title6Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title6Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(sff,"cdWheel",sff)
  sff.cdWheel.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.cdWheel.text:SetText("Has CD wheel:")
  sff.cdWheel:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.cdWheel=ch
    if not ch then sff.iconBlocker3:Show() else sff.iconBlocker3:Hide() end
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)


  createCB(sff,"cdReverse",sff)
  sff.cdReverse.text:SetPoint("RIGHT",sff.cdWheel.text,"RIGHT",0,-ySpacing)
  sff.cdReverse.text:SetText("Reverse spin:")
  sff.cdReverse:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.cdReverse=ch
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)


  sff.iconBlocker3=CreateFrame("Button",nil,sff)
  local iB3=sff.iconBlocker3
  iB3:SetFrameLevel(sff:GetFrameLevel()+3)
  iB3:SetPoint("TOPLEFT",sff.cdReverse.text,"TOPLEFT",-2,12)
  iB3:SetHeight(50)
  iB3:SetWidth(200)
  iB3.texture=iB3:CreateTexture(nil,"OVERLAY")
  iB3.texture:SetAllPoints()
  iB3.texture:SetColorTexture(0.07,0.07,0.07,0.4)
  end --end of CDwheel settings

  --create border settings
  do
  sff.title7=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title7
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Border")
  t:SetPoint("TOPLEFT",sff.title6,"TOPLEFT",0,-80)

  sff.title7Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title7Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(sff,"hasBorder",sff)
  sff.hasBorder.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.hasBorder.text:SetText("Has Border:")
  sff.hasBorder:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.hasBorder=ch
    if not ch then sff.iconBlocker4:Show() else sff.iconBlocker4:Hide() end
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)
  --NYI not hiding border
  
  createDD(sff,"borderType",sff)
  sff.borderType.text:SetPoint("RIGHT",sff.hasBorder.text,"RIGHT",0,-ySpacing)
  sff.borderType.text:SetText("Border type:")
  sff.borderType.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"debuffColor"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.borderType=v

       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus() 
       updateAllFramesFamilyParas(eF.activeFamilyIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.borderType,60)


  sff.iconBlocker4=CreateFrame("Button",nil,sff)
  local iB4=sff.iconBlocker4
  iB4:SetFrameLevel(sff:GetFrameLevel()+3)
  iB4:SetPoint("TOPLEFT",sff.borderType.text,"TOPLEFT",-2,12)
  iB4:SetHeight(50)
  iB4:SetWidth(200)
  iB4.texture=iB4:CreateTexture(nil,"OVERLAY")
  iB4.texture:SetAllPoints()
  iB4.texture:SetColorTexture(0.07,0.07,0.07,0.4)

  end --end of border settings

  --create text1 settings
  do
  sff.title8=sff:CreateFontString(nil,"OVERLAY")
  local t=sff.title8
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Text 1")
  t:SetPoint("TOPLEFT",sff.title5,"TOPLEFT",0,-200)

  sff.title8Spacer=sff:CreateTexture(nil,"OVERLAY")
  local tS=sff.title8Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(sff,"hasText1",sff)
  sff.hasText1.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  sff.hasText1.text:SetText("Text 1:")
  sff.hasText1:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.hasText=ch
    if not ch then sff.iconBlocker5:Show() else sff.iconBlocker5:Hide() end
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)
  
  createDD(sff,"textType1",sff)
  sff.textType1.text:SetPoint("RIGHT",sff.hasText1.text,"RIGHT",0,-ySpacing)
  sff.textType1.text:SetText("Text type:")
  sff.textType1.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"Time left"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.textType=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus() 
       updateAllFramesFamilyParas(eF.activeFamilyIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.textType1,60)

  
  createCS(sff,"textColor1",sff)
  sff.textColor1.text:SetPoint("RIGHT",sff.textType1.text,"RIGHT",0,-ySpacing)
  sff.textColor1.text:SetText("Color:")
  sff.textColor1.getOldRGBA=function(self)
    local r=eF.activePara.textR
    local g=eF.activePara.textG
    local b=eF.activePara.textB
    return r,g,b
  end

  sff.textColor1.opacityFunc=function()
    local r,g,b=ColorPickerFrame:GetColorRGB()
    local a=OpacitySliderFrame:GetValue()
    sff.textColor1.thumb:SetVertexColor(r,g,b)
    eF.activePara.textR=r
    eF.activePara.textG=g
    eF.activePara.textB=b
    updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end


  createNumberEB(sff,"textDecimals1",sff)
  sff.textDecimals1.text:SetPoint("RIGHT",sff.textColor1.text,"RIGHT",0,-ySpacing)
  sff.textDecimals1.text:SetText("Decimals:")
  sff.textDecimals1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  n=self:GetNumber()
  if not n then n=eF.activePara.textDecimals; self:SetText(n)
  else eF.activePara.textDecimals=n end
  end)

  createNumberEB(sff,"fontSize1",sff)
  sff.fontSize1.text:SetPoint("RIGHT",sff.textDecimals1.text,"RIGHT",0,-ySpacing)
  sff.fontSize1.text:SetText("Font size:")
  sff.fontSize1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  n=self:GetNumber()
  if n==0 then n=eF.activePara.textSize; self:SetText(n)
  else eF.activePara.textSize=n; updateAllFramesFamilyParas(eF.activeFamilyIndex) end
  end)


  createNumberEB(sff,"textA1",sff)
  sff.textA1.text:SetPoint("RIGHT",sff.fontSize1.text,"RIGHT",0,-ySpacing)
  sff.textA1.text:SetText("Alpha:")
  sff.textA1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  a=self:GetNumber()
  eF.activePara.textA=a
  updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)


  createDD(sff,"textFont1",sff)
  sff.textFont1.text:SetPoint("RIGHT",sff.textA1.text,"RIGHT",0,-ySpacing)
  sff.textFont1.text:SetText("Font:")
  sff.textFont1.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   for i=1,#eF.fonts do
     local v=eF.fonts[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.textFont="Fonts\\"..arg1..".ttf"
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesFamilyParas(eF.activeFamilyIndex)
     end
     
     UIDropDownMenu_AddButton(info)
   end
  end

  createDD(sff,"textAnchor1",sff)
  sff.textAnchor1.text:SetPoint("RIGHT",sff.textFont1.text,"RIGHT",0,-ySpacing)
  sff.textAnchor1.text:SetText("Position:")
  sff.textAnchor1.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   for i=1,#eF.positions do
     local v=eF.positions[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.textAnchor=arg1
       eF.activePara.textAnchorTo=arg1
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesFamilyParas(eF.activeFamilyIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end

  
  createNumberEB(sff,"textXOS1",sff)
  sff.textXOS1.text:SetPoint("RIGHT",sff.textAnchor1.text,"RIGHT",0,-ySpacing)
  sff.textXOS1.text:SetText("X Offset:")
  sff.textXOS1:SetWidth(30)
  sff.textXOS1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x then x=eF.activePara.textXOS; self:SetText(x); 
  else 
    eF.activePara.textXOS=x;
  end
  updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)

  createNumberEB(sff,"textYOS1",sff)
  sff.textYOS1.text:SetPoint("RIGHT",sff.textXOS1.text,"RIGHT",0,-ySpacing)
  sff.textYOS1.text:SetText("Y Offset:")
  sff.textYOS1:SetWidth(30)
  sff.textYOS1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x  then x=eF.activePara.textYOS; self:SetText(x)
  else 
    eF.activePara.textYOS=x;
  end
  updateAllFramesFamilyParas(eF.activeFamilyIndex)
  end)

  
  sff.iconBlocker5=CreateFrame("Button",nil,sff)
  local iB5=sff.iconBlocker5
  iB5:SetFrameLevel(sff:GetFrameLevel()+3)
  iB5:SetPoint("TOPLEFT",sff.textType1.text,"TOPLEFT",-2,12)
  iB5:SetPoint("BOTTOMRIGHT",sff.textYOS1,"BOTTOMRIGHT",58,-3)
  iB5:SetWidth(200)
  iB5.texture=iB5:CreateTexture(nil,"OVERLAY")
  iB5.texture:SetAllPoints()
  iB5.texture:SetColorTexture(0.07,0.07,0.07,0.4)

  end --end of text settings
  
end --end of create smart FF

--create dumb family frame
do
ff.dumbFamilyFrame=CreateFrame("Frame","eFDFF",ff)
local dff=ff.dumbFamilyFrame
dff:SetPoint("TOPLEFT",ff.famList.border,"TOPRIGHT",20,0)
dff:SetPoint("BOTTOMRIGHT",ff.famList.border,"BOTTOMRIGHT",20+ff:GetWidth()*0.72,0)
dff:SetBackdrop(bd)

dff.bg=dff:CreateTexture(nil,"BACKGROUND")
dff.bg:SetAllPoints()
dff.bg:SetColorTexture(0,0,0,0.3)

dff.text=dff:CreateFontString(nil,"OVERLAY")
dff.text:SetPoint("CENTER")
dff.text:SetFont(titleFont,20,titleFontExtra)
dff.text:SetTextColor(0.9,0.9,0.9)
dff.text:SetText("dumb Family stuff goes here")
end --end of create dumb FF

--create child icon frame
do
  
  local cisf,cif
  --create scroll frame + box etc
  do
  ff.childIconScrollFrame=CreateFrame("ScrollFrame","eFChildIconScrollFrame",ff,"UIPanelScrollFrameTemplate")
  cisf=ff.childIconScrollFrame
  cisf:SetPoint("TOPLEFT",ff.famList,"TOPRIGHT",20,0)
  cisf:SetPoint("BOTTOMRIGHT",ff.famList,"BOTTOMRIGHT",20+ff:GetWidth()*0.72,0)
  cisf:SetClipsChildren(true)
  cisf:SetScript("OnMouseWheel",ScrollFrame_OnMouseWheel)
  
  cisf.border=CreateFrame("Frame",nil,ff)
  cisf.border:SetPoint("TOPLEFT",cisf,"TOPLEFT",-5,5)
  cisf.border:SetPoint("BOTTOMRIGHT",cisf,"BOTTOMRIGHT",5,-5)
  cisf.border:SetBackdrop(bd)
  
  ff.childIconFrame=CreateFrame("Frame","eFcif",ff)
  cif=ff.childIconFrame
  cif:SetPoint("TOP",cisf,"TOP",0,-20)
  cif:SetWidth(cisf:GetWidth()*0.8)
  cif:SetHeight(cisf:GetHeight()*1.2)
 
  cisf.ScrollBar:ClearAllPoints()
  cisf.ScrollBar:SetPoint("TOPRIGHT",cisf,"TOPRIGHT",-6,-18)
  cisf.ScrollBar:SetPoint("BOTTOMLEFT",cisf,"BOTTOMRIGHT",-16,18)
  cisf.ScrollBar.bg=cisf.ScrollBar:CreateTexture(nil,"BACKGROUND")
  cisf.ScrollBar.bg:SetAllPoints()
  cisf.ScrollBar.bg:SetColorTexture(0,0,0,0.5)
  
  cisf:SetScrollChild(cif)
  
  cisf.bg=cisf:CreateTexture(nil,"BACKGROUND")
  cisf.bg:SetAllPoints()
  cisf.bg:SetColorTexture(0.07,0.07,0.07,1)

  cif.setValues=setCIFActiveValues
  end --end of scroll frame + box etc
  
  --create general settings stuff
  do
  cif.title1=cif:CreateFontString(nil,"OVERLAY")
  local t=cif.title1
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("General")
  t:SetPoint("TOPLEFT",cif,"TOPLEFT",50,-25)

  cif.title1Spacer=cif:CreateTexture(nil,"OVERLAY")
  local tS=cif.title1Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createNumberEB(cif,"name",cif)
  cif.name.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  cif.name.text:SetText("Name:")
  cif.name:SetWidth(80)
  cif.name:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  name=self:GetText()
  if not name or name=="" then name=eF.activePara.displayName; self:SetText(name)
  else 
    eF.activePara.displayName=name; 
    eF.activeButton.text:SetText(name)
  end
  end)

  createDD(cif,"trackType",cif)
  cif.trackType.text:SetPoint("RIGHT",cif.name.text,"RIGHT",0,-ySpacing)
  cif.trackType.text:SetText("Tracks:")
  cif.trackType.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"Buffs","Debuffs","Static"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.trackType=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
       if v=="Static" then cif.iconBlocker6:Show() else cif.iconBlocker6:Hide() end
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(cif.trackType,80)
  
  createDD(cif,"trackBy",cif)
  cif.trackBy.text:SetPoint("RIGHT",cif.trackType.text,"RIGHT",0,-ySpacing)
  cif.trackBy.text:SetText("Track by:")
  cif.trackBy.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"Name"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.trackBy=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)

     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(cif.trackType,80)


  
  createNumberEB(cif,"spell",cif)
  cif.spell.text:SetPoint("RIGHT",cif.trackBy.text,"RIGHT",0,-ySpacing)
  cif.spell.text:SetText("Spell:")
  cif.spell:SetWidth(80)
  cif.spell:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  spell=self:GetText()
  if not spell or spell=="" then spell=eF.activePara.arg1; self:SetText(spell)
  else 
    eF.activePara.arg1=spell;
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end
  end)

  
  createCB(cif,"ownOnly",cif)
  cif.ownOnly.text:SetPoint("RIGHT",cif.spell.text,"RIGHT",0,-ySpacing)
  cif.ownOnly.text:SetText("Own only:")
  cif.ownOnly:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.ownOnly=ch
  end)
  
  cif.iconBlocker6=CreateFrame("Button",nil,cif)
  local iB1=cif.iconBlocker6
  iB1:SetFrameLevel(cif:GetFrameLevel()+3)
  iB1:SetPoint("TOPRIGHT",cif.trackBy,"TOPRIGHT",2,2)
  iB1:SetPoint("BOTTOMLEFT",cif.ownOnly.text,"BOTTOMLEFT",-2,-2)
  iB1.texture=iB1:CreateTexture(nil,"OVERLAY")
  iB1.texture:SetAllPoints()
  iB1.texture:SetColorTexture(0.07,0.07,0.07,0.4)
  
  end--end of general settings

  --create layout settings
  do
  cif.title2=cif:CreateFontString(nil,"OVERLAY")
  local t=cif.title2
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Layout")
  t:SetPoint("TOPLEFT",cif.title1,"TOPLEFT",220,0)

  cif.title2Spacer=cif:CreateTexture(nil,"OVERLAY")
  local tS=cif.title2Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createNumberEB(cif,"width",cif)
  cif.width.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  cif.width.text:SetText("Width:")
  cif.width:SetWidth(30)
  cif.width:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  w=self:GetNumber()
  if not w or w==0 then w=eF.activePara.width; self:SetText(w)
  else 
    eF.activePara.width=w;
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)

  createNumberEB(cif,"height",cif)
  cif.height.text:SetPoint("RIGHT",cif.width.text,"RIGHT",0,-ySpacing)
  cif.height.text:SetText("Height:")
  cif.height:SetWidth(30)
  cif.height:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  h=self:GetNumber()
  if not h or h==0 then h=eF.activePara.height; self:SetText(h)
  else 
    eF.activePara.height=h;
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)
  
  createNumberEB(cif,"xPos",cif)
  cif.xPos.text:SetPoint("RIGHT",cif.height.text,"RIGHT",0,-ySpacing)
  cif.xPos.text:SetText("X Offset:")
  cif.xPos:SetWidth(30)
  cif.xPos:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x then x=eF.activePara.xPos; self:SetText(x); 
  else 
    eF.activePara.xPos=x;
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)

  createNumberEB(cif,"yPos",cif)
  cif.yPos.text:SetPoint("RIGHT",cif.xPos.text,"RIGHT",0,-ySpacing)
  cif.yPos.text:SetText("Y Offset:")
  cif.yPos:SetWidth(30)
  cif.yPos:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x  then x=eF.activePara.yPos; self:SetText(x)
  else 
    eF.activePara.yPos=x;
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)

  createDD(cif,"anchor",cif)
  cif.anchor.text:SetPoint("RIGHT",cif.yPos.text,"RIGHT",0,-ySpacing)
  cif.anchor.text:SetText("Position:")
  cif.anchor.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst=eF.positions
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.anchor=v
       eF.activePara.anchorTo=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus() 
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(cif.anchor,60)

  end--end of layout settings

  --create icon settings
  do
  cif.title3=cif:CreateFontString(nil,"OVERLAY")
  local t=cif.title3
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Icon")
  t:SetPoint("TOPLEFT",cif.title1,"TOPLEFT",0,-170)

  cif.title3Spacer=cif:CreateTexture(nil,"OVERLAY")
  local tS=cif.title3Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(cif,"iconCB",cif)
  cif.iconCB.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  cif.iconCB.text:SetText("Has Icon:")
  cif.iconCB:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.hasTexture=ch
    if not ch then cif.iconBlocker1:Show();cif.iconBlocker2:Show() else cif.iconBlocker1:Hide();cif.iconBlocker2:Hide() end
    if eF.activePara.smartIcon then cif.iconBlocker2:Show() end
    eF.activePara.hasTexture=ch
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)


  createCB(cif,"smartIcon",cif)
  cif.smartIcon.text:SetPoint("RIGHT",cif.iconCB.text,"RIGHT",0,-ySpacing)
  cif.smartIcon.text:SetText("Smart Icon:")
  cif.smartIcon:SetScript("OnClick",function(self)
    if cif.iconBlocked1 then self.SetChecked(not self:GetChecked());return end
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.smartIcon=ch
    if ch then cif.iconBlocker2:Show() else cif.iconBlocker2:Hide() end
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)


  cif.iconBlocker1=CreateFrame("Button",nil,cif)
  local iB1=cif.iconBlocker1
  iB1:SetFrameLevel(cif:GetFrameLevel()+3)
  iB1:SetPoint("TOPRIGHT",cif.smartIcon,"TOPRIGHT",2,2)
  iB1:SetPoint("BOTTOMLEFT",cif.smartIcon.text,"BOTTOMLEFT",-2,-2)
  iB1.texture=iB1:CreateTexture(nil,"OVERLAY")
  iB1.texture:SetAllPoints()
  iB1.texture:SetColorTexture(0.07,0.07,0.07,0.4)


  createIP(cif,"icon",cif)
  cif.icon.text:SetPoint("RIGHT",cif.smartIcon.text,"RIGHT",0,-ySpacing)
  cif.icon.text:SetText("Texture:")
  cif.icon:SetWidth(60)
  cif.icon:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  if not x  then x=eF.activePara.texture; self:SetText(x)
  else 
    eF.activePara.texture=x;
    self.pTexture:SetTexture(x)
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)
  --NYI: update without reload

  cif.iconBlocker2=CreateFrame("Button",nil,cif)
  local iB2=cif.iconBlocker2
  iB2:SetFrameLevel(cif:GetFrameLevel()+3)
  iB2:SetPoint("TOPLEFT",cif.icon.text,"TOPLEFT",-2,12)
  iB2:SetHeight(50)
  iB2:SetWidth(175)
  iB2.texture=iB2:CreateTexture(nil,"OVERLAY")
  iB2.texture:SetAllPoints()
  iB2.texture:SetColorTexture(0.07,0.07,0.07,0.4)



  end --end of icon settings

  --create CDwheel settings
  do
  cif.title4=cif:CreateFontString(nil,"OVERLAY")
  local t=cif.title4
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("CD Wheel")
  t:SetPoint("TOPLEFT",cif.title3,"TOPLEFT",225,0)

  cif.title4Spacer=cif:CreateTexture(nil,"OVERLAY")
  local tS=cif.title4Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(cif,"cdWheel",cif)
  cif.cdWheel.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  cif.cdWheel.text:SetText("Has CD wheel:")
  cif.cdWheel:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.cdWheel=ch
    if not ch then cif.iconBlocker3:Show() else cif.iconBlocker3:Hide() end
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)


  createCB(cif,"cdReverse",cif)
  cif.cdReverse.text:SetPoint("RIGHT",cif.cdWheel.text,"RIGHT",0,-ySpacing)
  cif.cdReverse.text:SetText("Reverse spin:")
  cif.cdReverse:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.cdReverse=ch
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)


  cif.iconBlocker3=CreateFrame("Button",nil,cif)
  local iB3=cif.iconBlocker3
  iB3:SetFrameLevel(cif:GetFrameLevel()+3)
  iB3:SetPoint("TOPLEFT",cif.cdReverse.text,"TOPLEFT",-2,12)
  iB3:SetHeight(50)
  iB3:SetWidth(200)
  iB3.texture=iB3:CreateTexture(nil,"OVERLAY")
  iB3.texture:SetAllPoints()
  iB3.texture:SetColorTexture(0.07,0.07,0.07,0.4)
  end --end of CDwheel settings

  --create border settings
  do
  cif.title5=cif:CreateFontString(nil,"OVERLAY")
  local t=cif.title5
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Border")
  t:SetPoint("TOPLEFT",cif.title4,"TOPLEFT",0,-80)

  cif.title5Spacer=cif:CreateTexture(nil,"OVERLAY")
  local tS=cif.title5Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(cif,"hasBorder",cif)
  cif.hasBorder.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  cif.hasBorder.text:SetText("Has Border:")
  cif.hasBorder:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.hasBorder=ch
    if not ch then cif.iconBlocker4:Show() else cif.iconBlocker4:Hide() end
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)
  --NYI not hiding border
  
  createDD(cif,"borderType",cif)
  cif.borderType.text:SetPoint("RIGHT",cif.hasBorder.text,"RIGHT",0,-ySpacing)
  cif.borderType.text:SetText("Border type:")
  cif.borderType.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"debuffColor"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.borderType=v

       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus() 
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(cif.borderType,60)


  cif.iconBlocker4=CreateFrame("Button",nil,cif)
  local iB4=cif.iconBlocker4
  iB4:SetFrameLevel(cif:GetFrameLevel()+3)
  iB4:SetPoint("TOPLEFT",cif.borderType.text,"TOPLEFT",-2,12)
  iB4:SetHeight(50)
  iB4:SetWidth(200)
  iB4.texture=iB4:CreateTexture(nil,"OVERLAY")
  iB4.texture:SetAllPoints()
  iB4.texture:SetColorTexture(0.07,0.07,0.07,0.4)

  end --end of border settings

  --create text1 settings
  do
  cif.title5=cif:CreateFontString(nil,"OVERLAY")
  local t=cif.title5
  t:SetFont(titleFont,15,titleFontExtra)
  t:SetTextColor(1,1,1)
  t:SetText("Text 1")
  t:SetPoint("TOPLEFT",cif.title3,"TOPLEFT",0,-115)

  cif.title5Spacer=cif:CreateTexture(nil,"OVERLAY")
  local tS=cif.title5Spacer
  tS:SetPoint("TOPLEFT",t,"BOTTOMLEFT",1,5)
  tS:SetHeight(8)
  tS:SetTexture(titleSpacer)
  tS:SetWidth(110)

  createCB(cif,"hasText1",cif)
  cif.hasText1.text:SetPoint("TOPLEFT",tS,"TOPLEFT",25,-initSpacing)
  cif.hasText1.text:SetText("Text 1:")
  cif.hasText1:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.hasText=ch
    if not ch then cif.iconBlocker5:Show() else cif.iconBlocker5:Hide() end
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)
  --NYI not hiding border
  
  createDD(cif,"textType1",cif)
  cif.textType1.text:SetPoint("RIGHT",cif.hasText1.text,"RIGHT",0,-ySpacing)
  cif.textType1.text:SetText("Text type:")
  cif.textType1.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   local lst={"Time left"}
   for i=1,#lst do
     local v=lst[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.textType=v
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus() 
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(cif.textType1,60)

  
  createCS(cif,"textColor1",cif)
  cif.textColor1.text:SetPoint("RIGHT",cif.textType1.text,"RIGHT",0,-ySpacing)
  cif.textColor1.text:SetText("Color:")
  cif.textColor1.getOldRGBA=function(self)
    local r=eF.activePara.textR
    local g=eF.activePara.textG
    local b=eF.activePara.textB
    return r,g,b
  end

  cif.textColor1.opacityFunc=function()
    local r,g,b=ColorPickerFrame:GetColorRGB()
    local a=OpacitySliderFrame:GetValue()
    cif.textColor1.thumb:SetVertexColor(r,g,b)
    eF.activePara.textR=r
    eF.activePara.textG=g
    eF.activePara.textB=b
    updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end


  createNumberEB(cif,"textDecimals1",cif)
  cif.textDecimals1.text:SetPoint("RIGHT",cif.textColor1.text,"RIGHT",0,-ySpacing)
  cif.textDecimals1.text:SetText("Decimals:")
  cif.textDecimals1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  n=self:GetNumber()
  if not n then n=eF.activePara.textDecimals; self:SetText(n)
  else eF.activePara.textDecimals=n end
  end)

  createNumberEB(cif,"fontSize1",cif)
  cif.fontSize1.text:SetPoint("RIGHT",cif.textDecimals1.text,"RIGHT",0,-ySpacing)
  cif.fontSize1.text:SetText("Font size:")
  cif.fontSize1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  n=self:GetNumber()
  if n==0 then n=eF.activePara.textSize; self:SetText(n)
  else eF.activePara.textSize=n; updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex) end
  end)


  createNumberEB(cif,"textA1",cif)
  cif.textA1.text:SetPoint("RIGHT",cif.fontSize1.text,"RIGHT",0,-ySpacing)
  cif.textA1.text:SetText("Alpha:")
  cif.textA1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  a=self:GetNumber()
  eF.activePara.textA=a
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)


  createDD(cif,"textFont1",cif)
  cif.textFont1.text:SetPoint("RIGHT",cif.textA1.text,"RIGHT",0,-ySpacing)
  cif.textFont1.text:SetText("Font:")
  cif.textFont1.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   for i=1,#eF.fonts do
     local v=eF.fonts[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.textFont="Fonts\\"..arg1..".ttf"
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
     end
     
     UIDropDownMenu_AddButton(info)
   end
  end

  createDD(cif,"textAnchor1",cif)
  cif.textAnchor1.text:SetPoint("RIGHT",cif.textFont1.text,"RIGHT",0,-ySpacing)
  cif.textAnchor1.text:SetText("Position:")
  cif.textAnchor1.initialize=function(frame,level,menuList)
   local info = UIDropDownMenu_CreateInfo()
   for i=1,#eF.positions do
     local v=eF.positions[i]
     info.text, info.checked, info.arg1 = v,false,v
     info.func=function(self,arg1,arg2,checked)
       eF.activePara.textAnchor=arg1
       eF.activePara.textAnchorTo=arg1
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
       updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
     end
     UIDropDownMenu_AddButton(info)
   end
  end

  
  createNumberEB(cif,"textXOS1",cif)
  cif.textXOS1.text:SetPoint("RIGHT",cif.textAnchor1.text,"RIGHT",0,-ySpacing)
  cif.textXOS1.text:SetText("X Offset:")
  cif.textXOS1:SetWidth(30)
  cif.textXOS1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x then x=eF.activePara.textXOS; self:SetText(x); 
  else 
    eF.activePara.textXOS=x;
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)

  createNumberEB(cif,"textYOS1",cif)
  cif.textYOS1.text:SetPoint("RIGHT",cif.textXOS1.text,"RIGHT",0,-ySpacing)
  cif.textYOS1.text:SetText("Y Offset:")
  cif.textYOS1:SetWidth(30)
  cif.textYOS1:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetText()
  x=tonumber(x)
  if not x  then x=eF.activePara.textYOS; self:SetText(x)
  else 
    eF.activePara.textYOS=x;
  end
  updateAllFramesChildParas(eF.activeFamilyIndex,eF.activeChildIndex)
  end)

  
  cif.iconBlocker5=CreateFrame("Button",nil,cif)
  local iB5=cif.iconBlocker5
  iB5:SetFrameLevel(cif:GetFrameLevel()+3)
  iB5:SetPoint("TOPLEFT",cif.textType1.text,"TOPLEFT",-2,12)
  iB5:SetPoint("BOTTOMRIGHT",cif.textYOS1,"BOTTOMRIGHT",58,-3)
  iB5:SetWidth(200)
  iB5.texture=iB5:CreateTexture(nil,"OVERLAY")
  iB5.texture:SetAllPoints()
  iB5.texture:SetColorTexture(0.07,0.07,0.07,0.4)

  end --end of text settings

  
end --end of create child icon frame

--create child bar frame
do
ff.childBarFrame=CreateFrame("Frame","eFDFF",ff)
local cbf=ff.childBarFrame
cbf:SetPoint("TOPLEFT",ff.famList.border,"TOPRIGHT",20,0)
cbf:SetPoint("BOTTOMRIGHT",ff.famList.border,"BOTTOMRIGHT",20+ff:GetWidth()*0.72,0)
cbf:SetBackdrop(bd)

cbf.bg=cbf:CreateTexture(nil,"BACKGROUND")
cbf.bg:SetAllPoints()
cbf.bg:SetColorTexture(0,0,0,0.3)

cbf.text=cbf:CreateFontString(nil,"OVERLAY")
cbf.text:SetPoint("CENTER")
cbf.text:SetFont(titleFont,20,titleFontExtra)
cbf.text:SetTextColor(0.9,0.9,0.9)
cbf.text:SetText("child bar frame here")
end --end of create child bar frame

--family + child creation
do

local ecf
--Plus button and select screen
do
ff.elementCreationButton=CreateFrame("Button",nil,ff)
local ecb=ff.elementCreationButton
ecb:SetPoint("BOTTOMLEFT",fL,"TOPLEFT",0,5)
ecb:SetSize(40,40)
ecb:SetBackdrop(bd2)

ecb.plus=ecb:CreateTexture(nil,"BACKGROUND")
ecb.plus:SetAllPoints(true)
ecb.plus:SetTexture(plusTexture)
ecb:SetNormalTexture(ecb.plus)

ecb.hl=ecb:CreateTexture(nil,"BACKGROUND")
ecb.hl:SetPoint("TOPRIGHT",ecb,"TOPRIGHT",3,3)
ecb.hl:SetPoint("BOTTOMLEFT",ecb,"BOTTOMLEFT",-3,-4)
ecb.hl:SetTexture("Interface\\BUTTONS\\ButtonHilight-SquareQuickslot")
ecb:SetHighlightTexture(ecb.hl)

ecb.plus=ecb:CreateTexture(nil,"BACKGROUND")
ecb.plus:SetAllPoints(true)
ecb.plus:SetTexture(plusTexture)
ecb.plus:SetVertexColor(0.5,0.5,0.5)
ecb:SetPushedTexture(ecb.plus)


ff.elementExterminationButton=CreateFrame("Button",nil,ff)
local eeb=ff.elementExterminationButton
eeb:SetPoint("BOTTOMRIGHT",fL,"TOPRIGHT",0,5)
eeb:SetSize(40,40)
eeb:SetBackdrop(bd2)

eeb.plus=eeb:CreateTexture(nil,"BACKGROUND")
eeb.plus:SetAllPoints(true)
eeb.plus:SetTexture(destroyTexture)
eeb:SetNormalTexture(eeb.plus)

eeb.hl=eeb:CreateTexture(nil,"BACKGROUND")
eeb.hl:SetPoint("TOPRIGHT",eeb,"TOPRIGHT",3,3)
eeb.hl:SetPoint("BOTTOMLEFT",eeb,"BOTTOMLEFT",-3,-4)
eeb.hl:SetTexture("Interface\\BUTTONS\\ButtonHilight-SquareQuickslot")
eeb:SetHighlightTexture(eeb.hl)

eeb.plus=eeb:CreateTexture(nil,"BACKGROUND")
eeb.plus:SetAllPoints(true)
eeb.plus:SetTexture(destroyTexture)
eeb.plus:SetVertexColor(0.5,0.5,0.5)
eeb:SetPushedTexture(eeb.plus)

eeb.text=eeb:CreateFontString(nil,"OVERLAY")
eeb.text:SetPoint("LEFT",eeb,"RIGHT",15,0)
eeb.text:SetFont("Fonts\\FRIZQT__.TTF",15,"OUTLINE")
--eeb.text:SetTextColor(titleFontColor)
eeb.text:SetTextColor(1,1,1)

eeb.confirmButton=CreateFrame("Button",nil,eeb,"UIPanelButtonTemplate")
eeb.confirmButton:SetPoint("LEFT",eeb.text,"RIGHT",5,0)
eeb.confirmButton:SetText("Yes")
eeb.confirmButton:SetSize(40,20)
eeb.confirmButton.deleteJ=nil
eeb.confirmButton.deleteK=nil
eeb.confirmButton.textPointer=eeb.text
eeb.confirmButton:Hide()

ff.elementCreationScrollFrame=CreateFrame("ScrollFrame","eFelementCreationScrollFrame",ff,"UIPanelScrollFrameTemplate")
local ecsf=ff.elementCreationScrollFrame
ecsf:SetPoint("TOPLEFT",ff.famList,"TOPRIGHT",20,0)
ecsf:SetPoint("BOTTOMRIGHT",ff.famList,"BOTTOMRIGHT",20+ff:GetWidth()*0.72,0)
ecsf:SetClipsChildren(true)
ecsf:SetScript("OnMouseWheel",ScrollFrame_OnMouseWheel)

ecsf.border=CreateFrame("Frame",nil,ff)
ecsf.border:SetPoint("TOPLEFT",ecsf,"TOPLEFT",-5,5)
ecsf.border:SetPoint("BOTTOMRIGHT",ecsf,"BOTTOMRIGHT",5,-5)
ecsf.border:SetBackdrop(bd)

ff.elementCreationFrame=CreateFrame("Frame","eFecf",ff)
ecf=ff.elementCreationFrame
ecf:SetPoint("TOP",ecsf,"TOP",0,-20)
ecf:SetWidth(ecsf:GetWidth()*0.8)
ecf:SetHeight(ecsf:GetHeight()*0.6)


ecsf.ScrollBar:ClearAllPoints()
ecsf.ScrollBar:SetPoint("TOPRIGHT",ecsf,"TOPRIGHT",-6,-18)
ecsf.ScrollBar:SetPoint("BOTTOMLEFT",ecsf,"BOTTOMRIGHT",-16,18)
ecsf.ScrollBar.bg=ecsf.ScrollBar:CreateTexture(nil,"BACKGROUND")
ecsf.ScrollBar.bg:SetAllPoints()
ecsf.ScrollBar.bg:SetColorTexture(0,0,0,0.5)

ecsf:SetScrollChild(ecf)


ecsf.bg=ecsf:CreateTexture(nil,"BACKGROUND")
ecsf.bg:SetAllPoints()
ecsf.bg:SetColorTexture(0.07,0.07,0.07,1)

ecb:SetScript("OnClick",function() 
  releaseAllFamilies()
  hideAllFamilyParas()
  ecsf:Show()
end)

eeb:SetScript("OnClick",function(self)
  self.confirmButton.deleteJ=eF.activeButton.familyIndex
  self.confirmButton.deleteK=eF.activeButton.childIndex
  local j,k=eF.activeButton.familyIndex,eF.activeButton.childIndex
  local name
  if k then name=eF.para.families[j][k].displayName else name=eF.para.families[j].displayName end
  eeb.text:SetText('Are you sure you want to delete "'..name..'" ')
  eeb.confirmButton:Show()
end)

eeb.confirmButton:SetScript("OnClick",function(self)
  local j,k=self.deleteJ,self.delete
  if j==1 and not k then return end
  if k then exterminateChild(j,k)
  else
    if eF.activeButton.smart then exterminateSmartFamily(j) else exterminateDumbFamily(j) end
  end
  releaseAllFamilies()
  hideAllFamilyParas()
  self.textPointer:SetText("")
  self:Hide()
end)


end --end of plus button + select

--Populate select screen (ecb)
do
local cwlb,cblb,cib,cbb,cgb

--create whitelist button (cwlb)
do
ecf.createWhitelistButton=CreateFrame("Button",nil,ecf)
cwlb=ecf.createWhitelistButton
cwlb:SetPoint("TOPLEFT",ecf,"TOPLEFT",80,-40)
cwlb:SetSize(150,80)

cwlb.border=CreateFrame("Frame",nil,cwlb)
cwlb.border:SetPoint("TOPRIGHT",cwlb,"TOPRIGHT",3,3)
cwlb.border:SetPoint("BOTTOMLEFT",cwlb,"BOTTOMLEFT",-3,-3)
cwlb.border:SetBackdrop(bd2)

cwlb.nT=cwlb:CreateTexture(nil,"BACKGROUND")
cwlb.nT:SetAllPoints(true)
cwlb.nT:SetColorTexture(0.2,0.25,0.2,1)
cwlb.nT:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
cwlb:SetNormalTexture(cwlb.nT)

cwlb.hl=cwlb:CreateTexture(nil,"BACKGROUND")
cwlb.hl:SetAllPoints(true)
cwlb.hl:SetColorTexture(0.6,0.8,0.4)
cwlb.hl:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cwlb.hl:SetAlpha(0.4)
cwlb:SetHighlightTexture(cwlb.hl)

cwlb.pT=cwlb:CreateTexture(nil,"BACKGROUND")
cwlb.pT:SetAllPoints(true)
cwlb.pT:SetColorTexture(0.6,0.8,0.4)
cwlb.pT:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cwlb:SetPushedTexture(cwlb.pT)

cwlb.text=cwlb:CreateFontString(nil,"OVERLAY")
cwlb.text:SetFont("Fonts\\FRIZQT__.TTF",19,"OUTLINE")
cwlb.text:SetText("Create Whitelist")
cwlb.text:SetTextColor(1,1,1) 
cwlb.text:SetPoint("CENTER")

cwlb.descripton=cwlb:CreateFontString(nil,"OVERLAY")
cwlb.descripton:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
cwlb.descripton:SetText("")
cwlb.descripton:SetPoint("TOP",cwlb,"BOTTOM",0,-8)

cwlb:SetScript("OnClick",function()
local j=#eF.para.families+1
createNewWhitelistParas(j)
createAllFamilyFrame(j)
sc:createFamily(j)
sc:setFamilyPositions()
eF.familyButtonsList[#eF.familyButtonsList]:SetButtonState("PUSHED")
eF.familyButtonsList[#eF.familyButtonsList]:Click()
afterDo(0, function() fL:SetVerticalScroll(fL:GetVerticalScrollRange()) end)
updateAllFramesFamilyLayout(j)
end)

end --end of create whitelist button

--create blacklist button (cblb)
do
ecf.createBlacklistButton=CreateFrame("Button",nil,ecf)
cblb=ecf.createBlacklistButton
cblb:SetPoint("TOP",cwlb,"BOTTOM",0,-40)
cblb:SetSize(150,80)

cblb.border=CreateFrame("Frame",nil,cblb)
cblb.border:SetPoint("TOPRIGHT",cblb,"TOPRIGHT",3,3)
cblb.border:SetPoint("BOTTOMLEFT",cblb,"BOTTOMLEFT",-3,-3)
cblb.border:SetBackdrop(bd2)

cblb.nT=cblb:CreateTexture(nil,"BACKGROUND")
cblb.nT:SetAllPoints(true)
cblb.nT:SetColorTexture(0.2,0.25,0.2,1)
cblb.nT:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
cblb:SetNormalTexture(cblb.nT)

cblb.hl=cblb:CreateTexture(nil,"BACKGROUND")
cblb.hl:SetAllPoints(true)
cblb.hl:SetColorTexture(0.6,0.8,0.4)
cblb.hl:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cblb.hl:SetAlpha(0.4)
cblb:SetHighlightTexture(cblb.hl)

cblb.pT=cblb:CreateTexture(nil,"BACKGROUND")
cblb.pT:SetAllPoints(true)
cblb.pT:SetColorTexture(0.6,0.8,0.4)
cblb.pT:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cblb:SetPushedTexture(cblb.pT)

cblb.text=cblb:CreateFontString(nil,"OVERLAY")
cblb.text:SetFont("Fonts\\FRIZQT__.TTF",19,"OUTLINE")
cblb.text:SetText("Create Blacklist")
cblb.text:SetTextColor(1,1,1) 
cblb.text:SetPoint("CENTER")

cblb.descripton=cblb:CreateFontString(nil,"OVERLAY")
cblb.descripton:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
cblb.descripton:SetText("")
cblb.descripton:SetPoint("TOP",cblb,"BOTTOM",0,-8)

cblb:SetScript("OnClick",function()
local j=#eF.para.families+1
createNewBlacklistParas(j)
createAllFamilyFrame(j)
sc:createFamily(j)
sc:setFamilyPositions()
eF.familyButtonsList[#eF.familyButtonsList]:SetButtonState("PUSHED")
eF.familyButtonsList[#eF.familyButtonsList]:Click()
afterDo(0, function() fL:SetVerticalScroll(fL:GetVerticalScrollRange()) end)
updateAllFramesFamilyLayout(j)
end)
end --end of create blacklist button

--create group button (cgb)
do
ecf.createGroupButton=CreateFrame("Button",nil,ecf)
cgb=ecf.createGroupButton
cgb:SetPoint("TOP",cblb,"BOTTOM",0,-40)
cgb:SetSize(150,80)

cgb.border=CreateFrame("Frame",nil,cgb)
cgb.border:SetPoint("TOPRIGHT",cgb,"TOPRIGHT",3,3)
cgb.border:SetPoint("BOTTOMLEFT",cgb,"BOTTOMLEFT",-3,-3)
cgb.border:SetBackdrop(bd2)

cgb.nT=cgb:CreateTexture(nil,"BACKGROUND")
cgb.nT:SetAllPoints(true)
cgb.nT:SetColorTexture(0.15,0.22,0.4,1)
cgb.nT:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
cgb:SetNormalTexture(cgb.nT)
  
cgb.hl=cgb:CreateTexture(nil,"BACKGROUND")
cgb.hl:SetAllPoints(true)
cgb.hl:SetColorTexture(0.32,0.51,0.8)
cgb.hl:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cgb.hl:SetAlpha(0.4)
cgb:SetHighlightTexture(cgb.hl)

cgb.pT=cgb:CreateTexture(nil,"BACKGROUND")
cgb.pT:SetAllPoints(true)
cgb.pT:SetColorTexture(0.32,0.51,0.8)
cgb.pT:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cgb:SetPushedTexture(cgb.pT)

cgb.text=cgb:CreateFontString(nil,"OVERLAY")
cgb.text:SetFont("Fonts\\FRIZQT__.TTF",19,"OUTLINE")
cgb.text:SetText("Create Group")
cgb.text:SetTextColor(1,1,1) 
cgb.text:SetPoint("CENTER")

cgb.descripton=cgb:CreateFontString(nil,"OVERLAY")
cgb.descripton:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
cgb.descripton:SetText("")
cgb.descripton:SetPoint("TOP",cgb,"BOTTOM",0,-8)

cgb:SetScript("OnClick",function()
local j=#eF.para.families+1
createNewGroupParas(j)
createAllFamilyFrame(j)
sc:createGroup(j)
sc:setFamilyPositions()
eF.familyButtonsList[#eF.familyButtonsList]:SetButtonState("PUSHED")
eF.familyButtonsList[#eF.familyButtonsList]:Click()
afterDo(0, function() fL:SetVerticalScroll(fL:GetVerticalScrollRange()) end)
updateAllFramesFamilyLayout(j)
end)
end --end of create blacklist button

--create icon button (cib)
do
ecf.createIconButton=CreateFrame("Button",nil,ecf)
cib=ecf.createIconButton
cib:SetPoint("TOPRIGHT",ecf,"TOPRIGHT",0,-40)
cib:SetSize(150,80)

cib.border=CreateFrame("Frame",nil,cib)
cib.border:SetPoint("TOPRIGHT",cib,"TOPRIGHT",3,3)
cib.border:SetPoint("BOTTOMLEFT",cib,"BOTTOMLEFT",-3,-3)
cib.border:SetBackdrop(bd2)

cib.nT=cib:CreateTexture(nil,"BACKGROUND")
cib.nT:SetAllPoints(true)
cib.nT:SetColorTexture(0.28,0.2,0.2,1)
cib.nT:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
cib:SetNormalTexture(cib.nT)

cib.hl=cib:CreateTexture(nil,"BACKGROUND")
cib.hl:SetAllPoints(true)
cib.hl:SetColorTexture(0.8,0.4,0.4)
cib.hl:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cib.hl:SetAlpha(0.4)
cib:SetHighlightTexture(cib.hl)

cib.pT=cib:CreateTexture(nil,"BACKGROUND")
cib.pT:SetAllPoints(true)
cib.pT:SetColorTexture(0.8,0.4,0.4)
cib.pT:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cib:SetPushedTexture(cib.pT)

cib.text=cib:CreateFontString(nil,"OVERLAY")
cib.text:SetFont("Fonts\\FRIZQT__.TTF",19,"OUTLINE")
cib.text:SetText("Create Icon")
cib.text:SetTextColor(1,1,1) 
cib.text:SetPoint("CENTER")

cib.descripton=cib:CreateFontString(nil,"OVERLAY")
cib.descripton:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
cib.descripton:SetText("")
cib.descripton:SetPoint("TOP",cib,"BOTTOM",0,-8)

cib:SetScript("OnClick",function()
local j=1
local k=eF.para.families[j].count+1
eF.para.families[j].count=k

createNewIconParas(j,k)
createAllIconFrame(j,k)
sc:createChild(j,k)
sc:setFamilyPositions()
eF.familyButtonsList[#eF.familyButtonsList]:SetButtonState("PUSHED")
eF.familyButtonsList[#eF.familyButtonsList]:Click()
afterDo(0, function() fL:SetVerticalScroll(fL:GetVerticalScrollRange()) end)
end)

end --end of icon creation button 

--create bar button (cbb)
do
ecf.createBarButton=CreateFrame("Button",nil,ecf)
cbb=ecf.createBarButton
cbb:SetPoint("TOP",cib,"BOTTOM",0,-40)
cbb:SetSize(150,80)

cbb.border=CreateFrame("Frame",nil,cbb)
cbb.border:SetPoint("TOPRIGHT",cbb,"TOPRIGHT",3,3)
cbb.border:SetPoint("BOTTOMLEFT",cbb,"BOTTOMLEFT",-3,-3)
cbb.border:SetBackdrop(bd2)

cbb.nT=cbb:CreateTexture(nil,"BACKGROUND")
cbb.nT:SetAllPoints(true)
cbb.nT:SetColorTexture(0.28,0.2,0.2,1)
cbb.nT:SetGradient("vertical",0.5,0.5,0.5,0.8,0.8,0.8)
cbb:SetNormalTexture(cbb.nT)

cbb.hl=cbb:CreateTexture(nil,"BACKGROUND")
cbb.hl:SetAllPoints(true)
cbb.hl:SetColorTexture(0.8,0.4,0.4)
cbb.hl:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cbb.hl:SetAlpha(0.4)
cbb:SetHighlightTexture(cbb.hl)

cbb.pT=cbb:CreateTexture(nil,"BACKGROUND")
cbb.pT:SetAllPoints(true)
cbb.pT:SetColorTexture(0.8,0.4,0.4)
cbb.pT:SetGradient("vertical",0.1,0.1,0.1,0.4,0.4,0.4)
cbb:SetPushedTexture(cbb.pT)

cbb.text=cbb:CreateFontString(nil,"OVERLAY")
cbb.text:SetFont("Fonts\\FRIZQT__.TTF",19,"OUTLINE")
cbb.text:SetText("Create Bar")
cbb.text:SetTextColor(1,1,1) 
cbb.text:SetPoint("CENTER")

cbb.descripton=cbb:CreateFontString(nil,"OVERLAY")
cbb.descripton:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
cbb.descripton:SetText("")
cbb.descripton:SetPoint("TOP",cbb,"BOTTOM",0,-8)
end --end of create bar button

end 

end --end of creation

end--end of family frames










