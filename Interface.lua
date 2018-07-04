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
local int,tb,hd1,hd1b1,hd1b2,hd1b3,gf

function header1ReleaseAll()
  hd1.button1:Enable()
  hd1.button2:Enable()
  hd1.button3:Enable()
  if hd1.button1.relatedFrame then hd1.button1.relatedFrame:Hide() end
  if hd1.button2.relatedFrame then hd1.button2.relatedFrame:Hide() end
  if hd1.button3.relatedFrame then hd1.button3.relatedFrame:Hide() end
end

function makeHeader1Button(self)
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
  tx:SetPoint("RIGHT",eb,"LEFT",-12,0)
end

local function createDD(self,name,tab)
  self[name]=CreateFrame("Frame","eFDropDown"..name,tab,"UIDropDownMenuTemplate")
  local dd=self[name]
  UIDropDownMenu_SetWidth(dd,70)


  dd.text=dd:CreateFontString()
  local tx=dd.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)
  tx:SetPoint("RIGHT",dd,"LEFT",10,0)
end

local function createCB(self,name,tab)
  self[name]=CreateFrame("CHeckButton",nil,tab,"ChatConfigCheckButtonTemplate")
  local cb=self[name]

  cb.text=cb:CreateFontString()
  local tx=cb.text
  tx:SetFont(font,12,fontExtra)
  tx:SetTextColor(1,1,1)
  tx:SetPoint("RIGHT",cb,"LEFT",-12,0)
  
  
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
  tx:SetPoint("RIGHT",cp,"LEFT",-12,0)
end

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

gf.frameDim=CreateFrame("Frame",nil,gf)
local fD=gf.frameDim
fD:SetPoint("TOPLEFT",gf,"TOPLEFT",gf:GetWidth()*0.04,-30)
fD:SetHeight(250)
fD:SetWidth(gf:GetWidth()*0.92 )
fD:SetBackdrop(bd2)

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

createNumberEB(fD,"ebHeight",gf)
fD.ebHeight:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-15)
fD.ebHeight.text:SetText("Height:")
fD.ebHeight:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
h=self:GetNumber()
if h==0 then h=eF.para.units.height; self:SetText(h)
else eF.para.units.height=h; eF.units:updateSize() end
end)

createNumberEB(fD,"ebWidth",gf)
fD.ebWidth:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-40)
--fD.ebWidth:SetText(eF.para.units.width) ebWidth:SetText(eF.para.units.width)
fD.ebWidth.text:SetText("Width:")
fD.ebWidth:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
w=self:GetNumber()
if w==0 then w=eF.para.units.width; self:SetText(w)
else eF.para.units.width=w; eF.units:updateSize() end
end)

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

createCB(fD,"hClassColor",gf)
fD.hClassColor:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-15)
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

createCS(fD,"hColor",gf)
fD.hColor:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-40)
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

fD.hColor.blocker=CreateFrame("Frame",nil,gf)
local hCB=fD.hColor.blocker
hCB:SetFrameLevel(fD.hColor:GetFrameLevel()+1)
hCB:SetPoint("TOPRIGHT",fD.hColor,"TOPRIGHT",2,2)
hCB:SetHeight(22)
hCB:SetWidth(120)
hCB.texture=hCB:CreateTexture(nil,"OVERLAY")
hCB.texture:SetAllPoints()
hCB.texture:SetColorTexture(0.1,0.1,0.1,0.5)


createDD(fD,"hDir",gf)
fD.hDir:SetPoint("TOPLEFT",fD.hClassColor,"TOPLEFT",-22,-46)
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

--[[
createNumberEB(fD,"hGrad",gf)
fD.hGrad:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-65)
fD.hGrad:SetText("true")
fD.hGrad.text:SetText("Gradient:")]]

createNumberEB(fD,"gradStart",gf)
fD.gradStart:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-90)
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

createNumberEB(fD,"gradFinal",gf)
fD.gradFinal:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-115)
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


createCB(fD,"nClassColor",gf)
fD.nClassColor:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-15)
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


createCS(fD,"nColor",gf)
fD.nColor:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-40)
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

fD.nColor.blocker=CreateFrame("Frame",nil,gf)
local nCB=fD.nColor.blocker
nCB:SetFrameLevel(fD.nColor:GetFrameLevel()+1)
nCB:SetPoint("TOPRIGHT",fD.nColor,"TOPRIGHT",2,2)
nCB:SetHeight(22)
nCB:SetWidth(120)
nCB.texture=nCB:CreateTexture(nil,"OVERLAY")
nCB.texture:SetAllPoints()
nCB.texture:SetColorTexture(0.1,0.1,0.1,0.5)



createNumberEB(fD,"nMax",gf)
fD.nMax:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-115)
fD.nMax.text:SetText("Characters:")
fD.nMax:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
if n==0 then n=eF.para.units.textLim; self:SetText(n)
else eF.para.units.textLim=n; eF.units.textLim=n; eF.units:updateTextLim() end
end)

createNumberEB(fD,"nSize",gf)
fD.nSize:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-65)
fD.nSize.text:SetText("Font size:")
fD.nSize:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
n=self:GetNumber()
if n==0 then n=eF.para.units.textSize; self:SetText(n)
else eF.para.units.textSize=n; eF.units.textSize=n; eF.units:updateTextFont() end
end)

createDD(fD,"nFont",gf)
fD.nFont:SetPoint("TOPLEFT",fD.nSize,"TOPLEFT",-22,-25)
fD.nFont.text:SetText("Font:")
UIDropDownMenu_SetWidth(fD.nFont,90)
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

-- eF.units:updateTextFont() 

createNumberEB(fD,"nAlpha",gf)
fD.nAlpha:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-140)
fD.nAlpha.text:SetText("Alpha:")
fD.nAlpha:SetScript("OnEnterPressed", function(self)
self:ClearFocus()
a=self:GetNumber()
eF.para.units.textA=a; eF.units.textA=a; eF.units:updateTextColor() 
end)

createDD(fD,"nPos",gf)
fD.nPos:SetPoint("TOPLEFT",fD.nAlpha,"TOPLEFT",-22,-25)
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

createCS(fD,"bColor",gf)
fD.bColor:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-15)
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


createNumberEB(fD,"bWid",gf)
fD.bWid:SetPoint("TOPRIGHT",tS,"TOPRIGHT",0,-40)
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

end

function intSetInitValues()
  local int=eF.interface
  local gF=int.generalFrame
  local fD=gF.frameDim
  local para=eF.para
  local units=para.units
  local layout=para.layout
  local ssub=string.sub
  
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
eF.rep.intSetInitValues=intSetInitValues










