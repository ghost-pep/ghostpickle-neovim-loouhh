; extends

; Neovim rejects fenced-code info strings that contain non-word characters
; (see runtime/lua/vim/treesitter/languagetree.lua: `alias:match('[%w_]+')`),
; so ```c++ and ```c# never reach alias resolution. Setting the language with
; a `#set!` directive bypasses that check and forces the right parser.

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#eq? @_lang "c++")
  (#set! injection.language "cpp"))

((fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content)
  (#eq? @_lang "c#")
  (#set! injection.language "c_sharp"))
