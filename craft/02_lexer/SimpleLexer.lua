--[[
    --用于学习编译原理
    https://time.geekbang.org/column/article/118378
]]
require("framework.init")

local STATE = {
    Initial=0 ,
    If=1, Id_if1=2, Id_if2=3, Else=4, Id_else1=5, Id_else2=6, Id_else3=7, Id_else4=8, Int=9, Id_int1=10, Id_int2=11, Id_int3=12, Id=13, GT=14, GE=15,

    Assignment=16,

    Plus=17, Minus=18, Star=19, Slash=20,

    SemiColon=21,
    LeftParen=22,
    RightParen=23,

    IntLiteral = 24 ,--整数常量
}
local TOKEN_TYPE = {
    Plus="Plus",   -- +
    Minus="Minus",  -- -
    Star="Star",   -- *
    Slash="Slash",  -- /

    GE="GE",     -- >=
    GT="GT",     -- >
    EQ="EQ",     -- ==
    LE="LE",     -- <=
    LT="LT",     -- <

    SemiColon="SemiColon", -- ;
    LeftParen="LeftParen", -- (
    RightParen="RightParen",-- )

    Assignment="Assignment",-- =

    If="If",
    Else="Else",
    
    Int="Int",

    Identifier="Identifier",     --标识符

    IntLiteral="IntLiteral",     --整型字面量
    StringLiteral="StringLiteral",   --字符串字面量
}



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




function lexer.initToken( ch )
    -- print("initToken ch=",ch,string.char( ch ),lexer.token.type,lexer.tokenText)
    if string.len( lexer.tokenText) >0 then
       
        lexer.token.text=lexer.tokenText
        table.insert( lexer.tokens, lexer.token )
        -- print("initToken insert tokens",ch,string.char( ch ),lexer.token.type,lexer.token.text)
        lexer.tokenText=""
        lexer.token={}
    end
    local new_state = STATE.Initial
    --第一个字符是字母
    if lexer.isAlpha(ch) then
        if  ch == string.byte('i')  then
            new_state = STATE.Id_int1;
        else
            new_state = STATE.Id -- 进入Id状态
        end
        
        lexer.token.type = TOKEN_TYPE.Identifier -- token 类型设置为常量类型
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
    elseif ch == string.byte('+') then
        new_state = STATE.Plus
        lexer.token.type = TOKEN_TYPE.Plus
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('-') then
        new_state = STATE.Minus
        lexer.token.type = TOKEN_TYPE.Minus
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('*') then
        new_state = STATE.Star
        lexer.token.type = TOKEN_TYPE.Star
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('/') then
        new_state = STATE.Slash
        lexer.token.type = TOKEN_TYPE.Slash
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('') then
        new_state = STATE.SemiColon
        lexer.token.type = TOKEN_TYPE.SemiColon
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('(') then
        new_state = STATE.LeftParen
        lexer.token.type = TOKEN_TYPE.LeftParen
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte(')') then
        new_state = STATE.RightParen
        lexer.token.type = TOKEN_TYPE.RightParen
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('=') then
        new_state = STATE.Assignment
        lexer.token.type = TOKEN_TYPE.Assignment
        lexer.tokenText =  lexer.tokenText .. string.char( ch ) --追加字符串
    else 
        new_state = STATE.Initial -- skip all unknown patterns
   
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
        
        --根据状态调用后续方法
        if state ==  STATE.Initial then
            -- print("STATE.Initial")    
            state = lexer.initToken(ch) -- 重新确定后续状态
        elseif state == STATE.Id then 
            --如果是字符或者数字
            if lexer.isAlpha(ch) or lexer.isDigit(ch) then
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            else
                state = lexer.initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state == STATE.GT then 
            if  ch == string.byte('=') then
                lexer.token.type = TOKEN_TYPE.GE --转换成GE 
                state = STATE.GE 
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串 
            else 
                state =  lexer.initToken(ch)  --退出标识符状态，并保存Token
                
            end
        elseif  state == STATE.GE or
                state ==  STATE.Assignment or
                state ==  STATE.Plus or
                state ==  STATE.Minus or
                state ==  STATE.Star or
                state ==  STATE.Slash or
                state ==  STATE.SemiColon or
                state ==  STATE.LeftParen or
                state ==  STATE.RightParen then 

                state = lexer.initToken(ch) --退出GT状态，并保存Token
        elseif state ==STATE.IntLiteral then
            --如果是数字
            if  lexer.isDigit(ch) then
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            else
                state = lexer.initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state ==STATE.Id_int1 then
            --如果是数字
            if ch == string.byte('n')then
                state = STATE.Id_int2;
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            elseif  lexer.isDigit(ch) or lexer.isAlpha(ch) then
                state = STATE.Id;    --切换回Id状态
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            else
                state = lexer.initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state ==STATE.Id_int2 then
            --如果是数字
            if ch == string.byte('t')then
                state = STATE.Id_int3
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            elseif  lexer.isDigit(ch) or lexer.isAlpha(ch) then
                state = STATE.Id;    --切换回Id状态
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            else
                state = lexer.initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state ==STATE.Id_int3 then
            --如果是数字
            if lexer.isBlank(ch) then
                lexer.token.type  = TOKEN_TYPE.Int
                -- print("STATE.Int")   
                state = lexer.initToken(ch) --退出标识符状态，并保存Token
            else
                state = STATE.Id;    --切换回Id状态
                lexer.tokenText = lexer.tokenText ..string.char( ch ) --追加字符串
            end      
        else
                -- print("switch 不存在 ",ch,string.char( ch ),state)
        end
        -- print("switch 后",ch,string.char( ch ),state)
    end
    if  string.len( lexer.tokenText) >0  then
        lexer.initToken(ch)
    end
    return  lexer.tokens
end

function lexer.dump( tokens )
    for i,token in ipairs(tokens) do
        print(token.type,token.text)
    end
end
--主方法
local function main(  )
    print("词法分析器 ")
    --测试int的解析
    local script  =[[int age = 45;]]
    print("------------------------")
    print(script)
    print("------------------------")
    local tokens=lexer.tokenize(script)
    lexer.dump( tokens )
    print("------------------------")

    --测试inta的解析
    script  = [[inta age = 45;]]
    print("------------------------")
    print(script)
    print("------------------------")
    local tokens=lexer.tokenize(script)
    lexer.dump( tokens )
    print("------------------------")

    --测试in的解析
    script  = [[in age = 45;]]
    print("------------------------")
    print(script)
    print("------------------------")
    local tokens=lexer.tokenize(script)
    lexer.dump( tokens )
    print("------------------------")

    --测试>=的解析
    script  =[[age >= 45; ]]
    print("------------------------")
    print(script)
    print("------------------------")
    local tokens=lexer.tokenize(script)
    lexer.dump( tokens )
    print("------------------------")

    --测试>的解析
    script  =[["age > 45; ]]
    print("------------------------")
    print(script)
    print("------------------------")
    local tokens=lexer.tokenize(script)
    lexer.dump( tokens )
    print("------------------------")
end
main()