--[[ Helpers ]]
local helper, h = ...

-- Container for helper functions
h.f = {}

-- Round Function
-- x = value to round
-- n = decimal places
local function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end

h.f.round = round