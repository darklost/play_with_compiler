local STATE = {}
STATE.INIT=0 
STATE.IDENTIFIER=1
STATE.GE=2
STATE.INTLITERAL=2
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

lexer.tokenText =nil
lexer.tokens  =nil
lexer.token  =nil


function lexer.initToken( ch )
    
end
function lexer.simpletokenreader( code_str )
    
end

--主方法
local function main(  )
    print("lexer")
    local script  =[[ age >= 45 ]]
     for i=1,string.len( script ) do
         local ch= string.byte( script,i )
         print(string.char(ch ) ,"isBlank",lexer.isBlank(ch) )
         print(string.char(ch ) ,"isDigit",lexer.isDigit(ch) )
         print(string.char(ch ) ,"isAlpha",lexer.isAlpha(ch) )
     end
   
    script  = [[int age = 40]]
    
    script  =[[ 2+3*5 ]]
end
main()