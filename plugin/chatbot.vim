" ============================================================================
" FILE: chatbot.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" Last Modified: 2014 09/15
" DESCRIPTION: {{{
" Let's talk with Vim!
" }}}
" ============================================================================
if exists('g:loaded_chatbot')
  finish
endif
let g:loaded_chatbot = 1
let s:save_cpo = &cpo
set cpo&vim


command! -bar ChatBotTalkMode call chatbot#talkmode('dialog')
command! -bar ChatBotSiritoriMode call chatbot#talkmode('srtr')
command! -bar ChatBotQandAMode call chatbot#qamode()


let &cpo = s:save_cpo
unlet s:save_cpo
