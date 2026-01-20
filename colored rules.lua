--Modified by: Gl1tcherBro


--This function was put together by me quickly
function getColorByObjectName(name)
	local text_name = "text_" .. name
	local unitid = nil

	for _, unitid_ in ipairs(findall({text_name, {}})) do
		unitid = unitid_
		break
	end

	local c1,c2 = -1,-1

	if (unitid ~= nil) then
		c1,c2 = getcolour(unitid,"active")
	end


	if (c1 == -1) or (c2 == -1) then
		--error(name,999)
		c1 = 0
		c2 = 3
	end

	return "$" .. c1 .. "," .. c2
end


--Original function came with the game
function writerules(parent,name,x_,y_)
	local allrules_colored = {}
	
	local basex = x_
	local basey = y_
	local linelimit = 12
	local maxcolumns = 4
	
	local x,y = basex,basey
	
	if (#visualfeatures > 0) then
		writetext(langtext("rules_colon"),0,x,y,name,true,2,true)
	end
	
	local i_ = 1
	
	local count = 0
	local allrules = {}
	
	local custom = MF_read("level","general","customruleword")
	
	for i,rules in ipairs(visualfeatures) do
		local text = ""
		local coloured_text = ""
		local rule = rules[1]
		
		if (#custom == 0) then
			text = text .. rule[1] .. " "

			coloured_text = "$0,3" .. coloured_text .. getColorByObjectName(rule[1]) .. rule[1] .. " "
		else
			text = text .. custom .. " "

			coloured_text = "$0,3" .. coloured_text .. getColorByObjectName(custom) .. custom .. " "
		end
		
		local conds = rules[2]
		local ids = rules[3]
		local tags = rules[4]
		
		local fullinvis = true
		for a,b in ipairs(ids) do
			for c,d in ipairs(b) do
				local dunit = mmf.newObject(d)
				
				if dunit.visible then
					fullinvis = false
					break
				end
			end
		end
		
		for a,b in ipairs(tags) do
			if (string.sub(b, 1, 12) == "mimicparent_") and (featureindex["mimic"] ~= nil) then
				local id = tonumber(string.sub(b, -1))
				local parent = featureindex["mimic"][id]
				
				if (parent ~= nil) then
					local ids_ = parent[3]
					local finvis = true
					for a,b_ in ipairs(ids_) do
						for c,d in ipairs(b_) do
							local dunit = mmf.newObject(d)
							
							if dunit.visible then
								finvis = false
								break
							end
						end
					end
					
					if finvis then
						fullinvis = true
					end
				end
				
				break
			end
		end
		
		if (fullinvis == false) then
			if (#conds > 0) then
				for a,cond in ipairs(conds) do
					local middlecond = true
					
					if (cond[2] == nil) or ((cond[2] ~= nil) and (#cond[2] == 0)) then
						middlecond = false
					end
					
					if middlecond then
						if (#custom == 0) then
							local target = cond[1]
							local isnot = string.sub(target, 1, 4)
							local target_ = target
							local coloured_target = target
							local coloured_isnot = ""
							
							if (isnot == "not ") then
								target_ = string.sub(target, 5)

								coloured_isnot = getColorByObjectName("not") .. "not "
							else
								isnot = ""
							end
							
							if (word_names[target_] ~= nil) then
								target = isnot .. word_names[target_]

								coloured_target = coloured_isnot .. getColorByObjectName(word_names[target_]) .. word_names[target_]
							else
								coloured_target = coloured_isnot .. getColorByObjectName(target_) .. target_
							end
							
							text = text .. target .. " "

							coloured_text = "$0,3" .. coloured_text .. coloured_target .. " "
						else
							text = text .. custom .. " "

							coloured_text = "$0,3" .. coloured_text .. getColorByObjectName(custom) .. custom .. " "
						end
						
						if (cond[2] ~= nil) then
							if (#cond[2] > 0) then
								for c,d in ipairs(cond[2]) do
									if (#custom == 0) then
										local target = d
										local isnot = string.sub(target, 1, 4)
										local target_ = target
										local coloured_target = target
										local coloured_isnot = ""
										
										if (isnot == "not ") then
											target_ = string.sub(target, 5)

											coloured_isnot = getColorByObjectName("not") .. "not "
										else
											isnot = ""
										end
										
										if (word_names[target_] ~= nil) then
											target = isnot .. word_names[target_]

											coloured_target = coloured_isnot .. getColorByObjectName(word_names[target_]) .. word_names[target_]
										else
											coloured_target = coloured_isnot .. getColorByObjectName(target_) .. target_
										end
										
										text = text .. target .. " "

										coloured_text = "$0,3" .. coloured_text .. coloured_target .. " "
									else
										text = text .. custom .. " "

										coloured_text = "$0,3" .. coloured_text .. getColorByObjectName(custom) .. custom .. " "
									end
									
									if (#cond[2] > 1) and (c ~= #cond[2]) then
										text = text .. "& "

										coloured_text = "$0,3" .. coloured_text .. "& "
									end
								end
							end
						end
						
						if (a < #conds) then
							text = text .. "& "

							coloured_text = "$0,3" .. coloured_text .. "& "
						end
					else
						if (#custom == 0) then
							text = cond[1] .. " " .. text

							coloured_text = getColorByObjectName(cond[1]) .. cond[1] .. "$0,3 " .. coloured_text
						else
							text = custom .. " " .. text

							coloured_text = getColorByObjectName(custom) .. custom .. "$0,3 " .. coloured_text
						end
					end
				end
			end

			local target = rule[3]
			local isnot = string.sub(target, 1, 4)
			local target_ = target
			local coloured_target = target
			local coloured_isnot = ""
			
			if (isnot == "not ") then
				target_ = string.sub(target, 5)
				isnot = isnot

				coloured_isnot = getColorByObjectName("not") .. "not "
			else
				isnot = ""
			end
			
			if (word_names[target_] ~= nil) then
				target = isnot .. word_names[target_]

				coloured_target = coloured_isnot .. getColorByObjectName(word_names[target_]) .. word_names[target_]
			else
				coloured_target = coloured_isnot .. getColorByObjectName(target_) .. target_
			end
			
			if (#custom == 0) then
				text = text .. rule[2] .. " " .. target

				coloured_text = "$0,3" .. coloured_text .. getColorByObjectName(rule[2]) .. rule[2] .. "$0,3 " .. getColorByObjectName(coloured_target) .. coloured_target
			else
				text = text .. custom .. " " .. custom

				coloured_text = "$0,3" .. coloured_text .. getColorByObjectName(custom) .. custom .. "$0,3 " .. getColorByObjectName(custom) .. custom
			end
			
			for a,b in ipairs(tags) do
				if (b == "mimic") then
					text = text .. " (mimic)"

					coloured_text = "$0,3" .. coloured_text .. " (" .. getColorByObjectName("mimic") .. "mimic" .. "$0,3)"
				end
			end
			
			if (allrules[text] == nil) then
				allrules[text] = 1
				count = count + 1

				allrules_colored[coloured_text] = 1
			else
				allrules[text] = allrules[text] + 1

				allrules_colored[coloured_text] = allrules_colored[coloured_text] + 1
			end
			i_ = i_ + 1
		end
	end
	
	local columns = math.min(maxcolumns, math.floor((count - 1) / linelimit) + 1)
	local columnwidth = math.min(screenw - f_tilesize * 2, columns * f_tilesize * 10) / columns
	
	i_ = 1
	
	local maxlimit = 4 * linelimit
	if (allrules_colored ~= nil) then
		for i,v in pairs(allrules_colored) do
			local text = i
		
			if (i_ <= maxlimit) then
				local currcolumn = math.floor((i_ - 1) / linelimit) - (columns * 0.5)
				x = basex + columnwidth * currcolumn + columnwidth * 0.5
				y = basey + (((i_ - 1) % linelimit) + 1) * f_tilesize * 0.8
			end
		
			if (i_ <= maxlimit-1) then
				if (v == 1) then
					writetext(text,0,x,y,name,true,2,true)
				elseif (v > 1) then
					writetext(tostring(v) .. " x " .. text,0,x,y,name,true,2,true)
				end
			end
		
			i_ = i_ + 1
		end
	else
		for i,v in pairs(allrules) do
			local text = i
			
			if (i_ <= maxlimit) then
				local currcolumn = math.floor((i_ - 1) / linelimit) - (columns * 0.5)
				x = basex + columnwidth * currcolumn + columnwidth * 0.5
				y = basey + (((i_ - 1) % linelimit) + 1) * f_tilesize * 0.8
			end
			
			if (i_ <= maxlimit-1) then
				if (v == 1) then
					writetext(text,0,x,y,name,true,2,true)
				elseif (v > 1) then
					writetext(tostring(v) .. " x " .. text,0,x,y,name,true,2,true)
				end
			end
			
			i_ = i_ + 1
		end
	end
	
	if (i_ > maxlimit-1) then
		writetext("(+ " .. tostring(i_ - maxlimit) .. ")",0,x,y,name,true,2,true)
	end
end
