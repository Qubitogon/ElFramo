local _,eF=...
eF.initProfile="test"
eF.para={}
eF.rep={}
eF.profiles={}
_eF_initProfile="test"

_eF_savVar={}
_eF_savVar.profiles={
              default={throttle=0.1, --currently not actually applying, it's set to 0.1
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
                               textXOS=0,
                               textYOS=0,
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
                               oorA=0.3, --alpha to be set to if out of range
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
                               borderA=1,},  
                       colors={
                               debuff={Disease={0.6,0.4,0},Poison={0,0.6,0},Curse={0.6,0,0.1},Magic={0.2,0.6,1}},
                              }, --end of colors
                       layout={
                               spacing=5,
                               grow1="down",
                               grow2="right",   
                               byClassColor=true,
                               byGroup=true,
                               maxInLine=5,
                               },
                       families={[1]={displayName="void",
                                     smart=false,
                                     count=4,
                                     [1]={displayName="ReM",
                                          type="icon",
                                          trackType="name",
                                          buff=true,
                                          frameLevel=4,
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
                                          frameLevel=4,

                                          height=20,
                                          width=20,
                                          anchor="TOPLEFT",
                                          anchorTo="TOPLEFT",
                                          cdWheel=true,
                                          cdReverse=true,
                                          hasBorder=true,
                                          borderType="debuffColor",
                                          texture=606550,
                                          hasText=false,
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
                                          ownOnly=false,
                                          loadAlways=true,
                                          },    
                                     [3]={displayName="TankSquare",
                                          type="icon",
                                          trackType="Static",
                                          xPos=0,
                                          yPos=0,
                                          height=5,
                                          width=5,
                                          anchor="TOPLEFT",
                                          anchorTo="TOPLEFT",
                                          hasTexture=true,
                                          hasColorTexture=true,
                                          frameLevel=3,

                                          textureR=0.1,
                                          textureG=0.1,
                                          textureB=0.5,
                                          loadAlways=false,   
                                          loadRole=true,
                                          loadRoleList={"TANK"},                            
                                          },
                                     [4]={displayName="PowerBar",
                                          type="bar",
                                          trackType="power",
                                          frameLevel=2,

                                          xPos=3,
                                          yPos=0,
                                          lFix=7,
                                          lMax=50,
                                          grow="up",
                                          --anchor="BOTTOMLEFT",--anchor decided based on where it grows; up->top, right-> left etc
                                          anchorTo="BOTTOMLEFT",
                                          loadAlways=false,
                                          loadRole=true,
                                          loadRoleList={"HEALER"}, 
                                          loadClass=true,
                                          loadClassList={"Monk"}
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
                                     frameLevel=4,
                                     width=20,
                                     anchor="BOTTOMLEFT",
                                     anchorTo="BOTTOMLEFT",
                                     buff=false,
                                     arg1={"Soothing Mist","Renewing Mist","Enveloping Mist","Essence Font"},
                                     smartIcons=true,
                                     grow="right",
                                     growAnchor="LEFT",
                                     growAnchorTo="CENTER",
                                     cdReverse=true,
                                     cdWheel=true,
                                     hasBorder=true,
                                     borderType="debuffColor",
                                     hasText=true,
                                     hasTexture=true,
                                     ignorePermanents=true,
                                     ignoreDurationAbove=20,
                                     textType="Time left",
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
                                     frameLevel=4,
                                     width=20,
                                     anchor="LEFT",
                                     anchorTo="LEFT",
                                     buff=true,
                                     smartIcons=true,
                                     grow="right",
                                     growAnchor="LEFT",
                                     growAnchorTo="CENTER",
                                     cdReverse=true,
                                     cdWheel=true,
                                     hasText=true,
                                     hasTexture=true,
                                     ignorePermanents=true,
                                     ignoreDurationAbove=nil,
                                     textType="Time left",
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
                       },  --end of "default"

                 test={throttle=0.1, --currently not actually applying, it's set to 0.1
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
                               borderA=1,},  
                       colors={
                               debuff={Disease={0.6,0.4,0},Poison={0,0.6,0},Curse={0.6,0,0.1},Magic={0.2,0.6,1}},
                              }, --end of colors
                       layout={
                               spacing=5,
                               grow1="down",
                               grow2="right",   
                               byClassColor=true,
                               byGroup=true,
                               maxInLine=5,
                               },
                       families={[1]={displayName="void",
                                     smart=false,
                                     count=4,
                                     [1]={displayName="ReM",
                                          type="icon",
                                          trackType="Buffs",
                                          trackBy="Name",
                                          frameLevel=4,
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
                                          ownOnly=false,
                                          loadAlways=true,
                                          }, --end of [1][1]
                                     [2]={displayName="SooM",
                                          type="icon",
                                          trackType="Buffs",
                                          trackBy="Name",
                                          arg1="Soothing Mist",
                                          xPos=0,
                                          yPos=0,
                                          frameLevel=4,

                                          height=20,
                                          width=20,
                                          anchor="TOPLEFT",
                                          anchorTo="TOPLEFT",
                                          cdWheel=true,
                                          cdReverse=true,
                                          hasBorder=true,
                                          borderType="debuffColor",
                                          texture=606550,
                                          hasText=false,
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
                                          ownOnly=false,
                                          loadAlways=true,
                                          },    
                                     [3]={displayName="TankSquare",
                                          type="icon",
                                          trackType="Static",
                                          xPos=0,
                                          yPos=0,
                                          height=5,
                                          width=5,
                                          anchor="TOPLEFT",
                                          anchorTo="TOPLEFT",
                                          hasTexture=true,
                                          hasColorTexture=true,
                                          frameLevel=3,

                                          textureR=0.1,
                                          textureG=0.1,
                                          textureB=0.5,
                                          loadAlways=false,   
                                          loadRole=true,
                                          loadRoleList={"TANK"},                            
                                          },
                                     [4]={displayName="PowerBar",
                                          type="bar",
                                          trackType="power",
                                          frameLevel=2,

                                          xPos=3,
                                          yPos=0,
                                          lFix=7,
                                          lMax=50,
                                          grow="up",
                                          --anchor="BOTTOMLEFT",--anchor decided based on where it grows; up->top, right-> left etc
                                          anchorTo="BOTTOMLEFT",
                                          loadAlways=false,
                                          loadRole=true,
                                          loadRoleList={"HEALER"}, 
                                          loadClass=true,
                                          loadClassList={"Monk"}
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
                                     frameLevel=4,
                                     width=20,
                                     anchor="BOTTOMLEFT",
                                     anchorTo="BOTTOMLEFT",
                                     trackType="Debuffs",
                                     arg1={"Soothing Mist","Renewing Mist","Enveloping Mist","Essence Font"},
                                     smartIcons=true,
                                     grow="right",
                                     growAnchor="BOTTOMLEFT",
                                     growAnchorTo="BOTTOMLEFT",
                                     cdReverse=true,
                                     cdWheel=true,
                                     hasBorder=true,
                                     borderType="debuffColor",
                                     hasText=true,
                                     hasTexture=true,
                                     ignorePermanents=true,
                                     ignoreDurationAbove=50,
                                     textType="Time left",                                     
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
                                     frameLevel=4,
                                     width=20,
                                     anchor="LEFT",
                                     anchorTo="LEFT",
                                     trackType="Buffs",
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
                                     textType="Time left",
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
                       },  --end of "test"
}                       
                
local function setProfile(prof)
  if not prof then return end
  if not eF.profiles[prof] then return end 
  eF.para={}
  eF.para=eF.profiles[prof]
end
eF.rep.setProfile=setProfile