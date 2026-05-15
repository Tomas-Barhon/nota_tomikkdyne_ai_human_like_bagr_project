function getInfo()
	return {
		onNoUnits = SUCCESS, -- instant success
		tooltip = "Unload given unit",
		parameterDefs = {
			{ 
				name = "transporter",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "units",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			}
		}
	}
end

function Run(self, units, parameter)
	local transporter = parameter.transporter -- UnitID
	local units = parameter.units -- table of units

    for _, unit in ipairs(units) do
        if not Spring.ValidUnitID(unit) or not Spring.ValidUnitID(transporter) then
            return FAILURE
        end
    end

    local all_unloaded = false
    for _, unit in ipairs(units) do
        if Spring.GetUnitTransporter(unit) == nil then
            all_unloaded = true
        else
            all_unloaded = false
            break
        end
    end

    if all_unloaded then
        return SUCCESS
    end

    local transporter_position = Vec3(Spring.GetUnitPosition(transporter))
	if not self.init then
		Spring.GiveOrderToUnit(transporter, CMD.UNLOAD_UNITS,
				{transporter_position.x, transporter_position.y, transporter_position.z,
				 200}, {"shift"})
		self.init = true
	end

	return RUNNING
end

function Reset(self)
	self.init = false
end