local token_type_const = {}

local function add(const)
    if token_type_const[const.code]  then

        local info = debug.getinfo(2, "Sl")
        local get_src = ""
        if info then
            local short_src = info.short_src
            get_src =  string.format("[%s:%d] ", short_src, info.currentline)
        end
        local err_info = string.format("%s have the same error code[%d], desc[%s]",get_src, const.code, const.desc)
        print(err_info)
        error(err_info)
    end
    token_type_const[const.code] = const

    return const.code
end

TOKEN_TYPE = {
    Plus                    = add{  code = 1     ,desc="Plus"},   -- +
    Minus                   = add{  code = 2     ,desc="Minus"},  -- -
    Star                    = add{  code = 3     ,desc="Star"},   -- *
    Slash                   = add{  code = 4     ,desc="Slash"},  -- /

    GE                      = add{  code = 5     ,desc="GE"},     -- >=
    GT                      = add{  code = 6     ,desc="GT"},     -- >
    EQ                      = add{  code = 7     ,desc="EQ"},     -- ==
    LE                      = add{  code = 8     ,desc="LE"},     -- <=
    LT                      = add{  code = 9     ,desc="LT"},     -- <

    SemiColon               = add{  code = 10    ,desc="SemiColon"}, -- ;
    LeftParen               = add{  code = 11    ,desc="LeftParen"}, -- (
    RightParen              = add{  code = 12    ,desc="RightParen"},-- )

    Assignment              = add{  code = 13    ,desc="Assignment"},-- =

    If                      = add{  code = 14    ,desc="If"},
    Else                    = add{  code = 15    ,desc="Else"},
    
    Int                     = add{  code = 16    ,desc="Int"},

    Identifier              = add{  code = 17    ,desc="Identifier"},     --标识符

    IntLiteral              = add{  code = 18    ,desc="IntLiteral"},     --整型字面量
    StringLiteral           = add{  code = 19    ,desc="StringLiteral"},   --字符串字面量
}

return token_type_const
