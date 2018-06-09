local _,eF=...
eF.para={}
eF.para.units={
               height=50,
               width=50,
               bg=true,
               bgR=nil,
               bgG=nil,
               bgB=nil,
               spacing=10,
               grow1="down",
               grow2="right",
               healthGrow="up",
               --hpTexture="Interface\\TargetingFrame\\UI-StatusBar",
               hpR=0,
               hpG=0.8,
               hpB=0,
               hpA=1,
               hpGrad=false,
               hpGradOrientation="VERTICAL",
               hpGrad1R=0.5,
               hpGrad1G=0.5,
               hpGrad1B=0.5,
               hpGrad1A=1,
               hpGrad2R=0.8,
               hpGrad2G=0.8,
               hpGrad2B=0.8,
               hpGrad2A=1,
               }

local function initUnitsFrame()
eF.units=CreateFrame("Frame","units",UIParent)
eF.units:EnableMouse(true)
eF.units:SetPoint("CENTER",UIParent,"CENTER",-300,0)
eF.units:SetHeight(200)
eF.units:SetWidth(500)
eF.units:Show()

MakeMovable(eF.units)

eF.units.texture=eF.units:CreateTexture()
eF.units.texture:SetAllPoints()
eF.units.texture:SetDrawLayer("BACKGROUND",-6)
eF.units.texture:SetColorTexture(0.5,0,0.5,0.5)

eF.units.createUnitFrame=eF.rep.createUnitFrame

--apply all relevant non-table parameters
for k,v in pairs(eF.para.units) do
  if type(v)~="table" then eF.units[k]=v end
end 

end


eF.rep={}


local function createUnitAuras(self)
--will contain creation of all auras necessary, probably iwll beed a loop through families and their parameters, see old elFramo
end
eF.rep.createUnitAuras=createUnitAuras

local function createUnitHealth(self)
--should be self-explanatory
end
eF.rep.createUnitHealth=eF.rep.createUnitHealth

local function createUnitFrame(self,unit)
  
  --if this unit frame exists already or unit is nil, fuck it
  if self.unit or not unit then return end  
  
  self.unit=CreateFrame("Button",nil,self,"SecureUnitButtonTemplate")
  
  self.unit:SetAttribute("unit",unit)
  self.unit:SetAttribute("type1","target")
  
  --TBA: positional table
  self.unit:SetPoint("TOPLEFT",self,"TOPLEFT",0,0)
  
  self.unit:SetSize(self.height,self.width)
  self.unit:SetFrameStrata("MEDIUM")
  self.unit:Show()
  RegisterUnitWatch(self.unit)
  
  if self.bg then 
    self.unit.bg=self.unit:CreateTexture()
    self.unit.bg:SetAllPoints()
    if self.bgR then self.unit.bg:SetColorTexture(self.bgR,self.bgG,self.bgB)
    else self.unit.bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background") end 
    
    self.unit.bg:SetDrawLayer("BACKGROUND",-4)
  end --end of if self.bg
  
  --status bar health: https://us.battle.net/forums/en/wow/topic/8796680765
  
  do --create HP bar
  self.unit.hp=CreateFrame("StatusBar",nil,self.unit,"TextStatusBar") 
  if self.healthGrow=="up" then self.unit.hp:SetPoint("BOTTOMLEFT"); self.unit.hp:SetPoint("BOTTOMRIGHT");  self.unit.hp:SetHeight(self.height)
  elseif self.healthGrow=="right" then self.unit.hp:SetPoint("BOTTOMLEFT"); self.unit.hp:SetPoint("TOPLEFT"); self.unit.hp:SetWidth(self.width)
  elseif self.healthGrow=="down" then self.unit.hp:SetPoint("TOPRIGHT"); self.unit.hp:SetPoint("TOPLEFT"); self.unit.hp:SetHeight(self.height)
  elseif self.healthGrow=="left" then self.unit.hp:SetPoint("TOPRIGHT"); self.unit.hp:SetPoint("BOTTOMRIGHT"); self.unit.hp:SetWidth(self.width)
  end

  if self.hpTexture then 
    self.unit.hp:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar",0,0.8,0)
    
    if self.hpR then 
      local alpha=self.hpA or 1 
      self.unit.hp:SetStatusBarColor(self.hpR,self.hpG,self.hpB,alpha)    
    end   
  
  else 
    local alpha=self.hpA or 1
    self.unit.hp:SetStatusBarTexture(self.hpR,self.hpG,self.hpB,alpha)  
  end
  
  
  self.unit.hp:SetMinMaxValues(0,1) 
  self.unit.hp:SetFrameLevel( self.unit:GetFrameLevel())
  
  local hpTexture=self.unit.hp:GetStatusBarTexture()
  
  if self.hpGrad then 
    hpTexture:SetGradientAlpha(self.hpGradOrientation,self.hpGrad1R,self.hpGrad1G,self.hpGrad1B,self.hpGrad1A,self.hpGrad2R,self.hpGrad2G,self.hpGrad2B,self.hpGrad2A)
  end
  
  end
  
  
end --end of CreateUnitFrame()
  

eF.rep.createUnitFrame=createUnitFrame

initUnitsFrame()
eF.units:createUnitFrame("player")

