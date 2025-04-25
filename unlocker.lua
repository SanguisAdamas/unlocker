local Unlocker = {}
services = {}
DataModel = setmetatable({}, {
	__index = function(table, key)
		if services[key] then
			return services[key]
		else
			return game[key]
		end
	end,
	__newindex = function(table, key, value)
		if services[key] then
			services[key] = value
		else
			rawset(table, key, value)
		end
	end
})

for _, v in pairs(game:GetChildren()) do
	DataModel[v.Name] = setmetatable({}, {
		__index = function(table, key)
			local value = v[key]
			if type(value) == "function" then
				return function(...)
					return value(v, ...)
				end
			else
				return value
			end
		end,
		__newindex = function(table, key, value)
			if services[key] then
				services[key] = value
			else
				rawset(table, key, value)
			end
		end
	})
end

function DataModel:GetService(name: string)
	return DataModel[name]
end

function DataModel:FindFirstChild(name: string)
	return DataModel[name]
end

function DataModel:WaitForChild(name: string, timeout: number)
	local startTime = tick()
	if timeout == nil then
		timeout = 99
	end
	local child = DataModel[name]
	while child == nil do
		if tick() - startTime >= timeout then
			return nil
		end
		wait()
		child = DataModel[name]
	end
	return child
end
function DataModel:FindService(name: string)
	return DataModel[name]
end
function DataModel:RegisterService(name, module)
	services[name] = require(module)
end
function Unlocker:Load()
	getfenv(2).game = DataModel
end

return Unlocker
