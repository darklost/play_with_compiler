--[[
    --用于学习编译原理
    https://time.geekbang.org/column/article/118378
]]

local STATE = {}
STATE.Initial=0 
STATE.Id = 1 --标识符
STATE.GT = 2 -- >
STATE.GE = 3 -- >=
STATE.IntLiteral = 4 --整数常量

local TOKEN_TYPE = {}
TOKEN_TYPE.IDENTIFIER="Identifier" -- 标识符
TOKEN_TYPE.GE="GE" -- >=
TOKEN_TYPE.IntLiteral="IntLiteral" -- 常量

local lexer= {}
--是否是字母
function lexer.isAlpha(ch)
  
    if ch >=  string.byte('a') and ch <=  string.byte('z') then
        return true
    end
    if ch >= string.byte('A') and ch <=  string.byte('Z') then
        return true
    end
    return false
end

--是否是数字
function lexer.isDigit(ch) 
   
    return ch >= string.byte('0') and ch <=  string.byte('9');
end

--是否是空白字符
function lexer.isBlank(ch) 
   
    return ch == string.byte(' ') or ch == string.byte('\t')  or ch ==string.byte('\n')
end
lexer.tokens = {}
lexer.token  = {}
lexer.tokenText = ""




function lexer.InitialToken( ch )
    
    if string.len( lexer.tokenText) >0 then

        lexer.token.text=lexer.tokenText
        table.insert( lexer.tokens, lexer.token )

        lexer.tokenText=""
        lexer.token={}
    end
    local new_state = STATE.Initial
    --开始字符是字母
    if lexer.isAlpha(ch) then
        new_state = STATE.Id -- 进入Id状态
        lexer.token.type = TOKEN_TYPE.IDENTIFIER -- token 类型设置为常量类型
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    --开始字符是数字    
    elseif lexer.isDigit(ch) then
        new_state = STATE.IntLiteral -- 进入Id状态
        lexer.token.type = TOKEN_TYPE.IntLiteral -- token 类型设置为常量类型
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    --开始字符是  >   
    elseif  ch == string.byte('>')  then 
        new_state = STATE.GT -- 进入Id状态
        lexer.token.type = TOKEN_TYPE.GT -- token 类型设置为常量类型
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    end
    
    return new_state 
end
function lexer.tokenize( code_str )
    lexer.tokens = {}
    lexer.token  = {}
    lexer.tokenText = ""
    local state =STATE.Initial
    local ch = 0
    -- print(code_str)
    for i=1,string.len( code_str ) do
        local ch= string.byte( code_str,i )
        -- print(ch,string.char( ch ),state)
        local switch = {
            [STATE.Initial]=function (  )
                -- print("STATE.Initial")    
                state = lexer.InitialToken(ch) -- 重新确定后续状态
            end,
            [STATE.Id]=function (  )
                --如果是字符或者数字
                if lexer.isAlpha(ch) or lexer.isDigit(ch) then
                    lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
                else
                    state = lexer.InitialToken(ch) --退出标识符状态，并保存Token
                end
            end,
            [STATE.GT]=function (  )
                if  ch == string.byte('=')then
                    lexer.token.type = TOKEN_TYPE.GE --转换成GE 
                    state = STATE.GE 
                    lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串 
                else 
                    state =  lexer.InitialToken(ch)  --退出标识符状态，并保存Token
                    
                end
            end,
            [STATE.GE]=function (  )
                state = lexer.InitialToken(ch) --退出GT状态，并保存Token
            end,
            [STATE.IntLiteral]=function (  )
                --如果是数字
                if  lexer.isDigit(ch) then
                    lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
                else
                    state = lexer.InitialToken(ch) --退出标识符状态，并保存Token
                end
            end,
        }
        --根据状态调用后续方法
        local f = switch[state]
        if f then
            f()
        else
            print("不存在方法")    
        end
        -- print("switch 后",ch,string.char( ch ),state)
    end
    if  string.len( lexer.tokenText) >0  then
        lexer.InitialToken(ch)
    end
    return  lexer.tokens
end

function lexer.dump( tokens )
    for i,token in ipairs(tokens) do
        print(token.text,token.type)
    end
end
--主方法
local function main(  )
    print("lexer")
    local script  =[[ age >= 45 ]]
    local tokens=lexer.tokenize(script)
    lexer.dump( tokens )
    script  = [[int age = 40]]
    
    script  =[[ 2+3*5 ]]
end
main()