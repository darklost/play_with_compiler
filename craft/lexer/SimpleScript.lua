--[[
    author:darklost
    time:2021-09-04 24:48:43
]]

------------------------------------------------------------------
-- 一个简单的脚本解释器。
-- 所支持的语法，请参见SimpleParser.lua
--
-- 运行脚本：
-- 在命令行下，键入：lua -e "package.path='craft/lexer/?.lua;craft/?.lua;'" .\craft\lexer\SimpleScript.lua -v
-- 则进入一个REPL界面。你可以依次敲入命令。比如：
-- > 2+3;
-- > int age = 10;
-- > int b;
-- > b = 10*2;
-- > age = age + b;
-- > exit();  //退出REPL界面。
--
-- 你还可以使用一个参数 -v，让每次执行脚本的时候，都输出AST和整个计算过程。
--
------------------------------------------------------------------
require "framework.init"
local SimpleParser = require "SimpleParser"
local SimpleScript = class('SimpleScript')
SimpleScript.verbose = false

function SimpleScript:ctor()
    self.variables = {}
end




----------------
-- 遍历AST，计算值。
-- @param node
-- @param indent
-- @return
-- @throws Exception
----------------
function SimpleScript:evaluate( node,  indent) 
    local  result = nil   
    if SimpleScript.verbose then
        print(indent , "Calculating: " , node:getType())
    end
    local switch_func = {}
  
    switch_func[ASTNodeType.Programm]=function ()
        for i,child in ipairs( node:getChildren()) do
            result = self:evaluate(child, indent)
        end
       
    end
   
    switch_func[ASTNodeType.Additive]=function ()
        local children =  node:getChildren()
        local child1 = children[1]
        local value1 = self:evaluate(child1, indent .. "\t")
        local child2 = children[2]
        local value2 = self:evaluate(child2, indent .. "\t")
        if node:getText()=="+" then
            result = value1 + value2
         else 
            result = value1 - value2
         end
       
    end
      
    switch_func[ASTNodeType.Multiplicative]=function ()
        local children =  node:getChildren()
        local child1 = children[1]
        local value1 = self:evaluate(child1, indent .. "\t")
        local child2 = children[2]
        local value2 = self:evaluate(child2, indent .. "\t")
        if node:getText()=="*" then
            result = value1 * value2
        else
            result = value1 / value2
        end
        
    end
      
    switch_func[ASTNodeType.IntLiteral]=function ()
        result = tonumber(node:getText())
    end
      
    switch_func[ASTNodeType.Identifier]=function ()
        local  varName = node:getText()
        if  self.variables[varName] then
            local  value = self.variables[varName]
            if value then
                result = tonumber(value)
            else
                error("variable ".. varName.. " has not been set any value")
            end
       
        else
            error("unknown variable: "..varName)
        end
       
    end
       
    switch_func[ASTNodeType.AssignmentStmt]=function ()
        local varName = node:getText()
        
        if  self.variables[varName] ==nil then
            dump(self.variables)
            error("unknown variable: "..varName)
        end  
        --接着执行下面的代码
        switch_func[ASTNodeType.IntDeclaration]()
    end
      
    switch_func[ASTNodeType.IntDeclaration]=function ()
        local varName = node:getText()
        local varValue = false --为了方便table 插入key 分清楚map中key 存在 但是value 是nil
        if #node:getChildren() > 0 then
            local  child = node:getChildren()[1]
            result = self:evaluate(child, indent .. "\t")
           
            varValue = tonumber(result)
        end
        self.variables[varName]=varValue

       
    end
     

    local func = switch_func[node:getType()]
    if func then
        func()
    end

    if SimpleScript.verbose then
       print(indent , "Result:", result)
    elseif indent == "" then -- 顶层的语句
        if node:getType() == ASTNodeType.IntDeclaration or node:getType() == ASTNodeType.AssignmentStmtthen then
           result = result or "nil"
           print(node:getText().. ":"..result)
        elseif node:getType() ~= ASTNodeType.Programm then
           print(result)
        end
    end

 
    return result
end




--[[
    @desc: lua -e "package.path='craft/lexer/?.lua;craft/?.lua;'" .\craft\lexer\SimpleScript.lua
    author:darklost
    time:2021-09-04 02:25:47
    @return:
]]
local function main()
    if #arg > 0 and arg[1] == "-v" then
        SimpleScript.verbose = true
        print("SimpleScript.verbose mode")
    end
    print("Simple script language!")

    local parser =  SimpleParser.new()
    local script =  SimpleScript.new()
 

    local scriptText = ""
    io.write("\n>")   --提示符

    while true do
        local line  = string.trim(io.read("*l"))
        if line =="exit();" then
            io.write("good bye!")
            break
        end
        local ok ,err = pcall(function ()
          
            scriptText = scriptText .. line .. "\n"
            if string.end_with(line,";") then
                local tree = parser:parse(scriptText)
                if (SimpleScript.verbose) then
                    SimpleParser.dumpAST(tree, "")
                end

                script:evaluate(tree, "")

                io.write("\n>")  --提示符

                scriptText = ""
            end
        end)
        
        if not ok then
            io.write(err)
            io.write("\n>")   --提示符
            scriptText = ""
        end
    end
end

main()

return SimpleScript