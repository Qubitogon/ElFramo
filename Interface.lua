local _,eF=...
--see OptionsPanelTemplates.xml
local font="Fonts\\FRIZQT__.ttf"
local font2="Fonts\\ARIALN.ttf"
local border1="Interface\\Tooltips\\UI-Tooltip-Border"
local fontExtra="OUTLINE"
local smallBreak="Interface\\QUESTFRAME\\UI-HorizontalBreak"
local largeBreak="Interface\\MailFrame\\MailPopup-Divider"
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
  local fam=eF.interface.familiesFrame.famList.scrollChild.families
  
  for i=1,#fam do
    fam[i]:Enable()
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
    self:SetText(self:GetText()..'\n')
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
  ff.smartFamilyFrame:Hide()
end

local function showSmartFamilyPara()
  local sff=eF.interface.familiesFrame.smartFamilyFrame
  sff:Show()
  sff:setValues()
end

local function showDumbFamilyPara()
  local dff=eF.interface.familiesFrame.dumbFamilyFrame
  dff:Show()
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

--http://wowwiki.wikia.com/wiki/UIOBJECT_ColorSelect
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

local function createFamily(self,n)

  local para=eF.para.families[n]
  if self.families[n] then self.families[n]=nil end
  
  --button creation
  self.families[n]=CreateFrame("Button",nil,self)
  local f=self.families[n]
  f:SetWidth(eF.interface.familiesFrame.famList:GetWidth()-25)
  f:SetHeight(familyHeight)
  f:SetPoint("TOPRIGHT",self,"TOPRIGHT",-4,-5-(familyHeight+2)*(n-1))
  f:SetBackdrop(bd2)
  f.para=para
  
  f:SetScript("OnClick",function(self)
    releaseAllFamilies()
    hideAllFamilyParas()
    eF.activePara=para
    eF.activeButton=self
    if self.para.smart then showSmartFamilyPara() else showDumbFamilyPara() end
    self:Disable()
    end)
  
  -- normal texture
  do
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
  f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
  f.bg:SetColorTexture(1,1,1,0.1)
  f:SetNormalTexture(f.bg)
  end
   
   
  --pushed texture
  do
  f.bg=f:CreateTexture(nil,"BACKGROUND")
  f.bg:SetPoint("TOPLEFT",f,"TOPLEFT",3,-3)
  f.bg:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-3,3)
  f.bg:SetColorTexture(0.9,0.9,0.6,0.3)
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
  end--end of if#para.arg1>0
  
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

end --end of setSFFActiveValues func  

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
else eF.para.units.height=h; eF.units:updateSize() end
end)

createNumberEB(fD,"ebWidth",fD)
fD.ebWidth.text:SetPoint("RIGHT",fD.ebHeight.text,"RIGHT",0,-ySpacing)
--fD.ebWidth:SetText(eF.para.units.width) ebWidth:SetText(eF.para.units.width)
fD.ebWidth.text:SetText("Width:")
fD.ebWidth:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
w=self:GetNumber()
if w==0 then w=eF.para.units.width; self:SetText(w)
else eF.para.units.width=w; eF.units:updateSize() end
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
  eF.units:updateHealthVis()
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
  eF.units:updateHealthVis()
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
     eF.units:updateHealthVis()
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
eF.units:updateGrad() 
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
eF.units:updateGrad() 
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
  eF.units:updateTextColor() 
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
  eF.units:updateTextColor()
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
else eF.para.units.textLim=n; eF.units.textLim=n; eF.units:updateTextLim() end
end)

createNumberEB(fD,"nSize",fD)
fD.nSize.text:SetPoint("RIGHT",fD.nMax.text,"RIGHT",0,-ySpacing)
fD.nSize.text:SetText("Font size:")
fD.nSize:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
if n==0 then n=eF.para.units.textSize; self:SetText(n)
else eF.para.units.textSize=n; eF.units.textSize=n; eF.units:updateTextFont() end
end)


createNumberEB(fD,"nAlpha",fD)
fD.nAlpha.text:SetPoint("RIGHT",fD.nSize.text,"RIGHT",0,-ySpacing)
fD.nAlpha.text:SetText("Alpha:")
fD.nAlpha:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
a=self:GetNumber()
eF.para.units.textA=a; eF.units.textA=a; eF.units:updateTextColor() 
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
     eF.units:updateTextPos()
     UIDropDownMenu_SetText(frame,v)
     UIDropDownMenu_SetSelectedName(frame,v)
     CloseDropDownMenus()
     eF.units:updateTextFont()
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
     eF.units:updateTextPos()
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
--fL:HookScript("OnMouseWheel",function()  print("scsr") end)
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
sc:SetWidth(fL:GetWidth())
sc:SetHeight(600)
sc:SetPoint("TOP",fL,"TOP")
sc.families={}
end

