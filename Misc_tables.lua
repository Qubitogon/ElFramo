print("----Misc_tables.lua init")
ElFramo.ClassTable={Druid="DRUID",Monk="MONK",Paladin="PALADIN", Priest="PRIEST", Rogue="ROGUE",Mage="MAGE",Warlock="WARLOCK",Hunter="HUNTER",Shaman="SHAMAN"}

ElFramo.RaidRosterIndextoGroupIndex={} --1:1 map from RaidRoster index to index in Group

ElFramo.NameToRaidRosterIndex={}

ElFramo.PartyIDs={}
ElFramo.PartyIDs[1]="player"
for i=2,5 do ElFramo.PartyIDs[i]="party"..tostring(i) end

ElFramo.RaidIDs={}
for i=1,40 do ElFramo.RaidIDs[i]="raid"..tostring(i) end

