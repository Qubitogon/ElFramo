
print("ElNoto start init")

local playername,playerrealm=UnitName("player")
local player1=playername
local player2=nil
local playerrealm=nil
local Elnoto_grid={}
local yourturn=true
local didstart=false
local duelup=false
local gridsym={}
local player1next=false
local player2next=false
local p1score,p2score,drawscore=0,0,0

RegisterAddonMessagePrefix("elnoto")
local frame = CreateFrame("FRAME", "FooAddonFrame");
frame:RegisterEvent("CHAT_MSG_ADDON")
local positions={"TL","TC","TR","CL","CC","CR","BL","BC","BR"}

local function ssplit(s)
	local pos1 = 0
	local pos2 = 0
	local DelCountStart=0
	local DelCountEnd=0
	
	i=1
	while s:sub(i,i)==" " do
		DelCountStart=DelCountStart+1
		i=i+1
	end
	
	i=#s
	while s:sub(i,i)==" " do
		DelCountEnd=DelCountEnd+1
		i=i-1
	end
	
	s=s:sub(DelCountStart+1,#s-DelCountEnd)
	
	for i=1,#s do 	
		local c=s:sub(i,i)
		local cn=s:sub(i+1,i+1)
		
		if i==1 then pos1=1 
		elseif i==#s then pos2=#s+1
		elseif pos2-pos1<=0 and c==" " then pos2=i end
		
		if pos2-pos1>0 and cn~=" "  then 
						subs=s:sub(pos1,pos2-1)
						if TesterWordList[subs]==nil then TesterWordList[subs]=0
						else TesterWordList[subs]=TesterWordList[subs]+1 end 	
						pos1=i+1
						pos2=0
				       end 
	end
	
	
	
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function onUpdate(self,elapsed)
  --  CDtimer = CDtimer + elapsed
	--  delay=delay+elapsed
	
end
 
 
--local t = CreateFrame("frame")
--t:SetScript("OnUpdate", onUpdate)


do-------------------Main frame creation
local Elnoto = CreateFrame("Frame", "Elnoto", UIParent)
Elnoto:EnableMouse(true)
Elnoto:SetFrameStrata("MEDIUM")
Elnoto:SetMovable(true)
Elnoto:EnableMouse(true)
Elnoto:RegisterForDrag("LeftButton")
Elnoto:SetScript("OnDragStart", Elnoto.StartMoving)
Elnoto:SetScript("OnDragStop", Elnoto.StopMovingOrSizing)
Elnoto:SetPoint("CENTER"); Elnoto:SetWidth(200); Elnoto:SetHeight(200);

local Elnoto_border = Elnoto:CreateTexture();
Elnoto_border:SetDrawLayer("BACKGROUND",0)
Elnoto_border:SetPoint("TOPLEFT",-3,3)
Elnoto_border:SetPoint("BOTTOMRIGHT",3,-3)
Elnoto_border:SetAlpha(1);
--Elnoto_border:SetColorTexture(0.54,0.27,0.075)
Elnoto_border:SetColorTexture(0,0,0)


--[[local Elnoto_body = Elnoto:CreateTexture();
Elnoto_body:SetDrawLayer("BACKGROUND",1)
Elnoto_body:SetPoint("TOPLEFT",0,0)
Elnoto_body:SetPoint("BOTTOMRIGHT",0,0)
Elnoto_body:SetAlpha(1);
Elnoto_body:SetColorTexture(0.25,0.2,0.133)]]--
end

do------------------Subframes initialisation
local j=1
for j=1,9 do
  local lpos=positions[j]
  
  Elnoto_grid[lpos]={}
  Elnoto_grid[lpos]["frame"]={}
  Elnoto_grid[lpos]["button"]={}
  
  Elnoto_grid[lpos].frame["frame"]=CreateFrame("Frame",nil,Elnoto)
  Elnoto_grid[lpos].frame["texture"]=Elnoto_grid[lpos].frame.frame:CreateTexture()
  Elnoto_grid[lpos].frame["text"]=Elnoto_grid[lpos].frame.frame:CreateFontString(nil,"BACKGROUND") ----HERE3
  
  Elnoto_grid[lpos].button["button"]=CreateFrame("Button",nil,Elnoto)
  Elnoto_grid[lpos].button["texture"]=Elnoto_grid[lpos].button.button:CreateTexture()
  Elnoto_grid[lpos].button["pdtexture"]=Elnoto_grid[lpos].button.button:CreateTexture()
  Elnoto_grid[lpos].button["hltexture"]=Elnoto_grid[lpos].button.button:CreateTexture()
  Elnoto_grid[lpos].button.button:EnableMouse(true)
  
end

Elnoto_MiddleFrame = CreateFrame("Frame", "MiddleFrame", Elnoto)
MiddleFrame:SetFrameStrata("HIGH")
MiddleFrame:SetAllPoints()

Elnoto_MiddleText=Elnoto_MiddleFrame:CreateFontString(nil,"ARTWORK",-3)
Elnoto_MiddleText:SetPoint("CENTER",MiddleFrame,"CENTER",0,0)
Elnoto_MiddleText:SetFont("Fonts\\ARIALN.ttf",30) --,500)
Elnoto_MiddleText:SetTextColor(0.85,0.85,0)
Elnoto_MiddleText:SetText("")

