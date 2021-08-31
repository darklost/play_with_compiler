--[[
    --用于学习编译原理
    https://time.geekbang.org/column/article/118378
]]

require "framework.init"
local token_type_const = require("TokenType")
local Token = require "Token"
local TokenReader = require "TokenReader"

local DfaState = {
    Initial=0 ,
    If=1, Id_if1=2, Id_if2=3, Else=4, Id_else1=5, Id_else2=6, Id_else3=7, Id_else4=8, Int=9, Id_int1=10, Id_int2=11, Id_int3=12, Id=13, GT=14, GE=15,

    Assignment=16,

    Plus=17, Minus=18, Star=19, Slash=20,

    SemiColon=21,
    LeftParen=22,
    RightParen=23,

    IntLiteral = 24 ,--整数常量
}
----------------------
--Token的一个简单实现。只有类型和文本值两个属性。
----------------------
local SimpleToken = class("SimpleToken",Token) 

function SimpleToken:ctor()
    --Token类型
   self.type = nil;
   --文本值
   self.text = nil;
end

-- Token的类型
function SimpleToken:getType()
    return self.type
end

--  Token的文本值
function SimpleToken:getText()
    return self.text
end
------------------------------------------
-- 一个简单的Token流。是把一个Token列表进行了封装。
------------------------------------------
local SimpleTokenReader = class("SimpleTokenReader", TokenReader)

function SimpleTokenReader:ctor(tokens)
   self.tokens = tokens;
   self.pos = 0;
end


function SimpleTokenReader:read()
       if self.pos < #self.tokens then
           self.pos = self.pos +1
        
           return self.tokens[self.pos]
       end
       return nil
end

function SimpleTokenReader:peek() 
       if self.pos < #self.tokens then
           return self.tokens[self.pos]
       end
       return nil
end

function SimpleTokenReader:unread() 
       if self.pos > 0 then
           self.pos = self.pos - 1
       end
end
function SimpleTokenReader:getPosition() 
       return self.pos;
 end       

