-----------------------------
-- 一个简单的Token。
-- 只有类型和文本值两个属性。
-----------------------------
local Token = class("Token")


function Token:ctor()
end

-- Token的类型
function Token:getType()
end

--  Token的文本值
function Token:getText()
end
return Token
