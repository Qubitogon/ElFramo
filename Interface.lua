local _,eF=...

local font="Fonts\\FRIZQT__.ttf"
local font2="Fonts\\ARIALN.ttf"
local fontExtra="OUTLINE"

local bd={edgeFile ="Interface\\DialogFrame\\UI-DialogBox-Border",edgeSize = 20, insets ={ left = 0, right = 0, top = 0, bottom = 0 }}

local function frameToggle(self)
  if not self then return end
  if self:IsShown() then self:Hide() else self:Show()end
end
--create main frame
eF.interface=CreateFrame("Frame","eFInterface",UIParent)
local int=eF.interface
do
int:SetPoint("LEFT",UIParent,"LEFT",200,0)
int:SetHeight(600)
int:SetWidth(850)
int:SetBackdrop(bd)
int:EnableMouse(true)
int:SetAlpha(0.9)

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
int.titleBox=CreateFrame("Frame","eFTitle",int)
local tb=int.titleBox
do
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
int.header1=CreateFrame("Frame","eFHeader",int)
local hd1=int.header1
do 
hd1:SetPoint("TOPLEFT",int,"TOPLEFT",15,-25)
hd1:SetPoint("BOTTOMRIGHT",int,"BOTTOMRIGHT",-15,10)
hd1:SetBackdrop(bd)
hd1:SetBackdropColor(0,0,0,0)

hd1.bg=hd1:CreateTexture(nil,"BACKGROUND")
hd1.bg:SetPoint("TOPLEFT",hd1,"TOPLEFT",5,-5)
hd1.bg:SetPoint("BOTTOMRIGHT",hd1,"BOTTOMRIGHT",-5,5)
hd1.bg:SetColorTexture(0.1,0.1,0.1)
end

function header1ReleaseAll()
  hd1.button1:Enable()
  hd1.button2:Enable()
  hd1.button3:Enable()
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
    end)
end

--create header 1 buttons
hd1.button1=CreateFrame("Button","eFHeader1Button1",hd1)
local hd1b1=hd1.button1
hd1b1:SetPoint("BOTTOMLEFT",hd1,"TOPLEFT",35,-9)
makeHeader1Button(hd1b1)


--create button 2
hd1.button2=CreateFrame("Button","eFHeader1Button2",hd1)
local hd1b2=hd1.button2
hd1b2:SetPoint("BOTTOMLEFT",hd1,"TOPLEFT",140,-9)
makeHeader1Button(hd1b2)
hd1b2.text:SetText("Other stuff")

--create button 3
hd1.button3=CreateFrame("Button","eFHeader1Button3",hd1)
local hd1b3=hd1.button3
hd1b3:SetPoint("BOTTOMLEFT",hd1,"TOPLEFT",245,-9)
makeHeader1Button(hd1b3)
hd1b3.text:SetText("Families")


