Elnoto_MiddleTexture=Elnoto_MiddleFrame:CreateTexture()
Elnoto_MiddleTexture:SetPoint("CENTER",Elnoto_MiddleFrame,"CENTER",0,0)
Elnoto_MiddleTexture:SetColorTexture(0,0,0,0.5)
Elnoto_MiddleTexture:SetHeight(30)
Elnoto_MiddleTexture:SetWidth(200)

MiddleFrame:Hide()

end

do------------------Create Bottom Bar
Elnoto_BB=CreateFrame("Frame",nil,Elnoto)
Elnoto_BB:SetFrameStrata("MEDIUM")
Elnoto_BB:SetPoint("TOPLEFT",Elnoto,"BOTTOMLEFT",0,0)
Elnoto_BB:SetPoint("TOPRIGHT",Elnoto,"TOPRIGHT",0,0)
Elnoto_BB:SetHeight(50)

Elnoto_BBtexture=Elnoto_BB:CreateTexture()
Elnoto_BBtexture:SetDrawLayer("ARTWORK")
Elnoto_BBtexture:SetAllPoints()
Elnoto_BBtexture:SetAlpha(1)
Elnoto_BBtexture:SetColorTexture(0,0,0)

Elnoto_BB_text=Elnoto_BB:CreateFontString(nil,"ARTWORK")
Elnoto_BB_text:SetPoint("CENTER",Elnoto_BB,"CENTER",0,0)
Elnoto_BB_text:SetFont("Fonts\\ARIALN.ttf",15)
Elnoto_BB_text:SetTextColor(0.85,0.85,0)
Elnoto_BB_text:SetText("/enduel to duel your target")

Elnoto_BB_next=CreateFrame("Button",nil,Elnoto_BB)
Elnoto_BB_next:SetFrameStrata("HIGH")
Elnoto_BB_next:SetPoint("CENTER",Elnoto,"CENTER",0,-18)
Elnoto_BB_next:SetWidth(50)
Elnoto_BB_next:SetHeight(16)
Elnoto_BB_next:SetText("NEXT")
Elnoto_BB_next:SetNormalFontObject("GameFontNormal")
 
Elnoto_BB_next_texture=Elnoto_BB_next:CreateTexture()
Elnoto_BB_next_texture:SetDrawLayer("ARTWORK")
Elnoto_BB_next_texture:SetAllPoints()
Elnoto_BB_next_texture:SetAlpha(0.8);
Elnoto_BB_next_texture:SetColorTexture(0,0,0)
Elnoto_BB_next:SetNormalTexture(resetb_texture)

  Elnoto_BB_score1=Elnoto_BB:CreateFontString(nil,"ARTWORK")
  Elnoto_BB_score1:SetPoint("TOPLEFT",Elnoto_BB,"TOPLEFT",10,-10)
  Elnoto_BB_score1:SetFont("Fonts\\ARIALN.ttf",12)
  Elnoto_BB_score1:SetTextColor(0.85,0.85,0)
  Elnoto_BB_score1:Hide()
  
   
  Elnoto_BB_score2=Elnoto_BB:CreateFontString(nil,"ARTWORK")
  Elnoto_BB_score2:SetPoint("TOP",Elnoto_BB,"TOP",0,-10)
  Elnoto_BB_score2:SetFont("Fonts\\ARIALN.ttf",12)
  Elnoto_BB_score2:SetTextColor(0.85,0.85,0)
  Elnoto_BB_score2:Hide()
  
  Elnoto_BB_score3=Elnoto_BB:CreateFontString(nil,"ARTWORK")
  Elnoto_BB_score3:SetPoint("TOPRIGHT",Elnoto_BB,"TOPRIGHT",-10,-10)
  Elnoto_BB_score3:SetFont("Fonts\\ARIALN.ttf",12)
  Elnoto_BB_score3:SetTextColor(0.85,0.85,0)
  Elnoto_BB_score3:Hide()
