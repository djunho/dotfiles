local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local utils = require("myconf.snippetsUtils")


return {
    -- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
    s("fn basic", {
        t("-- @param: "), f(utils.copy, 2),
        t({"","local "}), i(1), t(" = function("),i(2,"fn param"),t({ ")", "\t" }),
        i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
        t({ "", "end" }),
    }),
    s("fn module", {
        -- make new line into snippet
        t("-- @param: "), f(utils.copy, 3), t({"",""}),
        i(1, "modname"), t("."), i(2, "fnname"), t(" = function("),i(3,"fn param"),t({ ")", "\t" }),
        i(0), -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
        t({ "", "end" }),
    }),
    s({trig="if basic", wordTrig=true}, {
        t({"if "}),
        i(1),
        t({" then", "\t"}),
        i(0),
        t({"", "end"})
    }),
    s({trig="else", wordTrig=true}, {
        t({"else", "\t"}),
        i(0),
    }),
    s("for", {
        t"for ", c(1, {
        sn(nil, {i(1, "k"), t", ", i(2, "v"), t" in ", c(3, {t"pairs", t"ipairs"}), t"(", i(4), t")"}),
        sn(nil, {i(1, "i"), t" = ", i(2), t", ", i(3), })
        }), t{" do", "\t"}, i(0), t{"", "end"}
    })
}

