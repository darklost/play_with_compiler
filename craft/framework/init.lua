print("===========================================================")
print("              LOAD Lua FRAMEWORK")
print("===========================================================")

if type(DEBUG) ~= "number" then DEBUG = 0 end
if type(DEBUG_FPS) ~= "boolean" then DEBUG_FPS = false end
if type(DEBUG_MEM) ~= "boolean" then DEBUG_MEM = false end

local CURRENT_MODULE_NAME = ...
framework = framework or {}
framework.PACKAGE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6)
require(framework.PACKAGE_NAME .. ".debug")
require(framework.PACKAGE_NAME .. ".functions")

printInfo("")
printInfo("# DEBUG                        = "..DEBUG)
printInfo("#")


-- export global variable
local __g = _G
framework.exports = {}
setmetatable(framework.exports, {
    __newindex = function(_, name, value)
        rawset(__g, name, value)
    end,

    __index = function(_, name)
        return rawget(__g, name)
    end
})

-- disable create unexpected global variable
function framework.disable_global()
    setmetatable(__g, {
        __newindex = function(_, name, value)
            error(string.format("USE \" framework.exports.%s = value \" INSTEAD OF SET GLOBAL VARIABLE", name), 0)
        end
    })
end