function SimpleTokenReader:setPosition(position)
       if (position >=0 and position < #self.tokens)then
           self.pos = position
       end
end




local SimpleLexer= class("SimpleLexer")
function SimpleLexer:ctor()
    --下面几个变量是在解析过程中用到的临时变量,如果要优化的话，可以塞到方法里隐藏起来
    self.tokenText = nil             --临时保存token的文本
    self.tokens = nil                --当前正在解析的Token
    self.token  = nil                --保存解析出来的Token
  
end
--是否是字母
function SimpleLexer:isAlpha(ch)
  
    if ch >=  string.byte('a') and ch <=  string.byte('z') then
        return true
    end
    if ch >= string.byte('A') and ch <=  string.byte('Z') then
        return true
    end
    return false
end

--是否是数字
function SimpleLexer:isDigit(ch) 
   
    return ch >= string.byte('0') and ch <=  string.byte('9');
end

--是否是空白字符
function SimpleLexer:isBlank(ch) 
   
    return ch == string.byte(' ') or ch == string.byte('\t')  or ch ==string.byte('\n')
end

-------------------------
-- 有限状态机进入初始状态。
-- 这个初始状态其实并不做停留，它马上进入其他状态。
-- 开始解析的时候，进入初始状态；某个Token解析完毕，也进入初始状态，在这里把Token记下来，然后建立一个新的Token。
-- @param ch string
-- @return DfaState
--------------------------
function SimpleLexer:initToken( ch )
    -- print("initToken ch=",ch,string.char( ch ),self:token.type,self:tokenText)
    if string.len( self.tokenText ) >0 then
       
        self.token.text = self.tokenText
        table.insert( self.tokens, self.token )
        -- print("initToken insert tokens",ch,string.char( ch ),self.token.type,self.token.text)
        self.tokenText = ""
        self.token = SimpleToken.new()
    end
    local new_state = DfaState.Initial
    --第一个字符是字母
    if self:isAlpha(ch) then
        if  ch == string.byte('i')  then
            new_state = DfaState.Id_int1;
        else
            new_state = DfaState.Id -- 进入Id状态
        end
        
        self.token.type = TOKEN_TYPE.Identifier -- token 类型设置为常量类型
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    --开始字符是数字    
    elseif self:isDigit(ch) then
        new_state = DfaState.IntLiteral -- 进入Id状态
        self.token.type = TOKEN_TYPE.IntLiteral -- token 类型设置为常量类型
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    --开始字符是  >   
    elseif  ch == string.byte('>')  then 
        new_state = DfaState.GT -- 进入Id状态
        self.token.type = TOKEN_TYPE.GT -- token 类型设置为常量类型
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('+') then
        new_state = DfaState.Plus
        self.token.type = TOKEN_TYPE.Plus
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('-') then
        new_state = DfaState.Minus
        self.token.type = TOKEN_TYPE.Minus
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('*') then
        new_state = DfaState.Star
        self.token.type = TOKEN_TYPE.Star
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('/') then
        new_state = DfaState.Slash
        self.token.type = TOKEN_TYPE.Slash
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte(';') then
        new_state = DfaState.SemiColon
        self.token.type = TOKEN_TYPE.SemiColon
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('(') then
        new_state = DfaState.LeftParen
        self.token.type = TOKEN_TYPE.LeftParen
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte(')') then
        new_state = DfaState.RightParen
        self.token.type = TOKEN_TYPE.RightParen
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    elseif ch == string.byte('=') then
        new_state = DfaState.Assignment
        self.token.type = TOKEN_TYPE.Assignment
        self.tokenText =  self.tokenText .. string.char( ch ) --追加字符串
    else 
        new_state = DfaState.Initial -- skip all unknown patterns
   
    end
    
    return new_state 
end

----------------------------
--解析字符串，形成Token。
--这是一个有限状态自动机，在不同的状态中迁移。
--@param code
--@return
----------------------------
function  SimpleLexer:tokenize( code_str )
    self.tokens = {}
    self.token  = SimpleToken.new()
    self.tokenText = ""
    local state =DfaState.Initial
    local ch = 0
    -- print(code_str)
    for i=1,string.len( code_str ) do
        local ch= string.byte( code_str,i )
        -- print(ch,string.char( ch ),state)
        
        --根据状态调用后续方法
        if state ==  DfaState.Initial then
            -- print("DfaState.Initial")    
            state = self:initToken(ch) -- 重新确定后续状态
        elseif state == DfaState.Id then 
            --如果是字符或者数字
            if self:isAlpha(ch) or self:isDigit(ch) then
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            else
                state = self:initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state == DfaState.GT then 
            if  ch == string.byte('=') then
                self.token.type = TOKEN_TYPE.GE --转换成GE 
                state = DfaState.GE 
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串 
            else 
                state =  self:initToken(ch)  --退出标识符状态，并保存Token
                
            end
        elseif  state == DfaState.GE or
                state ==  DfaState.Assignment or
                state ==  DfaState.Plus or
                state ==  DfaState.Minus or
                state ==  DfaState.Star or
                state ==  DfaState.Slash or
                state ==  DfaState.SemiColon or
                state ==  DfaState.LeftParen or
                state ==  DfaState.RightParen then 

                state = self:initToken(ch) --退出GT状态，并保存Token
        elseif state ==DfaState.IntLiteral then
            --如果是数字
            if  self:isDigit(ch) then
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            else
                state = self:initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state ==DfaState.Id_int1 then
            --如果是数字
            if ch == string.byte('n')then
                state = DfaState.Id_int2
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            elseif  self:isDigit(ch) or self:isAlpha(ch) then
                state = DfaState.Id   --切换回Id状态
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            else
                state = self:initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state ==DfaState.Id_int2 then
            --如果是数字
            if ch == string.byte('t')then
                state = DfaState.Id_int3
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            elseif  self:isDigit(ch) or self:isAlpha(ch) then
                state = DfaState.Id    --切换回Id状态
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            else
                state = self:initToken(ch) --退出标识符状态，并保存Token
            end
        elseif state ==DfaState.Id_int3 then
            --如果是数字
            if self:isBlank(ch) then
                self.token.type  = TOKEN_TYPE.Int
                -- print("DfaState.Int")   
                state = self:initToken(ch) --退出标识符状态，并保存Token
            else
                state = DfaState.Id    --切换回Id状态
                self.tokenText = self.tokenText ..string.char( ch ) --追加字符串
            end      
        else
                -- print("switch 不存在 ",ch,string.char( ch ),state)
        end
        -- print("switch 后",ch,string.char( ch ),state)
    end
    if  string.len( self.tokenText) >0  then
        self:initToken(ch)
    end
    return  SimpleTokenReader.new(self.tokens)
end





function dump_tokens( tokenReader )
    local token = nil
    repeat
        token = tokenReader:read()
        if token then
            print(token:getType(),token_type_const[token:getType()].desc,token:getText())
        end
       
    until token == nil 
  
end

--主方法
local function main(  )
    print("词法分析器 ")
    local lexer = SimpleLexer.new()
    --测试int的解析
    local script  =[[int age = 45;]]
    print("------------------------")
    print("parse :",script)
    print("------------------------")
    local tokens=lexer:tokenize(script)
    dump_tokens( tokens )
    print("------------------------")

    --测试inta的解析
    script  = [[inta age = 45;]]
    print("------------------------")
    print("parse :",script)
    print("------------------------")
    local tokens=lexer:tokenize(script)
    dump_tokens( tokens )
    print("------------------------")

    --测试in的解析
    script  = [[in age = 45;]]
    print("------------------------")
    print("parse :",script)
    print("------------------------")
    local tokens=lexer:tokenize(script)
    dump_tokens( tokens )
    print("------------------------")

    --测试>=的解析
    script  =[[age >= 45; ]]
    print("------------------------")
    print("parse :",script)
    print("------------------------")
    local tokens=lexer:tokenize(script)
    dump_tokens( tokens )
    print("------------------------")

    --测试>的解析
    script  =[["age > 45; ]]
    print("------------------------")
    print("parse :",script)
    print("------------------------")
    local tokens=lexer:tokenize(script)
    dump_tokens( tokens )
    print("------------------------")
end
main()