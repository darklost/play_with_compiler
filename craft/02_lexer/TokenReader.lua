

--------------------------------------
--一个Token流。由Lexer生成。Parser可以从中获取Token。
--------------------------------------
local TokenReader = class("Token")

--------------------------------------
--返回Token流中下一个Token，并从流中取出。 如果流已经为空，返回null;
--------------------------------------
function TokenReader:read()

end
--------------------------------------
--返回Token流中下一个Token，但不从流中取出。 如果流已经为空，返回null;
--------------------------------------
function TokenReader:peek()

end

--------------------------------------
--Token流回退一步。恢复原来的Token。
--------------------------------------
function TokenReader:unread()

end

--------------------------------------
--获取Token流当前的读取位置。
--@return
--------------------------------------
function TokenReader:getPosition()

end

--------------------------------------
--设置Token流当前的读取位置
--@param position
--------------------------------------
function TokenReader:setPosition( position)

end
return TokenReader
