print("----Frames_update.lua init")

function ElFramo.Frames_update_all()
    
   
end
 
 
function ElFramo.Frames_update_health_of(n)

  local width=ElFramo.Para.Frames.width
  local height=ElFramo.Para.Frames.height

  local vis=ElFramo.Frames.Visual[n]
  local trkn=ElFramo.Tracker[n] --SINCE THEY ARE POINTERS, CHANGING tkr IS CHANGING THE GLOBAL DICT
  
  local ratio=(trkn.maxhealth-trkn.health)/trkn.maxhealth
  
  vis.Health:SetPoint("TOPLEFT",0,-ratio*height)
   
end


function ElFramo.Group_FrameUpdate()
  local tostring=tostring
  local Unitid=ElFramo.Unitid
  -------------------------DEFINING NECESSARY FRAMES
  
  local f=ElFramo.Frames
  local g=ElFramo.Group
  
  -----------------TEST: CREATE A RAID FRAME (FOR "PLAYER")
  for i=1,g.nMembers do
    
    if not g[i].name then break end --if we reach end of the group members, stop
    
    local unit=Unitid(i)
    local para=ElFramo.Para.Frames
    local spacing=para.spacing
    local vis=ElFramo.Frames.Visual[i]
    local linenumber=math.floor(i/para.maxinline)
    --print(linenumber)
    local r,g,b = GetClassColor(  ElFramo.GetCLASS(g[i].class)  )

    vis.Frame:SetPoint("TOPLEFT","VisualMain","TOPLEFT",linenumber*(1+para.spacing)*para.width,(-(1+para.spacing)*(i-1-linenumber*para.maxinline)*para.height))
    
    vis.Frame:SetWidth(para.width)
    vis.Frame:SetHeight(para.height)
    
    vis.Frame:SetAttribute("type1","target") --http://wowwiki.wikia.com/wiki/SecureActionButtonTemplate
                                              --http://www.wowinterface.com/forums/showthread.php?t=29914
    vis.Frame:SetAttribute("unit",unit)

    print("for unit :"..unit)
    
    RegisterUnitWatch(vis.Frame) --controls the visibility of a protected frame based on whether the unit specified by the frame's "unit" attribute exists
    
    vis.Background:SetPoint("TOPLEFT",0,0)
    vis.Background:SetPoint("BOTTOMRIGHT",0,0)
    
    vis.Health:SetPoint("TOPLEFT",0,0)
    vis.Health:SetPoint("BOTTOMRIGHT",0,0)
    vis.Health:SetColorTexture(r,g,b)

    print("color:"..tostring(r).." "..tostring(g).." "..tostring(b).." ")
    
    ElFramo.Frames.Visual[i].Frame:Show()

    
  end --end of for i=1,g.nMembers

end --end of function Group_FrameUpdate


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















