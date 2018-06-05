print("----Frames_update.lua init")

function elFramo.framesUpdateAll()
    
   
end
 
 
function elFramo.framesUpdateHealthOf(n)

  local width=elFramo.para.frames.width
  local height=elFramo.para.frames.height

  local vis=elFramo.frames.visual[n]
  local trkn=elFramo.tracker[n] --SINCE THEY ARE POINTERS, CHANGING tkr IS CHANGING THE GLOBAL DICT
  
  local ratio=(trkn.maxHealth-trkn.health)/trkn.maxHealth
  
  vis.health:SetPoint("TOPLEFT",0,-ratio*height)
   
end


function elFramo.groupFrameUpdate()
  local tostring=tostring
  local unitID=elFramo.unitID
  -------------------------DEFINING NECESSARY FRAMES
  
  local f=elFramo.frames
  local g=elFramo.group
  
  -----------------TEST: CREATE A RAID FRAME (FOR "PLAYER")
  for i=1,g.nMembers do
    
    if not g[i].name then break end --if we reach end of the group members, stop
    
    local unit=unitID(i)
    local para=elFramo.para.frames
    local spacing=para.spacing
    local vis=elFramo.frames.visual[i]
    local lineNumber=math.floor(i/para.maxInLine)
    --print(linenumber)
    local r,g,b = GetClassColor(  elFramo.GetCLASS(g[i].class)  )

    vis.frame:SetPoint("TOPLEFT","VisualMain","TOPLEFT",lineNumber*(1+para.spacing)*para.width,(-(1+para.spacing)*(i-1-linenumber*para.maxInLine)*para.height))
    
    vis.frame:SetWidth(para.width)
    vis.frame:SetHeight(para.height)
    
    vis.frame:SetAttribute("type1","target") --http://wowwiki.wikia.com/wiki/SecureActionButtonTemplate
                                              --http://www.wowinterface.com/forums/showthread.php?t=29914
    vis.frame:SetAttribute("unit",unit)

    print("for unit :"..unit)
    
    RegisterUnitWatch(vis.frame) --controls the visibility of a protected frame based on whether the unit specified by the frame's "unit" attribute exists
    
    vis.background:SetPoint("TOPLEFT",0,0)
    vis.background:SetPoint("BOTTOMRIGHT",0,0)
    
    vis.health:SetPoint("TOPLEFT",0,0)
    vis.health:SetPoint("BOTTOMRIGHT",0,0)
    vis.health:SetColorTexture(r,g,b)

    print("color:"..tostring(r).." "..tostring(g).." "..tostring(b).." ")
    
    elFramo.frames.visual[i].frame:Show()

    
  end --end of for i=1,g.nMembers

end --end of function Group_FrameUpdate


function elFramo.frames.update_Icon(n,j,k)

  local trk=elFramo.tracker[n]
  local para=elFramo.para.frames
  local paraFam=para.family[j][k]
  local vis=elFramo.frames.visual
  local found=false
  local dur=0
  local ind=0
  local t=GetTime()
  
  if paraFam.type=="name" then
    --print(paraFam.arg1)
    if paraFam.arg1=="buff" then for i=1,trk.buffs.count do if trk.buffs[i].name==paraFam.arg2 then found=true; ind=i;  end end 
    elseif arg1=="debuff" then found=false end --NYI
      
      
      local isShown=vis[n].family[j][k].frame:IsShown()
      --print(isShown)
      
      if found and not isShown then
      
        vis[n].family[j][k].frame:Show()
        dur=trk.buffs[ind].duration
        if paraFam.cdWheel then vis[n].family[j][k].cdFrame:SetCooldown(GetTime(),dur) end
        print("Set the CD")
        
      elseif found and isShown then 
      
        dur=trk.buffs[ind].duration
        if paraFam.cdWheel then vis[n].family[j][k].cdFrame:SetCooldown( trk.buffs[ind].expirationTime-dur ,dur) end
        
      elseif not found and isShown then
      
        vis[n].family[j][k].frame:Hide()
          
      end
  --print(dur)  
  end --end of f para.family[j][k]=="name"
  
  
end--end of functon update_Icon

function elFramo.frames.updateFamily(n,j)
  local para=elFramo.para.frames
  local updateIcon=elFramo.frames.updateIcon
  
  for k=1,para.family[j].count do updateIcon(n,j,k) end 
  
end

function elFramo.frames.updateFamilies(n)

  local para=elFramo.para.frames
  local updateFamily=elFramo.frames.updateFamily
  
  for j=1,para.family.count do updateFamily(n,j) end 
  
end















