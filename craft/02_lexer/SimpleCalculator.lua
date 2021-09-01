
----------------------------------------------------------------------
-- 实现一个计算器，但计算的结合性是有问题的。因为它使用了下面的语法规则：
--
-- additive -> multiplicative | multiplicative + additive
-- multiplicative -> primary | primary * multiplicative    
--
-- 递归项在右边，会自然的对应右结合。我们真正需要的是左结合。
----------------------------------------------------------------------

local SimpleLexer = require "SimpleLexer"
local ASTNode = require "ASTNode"



------------------------
-- 打印输出AST的树状结构
-- @param node
-- @param indent 缩进字符，由tab组成，每一级多一个tab
------------------------
local function dumpAST( node,  indent)
   print(indent , node.getType() , node.getText())
   for i,child in ipairs(node.getChildren()) do
        dumpAST(child, indent.."\t")
   end
 
end

local function main()
    
end

main()

------------------------------
--一个简单的AST节点的实现。
-- 属性包括：类型、文本值、父节点、子节点。
------------------------------
local SimpleASTNode = class("SimpleASTNode",ASTNode)

function SimpleASTNode:ctor()
    self.parent = nil       --父节点
    self.children = {}      --子节点列表
    self.nodeType = nil     --节点类型
    self.text = nil         --文本值
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
    local token = tokens:peek()
    --匹配Int
    if token and token:getType() == TOKEN_TYPE.Int then
        --匹配标识符
    end
end

-----------------------
-- 语法解析：加法表达式
--  @return
--  @throws Exception
-----------------------
function SimpleCalculator:additive(tokens)
 
end

-----------------------
-- 语法解析：乘法表达式
-- @return
-- @throws Exception
-----------------------
function SimpleCalculator:multiplicative(tokens)
 
end

-----------------------
--语法解析：基础表达式
--@return
--@throws Exception
-----------------------
function SimpleCalculator:primary(tokens)
 
end


