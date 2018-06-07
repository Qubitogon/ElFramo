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
    local r,g,b = GetClassColor(  elFramo.getCLASS(g[i].class)  )

    vis.frame:SetPoint("TOPLEFT","visualMain","TOPLEFT",lineNumber*(1+para.spacing)*para.width,(-(1+para.spacing)*(i-1-lineNumber*para.maxInLine)*para.height))
    
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


function elFramo.frames.updateIcon(n,j,k)

  local trk=elFramo.tracker[n]
  local para=elFramo.para.frames
  local paraFam=para.family[j][k]
  local vis=elFramo.frames.visual[n]
  local found=false
  local dur=0
  local ind=0
  local t=GetTime()
  
  if paraFam.type=="name" then 
    local arg1=paraFam.arg1.."s"
    --print(paraFam.arg1)
    for i=1,trk[arg1].count do 
    if trk[arg1][i].name==paraFam.arg2 then found=true; ind=i; end 
    end 
      
      
      local isShown=vis.family[j][k].frame:IsShown()
      --print(isShown)
      
      if found and not isShown then
      
        vis.family[j][k].frame:Show()
        dur=trk[arg1][ind].duration
        if paraFam.cdWheel then vis.family[j][k].cdFrame:SetCooldown(GetTime(),dur) end
        --print("Set the CD")
        
      elseif found and isShown then 
      
        dur=trk[arg1][ind].duration
        if paraFam.cdWheel then vis.family[j][k].cdFrame:SetCooldown( trk[arg1][ind].expirationTime-dur ,dur) end
        
      elseif not found and isShown then
      
        vis.family[j][k].frame:Hide()
          
      end
  --print(dur)  
  end --end of f para.family[j][k]=="name"

end--end of functon update_Icon


function elFramo.frames.updateFamily(n,j)
  local para=elFramo.para.frames
  local paraFam=para.family[j]
  local updateIcon=elFramo.frames.updateIcon
  local vis=elFramo.frames.visual[n]
  local updateFrameTo=elFramo.updateFrameTo
  --local incrementSmartFamilyIconCount=elFramo.incrementSmartFamilyIconCount
  
  if not paraFam.smart then 
  
    for k=1,paraFam.count do updateIcon(n,j,k) end 
    
  else --if not para.family.smart else
    
    local trk=elFramo.tracker[n]
    local tbl=elFramo.tracker[n][paraFam.arg1.."s"]  --paraFam.arg1 = "buff" / "debuff"
        
    if paraFam.type=="blackList" then 
      
      local m=1
      local prevCount=vis.family[j].active --this time it's not a pointer because im not indexing prevCount and .active is just a number
      
      
      vis.family[j].active=0
      while vis.family[j].active<paraFam.maxCount do --either reach maximum in smart group,
        if m>#tbl then break end  --or end of buffs/debuffs       
        
        if not elFramo.isInList(tbl[m].name,paraFam.arg2) and not (paraFam.ignorePermanents and tbl[m].duration==0)  then
        vis.family[j].active=vis.family[j].active+1
        updateFrameTo(n,j,vis.family[j].active,m,paraFam.arg1.."s")         --updateFrameTo also does frame:Show(), but all others need to be hidden! (see below)
        end --end of if not elFramo.isInList(tbl[m].name,paraFam.arg2)
        
        m=m+1    
        
      end
      
      for o=vis.family[j].active+1,prevCount do
        vis.family[j][o].frame:Hide()
      end
      
    end --end of para.family.type=="blackList"
    
  end --end of  if not para.family.smart else  
end


function elFramo.updateFrameTo(n,j,k,m,s)

  local vis=elFramo.frames.visual[n].family[j][k]
  --print(n,j,k)
  local trk=elFramo.tracker[n][s][m]
  local isShown=vis.frame:IsShown()
  local para=elFramo.para.frames
  local paraFam=para.family[j]
  
  
  if not isShown then
    
    vis.frame:Show()   
    --print(trk.duration)
    if paraFam.cdWheel and trk.duration>0 then vis.cdFrame:SetCooldown(GetTime(),trk.duration) end
    vis.texture:SetTexture(trk.icon)
    
  elseif isShown then
    
    local dur=trk.duration
    if paraFam.cdWheel and trk.duration>0 then vis.cdFrame:SetCooldown( trk.expirationTime-dur ,dur) end
    vis.texture:SetTexture(trk.icon)
  end
  
end


function elFramo.frames.updateFamilies(n)

  local para=elFramo.para.frames
  local updateFamily=elFramo.frames.updateFamily
  
  for j=1,para.family.count do updateFamily(n,j) end 
  
end