end

local function Elnoto_SetScore(p1score,p2score,drawscore,p2)

  Elnoto_BB_score1:SetText(player1.."\n"..p1score)
  Elnoto_BB_score1:Show()
  Elnoto_BB_score2:SetText("Draws".."\n"..drawscore)
  Elnoto_BB_score2:Show()
  Elnoto_BB_score3:SetText(player2.."\n"..p2score)
  Elnoto_BB_score3:Show()
  
end

local function griddisable()
  local k=0
  for k=1,9 do
    local pos2=positions[k]
    Elnoto_grid[pos2].button.button:Disable()
    Elnoto_grid[pos2].button.texture:SetColorTexture(0.35,0.30,0.26)
  end
end

local function gridenable()
  local k=0
  for k=1,9 do
    local pos2=positions[k]
    Elnoto_grid[pos2].button.button:Enable()
    Elnoto_grid[pos2].button.texture:SetColorTexture(0.25,0.2,0.133)
  end
end

local threes={{"TL","TC","TR"},{"CL","CC","CR"},{"BL","BC","BR"},{"TL","CL","BL"},{"TC","CC","BC"},{"TR","CR","BR"},{"TL","CC","BR"},{"BL","CC","TR"}}


local function IsItWin()
  local win=nil
  local x=1
  local winid=0
  local winsym=''
  local count=0
  for x=1,8 do
    local sum=0
    local y=1
    for y=1,3 do
      local pos3=threes[x][y]
      local sym=gridsym[pos3]
      if sym=="O" then sum=sum+1 end
      if sym=="X" then sum=sum-1 end 
    end
    if sum==-3 then win=true;winsym='X';winid=x end
    if sum==3 then win=true;winsym='O';winid=x end
  end
  
  for x=1,9 do local 
    pos3=positions[x]
    local sym=gridsym[pos3]
    if (sym=="O" or sym=="X") then count=count+1 end
  end
  
  if (not win and count==9) then win=true;winsym="DRAW" end 
  
  return win,winsym,winid

end


local function PerfMove(pos,player)


  --PlaySound(soundid,"Master")
  if player==player1 then 
    gridsym[pos]="O"
    Elnoto_grid[pos].frame.text:SetText("O")
    yourturn=false
    griddisable()
    --count=count+1
  else 
    yourturn=true
    gridsym[pos]="X"
    gridenable()
  end
  Elnoto_grid[pos].button.button:Hide()
  local win,winsym,winid = IsItWin()
  if win then
    griddisable()
    local winner=""
    if winsym=="X" then winner=player2;p2score=p2score+1; 
    elseif winsym=="O" then winner=player1;p1score=p1score+1; 
    elseif winsym=="DRAW" then winner="Nobody";drawscore=drawscore+1; end
    Elnoto_MiddleText:SetText(winner.." won!")
    Elnoto_MiddleFrame:Show()
    Elnoto_BB_next:Show()
    --print("drawscore=",drawscore)
    Elnoto_SetScore(p1score,p2score,drawscore,player2)
    --Elnoto_BB_text:Show()
    
  end
  --if win then print("win") end 
end 
      

local function SendMoveMessage(player2,pos)
  local message="MOVE"..pos
  SendAddonMessage("elnoto",message,"WHISPER",player2)
end


------------------------Button creation
function ElnotoPaintGrid(index)

local pos=positions[index]
local rn=0
local cn=0

if pos=="TL" --positional things
  then rn=0; cn=0
elseif pos=="TC" 
  then rn=0; cn=1
elseif pos=="TR" 
  then rn=0; cn=2
elseif pos=="CL" 
  then rn=1; cn=0
elseif pos=="CC" 
  then rn=1; cn=1
elseif pos=="CR" 
  then rn=1; cn=2
elseif pos=="BL" 
  then rn=2; cn=0
elseif pos=="BC" 
  then rn=2; cn=1
elseif pos=="BR" 
  then rn=2; cn=2
end

local wid=floor(Elnoto:GetWidth()/3)-3
local hei=floor(Elnoto:GetHeight()/3)-3
local gapwid=6
local gaphei=6


