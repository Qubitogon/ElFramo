print("----EF ElFramo.lua init")
--local testvar="ElFramo.lua initiated me locally"
--globvar="ElFramo.lua initiated me globally"

--------------------INITIALISING NEEDED GLOBAL VARIABLES
ElFramo={}
ElFramo.Group={}
ElFramo.Tracker={}
ElFramo.Frames={}
ElFramo.Para={}
ElFramo.Para.Frames={}
ElFramo.Para.Frames.Family={}


function ElFramo.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[ElFramo.deepcopy(orig_key)] = ElFramo.deepcopy(orig_value)
        end
        setmetatable(copy, ElFramo.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--default testing profile
local defaultpara={}
defaultpara.Frames={}
defaultpara.Frames.Family={}
defaultpara.Frames.Family.count=1
defaultpara.Frames.Family[1]={}
defaultpara.Frames.Family[1].name="ReM family"
defaultpara.Frames.Family[1].Xpos=0
defaultpara.Frames.Family[1].Ypos=0
defaultpara.Frames.Family[1].Height=50
defaultpara.Frames.Family[1].Width=50
defaultpara.Frames.Family[1].Anchor="CENTER"
defaultpara.Frames.Family[1].AnchorTo="CENTER"
defaultpara.Frames.Family[1].smart=false
defaultpara.Frames.Family[1].count=1
defaultpara.Frames.Family[1][1]={}
defaultpara.Frames.Family[1][1].type="name"
defaultpara.Frames.Family[1][1].arg1="buff"
defaultpara.Frames.Family[1][1].arg2="Renewing Mist"
defaultpara.Frames.Family[1][1].Xpos=0
defaultpara.Frames.Family[1][1].Ypos=0
defaultpara.Frames.Family[1][1].Height=30
defaultpara.Frames.Family[1][1].Width=30
defaultpara.Frames.Family[1][1].Anchor="CENTER"
defaultpara.Frames.Family[1][1].AnchorTo="CENTER"
defaultpara.Frames.Family[1][1].cdwheel=true
defaultpara.Frames.Family[1][1].cdreverse=true
defaultpara.Frames.Family[1][1].hastexture=true
defaultpara.Frames.Family[1][1].texture=627487
defaultpara.Frames.Family[1][1].hastext=true
--defaultpara.Frames.Family[1][1].isShown=false  --put that in vis.frames instead, makes more sense to me

defaultpara.Frames.width=100
defaultpara.Frames.height=100
defaultpara.Frames.spacing=0.1
defaultpara.Frames.maxinline=5 
defaultpara.Frames.bygroup=false


ElFramo.Para=ElFramo.deepcopy(defaultpara)

-----------------


function ElFramo.UpdateFrame_update()
    ElFramo.Tracker_update() 
    ElFramo.Frames_update_health_of(1)
    ElFramo.Frames.update_Families(1)
--    ElFramo.Frames.update_Icon(1,1,1)

    --print("done")
    --ElFramo.Frames_update_health_of(2)
end

function ElFramo.GroupFrame_eventHandler(self,event,...)
    print(event)
    ElFramo.Group_update()
    ElFramo.Group_FrameUpdate()
end --end of function ElFrame.GroupFrame_eventHandler

function ElFramo.FirstDraw_Frames()
  local tostring=tostring
  -------------------------DEFINING NECESSARY FRAMES
  ElFramo.Frames.Group=CreateFrame("Frame", "GroupFrame", UIParent)
  ElFramo.Frames.Tracker=CreateFrame("Frame", "TrackerFrame", UIParent)
  ElFramo.Frames.Visual={}

  ElFramo.Frames.Visual.Main=CreateFrame("Frame", "VisualMain", UIParent)
  ElFramo.Frames.Visual.Main:EnableMouse(true)
  ElFramo.Frames.Visual.Main:SetPoint("CENTER") 
  ElFramo.Frames.Visual.Main:SetWidth(200) 
  ElFramo.Frames.Visual.Main:SetHeight(200)

  ElFramo.Frames.Visual.Main:Show()
  

  ElFramo.Frames.Update=CreateFrame("Frame","UpdateFrame",UIParent) --This frame is only there to have an OnUpdate event (triggered every frame)

  ------------------------GROUPFRAME EVENT HANDLER 

  ElFramo.Frames.Group:RegisterEvent("PLAYER_ENTERING_WORLD") --Fired whenever a raid is formed or disbanded, players lieaving / joining or when looting rules changes
                                                             --Also fired when players are being moved around                                                                                                         
  ElFramo.Frames.Group:RegisterEvent("GROUP_ROSTER_UPDATE")

  ElFramo.Frames.Group:SetScript("OnEvent",ElFramo.GroupFrame_eventHandler) --"OnEvent" makes it trigger for all events that were Registered (see RegisterEvent() )


  ----------------------UPDATE FRAME "EVENT" HANDLER


  ElFramo.Frames.Tracker:SetScript("OnUpdate",ElFramo.UpdateFrame_update) --cant directly put Tracker_update in there because it's not defined until Group_update.lua launches




  -----------------TEST: CREATE A RAID FRAME (FOR "PLAYER")
  for i=1,30 do
    --print("Creating Frame:"..tostring(1))
    --local width=ElFramo.Para.Frames.width
    --local height=ElFramo.Para.Frames.height
    
    ElFramo.Frames.Visual[i]={} --Might wanna save parameters here as well, maybe position or w/e idk 
    local FrameName= "Frame"..tostring(i)
    --local HealthName="Health"..tostring(i)

    ElFramo.Frames.Visual[i].Frame=CreateFrame("Button",FrameName,ElFramo.Frames.Visual.Main,"SecureUnitButtonTemplate") --http://wowwiki.wikia.com/wiki/SecureActionButtonTemplate
    ElFramo.Frames.Visual[i].Health=ElFramo.Frames.Visual[i].Frame:CreateTexture()
    ElFramo.Frames.Visual[i].Background=ElFramo.Frames.Visual[i].Frame:CreateTexture()
    
    
    --TESTING ICONS
    --ElFramo.Frames.Visual[i].ReM=CreateFrame("Frame",nil,ElFramo.Frames.Visual[i])
    ElFramo.Frames.Visual[i].ReM=CreateFrame("Frame",nil,ElFramo.Frames.Visual[i].Frame,UIParent)
    ElFramo.Frames.Visual[i].ReMIcon=ElFramo.Frames.Visual[i].ReM:CreateTexture()
    ElFramo.Frames.Visual[i].ReMCD=CreateFrame("Cooldown",nil,ElFramo.Frames.Visual[i].ReM,"CooldownFrameTemplate")
    
    
    ElFramo.Frames.Visual[i].ReM:Hide()
    
    local vis=ElFramo.Frames.Visual[i]
    
    vis.Frame:SetFrameStrata("MEDIUM")
    --vis.Frame:SetPoint("TOPLEFT","VisualMain","TOPLEFT",(1.1*i-1)*width,0)
    vis.Frame:SetPoint("TOPLEFT","VisualMain","TOPLEFT") --Initially we just put all our frames right in the TOPLEFT corner of the main
    --vis.Frame:SetWidth(30)
    --vis.Frame:SetHeight(30)
    
    --vis.Frame:SetAttribute("type1","target") --http://wowwiki.wikia.com/wiki/SecureActionButtonTemplate
                                              --http://www.wowinterface.com/forums/showthread.php?t=29914
    --vis.Frame:SetAttribute("unit",unitid)
    
    --RegisterUnitWatch(vis.Frame) --controls the visibility of a protected frame based on whether the unit specified by the frame's "unit" attribute exists
    
    vis.Background:SetDrawLayer("BACKGROUND") --http://wowwiki.wikia.com/wiki/API_Region_SetPoint
    vis.Background:SetPoint("TOPLEFT",0,0)
    vis.Background:SetPoint("BOTTOMRIGHT",0,0)
    vis.Background:SetAlpha(1)
    vis.Background:SetColorTexture(0.1,0.1,0.1)
    vis.Background:SetDrawLayer("BACKGROUND",-4) --goes from -8 to 7, higher means drawn ABOVE
    
    vis.Health:SetDrawLayer("BACKGROUND")
    vis.Health:SetPoint("TOPLEFT",0,0)
    vis.Health:SetPoint("BOTTOMRIGHT",0,0)
    vis.Health:SetAlpha(1)
    vis.Health:SetColorTexture(0.5,0.8,0.5)
    vis.Health:SetDrawLayer("BACKGROUND",-3)

    --vis.ReM:SetDrawLayer("BACKGROUND")

    
    
  end --end of for i=1,30 (all frames) (could be 1,1 for now for testing purposes)
  print("First_DrawFrames done")
end --end of function FirstDraw_Frames


function ElFramo.CreateFamilyFrames()

  local para=ElFramo.Para.Frames
  local vis=ElFramo.Frames.Visual
  
  for i=1,30 do --loops through all party frames
    vis[i].Family={}
    for j=1,para.Family.count do 
      vis[i].Family[j]={}
      vis[i].Family[j].Frame=CreateFrame("Frame",para.Family[j].name,vis[i].Frame)
      vis[i].Family[j].Frame:SetPoint(para.Family[j].Anchor,vis[i].Frame,para.Family[j].AnchorTo,para.Family[j].Xpos,para.Family[j].Ypos)
--      vis[i].Family[j].Frame:SetPoint("TOPLEFT",vis[i].Frame,"TOPLEFT")
      vis[i].Family[j].Frame:SetHeight(para.Family[j].Height)
      vis[i].Family[j].Frame:SetWidth(para.Family[j].Width)
--      vis[i].Family[j].Frame:SetAllPoints()
      
      for k=1,para.Family[j].count do
        
        vis[i].Family[j][k]={}
        vis[i].Family[j][k].isShown=false
        vis[i].Family[j][k].Frame=CreateFrame("Frame",nil,vis[i].Family[j].Frame)
        vis[i].Family[j][k].Frame:SetPoint(para.Family[j][k].Anchor,vis[i].Family[j].Frame,para.Family[j][k].AnchorTo,para.Family[j][k].Xpos,para.Family[j][k].Ypos)
--        vis[i].Family[j][k].Frame:SetPoint("CENTER",vis[i].Family[j],"CENTER")
        vis[i].Family[j][k].Frame:SetHeight(para.Family[j][k].Height)
        vis[i].Family[j][k].Frame:SetWidth(para.Family[j][k].Width)
        vis[i].Family[j][k].Frame:Hide()
        
        if para.Family[j][k].hastexture then 
--          vis[i].Family[j][k].Texture=vis[i].Family[j][k].Frame:CreateTexture()   
          vis[i].Family[j][k].Texture=vis[i].Family[j][k].Frame:CreateTexture()     
          vis[i].Family[j][k].Texture:SetAllPoints()
          vis[i].Family[j][k].Texture:SetDrawLayer("BACKGROUND",-2)
          vis[i].Family[j][k].Texture:SetTexture(para.Family[j][k].texture)
        end --end of if para.Family.hastexture
--defaultpara.Frames.Family[1][1].cdwheel=true        
        if para.Family[j][k].cdwheel then 
          vis[i].Family[j][k].CDFrame=CreateFrame("Cooldown",nil,vis[i].Family[j][k].Frame,"CooldownFrameTemplate") 
          if para.Family[j][k].cdreverse then vis[i].Family[j][k].CDFrame:SetReverse(true) end
          vis[i].Family[j][k].CDFrame:SetAllPoints()
        end --end of if para.Family[][].cdwheel
        
        
      end --end of for k=1,Family[j].count
    end --end of for j=1,FamilyCount
  end -- end of for i=1,30
end --end of CreateFamilyFrames


function ElFramo.Frames.update_Icon(n,j,k)

  local trk=ElFramo.Tracker[n]
  local para=ElFramo.Para.Frames
  local parafam=para.Family[j][k]
  local vis=ElFramo.Frames.Visual
  local found=false
  local dur=0
  local ind=0
  local t=GetTime()
  
  if parafam.type=="name" then
    --print(parafam.arg1)
    if parafam.arg1=="buff" then for i=1,trk.buffs.count do if trk.buffs[i].name==parafam.arg2 then found=true; ind=i;  end end 
    elseif arg1=="debuff" then found=false end --NYI
      
      
      local isShown=vis[n].Family[j][k].Frame:IsShown()
      --print(isShown)
      
      if found and not isShown then
      
        vis[n].Family[j][k].Frame:Show()
        dur=trk.buffs[ind].duration
        if parafam.cdwheel then vis[n].Family[j][k].CDFrame:SetCooldown(GetTime(),dur) end
        print("Set the CD")
        
      elseif found and isShown then 
      
        dur=trk.buffs[ind].duration
        if parafam.cdwheel then vis[n].Family[j][k].CDFrame:SetCooldown( trk.buffs[ind].expirationTime-dur ,dur) end
        
      elseif not found and isShown then
      
        vis[n].Family[j][k].Frame:Hide()
          
      end
  --print(dur)  
  end --end of f para.Family[j][k]=="name"
  
  
end--end of functon update_Icon

function ElFramo.Frames.update_Family(n,j)
  local para=ElFramo.Para.Frames
  local update_Icon=ElFramo.Frames.update_Icon
  
  for k=1,para.Family[j].count do update_Icon(n,j,k) end 
  
end

function ElFramo.Frames.update_Families(n)

  local para=ElFramo.Para.Frames
  local update_Family=ElFramo.Frames.update_Family
  
  for j=1,para.Family.count do update_Family(n,j) end 
  
end















