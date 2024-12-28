{
    config,
    pkgs,
    ...
}:

{
    programs.vim = {
        enable = true;
        settings = {
            expandtab = true;
            shiftwidth = 4;
            tabstop = 4;
        };
        extraConfig = ''
            set nocompatible
            if has('filetype')
                filetype indent plugin on
            endif
            if has('syntax')
                syntax on
            endif
            set cursorline
            set hidden
            set showcmd
            set showmode
            set showmatch
            set hlsearch
            set history=1000
            set wildmenu
            set wildmode=list:longest
            set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
            set ignorecase
            set smartcase
            set backspace=indent,eol,start
            set autoindent
            set nostartofline
            set ruler
            set laststatus=2
            set confirm
            set visualbell
            set t_vb=
            if has('mouse')
                set mouse=a
            endif
            set cmdheight=2
            set number
            set notimeout ttimeout ttimeoutlen=200
            set pastetoggle=<F11>
            

            map Y y$
            nnoremap <C-L> :nohl<CR><C-L>
        '';
    
    };
}
