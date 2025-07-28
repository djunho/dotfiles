local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local isn = ls.indent_snippet_node
local events = require("luasnip.util.events")

local utils = require("myconf.snippetsUtils")

local get_filename = function(_args, snip)
    local name = snip.snippet.env.TM_FILENAME
    if name == nil then
        return ""
    end
    name = name:gsub("%.", "_", 3)
    name = "_"..name:upper().."_"
    return name or ""
end


local parameter_doc_node = fmt("//! {} {}", { c(1, { t("[in]"), t("[out]"), t("")}), i(2, "Description") } )

local check_parameter = function(args)
    local _, _, _, name = string.find(args[1][1], "(%a+)%s*(%a*)")
    if name == "" then
        return false
    end
    return true
end

local parameter_doc = function(args, _, _, indent)
    local has_parameters = check_parameter(args)
    --print("has_parameters1 = "..tostring(has_parameters))

    if indent ~= nil and indent == true then
        if has_parameters == false then
            return sn(nil, t(""))
        end
        return sn(nil, t({ "", "" }))
    end

    --print("has_parameters2 = "..tostring(has_parameters))
    if has_parameters == false then
        print("Should not have the //!")
        return sn(nil, t(""))
    end
    return sn(nil, parameter_doc_node)
end

local func_parameter
func_parameter = function(args)
    print("args = "..vim.inspect(args))
    if #args ~= 0 then
        local _, _, comma = string.find(args[1][1], "%a+%s+%a+(,)")
        if comma == nil then
            -- If no comma is detected, stop the recursion
            return sn(nil, {})
        else
            -- Comma detected, insert a new parameter snippet
            return sn(nil, {
                             i(1, "void"),
                             d(2, parameter_doc, {1}),
                             d(3, parameter_doc, {1}, {user_args = {true}}),
                             d(4, func_parameter, {1})
                           }
                      )
        end
    else
        -- Insert the first snippet, jumping the lines
        return sn(nil, { d(1, parameter_doc, {2}, {user_args = {true}}),
                         i(2, "void"),
                         d(3, parameter_doc, {2}),
                         d(4, parameter_doc, {2}, {user_args = {true}}),
                         d(5, func_parameter, {2})
                       }
                  )
    end

end

return {
    -- functions
    s("func simple", fmt([[
        //__ {}
        {} {}({}){{
            {}
        }}
        {}
    ]], {
        i(5), i(1, "void"), i(2, "func"),
            d(3, func_parameter),
        i(4, "//__ code"), i(0)
    })),
--    -- functions
--    s("func simple", fmt([[
--        //__ {}
--        {} {}({}{}{}{}){{
--            {}
--        }}
--        {}
--    ]], {
--        i(8), i(1, "void"), i(2, "func"),
--        d(3, parameter_doc, {4}, {user_args = {true}}), i(4, "void"), d(5, parameter_doc, {4}), d(6, parameter_doc, {4}, {user_args = {true}}),
--        i(7, "//__ code"), i(0)
--    })),
    -- #ifdef header
    s("#ifndef header", fmt([[
        #ifndef {}
        #define {}
        {}
        #endif // {}
    ]], {
        f(get_filename), f(get_filename), i(0), f(get_filename)
    })),
    s("//!", parameter_doc_node),
    s("main", fmt([[
        #include <stdlib.h>

        int main(int argc, char *argv[]){{
            {}
            return 0;
        }}
        ]], {i(1, "//__code")})),
    s("typedef", fmt([[typedef {} {};]], {i(1), i(2, "newname_t")})),
    s("struct", fmt([[
        struct {}{{
            {}
        }}
    ]], {i(1), i(2)})),
    s("#error", fmt([[#error "{}"]], {i(1)})),
    s("#warning", fmt([[#warning "{}"]], {i(1)})),
    s("#inc\"", fmt([[#include "{}"]], {i(1)})),
    s("#inc<", fmt([[#include <{}>]], {i(1, "stdio.h")})),
    s("#ifndef", fmt([[
        #ifndef {}
            {}
        #endif // {}]], {i(1), i(2), f(utils.copy, {1})})),
    s("#ifdef", fmt([[
        #ifdef {}
            {}
        #endif // {}]], {i(1), i(2), f(utils.copy, {1})})),
    s("#if", fmt([[
        #if {}
            {}
        #endif // {}]], {i(1), i(2), f(utils.copy, {1})})),
    s("nocpp", fmt([[
        #ifdef __cplusplus"
        extern "C" {{
        #endif
            {}
        #ifdef __cplusplus
        }} // extern "C"
        #endif
    ]], {i(1)})),
    s("ifelse", fmt([[
        if ({}) {{
            {}
        }} else {{
            {}
        }}
    ]], {i(1, "cond"), i(2), i(3)})),
    s("if", fmt([[
        if ({}) {{
            {}
        }}
    ]], {i(1, "cond"), i(2)})),
    s("ternary", fmt([[{} ? {} : {};]], {i(1, "cond"), i(2), i(3)})),
    s("while", fmt([[
        while ({}){{
            {}
        }}
    ]], {i(1, "cond"), i(2, "//__ code")})),
    s("do", fmt([[
        do {{
            {}
        }} while ({});
    ]], {i(1, "//__ code"), i(1, "cond")})),
    s("for", fmt([[
        for ({}){{
            {}
        }}
        {}
    ]], {
        c(1, {
            fmt([[int i = {}; i < {}; {}]], {i(1, "0"), i(2, "10"), i(3, "++i")}),
            t(""),
             }),
        i(2, "//__ code"),
        i(0)
        })),
    s("switch", fmt([[
        switch ({}){{
            case {}:
                {}
                break;
            default:
                break;
        }}
    ]], {i(1, "cond"), i(2, "VALUE"), i(3, "//__ code")})),
    s("func jdoc",
        fmt([[
            {}
            {}{} {}({}){{
                {}
            }}
        ]], {
            d(5, utils.jdocsnip, {2, 4}),
            c(1, {
                t({""}),
                t({"public "}),
                t({"private "})
            }),
            c(2, {
                t({"void"}),
                i(nil, {""}),
                t({"String"}),
                t({"char"}),
                t({"int"}),
                t({"double"}),
                t({"boolean"}),
            }),
            i(3, {"myFunc"}),
            i(4),
            i(0),
    })),
}