--create smart Family Frame
do
  ff.smartFamilyFrame=CreateFrame("Frame","eFSFF",ff)
  local sff=ff.smartFamilyFrame
  sff:SetPoint("TOPLEFT",ff.famList.border,"TOPRIGHT",20,0)
  sff:SetPoint("BOTTOMRIGHT",ff.famList.border,"BOTTOMRIGHT",20+ff:GetWidth()*0.72,0)
  sff:SetBackdrop(bd)

  sff.bg=sff:CreateTexture(nil,"BACKGROUND")
  sff.bg:SetAllPoints()
  sff.bg:SetColorTexture(0.07,0.07,0.07,1)


  sff.setValues=setSFFActiveValues

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
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.type,80)
  --NYI: update without reload

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
       eF.activePara.trackType=rv
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.trackType,80)
  --NYI: update without reload

  
  createCB(sff,"ignorePermanents",sff)
  sff.ignorePermanents.text:SetPoint("RIGHT",sff.trackType.text,"RIGHT",0,-ySpacing)
  sff.ignorePermanents.text:SetText("Ignore permanents:")
  sff.ignorePermanents:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.ignorePermanents=ch
  end)
  --NYI: update without reload

  createNumberEB(sff,"ignoreDurationAbove",sff)
  sff.ignoreDurationAbove.text:SetPoint("RIGHT",sff.ignorePermanents.text,"RIGHT",0,-ySpacing)
  sff.ignoreDurationAbove.text:SetText("Max duration:")
  sff.ignoreDurationAbove:SetWidth(30)
  sff.ignoreDurationAbove:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  count=self:GetNumber()
  if not count or count=="" then eF.activePara.ignoreDurationAbove=nil; self:SetText("nil")
  else 
    eF.activePara.ignoreDurationAbove=count;
  end
  end)
  --NYI: update without reload

  createCB(sff,"ownOnly",sff)
  sff.ownOnly.text:SetPoint("RIGHT",sff.ignoreDurationAbove.text,"RIGHT",0,-ySpacing)
  sff.ownOnly.text:SetText("Own only:")
  sff.ownOnly:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.ownOnly=ch
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
       UIDropDownMenu_SetText(frame,v)
       UIDropDownMenu_SetSelectedName(frame,v)
       CloseDropDownMenus()
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.grow,60)
  --NYI: update without reload

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
  end)
  --NYI: update without reload

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
  end)
  --NYI: update without reload

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
  end)
  --NYI: update without reload

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
  sff.count:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetNumber()
  if not x  then x=eF.activePara.xPos; self:SetText(x)
  else 
    eF.activePara.xPos=x;
  end
  end)
  --NYI: update without reload

  createNumberEB(sff,"yPos",sff)
  sff.yPos.text:SetPoint("RIGHT",sff.xPos.text,"RIGHT",0,-ySpacing)
  sff.yPos.text:SetText("Y Offset:")
  sff.yPos:SetWidth(30)
  sff.count:SetScript("OnEnterPressed", function(self)
  self:ClearFocus()
  x=self:GetNumber()
  if not x  then x=eF.activePara.yPos; self:SetText(y)
  else 
    eF.activePara.yPos=x;
  end
  end)
  --NYI: update without reload

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
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.grow,60)
  --NYI: update without reload

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
  end)
  --NYI: update without reload


  createCB(sff,"smartIcon",sff)
  sff.smartIcon.text:SetPoint("RIGHT",sff.iconCB.text,"RIGHT",0,-ySpacing)
  sff.smartIcon.text:SetText("Smart Icon:")
  sff.smartIcon:SetScript("OnClick",function(self)
    if sff.iconBlocked1 then self.SetChecked(not self:GetChecked());return end
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.smartIcon=ch
    if ch then sff.iconBlocker2:Show() else sff.iconBlocker2:Hide() end
  end)
  --NYI: update without reload


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
  end) 
  --NYI: update without reload


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
  end)
  --NYI: update without reload


  createCB(sff,"cdReverse",sff)
  sff.cdReverse.text:SetPoint("RIGHT",sff.cdWheel.text,"RIGHT",0,-ySpacing)
  sff.cdReverse.text:SetText("Reverse spin:")
  sff.cdReverse:SetScript("OnClick",function(self)
    local ch=self:GetChecked()
    self:SetChecked(ch)
    eF.activePara.cdReverse=ch
  end)
  --NYI: update without reload


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
  end)
  --NYI: update without reload

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
     end
     UIDropDownMenu_AddButton(info)
   end
  end
  UIDropDownMenu_SetWidth(sff.grow,60)


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


end--end of family frames


local function intSetInitValues()
  local int=eF.interface
  local gF=int.generalFrame
  local fD=gF.frameDim
  local para=eF.para
  local units=para.units
  local layout=para.layout
  local ssub=string.sub
  local ff=int.familiesFrame
  local fL=ff.famList
  local sc=ff.famList.scrollChild
  local paraFam=eF.para.families
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
  
  for i=1,#paraFam do
    sc:createFamily(i)
  end
  hideAllFamilyParas()
  
  end
  
end
eF.rep.intSetInitValues=intSetInitValues










