


 
 



function createTextBox()




local mParameters = {        main  = {
                                        xPos=0,           
                                        yPos=0
										},
                               tabs  = {
                                 count = 3,
                                 [1] = {}, 
                                 [2] = {},
                                 [3] = {},
                                 },
                               pages = {
                                 count = 3,
                                 [1] = {},
                                 [2] = {},
                                 [3] = {},
                                }
                      }
           


local mPageWidth  = 400
local mPageHeight = 200


-----------textures for the stuffs
local background = "Interface\\TutorialFrame\\TutorialFrameBackground"
local edgeFile = "Interface\\Tooltips\\UI-ToolTip-Border"
local backdrop ={ bgFile = background,
                  edgeFile = edgeFile,
                  tile = false, tileSize = 70, edgeSize = 70,
                  insets = { left = 3, right = 3, top = 5, bottom = 3 }
                }


----------Create main
  mainMenu = {}
  mainMenu.frame = {}

  mainMenu.frame = CreateFrame("Frame", "mainMenu.frame", UIParent)
  mainMenu.frame:EnableMouse(true)
  mainMenu.frame:SetPoint("CENTER", 300, 300) 
  mainMenu.frame:SetWidth(mPageWidth) 
  mainMenu.frame:SetHeight(mPageWidth)
  mainMenu.frame:Hide()
  mainMenu.frame:SetBackdrop(backdrop)
  MakeMovable(mainMenu.frame)


 -- How to make shitty slider
 --[[ 
 local MySlider = CreateFrame("Slider", "MySliderGlobalName", mainMenu.frame, "OptionsSliderTemplate")
 MySlider:SetPoint("CENTER", 100, 0)
 MySlider:SetWidth(100)
 MySlider:SetHeight(20)
 MySlider:SetOrientation('HORIZONTAL')
 
-- MySlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Vertical")
 MySlider:SetMinMaxValues(0,100)
 MySlider:SetValue(1)
 MySlider:SetValueStep(25)
 MySlider:SetObeyStepOnDrag(true)

 
 MySlider:SetScript("OnValueChanged", function()
 print("adad")end)

--]]




----------Create frame for each page

mainMenu.pages = {}

for j=1,mParameters.pages.count do
  mainMenu.pages[j] = {}
  mainMenu.pages[j].frame = {}
  mainMenu.pages[j].frame = CreateFrame("Frame", nil, mainMenu.frame)
  mainMenu.pages[j].frame:EnableMouse(false)
  mainMenu.pages[j].frame:SetPoint("CENTER",mainMenu.frame,"CENTER", 0, 0) 
  mainMenu.pages[j].frame:SetWidth(mPageWidth)
  mainMenu.pages[j].frame:SetHeight(mPageWidth)
  mainMenu.pages[j].frame:Hide()
end


------------Make pages scrollable

--scrollframe ( 1 scrollframe per page) / page cant be both scroll content and parent

scrollframe = {}
scrollbar   = {}

for j=1,mParameters.pages.count do

  scrollframe[j] = CreateFrame("ScrollFrame", nil, mainMenu.frame)
  scrollframe[j]:SetSize(300,300)
  scrollframe[j]:SetPoint("CENTER",mainMenu.frame,"CENTER", 0, 0) 
  
  if j~=1 then scrollframe[j]:Hide() end


--scrollbar = frame for the scrollbar 

 scrollbar[j] = CreateFrame("Slider", nil, scrollframe[j], "UIPanelScrollBarTemplate") 
 scrollbar[j]:SetPoint("TOPLEFT", mainMenu.frame, "TOPRIGHT", 4, -16) 
 scrollbar[j]:SetPoint("BOTTOMLEFT", mainMenu.frame, "BOTTOMRIGHT", 4, 16) 
 scrollbar[j]:SetMinMaxValues(1, 200) 
 scrollbar[j]:SetValueStep(1) 
 scrollbar[j].scrollStep = 1 
 scrollbar[j]:SetValue(0) 
 scrollbar[j]:SetWidth(16) 
 scrollbar[j]:SetScript("OnValueChanged", 
 function (self, value) 
 self:GetParent():SetVerticalScroll(value) 
 end) 
 


--Set content frame / content = frame is being scrolled
 scrollframe[j]:SetScrollChild(mainMenu.pages[j].frame)
 end


-------tab hiding/showing frames functions 
 
function tabButton1()
 mainMenu.pages[1].frame:Show() 
 mainMenu.pages[2].frame:Hide() 
 mainMenu.pages[3].frame:Hide() 
 
 scrollframe[1]:Show() 
 scrollframe[2]:Hide() 
 scrollframe[3]:Hide()
end

function tabButton2()
 mainMenu.pages[2].frame:Show() 
 mainMenu.pages[1].frame:Hide() 
 mainMenu.pages[3].frame:Hide() 
 
 scrollframe[2]:Show() 
 scrollframe[1]:Hide() 
 scrollframe[3]:Hide()
end

function tabButton3()
 mainMenu.pages[3].frame:Show() 
 mainMenu.pages[1].frame:Hide() 
 mainMenu.pages[2].frame:Hide()

 scrollframe[3]:Show() 
 scrollframe[1]:Hide() 
 scrollframe[2]:Hide() 
