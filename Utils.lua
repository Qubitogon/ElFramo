local _,eF=...

--[[

eF.para={throttle=0.1--in s
        }
        
eF.para.units={
               height=50,
               width=70,
               bg=true,
               bgR=nil,
               bgG=nil,
               bgB=nil,
               --spacing=10,
               --grow1="down",
               --grow2="right",
               healthGrow="up",
               textLim=4,
               textFont="Fonts\\FRIZQT__.ttf",
               textExtra="OUTLINE",
               textPos="CENTER",
               textSize=13,
               textA=0.7,
               textColorByClass=true,
               --textR=1,
               --textG=1,
               hpTexture=nil, --would put path in here, e.g. "Interface\\TargetingFrame\\UI-StatusBar"
               --hpTexture="Interface\\TargetingFrame\\UI-StatusBar", if no texture given, uses SetColorTexture instead
               hpR=0.2,
               hpG=0.4,
               hpB=0.6,
               hpA=1,
               nA=1, --normal alpha
               checkOOR=true, --true if dim when oor
               oorA=0.45, --alpha to be set to if out of range
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
               borderSize=1,
               borderR=0.35,
               borderG=0.35,
               borderB=0.35,
               borderA=1,
               }
               
               
eF.para.layout={
               spacing=5,
               grow1="down",
               grow2="right",   
               byClassColor=true,
               byGroup=true,
               maxInLine=5,
               }   

eF.para.colors={}
eF.para.colors.debuff={Disease={0.6,0.4,0},Poison={0,0.6,0},Curse={0.6,0,0.1},Magic={0.2,0.6,1}}
               
]]            
               

               
eF.partyLoop={"player","party1","party2","party3","party4"}
eF.raidLoop={}
eF.positions={"CENTER","RIGHT","TOPRIGHT","TOP","TOPLEFT","LEFT","BOTTOMLEFT","BOTTOM","BOTTOMRIGHT"}



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

function eF.borderInfo(pos)
  local loc,p1,p2,w,f11,f12,f21,f22
  if pos=="RIGHT" then loc="borderRight"; p1="TOPRIGHT"; p2="BOTTOMRIGHT"; w=true; f11=1; f12=1; f21=1; f22=-1;
  elseif pos=="TOP" then loc="borderTop"; p1="TOPLEFT"; p2="TOPRIGHT"; w=false; f11=-1; f12=1; f21=1; f22=1;
  elseif pos=="LEFT" then loc="borderLeft"; p1="TOPLEFT"; p2="BOTTOMLEFT";w=true; f11=-1; f12=1; f21=-1; f22=-1;
  elseif pos=="BOTTOM" then loc="borderBottom"; p1="BOTTOMLEFT";p2="BOTTOMRIGHT"; w=false; f11=-1; f12=-1; f21=1; f22=-1; end  
  
  return loc,p1,p2,w,f11,f12,f21,f22
end

function eF.toDecimal(f,d)
  local m=math.pow(10,d)
  f=f*m
  f=floor(f)
  f=f/m
  return f
end

function eF.isInList(s,lst)

  if not s or not lst then return false end
  local found=false
  for i=1,#lst do 
    if type(lst[i])==type(s) then
      if lst[i]==s then
        found=true
        break
      end
    end
  end
  return found
end


function eF.posInList(s,lst)
  if not s or not lst then return nil end
  for i=1,#lst do 
    if type(lst[i])==type(s) then
      if lst[i]==s then
        break
      end
    end
  end
  return i
end




















