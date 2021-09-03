--[[
    author:darklost
    time:2020-04-14 14:20:54
]]


-- dump table
function dump_tostring(obj)
    local lookupTable = {}
    local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
    getIndent = function(level)
        return string.rep("\t", level)
    end
    quoteStr = function(str)
        return '"' .. string.gsub(str, '"', '\\"') .. '"'
    end
    wrapKey = function(val)
        if type(val) == "number" then
            return "[" .. val .. "]"
        elseif type(val) == "string" then
            return "[" .. quoteStr(val) .. "]"
        else
            return "[" .. tostring(val) .. "]"
        end
    end
    wrapVal = function(val, level)
        if type(val) == "table" then
            return dumpObj(val, level)
        elseif type(val) == "number" then
            return val
        elseif type(val) == "string" then
            return quoteStr(val)
        else
            return tostring(val)
        end
    end
    dumpObj = function(obj, level)
        if type(obj) ~= "table" then
            return wrapVal(obj)
        elseif lookupTable[obj] then
            return  '*REF*'
        end

        lookupTable[obj] = true
        level = level + 1
        local tokens = {}
        tokens[#tokens + 1] = "{"
        for k, v in pairs(obj) do
            tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
        end
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"
        return table.concat(tokens, "\n")
    end
    return dumpObj(obj, 0)
end

--[[
    @desc: 输出16进制字符串
    author:darklost
    time:2020-04-13 22:37:59
    --@buffer: 
    @return:
]]
function dump_tohex(buffer)
    assert(type(buffer)=="string","buffer must be string")
    local len = #buffer
    local bytes = {}
    for i = 1, len do
        bytes[i] = string.format("%02x", string.byte(buffer, i))
    end
    return table.concat(bytes, " ")
end

--[[
    @desc: 检查是否 str 是以 str_start 字符开头
    author:{author}
    time:2020-04-11 15:07:48
    --@str:目标字符串
	--@str_start: 检查字符串
    @return:
]]
function string.start_with(str,str_start)
    return string.sub(str,1,string.len(str_start))==str_start
 end
 --[[
    @desc: 检查是否 str 是以 str_end 字符结尾
    author:{author}
    time:2020-04-11 15:07:48
    --@str:目标字符串
	--@str_end: 检查字符串
    @return:
]]
 function string.end_with(str,str_end)
    return str_end=='' or string.sub(str,-string.len(str_end))==str_end
 end