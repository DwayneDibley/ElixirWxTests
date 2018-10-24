Definitions.

%INT        = [0-9]+
%ATOM       = :[a-z_]+
%KEY        = [a-z_]+:
%MODULE     = [A-Z][a-zA-Z_]+
%STOP       = [.]
%COMMA      =
%STRING     = ".*"
%QUOTE      = '.*'
%COMMENT    = #.*\n
%BRACKETS   = [\(\)\[\]\{\}]
%DEFINE     = @[a-z_]+
%IDENTIFIER = [a-z][a-zA-Z_]+
%IDENTIFIER = [a-z]
%UNUSED     = _[a-z][a-zA-Z_]+
%UNUSED     = _[a-z]
%OTHER      = .

Whitespace  = [\s\t]
Eol         = \n|\r\n|\r

ArgUnused   = _[a-z_]+
Atom        = :[a-z_]+
ArgsBegin   = \(
ArgsEnd     = \)
Bang        = \!
Brackets    = [\[\]\{\}]
Comment     = #.*\n
Defmodule   = defmodule
Def         = def
Do          = do
End         = end
FullStop    = \.
Comma       = ,
Name        = [a-z][a-zA-Z_]+
ShortName   = [a-z]
Module      = [A-Z][a-zA-Z_]+
Require     = require
Use         = use
Import      = import
String_sq   = '.*'
String_dq   = ".*"
Define      = @[a-z_]+
Pointer     = ->
Syntax      = [=+-|&]
Integer     = [0-9]+

NullArg     = {ArgUnused}
Block       = {Defmodule}|{Do}|{End}|{Def}
Directive   = {Require}|{Use}|{Import}
Identifier  = {Name}|{ShortName}
Punctuation = {FullStop}|{Comma}|{Bang}
String      = {String_sq}|{String_dq}

Rules.

{Atom}         : {token, {atom, TokenLine, TokenChars}}.
{Block}        : {token, {block, TokenLine, TokenChars}}.
{Brackets}     : {token, {brackets, TokenLine, TokenChars}}.
{ArgsBegin}    : {token, {argsbegin, TokenLine, TokenChars}}.
{Comment}      : {token, {comment, TokenLine, TokenChars}}.
{Define}       : {token, {define, TokenLine, TokenChars}}.
{Directive}    : {token, {directive, TokenLine, TokenChars}}.
{ArgsEnd}      : {token, {argsend, TokenLine, TokenChars}}.
{Eol}          : {token, {eol, TokenLine, TokenChars}}.
{Integer}      : {token, {integer, TokenLine, TokenChars}}.
{Module}       : {token, {module, TokenLine, TokenChars}}.
{NullArg}      : {token, {nullarg, TokenLine, TokenChars}}.
{Pointer}      : {token, {pointer, TokenLine, TokenChars}}.
{Punctuation}  : {token, {punctuation, TokenLine, TokenChars}}.
{Identifier}   : {token, {identifier, TokenLine, TokenChars}}.
{String}       : {token, {string, TokenLine, TokenChars}}.
{Syntax}       : {token, {syntax, TokenLine, TokenChars}}.
{Whitespace}   : {token, {whitespace, TokenLine, TokenChars}}.




%{INT}         : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
%{ATOM}        : {token, {atom, TokenLine, TokenChars}}.
%{KEY}         : {token, {key, TokenLine, TokenChars}}.
%{IDENTIFIER}  : {token, {identifier, TokenLine, TokenChars}}.
%{UNUSED}      : {token, {unused, TokenLine, TokenChars}}.
%{MODULE}      : {token, {module, TokenLine, TokenChars}}.
%{STOP}        : {token, {stop, TokenLine, TokenChars}}.
%{COMMA}       : {token, {comma, TokenLine, TokenChars}}.
%{STRING}      : {token, {string, TokenLine, TokenChars}}.
%{QUOTE}       : {token, {quote, TokenLine, TokenChars}}.
%{COMMENT}     : {token, {comment, TokenLine, TokenChars}}.
%{BRACKETS}    : {token, {bracket, TokenLine, TokenChars}}.
%{DEFINE}      : {token, {define, TokenLine, TokenChars}}.
%{OPERATOR}    : {token, {operator, TokenLine, TokenChars}}.

%[a-z_]+:      : {token, {key,  TokenLine, list_to_atom(lists:sublist(TokenChars, 1, TokenLen - 1))}}.
%\[            : {token, {'[',  TokenLine}}.
%\]            : {token, {']',  TokenLine}}.
%,             : {token, {',',  TokenLine}}.
%{WHITESPACE}  : {token, {whitespace, TokenLine, TokenChars}}.
%{STRING}      : {token, {string, TokenLine, TokenChars}}.
%{OTHER} : {token, {other, TokenLine, TokenChars}}.


Erlang code.

to_atom(Atom) ->
    'Elixir.Helpers':to_atom(Atom).