--local grid.frame[index]=CreateFrame("Frame",nil,Elnoto)
Elnoto_grid[pos].frame.frame:SetFrameStrata("MEDIUM")
Elnoto_grid[pos].frame.frame:SetPoint("TOPLEFT",Elnoto,"TOPLEFT",cn*(wid+gapwid),-rn*(hei+gaphei))
Elnoto_grid[pos].frame.frame:SetWidth(wid)
Elnoto_grid[pos].frame.frame:SetHeight(hei)

--local grid.frame[index].texture =grid.frame[index]:CreateTexture();
Elnoto_grid[pos].frame.texture:SetDrawLayer("BACKGROUND") ----HERE
Elnoto_grid[pos].frame.texture:SetPoint("TOPLEFT",0,0)
Elnoto_grid[pos].frame.texture:SetPoint("BOTTOMRIGHT",0,0)
Elnoto_grid[pos].frame.texture:SetAlpha(1);
Elnoto_grid[pos].frame.texture:SetColorTexture(0.25,0.2,0.133)

--local grid.frame[index].text=grid.frame[index]:CreateFontString(nil,"ARTWORK")
Elnoto_grid[pos].frame.text:SetPoint("CENTER",Elnoto_grid[pos].frame.frame,"CENTER",0,0)
Elnoto_grid[pos].frame.text:SetFont("Fonts\\ARIALN.ttf",72) --,500)
Elnoto_grid[pos].frame.text:SetText("X")


--local grid.button[index]=CreateFrame("Button",nil,Elnoto)
Elnoto_grid[pos].button.button:SetFrameStrata("MEDIUM")  ------HERE2
Elnoto_grid[pos].button.button:SetPoint("TOPLEFT",Elnoto,"TOPLEFT",cn*(wid+gapwid),-rn*(hei+gaphei))
Elnoto_grid[pos].button.button:SetWidth(wid)
Elnoto_grid[pos].button.button:SetHeight(hei)
Elnoto_grid[pos].button.button:SetText("")
Elnoto_grid[pos].button.button:SetNormalFontObject("GameFontNormal")

--local grid.button[index].texture = grid.button[index]:CreateTexture();
Elnoto_grid[pos].button.texture:SetDrawLayer("BACKGROUND") -----HERE
Elnoto_grid[pos].button.texture:SetPoint("TOPLEFT",0,0)
Elnoto_grid[pos].button.texture:SetPoint("BOTTOMRIGHT",0,0)
Elnoto_grid[pos].button.texture:SetAlpha(1);
Elnoto_grid[pos].button.texture:SetColorTexture(0.25,0.2,0.133)
Elnoto_grid[pos].button.button:SetNormalTexture(Elnoto_grid[pos].button.texture)

--local grid.button[index].pdtexture=grid.button[index]:CreateTexture()
Elnoto_grid[pos].button.pdtexture:SetDrawLayer("BACKGROUND",2) ------HERE
Elnoto_grid[pos].button.pdtexture:SetPoint("TOPLEFT",0,0)
Elnoto_grid[pos].button.pdtexture:SetPoint("BOTTOMRIGHT",0,0)
Elnoto_grid[pos].button.pdtexture:SetAlpha(1)
Elnoto_grid[pos].button.pdtexture:SetColorTexture(0.30,0.22,0.133)
Elnoto_grid[pos].button.button:SetPushedTexture(Elnoto_grid[pos].button.pdtexture)

--local grid.button[index].hltexture=grid.button[index]:CreateTexture()
Elnoto_grid[pos].button.hltexture:SetDrawLayer("BACKGROUND",1) -------HERE
Elnoto_grid[pos].button.hltexture:SetPoint("TOPLEFT",0,0)
Elnoto_grid[pos].button.hltexture:SetPoint("BOTTOMRIGHT",0,0)
Elnoto_grid[pos].button.hltexture:SetAlpha(0.1)
Elnoto_grid[pos].button.hltexture:SetColorTexture(1,1,1)
Elnoto_grid[pos].button.button:SetHighlightTexture(Elnoto_grid[pos].button.hltexture)

-------noise when clicked
Elnoto_grid[pos].button.button:SetScript("OnClick",function(self,button,down)
    PerfMove(pos,player1)
    if player2 and duelup then 
        SendMoveMessage(player2,pos);
    else print("Use /enduel to duel your target first") end 
     
  end) 
end 

local soundids={5980,5981,5982,5983,5984,5985,5986,5987,5988,5989,5990}
local posn=0
for posn=1,9 do
  ElnotoPaintGrid(posn)
end



SLASH_ENTOGGLE1 = '/entoggle'
function SlashCmdList.ENTOGGLE(msg, editbox) 
  local vis=Elnoto:IsVisible()
	if vis then Elnoto:Hide() 
  else Elnoto:Show() end
