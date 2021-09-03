
----------------------------------------------------------------------
--一个简单的语法解析器。
--能够解析简单的表达式、变量声明和初始化语句、赋值语句。
--它支持的语法规则为：
--
--programm -> intDeclare | expressionStatement | assignmentStatement
--intDeclare -> 'int' Id ( = additive) ';'
--expressionStatement -> addtive ';'
--addtive -> multiplicative ( (+ | -) multiplicative)*
--multiplicative -> primary ( (* | /) primary)*
--primary -> IntLiteral | Id | (additive)
--
----------------------------------------------------------------------
require "framework.init"
local SimpleLexer = require "SimpleLexer"
local ASTNode = require "ASTNode"
local ast_node_type_const = require "ASTNodeType"



------------------------------
--一个简单的AST节点的实现。
-- 属性包括：类型、文本值、父节点、子节点。
------------------------------
local SimpleASTNode = class("SimpleASTNode",ASTNode)

function SimpleASTNode:ctor(nodeType,text)
    self.parent = nil       --父节点
    self.children = {}      --子节点列表
    self.nodeType = nodeType     --节点类型
    self.text = text         --文本值
end

--父节点
function SimpleASTNode:getParent()
    return self.parent
end

--子节点
function SimpleASTNode:getChildren()
    return self.children
end

--AST类型
function SimpleASTNode:getType()
    return self.nodeType
end

--文本值
function SimpleASTNode:getText()
    return self.text 
end

--添加子节点
function SimpleASTNode:addChild(child)
    child.parent = self --设置子节点父节点为当前节点
    table.insert(self.children, child) --将子节点加入当前节点的子节点列表

end





local SimpleParser = class("SimpleParser")

function SimpleParser:ctor()
    
end


------------------------
-- 解析脚本，并返回根节点
-- @param code
-- @return
-- @throws Exception
-------------------------
function SimpleParser:parse( code)
    local  lexer =  SimpleLexer.new()
    local  tokens = lexer:tokenize(code)

    local  rootNode = self:prog(tokens)

    return rootNode
end



------------------------
-- 语法解析：根节点
-- @return
-- @throws Exception
-------------------------
function SimpleParser:prog( tokens) 

    local node = SimpleASTNode.new(ASTNodeType.Programm, "pwc")

    while tokens:peek() do

        local child = self:intDeclare(tokens)
    
        if not child  then
            child = self:expressionStatement(tokens)
        end
    
        if not  child then
            child = self:assignmentStatement(tokens)
        end
    
        if child  then
            node:addChild(child)
        else
            error("unknown statement")    
        end
    end
 
    return node
end

------------------------
--表达式语句，即表达式后面跟个分号。
-- @return
-- @throws Exception
-------------------------
function SimpleParser:expressionStatement( tokens) 

    local  pos = tokens:getPosition()
    local  node = self:additive(tokens)
    if node then
        local token = tokens:peek()
        if (token  and token:getType() == TOKEN_TYPE.SemiColon) then
            tokens:read()
         else
            node = nil
            tokens:setPosition(pos) --回溯
         end
    end
    return node  --直接返回子节点，简化了AST。
end

------------------------
--赋值语句，如age = 10*2;
-- @return
-- @throws Exception
-------------------------
function SimpleParser:assignmentStatement( tokens) 
    local node = nil
    local token = tokens:peek()    --预读，看看下面是不是标识符
    if (token and token:getType() == TOKEN_TYPE.Identifier) then
        token = tokens:read()      --读入标识符
        node = SimpleASTNode.new(ASTNodeType.AssignmentStmt, token:getText())
        token = tokens:peek()      --预读，看看下面是不是等号
        if token  and token:getType() == TOKEN_TYPE.Assignment then
            tokens:read()          --取出等号
            local child = self:additive(tokens)
            if not child then   --出错，等号右面没有一个合法的表达式
                error("invalide assignment statement, expecting an expression")
            
            else
                node:addChild(child)   --添加子节点
                token = tokens:peek()  --预读，看看后面是不是分号
                if (token and token:getType() == TOKEN_TYPE.SemiColon) then
                    tokens:read()      --消耗掉这个分号

                else                 --报错，缺少分号
                    error("invalid statement, expecting semicolon")
                end
            end
        
        else
            tokens:unread()            --回溯，吐出之前消化掉的标识符
            node = nil
        end
    end
    return node

end


