local _,eF=...
eF.initProfile="test"
eF.para={}
eF.rep={}
eF.profiles={}
_eF_initProfile="test"

_eF_savVar={}
_eF_savVar.profiles={
                 default={throttle=0.1, --currently not actually applying, it's set to 0.1
                       familyButtonsIndexList={},
                       groupParas=false,
                       version=1,
                       units={
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
                               textR=1,
                               textG=1,
                               textB=1,
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
                               spacing=5,
                               grow1="down",
                               grow2="right",   
                               byClassColor=true,
                               byGroup=true,
                               maxInLine=5,
                               }, 
                       unitsGroup={
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
                               textR=1,
                               textG=1,
                               textB=1,
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
                               spacing=5,
                               grow1="down",
                               grow2="right",   
                               byClassColor=true,
                               byGroup=true,
                               maxInLine=5,
                               },                    
                       colors={
                               debuff={Disease={0.6,0.4,0},Poison={0,0.6,0},Curse={0.6,0,0.1},Magic={0.2,0.6,1}},
                              }, --end of colors
                       families={[1]={displayName="void",
                                     smart=false,
                                     count=0,                                              
                                       }, --end of ...families[1]                        
                                }--end of all  
                       },  --end of "test"
}                       
                
local function setProfile(prof)
  if not prof then return nil end
  if not eF.profiles[prof] then return nil end 
  eF.para={}
  eF.para=eF.profiles[prof]
end
eF.rep.setProfile=setProfile