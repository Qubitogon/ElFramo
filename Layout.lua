local _,eF=...

local function layoutEventHandler(self,event,...)
  local ic=InCombatLockdown()
  if ic then eF.OOCActions.layoutUpdate=true else self:update() end
end
eF.rep.layoutEventHandler=layoutEventHandler


local function initLayoutFrame()
  eF.layout=CreateFrame("Frame",nil,UIParent)
  eF.layout:SetPoint("TOPRIGHT")
  eF.layout:SetPoint("BOTTOMRIGHT")
  eF.layout:RegisterEvent("GROUP_ROSTER_UPDATE")
  eF.layout:SetScript("OnEvent",eF.rep.layoutEventHandler)
  eF.layout:Show()
  eF.layout.update=eF.rep.layoutUpdate

  --apply all relevant non-table parameters --should not be needed any mroe but hey
  for k,v in pairs(eF.para.units) do
    if type(v)~="table" then eF.layout[k]=v end
  end 
end
eF.rep.initLayoutFrame=initLayoutFrame

local function layoutUpdate(self)
  if InCombatLockdown() then eF.OOCActions.layoutUpdate=true; return end
  local para
  local raid=IsInRaid()
  eF.units.raid=IsInRaid() --is used for the updatefunction
  local num=GetNumGroupMembers() --for some reason gives 0 when solo
  if num==0 then num=1 end
  eF.units.num=num
   
  local units=eF.units
  --r,g,b = GetClassColor
  
  
  if not raid then
    if eF.para.groupParas then para=eF.para.unitsGroup else para=eF.para.units end
    local width,height,spacing,grow1,grow2=para.width,para.height,para.spacing,para.grow1,para.grow2
    
    
    units:ClearAllPoints()
    units:SetPoint("CENTER",UIParent,"BOTTOMLEFT",para.xPos,para.yPos)
    
    local line=1
    local n
    local nmax=para.maxInLine or 5 

    local x=0
    local y=0
    for i=1,5 do
      local unit=eF.partyLoop[i]

      n=i --pointless, i would be fine but too lazy to change all of them
      line=math.floor((n-1)/nmax)+1
      
      if grow1=="right" then 
        x=((n-1)%nmax)*(width+spacing)
        if grow2=="up" then y=(line-1)*(height+spacing)
        elseif grow2=="down" then y=(1-line)*(height+spacing) end  
        
      elseif grow1=="down" then
        y=-((n-1)%nmax)*(height+spacing)

        if grow2=="right" then x=(line-1)*(width+spacing);
        elseif grow2=="left" then x=(1-line)*(width+spacing) end   
        
      elseif grow1=="up" then
        y=((n-1)%nmax)*(height+spacing)
        if grow2=="right" then x=(line-1)*(width+spacing)
        elseif grow2=="left" then x=(1-line)*(width+spacing) end  
        
      elseif grow1=="left" then
        x=-((n-1)%nmax)*(width+spacing)
        if grow2=="up" then y=(line-1)*(height+spacing)
        elseif grow2=="down" then y=(1-line)*(height+spacing) end
      end    
      units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)    
   end
      

  else --if not raid else
    local line=1
    local n
    para=eF.para.units
    local nmax=para.maxInLine or 5 
    local width,height,spacing,grow1,grow2=para.width,para.height,para.spacing,para.grow1,para.grow2
    units:ClearAllPoints()
    units:SetPoint("CENTER",UIParent,"BOTTOMLEFT",para.xPos,para.yPos)
    
    if not para.byGroup then 
      local x=0
      local y=0
      for i=1,40 do
        local unit=eF.raidLoop[i]

        n=i --pointless, i would be fine but too lazy to change all of them
        line=math.floor((n-1)/nmax)+1
        
        if grow1=="right" then 
          x=((n-1)%nmax)*(width+spacing)
          if grow2=="up" then y=(line-1)*(height+spacing)
          elseif grow2=="down" then y=(1-line)*(height+spacing) end  
          
        elseif grow1=="down" then
          y=-((n-1)%nmax)*(height+spacing)

          if grow2=="right" then x=(line-1)*(width+spacing);
          elseif grow2=="left" then x=(1-line)*(width+spacing) end   
          
        elseif grow1=="up" then
          y=((n-1)%nmax)*(height+spacing)
          if grow2=="right" then x=(line-1)*(width+spacing)
          elseif grow2=="left" then x=(1-line)*(width+spacing) end  
          
        elseif grow1=="left" then
          x=-((n-1)%nmax)*(width+spacing)
          if grow2=="up" then y=(line-1)*(height+spacing)
          elseif grow2=="down" then y=(1-line)*(height+spacing) end
        end    
        
        units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)    
     end
     
      
    else --else of if byGroup
      local groups={-1,-1,-1,-1,-1,-1,-1,-1}
      local x=0
      local y=0
      for i=1,num do

        local unit=eF.raidLoop[i]
        local group=select(3,GetRaidRosterInfo(i))
        groups[group]=groups[group]+1
        local ind=groups[group]         
              
        if grow1=="right" then 
          x=ind*(width+spacing)
          if grow2=="up" then y=(group-1)*(height+spacing)
          elseif grow2=="down" then y=(1-group)*(height+spacing) end  
          
        elseif grow1=="down" then
          y=-ind*(height+spacing)

          if grow2=="right" then x=(group-1)*(width+spacing);
          elseif grow2=="left" then x=(1-group)*(width+spacing) end   
          
        elseif grow1=="up" then
          y=ind*(height+spacing)
          if grow2=="right" then x=(group-1)*(width+spacing)
          elseif grow2=="left" then x=(1-group)*(width+spacing) end  
          
        elseif grow1=="left" then
          x=-ind*(width+spacing)
          if grow2=="up" then y=(group-1)*(height+spacing)
          elseif grow2=="down" then y=(1-group)*(height+spacing) end
        end    
        
        units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)    
        
     end--end of for loop 
     
     for i=num+1,40 do
     
        local unit=eF.raidLoop[i]
        local group
        for j=1,8 do 
          if groups[j]<5 then group=j; break end
        end
        if not group then break end
        groups[group]=groups[group]+1
        local ind=groups[group]         
              
        if grow1=="right" then 
          x=ind*(width+spacing)
          if grow2=="up" then y=(group-1)*(height+spacing)
          elseif grow2=="down" then y=(1-group)*(height+spacing) end  
          
        elseif grow1=="down" then
          y=-ind*(height+spacing)

          if grow2=="right" then x=(group-1)*(width+spacing);
          elseif grow2=="left" then x=(1-group)*(width+spacing) end   
          
        elseif grow1=="up" then
          y=ind*(height+spacing)
          if grow2=="right" then x=(group-1)*(width+spacing)
          elseif grow2=="left" then x=(1-group)*(width+spacing) end  
          
        elseif grow1=="left" then
          x=-ind*(width+spacing)
          if grow2=="up" then y=(group-1)*(height+spacing)
          elseif grow2=="down" then y=(1-group)*(height+spacing) end
        end    
        
        units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)  
        
     end --end of for i=num+1,40 do
     
   
   end--end  of if self.byGroup else
  
    
  end-- end of if not raid else
    
  eF.units:onGroupUpdate()
  
end
eF.rep.layoutUpdate=layoutUpdate

--initLayoutFrame()



























