-----------------------------
-- 一个简单的Token。
-- 只有类型和文本值两个属性。
-----------------------------
local Token = class("Token")
local token_type_const = require("token_type_const")

function Token:ctor()
end

-- Token的类型
function Token:getType()
    return self.type
end

--  Token的文本值
function Token:getText()
    
    return token_type_const[self.type]
end
return Token
