 local _,eF=...

eFGlob=eF

local function layoutEventHandler(self,event,...)
  self:update()
  if event=="PLAYER_ENTERING_WORLD" then self:update() end
end
eF.rep.layoutEventHandler=layoutEventHandler

local function initLayoutFrame()
  eF.layout=CreateFrame("Frame",nil,UIParent)
  eF.layout:SetPoint("TOPRIGHT")
  eF.layout:SetPoint("BOTTOMRIGHT")
  eF.layout:RegisterEvent("GROUP_ROSTER_UPDATE")
  eF.layout:RegisterEvent("PLAYER_ENTERING_WORLD")
  eF.layout:SetScript("OnEvent",eF.rep.layoutEventHandler)
  eF.layout:Show()
  eF.layout.update=eF.rep.layoutUpdate

  --apply all relevant non-table parameters
  for k,v in pairs(eF.para.layout) do
    if type(v)~="table" then eF.layout[k]=v end
  end 
end

local function layoutUpdate(self)
  local width=eF.units.width or 30
  local height=eF.units.height or 30
  local raid=IsInRaid()
  eF.units.raid=IsInRaid() --is used for the updatefunction
  local num=GetNumGroupMembers() --for some reason gives 0 when solo
  if num==0 then num=1 end
  eF.units.num=num
    
  local units=eF.units
  --r,g,b = GetClassColor
  
  if not raid then
    
    for n=1,num do
      local unit=eF.partyLoop[n]
      local x=0
      local y=0
      if self.grow1=="right" then 
        x=(n-1)*(width+self.spacing)
        y=0
      elseif self.grow1=="down" then
        y=(1-n)*(height+self.spacing)
        x=0
      elseif self.grow1=="up" then
        y=(n-1)*(height+self.spacing)
        x=0
      elseif self.grow2=="left" then
        x=(1-n)*(width+self.spacing)
      end    

      units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)
      
    end   

  else --if not raid else

    local line=1
    local nmax=self.maxInLine or 5 
    local n
    if not self.byGroup then 
      nmax=5 
      for i=1,num do
        local unit=eF.raidLoop[i]
        local x=0
        local y=0
        n=i --pointless, i would be fine but too lazy to change all of them
        line=math.floor((n-1)/nmax)+1
        
        if self.grow1=="right" then 
          x=((n-1)%nmax)*(width+self.spacing)
          if self.grow2=="up" then y=(line-1)*(height+self.spacing)
          elseif self.grow2=="down" then y=(1-line)*(height+self.spacing) end  
          
        elseif self.grow1=="down" then
          y=-((n-1)%nmax)*(height+self.spacing)

          if self.grow2=="right" then x=(line-1)*(width+self.spacing);
          elseif self.grow2=="left" then x=(1-line)*(width+self.spacing) end   
          
        elseif self.grow1=="up" then
          y=((n-1)%nmax)*(height+self.spacing)
          if self.grow2=="right" then x=(line-1)*(width+self.spacing)
          elseif self.grow2=="left" then x=(1-line)*(width+self.spacing) end  
          
        elseif self.grow1=="left" then
          x=-((n-1)%nmax)*(width+self.spacing)
          if self.grow2=="up" then y=(line-1)*(height+self.spacing)
          elseif self.grow2=="down" then y=(1-line)*(height+self.spacing) end
        end    
        
        units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)    
     end
    else --else of if byGroup
      local groups={-1,-1,-1,-1,-1,-1,-1,-1}
      
      for i=1,num do
        local x=0
        local y=0
        local unit=eF.raidLoop[i]
        local group=select(3,GetRaidRosterInfo(i))
        groups[group]=groups[group]+1
        local ind=groups[group]         
              
        if self.grow1=="right" then 
          x=ind*(width+self.spacing)
          if self.grow2=="up" then y=(group-1)*(height+self.spacing)
          elseif self.grow2=="down" then y=(1-group)*(height+self.spacing) end  
          
        elseif self.grow1=="down" then
          y=-ind*(height+self.spacing)

          if self.grow2=="right" then x=(group-1)*(width+self.spacing);
          elseif self.grow2=="left" then x=(1-group)*(width+self.spacing) end   
          
        elseif self.grow1=="up" then
          y=ind*(height+self.spacing)
          if self.grow2=="right" then x=(group-1)*(width+self.spacing)
          elseif self.grow2=="left" then x=(1-group)*(width+self.spacing) end  
          
        elseif self.grow1=="left" then
          x=-ind*(width+self.spacing)
          if self.grow2=="up" then y=(group-1)*(height+self.spacing)
          elseif self.grow2=="down" then y=(1-group)*(height+self.spacing) end
        end    
        
        units[unit]:SetPoint("TOPLEFT",units,"TOPLEFT",x,y)    
        
     end--end of for loop 
   
   end--end  of if self.byGroup else
  
  end-- end of if not raid else
    
  eF.units:onGroupUpdate()
  
end
eF.rep.layoutUpdate=layoutUpdate

initLayoutFrame()