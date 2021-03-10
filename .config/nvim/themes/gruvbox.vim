let g:conf_colorscheme = "gruvbox"
fun! ColorMyPencils()
    let g:gruvbox_contrast_dark = 'hard'
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    let g:gruvbox_invert_selection='0'

    set background=dark
    if has('nvim')
        call luaeval('vim.cmd("colorscheme " .. _A[1])', [g:conf_colorscheme])
    else
        " TODO: What the way to use g:conf_colorscheme
        colorscheme gruvbox
    endif

    hi ColorColumn ctermbg=0 guibg=grey
    hi Normal guibg=none
    hi LineNr guifg=#ff8659
    " hi LineNr guifg=#aed75f
    " hi LineNr guifg=#5eacd3
    highlight netrwDir guifg=#5eacd3
    hi qfFileName guifg=#aed75f
    hi TelescopeBorder guifg=#ff8659
endfun
call ColorMyPencils()

" Vim with me
nnoremap <leader>vwm :call ColorMyPencils()<CR>
nnoremap <leader>vwb :let g:conf_colorscheme =