-----------------------
--整型变量声明语句，如：
--int a;
--int b = 2*3;
--
--@return
--@throws Exception
-----------------------
function SimpleParser:intDeclare(tokens)
    local node = nil

    local token = tokens:peek()   --预读
    --匹配Int
    if token and token:getType() == TOKEN_TYPE.Int then
        token = tokens:read() --消耗int

        token = tokens:peek() --预读
        if token and token:getType() == TOKEN_TYPE.Identifier then
            token = tokens:read() --消耗标识符
            --创建当前节点，并把变量名记到AST节点的文本值中，这里新建一个变量子节点也是可以的
            node = SimpleASTNode.new(ASTNodeType.IntDeclaration,token:getText())

            token = tokens:peek()--预读
            --匹配 =
            if token and token:getType() == TOKEN_TYPE.Assignment then
                token = tokens:read() --消耗掉等号 
                -- =号忽略 不建立ASTNode
            
                local child = self:additive(tokens) --匹配一个表达式
                if child then
                    node:addChild(child)
                else
                    error("invalide variable initialization, expecting an expression")
                end
            end    
        else    
            error("variable name expected")
        end

        if node  then
            token = tokens:peek()
            if token and token:getType() == TOKEN_TYPE.SemiColon then
                tokens:read()
             else
                error("invalid statement, expecting semicolon")
            end
        end
    end

    return node
end

-----------------------
-- 语法解析：加法表达式
--  @return
--  @throws Exception
-----------------------
function SimpleParser:additive(tokens)

    local child1 = self:multiplicative(tokens) --应用add规则
    local node = child1

   
    if child1 then
        while true do  --循环应用add'规则
            local token = tokens:peek()
            if token:getType() == TOKEN_TYPE.Plus or token:getType() == TOKEN_TYPE.Minus then
                token = tokens:read()
                local child2 = self:multiplicative(tokens) --计算下级节点
                if child2 then
                    node = SimpleASTNode.new(ASTNodeType.Additive, token:getText())
                    node:addChild(child1)           --注意，新节点在顶层，保证正确的结合性
                    node:addChild(child2)
                    child1 = node
                else 
                    error("invalid additive expression, expecting the right part.")
                end
            else
                break    
            end
        end
       
    end
    return node
end

-----------------------
-- 语法解析：乘法表达式
-- @return
-- @throws Exception
-----------------------
function SimpleParser:multiplicative(tokens)
    local  child1 = self:primary(tokens)
    local  node = child1

   
    if child1 then
        while true do
            local  token = tokens:peek()
            if token:getType() == TOKEN_TYPE.Star or token:getType() == TOKEN_TYPE.Slash then
                token = tokens:read()
                local  child2 = self:primary(tokens)
                if child2 then
                    node =  SimpleASTNode.new(ASTNodeType.Multiplicative, token:getText())
                    node:addChild(child1)
                    node:addChild(child2)
                    child1 = node
                else
                    error("invalid multiplicative expression, expecting the right part.")
                end
            else
                break    
            end
        end
      
    end
    return node
end

-----------------------
--语法解析：基础表达式
--@return
--@throws Exception
-----------------------
function SimpleParser:primary(tokens)
    local  node = nil
    local  token = tokens:peek()
    if token  then
        if (token:getType() == TOKEN_TYPE.IntLiteral) then
            token = tokens:read()
            node = SimpleASTNode.new(ASTNodeType.IntLiteral, token:getText())
        elseif (token:getType() == TOKEN_TYPE.Identifier) then
            token = tokens:read()
            node = SimpleASTNode.new(ASTNodeType.Identifier, token:getText())
        elseif (token:getType() == TOKEN_TYPE.LeftParen) then
            tokens:read()
            node = self:additive(tokens)
            if node then
                token = tokens:peek()
                if (token and token:getType() == TOKEN_TYPE.RightParen) then
                    tokens:read()
                else 
                    error("expecting right parenthesis")
                end
            else 
                error("expecting an additive expression inside parenthesis")
            end
        end
    end
    return node --这个方法也做了AST的简化，就是不用构造一个primary节点，直接返回子节点。因为它只有一个子节点。
end

------------------------
-- 打印输出AST的树状结构
-- @param node
-- @param indent 缩进字符，由tab组成，每一级多一个tab
------------------------
function SimpleParser.dumpAST( node,  indent)
   
    print(indent , ast_node_type_const[node:getType()].type ,  node:getText())
    for i,child in ipairs(node:getChildren()) do
         SimpleParser.dumpAST(child, indent.."\t")
    end
  
 end

 
local function main()
    local parser = SimpleParser.new()
    local script = nil
    local tree = nil
    
   
    local ok,err=pcall(function ()
        script = "int age = 45+2; age= 20; age+10*2;"
        print("解析：",script)
        tree = parser:parse(script)
        SimpleParser.dumpAST(tree, "")
    end)
    
    if not ok then
        print(err)
    end
   



    --测试异常语法
    local ok,err=pcall(function ()
        script = "2+3+;"
        print("解析：",script)
        tree = parser:parse(script)
        SimpleParser.dumpAST(tree, "")
    end)
    
    if not ok then
        print(err)
    end



    --测试异常语法
    local ok,err=pcall(function ()
        script = "2+3*;";
        print("解析：",script)
        tree = parser:parse(script)
        SimpleParser.dumpAST(tree, "")
    end)
    
    if not ok then
        print(err)
    end
  
end

main()

return SimpleParser