end

local tabButton = {tabButton1, tabButton2, tabButton3}


---------tab frames

local tabs = {}

for j=1,mParameters.tabs.count do
 tabs[j] = {}
 tabs[j] = CreateFrame("Button", nil,  mainMenu.frame, "TabButtonTemplate")
 tabs[j]:ClearAllPoints()
 tabs[j]:SetPoint("BOTTOMLEFT", mainMenu.frame, "TOPLEFT",10+(j-1)*110, 0)
 tabs[j]:SetText("tab "..tostring(j))
 tabs[j]:RegisterForClicks("AnyUp")
 tabs[j]:SetScript("OnClick", tabButton[j])
 PanelTemplates_TabResize(tabs[j])
end


---------------------create stuff on page 1
 mainMenu.pages[1].editBoxes = {}
 mainMenu.pages[1].editBoxes[1] = {}
 
 mainMenu.pages[1].editBoxes[1].frame = CreateFrame("EditBox", "InputBoxTemplateTest",  mainMenu.pages[1].frame, "InputBoxTemplate")
 mainMenu.pages[1].editBoxes[1].frame:SetWidth(100)
 mainMenu.pages[1].editBoxes[1].frame:SetHeight(80)
 mainMenu.pages[1].editBoxes[1].frame:ClearAllPoints()
 mainMenu.pages[1].editBoxes[1].frame:SetPoint("CENTER", mainMenu.pages[1].frame ,"CENTER" , 0, 0)
 mainMenu.pages[1].editBoxes[1].frame:SetAutoFocus(false)
 mainMenu.pages[1].editBoxes[1].frame:SetText(23)
 
 mainMenu.pages[1].editBoxes[1].text =  mainMenu.pages[1].editBoxes[1].frame:CreateFontString(nil, "HIGH", 3)
 mainMenu.pages[1].editBoxes[1].text:SetPoint("CENTER",  mainMenu.pages[1].editBoxes[1].frame, "LEFT", -50, 0)
 mainMenu.pages[1].editBoxes[1].text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
 mainMenu.pages[1].editBoxes[1].text:SetTextColor(1,1,1,1)
 mainMenu.pages[1].editBoxes[1].text:SetText("Enter width")

 -----------------------create stuff on page 2

mainMenu.pages[2].checkBoxes={}
mainMenu.pages[2].checkBoxes[1]={}

mainMenu.pages[2].checkBoxes[1].frame = CreateFrame("CheckButton", "checkBox1", mainMenu.pages[2].frame, "UIRadioButtonTemplate")
mainMenu.pages[2].checkBoxes[1].frame:SetHeight(20)
mainMenu.pages[2].checkBoxes[1].frame:SetWidth(20)
mainMenu.pages[2].checkBoxes[1].frame:ClearAllPoints()
mainMenu.pages[2].checkBoxes[1].frame:SetPoint("CENTER", 0, 0)
_G[mainMenu.pages[2].checkBoxes[1].frame:GetName() .. "Text"]:SetText("do you want protection")
--_G["checkBox1".."Text"]:SetText("SSS")
MakeMovable(mainMenu.pages[2].checkBoxes[1].frame)
 
 
 
 
 
 
 
 --------------------------create stuff on page 3
 
 mainMenu.pages[3].editBoxes = {}
 mainMenu.pages[3].editBoxes[1] = {}
 
 mainMenu.pages[3].editBoxes[1].frame = CreateFrame("EditBox", "InputBoxTemplateTest",  mainMenu.pages[3].frame, "InputBoxTemplate")
 mainMenu.pages[3].editBoxes[1].frame:SetWidth(100)
 mainMenu.pages[3].editBoxes[1].frame:SetHeight(20)
 mainMenu.pages[3].editBoxes[1].frame:ClearAllPoints()
 mainMenu.pages[3].editBoxes[1].frame:SetPoint("CENTER", mainMenu.pages[3].frame ,"CENTER" , 0, 0)
 mainMenu.pages[3].editBoxes[1].frame:SetAutoFocus(false)
 mainMenu.pages[3].editBoxes[1].frame:SetText(23)
 
 mainMenu.pages[3].editBoxes[1].text =  mainMenu.pages[3].editBoxes[1].frame:CreateFontString(nil, "HIGH", 3)
 mainMenu.pages[3].editBoxes[1].text:SetPoint("CENTER",  mainMenu.pages[3].editBoxes[1].frame, "LEFT", -65, 0)
 mainMenu.pages[3].editBoxes[1].text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
 mainMenu.pages[3].editBoxes[1].text:SetTextColor(1,1,1,1)
 mainMenu.pages[3].editBoxes[1].text:SetText("beat me as i sneezes")
 
 
 

-- /eF to toggle menu
SLASH_ELFRAMO1 = "/eF"
SlashCmdList["ELFRAMO"] = 
function(msg)
  
 if mainMenu.frame:IsShown() then mainMenu.frame:Hide()
 else mainMenu.frame:Show()
 end
 
 mainMenu.pages[1].frame:Show()
end





end





