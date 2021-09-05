-- AST节点的类型
local ast_node_type_const = {}

local function add(type_const)
    if ast_node_type_const[type_const.code]  then

        local info = debug.getinfo(2, "Sl")
        local get_src = ""
        if info then
            local short_src = info.short_src
            get_src =  string.format("[%s:%d] ", short_src, info.currentline)
        end
        local err_info = string.format("%s have the same error code[%d], desc[%s]",get_src, type_const.code, type_const.desc)
        print(err_info)
        error(err_info)
    end
    ast_node_type_const[type_const.code] = type_const

    return type_const.code
end

ASTNodeType = {


    Programm                    =  add{  code = 1     , type="Programm"         ,    desc="程序入口，根节点"                         },            --程序入口，根节点

    IntDeclaration              =  add{  code = 2     , type="IntDeclaration"   ,    desc="整型变量声明"                             },            --整型变量声明
    ExpressionStmt              =  add{  code = 3     , type="ExpressionStmt"   ,    desc="表达式语句，即表达式后面跟个分号"           },            --表达式语句，即表达式后面跟个分号
    AssignmentStmt              =  add{  code = 4     , type="AssignmentStmt"   ,    desc="赋值语句"                                 },            --赋值语句

    Primary                     =  add{  code = 5     , type="Primary"          ,    desc="基础表达式"                               },            --基础表达式
    Multiplicative              =  add{  code = 6     , type="Multiplicative"   ,    desc="乘法表达式"                               },            --乘法表达式
    Additive                    =  add{  code = 7     , type="Additive"         ,    desc="加法表达式"                               },            --加法表达式

    Identifier                  =  add{  code = 8     , type="Identifier"       ,    desc="标识符"                                   },            --标识符
    IntLiteral                  =  add{  code = 9     , type="IntLiteral"       ,    desc="整型字面量"                               },            --整型字面量
}


return ast_node_type_const
