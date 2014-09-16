" ============================================================================
" FILE: chatbot.vim
" AUTHOR: koturn <jeak.koutan.apple@gmail.com>
" DESCRIPTION: {{{
" Let's talk with Vim!
" }}}
" ============================================================================
let s:save_cpo = &cpo
set cpo&vim


let s:V = vital#of('chatbot')
let s:JSON = s:V.import('Web.JSON')
let s:HTTP = s:V.import('Web.HTTP')

let s:APIKEY = '6d47394837346c514a6d336b6338495049385976365a68785a57362e64657a736a52574535376755375844'
let s:DOCOMO_API_URL = {
      \ 'dialogue': 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue',
      \ 'knowledgeQA': 'https://api.apigw.smt.docomo.ne.jp/knowledgeQA/v1/ask'
      \}
let s:PROMPT = {
      \ 'dialog': 'message> ',
      \ 'qa': 'question> '
      \}
let s:INDENT = '  '
lockvar s:APIKEY
lockvar s:DOCOMO_API_URL
lockvar s:TEXT
lockvar s:INDENT

let g:chatbot#user_profile = get(g:, 'chatbot#user_profile', {})


function! chatbot#talkmode(mode)
  let l:url = s:DOCOMO_API_URL.dialogue . '?' . s:HTTP.encodeURI({'APIKEY': s:APIKEY})
  let l:req_header = {'Content-Type': 'application/json'}
  let l:req_body_dict = deepcopy(g:chatbot#user_profile)
  let l:req_body_dict.mode = a:mode
  let l:req_body_dict.utt = input(s:PROMPT.dialog)

  while l:req_body_dict.utt !=# 'quit' && l:req_body_dict.utt !=# 'q'
    echo ' ...'
    let s:response = s:HTTP.post(l:url, s:JSON.encode(l:req_body_dict), l:req_header)
    let l:content = s:JSON.decode(s:response.content)
    echomsg l:content.utt
    let l:req_body_dict.context = l:content.context
    let l:req_body_dict.utt = input(s:PROMPT.dialog)
  endwhile
endfunction


function! chatbot#qamode()
  let l:indent = '  '
  let l:query = {
        \ 'APIKEY': s:APIKEY,
        \ 'q': input(s:PROMPT.qa)
        \}
  while l:query.q !=# 'quit' && l:query.q !=# 'q'
    echo ' ...'
    let l:response = s:HTTP.get(s:DOCOMO_API_URL.knowledgeQA, l:query)
    let l:content = s:JSON.decode(l:response.content)
    echomsg l:content.message.textForDisplay
    for l:answer in l:content.answers
      echomsg s:INDENT . l:answer.rank . ': ' . l:answer.answerText
      echomsg s:INDENT . l:answer.linkText . ': ' . l:answer.linkUrl
    endfor
    let l:query.q = input(s:PROMPT.qa)
  endwhile
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
