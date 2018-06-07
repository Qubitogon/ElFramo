print("---- UI.lua init")







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


--textures for the stuffs
local background = "Interface\\TutorialFrame\\TutorialFrameBackground"
local edgeFile = "Interface\\Tooltips\\UI-ToolTip-Border"
local backdrop ={ bgFile = background,
                  edgeFile = edgeFile,
                  tile = false, tileSize = 16, edgeSize = 16,
                  insets = { left = 3, right = 3, top = 5, bottom = 3 }
                }


--Create main
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


-- create pages ( parent frame mMenu.frames.main)

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


function tabButton1()
 mainMenu.pages[1].frame:Show() 
 mainMenu.pages[2].frame:Hide() 
 mainMenu.pages[3].frame:Hide() 
end

function tabButton2()
 mainMenu.pages[2].frame:Show() 
 mainMenu.pages[1].frame:Hide() 
 mainMenu.pages[3].frame:Hide() 
end

function tabButton3()
 mainMenu.pages[3].frame:Show() 
 mainMenu.pages[1].frame:Hide() 
 mainMenu.pages[2].frame:Hide() 
end

local tabButton = {tabButton1, tabButton2, tabButton3}


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


---create stuff on page 1
 mainMenu.pages[1].editBoxes = {}
 mainMenu.pages[1].editBoxes[1] = {}
 
 mainMenu.pages[1].editBoxes[1].frame = CreateFrame("EditBox", "InputBoxTemplateTest",  mainMenu.pages[1].frame, "InputBoxTemplate")
 mainMenu.pages[1].editBoxes[1].frame:SetWidth(100)
 mainMenu.pages[1].editBoxes[1].frame:SetHeight(20)
 mainMenu.pages[1].editBoxes[1].frame:ClearAllPoints()
 mainMenu.pages[1].editBoxes[1].frame:SetPoint("CENTER", mainMenu.pages[1].frame ,"CENTER" , 0, 0)
 mainMenu.pages[1].editBoxes[1].frame:SetAutoFocus(false)
 mainMenu.pages[1].editBoxes[1].frame:SetText(23)
 
 mainMenu.pages[1].editBoxes[1].text =  mainMenu.pages[1].editBoxes[1].frame:CreateFontString(nil, "HIGH", 3)
 mainMenu.pages[1].editBoxes[1].text:SetPoint("CENTER",  mainMenu.pages[1].editBoxes[1].frame, "LEFT", -50, 0)
 mainMenu.pages[1].editBoxes[1].text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
 mainMenu.pages[1].editBoxes[1].text:SetTextColor(1,1,1,1)
 mainMenu.pages[1].editBoxes[1].text:SetText("Enter width")

 ---create stuff on page 2

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
 
 
 
 
 
 
 
 ---create stuff on page 3
 
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





