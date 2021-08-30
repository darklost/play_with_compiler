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
    Plus                    = add(              code = 1 ,desc="Plus"),   -- +
    Minus                   = add(             code = 1 ,desc="Minus"),  -- -
    Star                    = add(              code = 1 ,desc="Star"),   -- *
    Slash                   = add(             code = 1 ,desc="Slash"),  -- /

    GE                      = add(                code = 1 ,desc="GE"),     -- >=
    GT                      = add(                code = 1 ,desc="GT"),     -- >
    EQ                      = add(                code = 1 ,desc="EQ"),     -- ==
    LE                      = add(                code = 1 ,desc="LE"),     -- <=
    LT                      = add(                code = 1 ,desc="LT"),     -- <

    SemiColon               = add(             code = 1 ,desc="SemiColon"), -- ;
    LeftParen               = add(             code = 1 ,desc="LeftParen"), -- (
    RightParen              = add(                code = 1 ,desc="RightParen"),-- )

    Assignment              = add(                code = 1 ,desc="Assignment"),-- =

    If                      = add(                code = 1 ,desc="If"),
    Else                    = add(              code = 1 ,desc="Else"),
    
    Int                     = add(               code = 1 ,desc="Int"),

    Identifier              = add(                code = 1 ,desc="Identifier"),     --标识符

    IntLiteral              = add(                code = 1 ,desc="IntLiteral"),     --整型字面量
    StringLiteral           = add(             code = 1 ,desc="StringLiteral"),   --字符串字面量
}

return token_type_const
