local _,eF=...
eF.para={}
eF.rep={}
eF.para.units={
               height=50,
               width=50,
               bg=true,
               bgR=nil,
               bgG=nil,
               bgB=nil,
               --spacing=10,
               --grow1="down",
               --grow2="right",
               healthGrow="up",
               hpTexture=nil, --would put path in here, e.g. "Interface\\TargetingFrame\\UI-StatusBar"
               --hpTexture="Interface\\TargetingFrame\\UI-StatusBar",
               hpR=0.2,
               hpG=0.4,
               hpB=0.6,
               hpA=1,
               hpGrad=true,
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

     
eF.partyLoop={"player","party1","party2","party3","party4"}
eF.raidLoop={}

for i=1,40 do
  local s="raid"..tostring(i)
  table.insert(eF.raidLoop,s)
  --print(eF.raidLoop[i])
end


function MakeMovable(frame)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end