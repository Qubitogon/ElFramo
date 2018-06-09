
elFramo.classTable={Druid="DRUID",Monk="MONK",Paladin="PALADIN", Priest="PRIEST", Rogue="ROGUE",Mage="MAGE",Warlock="WARLOCK",Hunter="HUNTER",Shaman="SHAMAN",Warrior="WARRIOR"}

elFramo.raidRosterIndextoGroupIndex={} --1:1 map from RaidRoster index to index in Group

elFramo.nameToRaidRosterIndex={}

elFramo.partyIDs={}
elFramo.partyIDs[1]="player"
for i=2,5 do elFramo.partyIDs[i]="party"..tostring(i) end

elFramo.raidIDs={}
for i=1,40 do elFramo.raidIDs[i]="raid"..tostring(i) end

