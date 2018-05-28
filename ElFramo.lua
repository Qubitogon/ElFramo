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
ElFramo.Buckets={}

-----------------TESTING PURPOSE

ElFramo.Para.Frames.width=100
ElFramo.Para.Frames.height=100
ElFramo.Para.Frames.spacing=0.1
ElFramo.Para.Frames.maxinline=5 
ElFramo.Para.Frames.bygroup=false

-----------------


function ElFramo.UpdateFrame_update()
    ElFramo.Tracker_update() 
    ElFramo.Frames_update_health_of(1)
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
    
    ElFramo.Frames.Visual[i].Frame:Hide()
    
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

    
  end --end of for i=1,30 (all frames) (could be 1,1 for now for testing purposes)
  print("First_DrawFrames done")
end --end of function FirstDraw_Frames