end


local function enreset()
  --print("enreset called")
  local k=0
  for k=1,9 do 
    local pos2=positions[k] 
    Elnoto_grid[pos2].button.button:Show()
    Elnoto_grid[pos2].frame.text:SetText("X")
    --count=2
  end
  Elnoto_MiddleFrame:Hide()
  Elnoto_MiddleText:SetText('')
  Elnoto_BB_text:Show()
  gridsym={}
  griddisable()
  if player2 then SendAddonMessage("elnoto","RESET","WHISPER",player2) end
  player2=nil
  duelup=false
  Elnoto_BB_next:Hide()
  p2score=0
  p1score=0
  drawscore=0
  Elnoto_BB_score1:Hide()
  Elnoto_BB_score2:Hide()
  Elnoto_BB_score3:Hide()
  
end

local function nextround()
  local k=0
  for k=1,9 do 
    local pos2=positions[k] 
    Elnoto_grid[pos2].button.button:Show()
    Elnoto_grid[pos2].frame.text:SetText("X")
    --count=2
  end
    Elnoto_MiddleFrame:Hide()
    Elnoto_MiddleText:SetText('')
    Elnoto_BB_next:Hide()
    gridsym={}
    player2next=false
    player1next=false
    if didstart then didstart=false; griddisable();
    else didstart=true; gridenable() end 

end

Elnoto_BB_next:SetScript("OnClick",function(self,button,down)
  SendAddonMessage("elnoto","NEXT","WHISPER",player2);
  if player2next then nextround()
  else player1next=true end
  end)
Elnoto_BB_next:Hide()
  
SLASH_ENRESET1 = '/enreset'
function SlashCmdList.ENRESET(msg, editbox) 
  enreset()
end

local function startduel(enemy,didstart)
  player1=player1
  player2=enemy
  duelup=true
  if didstart then gridenable() else griddisable() end
  Elnoto_BB_text:Hide()
  Elnoto_SetScore(0,0,0,player2)
end

SLASH_ENDUEL1 = '/enduel'
function SlashCmdList.ENDUEL(msg, editbox) 
  local name,realm=UnitName("target")
  if not duelup then 
    didstart=true
    player2=name
    startduel(player2,didstart)
    SendAddonMessage("elnoto","DUEL","WHISPER",player2)
  else 
    Elnoto_BB_text:SetText("You are in duel with someone else")
  end
end

local function eventHandler(self, event,...)--------handles CHAT_MSG_ADDON

	if event=="CHAT_MSG_ADDON" then 
    local prefix,message,channel,sender = ...
    local rlfind=nil
    if prefix=="elnoto" then 
      if sender then 
        sender=Ambiguate(sender,"none")
      end 
      if not duelup then 
      
        if message=="DUEL" then startduel(sender,false) end
        if message=="INDUEL" then print("Player is already in duel") end
        
      elseif sender==player2 then
        if strsub(message,1,4)=="MOVE" then PerfMove(strsub(message,5,6),sender) end
        
        if message=="NEXT" then 
          if player1next==true then nextround() else player2next=true end 
        end 
        
        if message=="RESET" then enreset();Elnoto_BB_text:SetText("Your opponent left"); end
        
      else SendAddonMessage("elnoto","INDUEL","WHISPER",sender) end 
      
 
    end
    
  end	
end

frame:SetScript("OnEvent", eventHandler);

--[[do-------------Create Reset Button
resetb=CreateFrame("Button",nil,Elnoto)
resetb:SetFrameStrata("HIGH")
resetb:SetPoint("BOTTOM",Elnoto,"TOP",0,10)
resetb:SetWidth(50)
resetb:SetHeight(20)
resetb:SetText("RESET")
resetb:SetNormalFontObject("GameFontNormal")

resetb:SetScript("OnClick",function(self,button,down)
  enreset()
  end)
 
resetb_texture=resetb:CreateTexture()
resetb_texture:SetDrawLayer("ARTWORK")
resetb_texture:SetPoint("TOPLEFT",0,0)
resetb_texture:SetPoint("BOTTOMRIGHT",0,-10)
resetb_texture:SetAlpha(1);
resetb_texture:SetColorTexture(0,0,0)
resetb:SetNormalTexture(resetb_texture)
end]]--



--SendAddonMessage("elnoto","WASSUPMAN","WHISPER",player1)

griddisable()
--Elnoto:Hide()
print("ElNoto initiated")


