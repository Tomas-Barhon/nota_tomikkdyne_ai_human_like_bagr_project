return {
	-- Each log-group can have one of the following values:
	-- 	"spring" - uses Spring.Echo
	-- 	"funnel" - logs the message into funnel-log.txt
	-- 	"separate" - logs the message into a sepearate file log_[log-group name].txt
	-- 	"ignore" (or any other string) - ignore the message completely
	-- 	the values can be combined by putting "+" between them, eg.: "spring+funnel "
	-- 	
	-- Additionally, the log-group can be an array of values that determine how to treat different types of log messages:
	-- 	{ [default], [warning], [error] } 
	-- If the array is not large enough (or log-group is missing entirely), the default values are:
	-- 	{ "funnel", "spring+funnel", "spring+funnel" }
	-- This default can be overriden by giving the new default values as settings for log-group "default".
	-- If it is not an array, it is equivalent to an array with a single value.

	["sanitize"] = "funnel",
	["commands"] = "funnel",
	["luacommand"] = "funnel",
	["roles"] = "funnel",
	["icons"] = "funnel",
	["reloading"] = "funnel",
	["tree-editing"] = "funnel",
	["script-load"] = "funnel",
	["selection"] = "funnel",
	["communication"] = "funnel",
	["dependency"] = "funnel",
	["command"] = "funnel",
	["save-and-load"] = "funnel",
	["Error"] = "funnel",
	["connection-lines"] = "funnel",
}
