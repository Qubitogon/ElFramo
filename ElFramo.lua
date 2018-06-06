print("----EF elFramo.lua init")
--local testvar="elFramo.lua initiated me locally"
--globvar="elFramo.lua initiated me globally"

---------------------TODO LIST
--[[

-Make a general CreateFamilyFrame function that creates a frame based on parameters given (i,j,k) 
---This would allow for dynamic creation of frames for smartGroups, so as to minimise wasted ressources
-----if not vis[i].family[j][k].frame then CreateFamilyFrame(i,j,k)

-"blacklist" currently is not blacklisting, should be easy to implement inside UpdateFamily(n,j)

-first family needs to be the "void" family, in which all orphan frames go

]]--




--------------------INITIALISING NEEDED GLOBAL VARIABLES
elFramo={}
elFramo.group={}
elFramo.tracker={}
elFramo.frames={}
elFramo.para={}
elFramo.para.frames={}
elFramo.para.frames.family={}


function elFramo.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[elFramo.deepcopy(orig_key)] = elFramo.deepcopy(orig_value)
        end
        setmetatable(copy, elFramo.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--default testing profile
--elFramo.ClassTable={Druid="DRUID",Monk="MONK",Paladin="PALADIN", Priest="PRIEST", Rogue="ROGUE",Mage="MAGE",Warlock="WARLOCK",Hunter="HUNTER",Shaman="SHAMAN"}

local defaultpara={frames={family={count=3, 
                                   [1]={name="void", 
                                        xpos=0, 
                                        ypos=0,
                                        height=50,
                                        width=50,
                                        anchor="CENTER",
                                        anchorTo="CENTER",
                                        smart=false,
                                        count=2,
                                        [1]={name="ReM",
                                             type="name",
                                             arg1="buff",
                                             arg2="Renewing Mist",
                                             xpos=0,
                                             ypos=0,
                                             height=30,
                                             width=30,
                                             anchor="CENTER",
                                             anchorTo="CENTER",
                                             cdWheel=true,
                                             cdReverse=true,
                                             hasTexture=true,
                                             texture=627487,
                                             hasText=true,
                                             },--end of Family[1][1]=
                                        [2]={name="SooM",
                                             type="name",
                                             arg1="buff",
                                             arg2="Soothing Mist",
                                             xpos=40,
                                             ypos=0,
                                             height=30,
                                             width=30,
                                             anchor="CENTER",
                                             anchorTo="CENTER",
                                             cdWheel=true,
                                             cdReverse=true,
                                             hasTexture=true,
                                             texture=606550,
                                             hasText=true,
                                             },--end of Family[1][2]=
                                        },--end of Family[1]=
                                      
                                   [2]={name="MW test family", 
                                        xpos=0, 
                                        ypos=50,
                                        height=50,
                                        width=50,
                                        anchor="CENTER",
                                        anchorTo="CENTER",
                                        smart=false,
                                        count=2,
                                        [1]={name="LC",
                                             type="name",
                                             arg1="buff",
                                             arg2="Life Cocoon",
                                             xpos=0,
                                             ypos=0,
                                             height=30,
                                             width=30,
                                             anchor="CENTER",
                                             anchorTo="CENTER",
                                             cdWheel=true,
                                             cdReverse=true,
                                             hasTexture=true,
                                             texture=627485,
                                             hasText=true,
                                             },--end of Family[1][1]=
                                        [2]={name="EnM",
                                             type="name",
                                             arg1="buff",
                                             arg2="Enveloping Mist",
                                             xpos=40,
                                             ypos=0,
                                             height=30,
                                             width=30,
                                             anchor="CENTER",
                                             anchorTo="CENTER",
                                             cdWheel=true,
                                             cdReverse=true,
                                             hasTexture=true,
                                             texture=775461,
                                             hasText=true,
                                             },--end of Family[1][2]=
                                        },--end of Family[1]=
                                   
                                   [3]={name="All smart", 
                                        xpos=0, 
                                        ypos=0,
                                        height=30,
                                        width=30,
                                        spacing=1,
                                        anchor="CENTER",
                                        anchorTo="CENTER",
                                        smart=true,
                                        maxCount=20,
                                        type="blackList",
                                        arg1="buff",
                                        arg2={"Sign of the Warrior","Soothing Mist"}, --has a blacklist array 
                                        smartIcons=true,
                                        grow="down",
                                        growAnchor="TOPLEFT",
                                        growAnchorTo="TOPLEFT",
                                        cdReverse=true,
                                        cdWheel=true,
                                        ignorePermanents=true,
                                        }--end of Family[3]=
                                   },--end of Family=
                           width=100,
                           height=100,
                           spacing=0.1,
                           maxInLine=5,
                           byGroup=false
                           },--end of Frames=
                   }--end of defaultpara=
                                   
elFramo.para=elFramo.deepcopy(defaultpara)

-----------------


function elFramo.updateFrameUpdate()
    elFramo.trackerUpdate() 
    elFramo.framesUpdateHealthOf(1)
    elFramo.frames.updateFamilies(1)
--    elFramo.frames.updateIcon(1,1,1)

    --print("done")
    --elFramo.framesUpdateHealthOf(2)
end

function elFramo.groupFrameEventHandler(self,event,...)
    print(event)
    elFramo.groupUpdate()
    elFramo.groupFrameUpdate()
end --end of function ElFrame.groupFrame_eventHandler

function elFramo.firstDrawFrames()
  local tostring=tostring
  -------------------------DEFINING NECESSARY FRAMES
  elFramo.frames.group=CreateFrame("Frame", "GroupFrame", UIParent)
  elFramo.frames.tracker=CreateFrame("Frame", "TrackerFrame", UIParent)
  elFramo.frames.visual={}

  elFramo.frames.visual.main=CreateFrame("Frame", "visualMain", UIParent)
  elFramo.frames.visual.main:EnableMouse(true)
  elFramo.frames.visual.main:SetPoint("CENTER") 
  elFramo.frames.visual.main:SetWidth(200) 
  elFramo.frames.visual.main:SetHeight(200)

  elFramo.frames.visual.main:Show()
  

  elFramo.frames.update=CreateFrame("Frame","updateFrame",UIParent) --This frame is only there to have an OnUpdate event (triggered every frame)

  ------------------------GROUPFRAME EVENT HANDLER 

  elFramo.frames.group:RegisterEvent("PLAYER_ENTERING_WORLD") --Fired whenever a raid is formed or disbanded, players lieaving / joining or when looting rules changes
                                                             --Also fired when players are being moved around                                                                                                         
  elFramo.frames.group:RegisterEvent("GROUP_ROSTER_UPDATE")

  elFramo.frames.group:SetScript("OnEvent",elFramo.groupFrameEventHandler) --"OnEvent" makes it trigger for all events that were Registered (see RegisterEvent() )


  ----------------------UPDATE FRAME "EVENT" HANDLER


  elFramo.frames.tracker:SetScript("OnUpdate",elFramo.updateFrameUpdate) --cant directly put Tracker_update in there because it's not defined until Group_update.lua launches




  -----------------TEST: CREATE A RAID FRAME (FOR "PLAYER")
  for i=1,30 do
    --print("Creating Frame:"..tostring(1))
    --local width=elFramo.para.frames.width
    --local height=elFramo.para.frames.height
    
    elFramo.frames.visual[i]={} --Might wanna save parameters here as well, maybe position or w/e idk 
    local frameName= "Frame"..tostring(i)
    --local HealthName="Health"..tostring(i)

    elFramo.frames.visual[i].frame=CreateFrame("Button",frameName,elFramo.frames.visual.main,"SecureUnitButtonTemplate") --http://wowwiki.wikia.com/wiki/SecureActionButtonTemplate
    elFramo.frames.visual[i].health=elFramo.frames.visual[i].frame:CreateTexture()
    elFramo.frames.visual[i].background=elFramo.frames.visual[i].frame:CreateTexture()
    
    
    --TESTING ICONS
    --elFramo.frames.visual[i].ReM=CreateFrame("Frame",nil,elFramo.frames.visual[i])


    
    local vis=elFramo.frames.visual[i]
    
    vis.frame:SetFrameStrata("MEDIUM")
    --vis.frame:SetPoint("TOPLEFT","visualMain","TOPLEFT",(1.1*i-1)*width,0)
    vis.frame:SetPoint("TOPLEFT","visualMain","TOPLEFT") --Initially we just put all our frames right in the TOPLEFT corner of the main
    --vis.frame:SetWidth(30)
    --vis.frame:SetHeight(30)
    
    --vis.frame:SetAttribute("type1","target") --http://wowwiki.wikia.com/wiki/SecureActionButtonTemplate
                                              --http://www.wowinterface.com/forums/showthread.php?t=29914
    --vis.frame:SetAttribute("unit",unitid)
    
    --RegisterUnitWatch(vis.frame) --controls the visibility of a protected frame based on whether the unit specified by the frame's "unit" attribute exists
    
    vis.background:SetDrawLayer("BACKGROUND") --http://wowwiki.wikia.com/wiki/API_Region_SetPoint
    vis.background:SetPoint("TOPLEFT",0,0)
    vis.background:SetPoint("BOTTOMRIGHT",0,0)
    vis.background:SetAlpha(1)
    vis.background:SetColorTexture(0.1,0.1,0.1)
    vis.background:SetDrawLayer("BACKGROUND",-4) --goes from -8 to 7, higher means drawn ABOVE
    
    vis.health:SetDrawLayer("BACKGROUND")
    vis.health:SetPoint("TOPLEFT",0,0)
    vis.health:SetPoint("BOTTOMRIGHT",0,0)
    vis.health:SetAlpha(1)
    vis.health:SetColorTexture(0.5,0.8,0.5)
    vis.health:SetDrawLayer("BACKGROUND",-3)

    --vis.ReM:SetDrawLayer("BACKGROUND")

    
    
  end --end of for i=1,30 (all frames) (could be 1,1 for now for testing purposes)
  print("First_DrawFrames done")
end --end of function FirstDraw_Frames


function elFramo.createFamilyFrames()

  local para=elFramo.para.frames
  local vis=elFramo.frames.visual
  
  --NEED TO CREATE BLACKLIST TYPE FRAME HERE AS WELL PROPERLY, SO FAR ONLY NON-SMART WITH "NAME" ICONS
  
  for i=1,30 do --loops through all party frames
    vis[i].family={}
    for j=1,para.family.count do 
    
    
      vis[i].family[j]={}
      vis[i].family[j].frame=CreateFrame("Frame",para.family[j].name,vis[i].frame)
      --vis[i].family[j].frame:SetPoint(para.family[j].anchor,vis[i].frame,para.family[j].anchorTo,para.family[j].xpos,para.family[j].ypos)
      --vis[i].family[j].frame:SetHeight(para.family[j].height)
      --vis[i].family[j].frame:SetWidth(para.family[j].width)
      vis[i].family[j].frame:SetAllPoints()
      
      if not para.family[j].smart then 
        for k=1,para.family[j].count do
          
          vis[i].family[j][k]={}
          vis[i].family[j][k].isShown=false
          vis[i].family[j][k].frame=CreateFrame("Frame",nil,vis[i].family[j].frame)
          vis[i].family[j][k].frame:SetPoint(para.family[j][k].anchor,vis[i].family[j].frame,para.family[j][k].anchorTo,para.family[j][k].xpos,para.family[j][k].ypos)
  --        vis[i].family[j][k].frame:SetPoint("CENTER",vis[i].family[j],"CENTER")
          vis[i].family[j][k].frame:SetHeight(para.family[j][k].height)
          vis[i].family[j][k].frame:SetWidth(para.family[j][k].width)
          vis[i].family[j][k].frame:Hide()
          
          if para.family[j][k].hasTexture then 
  --          vis[i].family[j][k].Texture=vis[i].family[j][k].frame:CreateTexture()   
            vis[i].family[j][k].texture=vis[i].family[j][k].frame:CreateTexture()     
            vis[i].family[j][k].texture:SetAllPoints()
            vis[i].family[j][k].texture:SetDrawLayer("BACKGROUND",-2)
            vis[i].family[j][k].texture:SetTexture(para.family[j][k].texture)
          end --end of if para.family.hasTexture
  --defaultpara.frames.family[1][1].cdWheel=true        
          if para.family[j][k].cdWheel then 
            vis[i].family[j][k].cdFrame=CreateFrame("Cooldown",nil,vis[i].family[j][k].frame,"CooldownFrameTemplate") 
            if para.family[j][k].cdReverse then vis[i].family[j][k].cdFrame:SetReverse(true) end
            vis[i].family[j][k].cdFrame:SetAllPoints()
          end --end of if para.family[][].cdWheel
          
        end --end of for k=1,Family[j].count
        
      else --if not vis.family.smart else
        vis[i].family[j].active=0

        if para.family[j].type=="blackList" and para.family[j].smartIcons then  
          for k=1,para.family[j].maxCount do
          
            vis[i].family[j][k]={}
            vis[i].family[j][k].isShown=false
            vis[i].family[j][k].frame=CreateFrame("Frame",nil,vis[i].family[j].frame)
            --print(string.format("created vis[%d].family[%d][%d].frame",i,j,k))
            
            ----------GENERATING X AND Y OFFSET
            local xos
            local yos
            if para.family[j].grow=="right" then
              xos=(k-1)*(para.family[j].width+para.family[j].spacing)
              yos=0
            elseif para.family[j].grow=="left" then
              xos=-(k-1)*(para.family[j].width+para.family[j].spacing)
              yos=0
            elseif para.family[j].grow=="up" then 
              xos=0
              yos=(k-1)*(para.family[j].height+para.family[j].spacing)
            elseif para.family[j].grow=="down" then 
              xos=0
              yos=-(k-1)*(para.family[j].height+para.family[j].spacing)
            end         
 
            vis[i].family[j][k].frame:SetPoint(para.family[j].growAnchor,vis[i].family[j].frame,para.family[j].growAnchorTo,xos,yos)
  --        vis[i].family[j][k].frame:SetPoint("CENTER",vis[i].family[j],"CENTER")
            vis[i].family[j][k].frame:SetHeight(para.family[j].height)
            vis[i].family[j][k].frame:SetWidth(para.family[j].width)
            vis[i].family[j][k].frame:Hide()
            
            vis[i].family[j][k].texture=vis[i].family[j][k].frame:CreateTexture()     
            vis[i].family[j][k].texture:SetAllPoints()
            vis[i].family[j][k].texture:SetDrawLayer("BACKGROUND",-2)
            
          if para.family[j].cdWheel then 
            vis[i].family[j][k].cdFrame=CreateFrame("Cooldown",nil,vis[i].family[j][k].frame,"CooldownFrameTemplate") 
            if para.family[j].cdReverse then vis[i].family[j][k].cdFrame:SetReverse(true) end
            vis[i].family[j][k].cdFrame:SetAllPoints()
          end --end of if para.family[][].cdWheel
 
          --[[{name="All smart", 
                                        xpos=0, 
                                        ypos=-50,
                                        height=30,
                                        width=30,
                                        spacing=10,
                                        anchor="CENTER",
                                        anchorTo="CENTER",
                                        smart=true,
                                        maxCount=3,
                                        type="blackList",
                                        arg1="buff",
                                        arg2=nil, --has a blacklist array 
                                        smartIcons=true,
                                        grow="right",
                                        growAnchor="LEFT",
                                        growAnchorTo="LEFT",
                                        cdReverse=true,
                                        cdWheel=true,
                                        }]]
 
 
 
          end --end of for k=1,para.family[j].maxCount
        end --end of if vis.family.type=="blackList"
      end--end of if not vis.family.smart else 
      
      
    end --end of for j=1,FamilyCount
  end -- end of for i=1,30
end --end of createFamilyFrames

















