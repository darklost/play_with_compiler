
----------------------------------------------------------------------
-- 实现一个计算器，但计算的结合性是有问题的。因为它使用了下面的语法规则：
--
-- additive -> multiplicative | multiplicative + additive
-- multiplicative -> primary | primary * multiplicative    
--
-- 递归项在右边，会自然的对应右结合。我们真正需要的是左结合。
----------------------------------------------------------------------
require "framework.init"
local SimpleLexer = require "SimpleLexer"
local ASTNode = require "ASTNode"
local ast_node_type_const = require "ASTNodeType"

------------------------
-- 打印输出AST的树状结构
-- @param node
-- @param indent 缩进字符，由tab组成，每一级多一个tab
------------------------
local function dumpAST( node,  indent)
   
   print(indent , ast_node_type_const[node:getType()].type ,  node:getText())
   for i,child in ipairs(node:getChildren()) do
        dumpAST(child, indent.."\t")
   end
 
end


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





local SimpleCalculator = class("SimpleCalculator")

function SimpleCalculator:ctor()
    
end

------------------------
-- 执行脚本，并打印输出AST和求值过程。
-- @param script
-------------------------
function SimpleCalculator:evaluate( script)
    local ok,err = pcall(function ()
        local  tree = self:parse(script)

        dumpAST(tree, "")
        self:evaluateASTNode(tree, "");
    end)
    if not ok then
        print(err)
    end
   
end

------------------------
-- 解析脚本，并返回根节点
-- @param code
-- @return
-- @throws Exception
-------------------------
function SimpleCalculator:parse( code)
    local  lexer =  SimpleLexer.new()
    local tokens = lexer:tokenize(code)

    local  rootNode = self:prog(tokens)

    return rootNode
end

------------------------
-- 对某个AST节点求值，并打印求值过程。
-- @param node
-- @param indent  打印输出时的缩进量，用tab控制
-- @return
-------------------------
function SimpleCalculator:evaluateASTNode( node,  indent)
    local result = 0
    print(indent , "Calculating: " , ast_node_type_const[node:getType()].type)
    local switch =  {
                    [ASTNodeType.Programm]= function()
                                    for i,child in ipairs(node:getChildren()) do
                                        result = self:evaluateASTNode(child, indent .. "\t")
                                    end
                    end,
                    [ASTNodeType.Additive]= function()
                            local  children = node:getChildren()
                            local  child1 = children[1]
                            local  value1 = self:evaluateASTNode(child1, indent .. "\t")
                            local  child2 = children[2]
                            local  value2 = self:evaluateASTNode(child2, indent .. "\t")
                            if node:getText() == "+" then 
                                result = value1 + value2
                            else
                                result = value1 - value2
                            end
                    end,                
                    [ASTNodeType.Multiplicative]= function()
                        local  children = node:getChildren()
                        local  child1 = children[1]
                        local  value1 = self:evaluateASTNode(child1, indent .. "\t")
                        local  child2 = children[2]
                        local  value2 = self:evaluateASTNode(child2, indent .. "\t")
                        if node:getText() == "*" then 
                            result = value1 * value2
                        else
                            result = value1 / value2
                        end
                    end, 
                    [ASTNodeType.IntLiteral]= function()
                        result = tonumber(node:getText())
                    end, 
    }
    local func = switch[node:getType()]
    if func then
        func()
    end
    
    print(indent , "Result: " ,result)
    return result
end

------------------------
-- 语法解析：根节点
-- @return
-- @throws Exception
-------------------------
function SimpleCalculator:prog( tokens) 

    local node = SimpleASTNode.new(ASTNodeType.Programm, "Calculator")

    local child = self:additive(tokens)

    if child  then
        node:addChild(child)
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
function SimpleCalculator:intDeclare(tokens)
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
function SimpleCalculator:additive(tokens)
    local child1 = self:multiplicative(tokens)
    local node = child1

    local token = tokens:peek()
    if child1 and token then
        if token:getType() == TOKEN_TYPE.Plus or token:getType() == TOKEN_TYPE.Minus then
            token = tokens:read()
            local child2 = self:additive(tokens)
            if child2 then
                node = SimpleASTNode.new(ASTNodeType.Additive, token:getText())
                node:addChild(child1)
                node:addChild(child2)
           
            else 
                error("invalid additive expression, expecting the right part.")
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
function SimpleCalculator:multiplicative(tokens)
    local  child1 = self:primary(tokens)
    local  node = child1

    local  token = tokens:peek()
    if child1  and token  then
        if token:getType() == TOKEN_TYPE.Star or token:getType() == TOKEN_TYPE.Slash then
            token = tokens:read()
            local  child2 = self:multiplicative(tokens)
            if child2 then
                node =  SimpleASTNode.new(ASTNodeType.Multiplicative, token:getText())
                node:addChild(child1)
                node:addChild(child2)
            else
                error("invalid multiplicative expression, expecting the right part.")
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
function SimpleCalculator:primary(tokens)
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

local function main()
    local calculator = SimpleCalculator.new()

    --测试变量声明语句的解析
    local script = "int a = b+3;"
    print("解析变量声明语句: " , script)
    local lexer =  SimpleLexer.new()
    local  tokens = lexer:tokenize(script)
    local ok,err = pcall(function ()
        local  node = calculator:intDeclare(tokens)
        dumpAST(node,"")
    end)
    if not ok then
        print(err)
    end
    
    --测试表达式
    script = "2+3*5";
    print("计算: " , script , "，看上去一切正常。")
    calculator:evaluate(script)

    --测试语法错误
    script = "2+";
    print("\n: " ,script , "，应该有语法错误。")
    calculator:evaluate(script)

    script = "2+3+4";
    print("\n计算: " , script , "，结合性出现错误。")
    calculator:evaluate(script)
end

main()

return SimpleCalculator

