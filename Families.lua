_,eF=...

eF.para.families={[1]={displayName="void",
                       smart=false,
                       
                       
                      }, --end of ...families[1]

                 }--end of eF.para.families
                 
for i=1,40 do
  local frame=eF.units[eF.raidLoop[i]]
  frame.families=eF.para.families
end--emd of i
                 
for i=1,5 do
  local frame=eF.units[eF.partyLoop[i]]
  frame.families=eF.para.families
end--emd of i

