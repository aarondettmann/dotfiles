# LuaLaTeX as the default engine ($pdf_mode = 4 selects $lualatex).
# -synctex=1 is added by VimTeX and by project Makefiles where needed.
$lualatex = 'lualatex -file-line-error %O %S';
$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;

# glossaries package: main glossary
add_cus_dep( 'glo', 'gls', 0, 'makeglo2gls' );
sub makeglo2gls {
    return system( "makeindex -s \"$_[0].ist\" -t \"$_[0].glg\" -o \"$_[0].gls\" \"$_[0].glo\"" );
}

# glossaries package: acronyms ([acronym] option)
add_cus_dep( 'acn', 'acr', 0, 'makeacn2acr' );
sub makeacn2acr {
    return system( "makeindex -s \"$_[0].ist\" -t \"$_[0].alg\" -o \"$_[0].acr\" \"$_[0].acn\"" );
}

# glossary package (the predecessor of glossaries): acronyms, with the
# input and output extensions reversed
add_cus_dep( 'acr', 'acn', 0, 'makeacr2acn' );
sub makeacr2acn {
    return system( "makeindex -s \"$_[0].ist\" -t \"$_[0].alg\" -o \"$_[0].acn\" \"$_[0].acr\"" );
}

# glossaries package: notation glossary, \newglossary[nlg]{notation}{not}{ntn}{Notation}
add_cus_dep( 'ntn', 'not', 0, 'makentn2not' );
sub makentn2not {
    return system( "makeindex -s \"$_[0].ist\" -t \"$_[0].nlg\" -o \"$_[0].not\" \"$_[0].ntn\"" );
}

# glossary package: notation glossary, with the extensions reversed
add_cus_dep( 'not', 'ntn', 0, 'makenot2ntn' );
sub makenot2ntn {
    return system( "makeindex -s \"$_[0].ist\" -t \"$_[0].nlg\" -o \"$_[0].ntn\" \"$_[0].not\"" );
}

# index package: custom indexes
add_cus_dep( 'adx', 'and', 0, 'makeadx2and' );
sub makeadx2and {
    return system( "makeindex -o \"$_[0].and\" \"$_[0].adx\"" );
}

add_cus_dep( 'ndx', 'nnd', 0, 'makendx2nnd' );
sub makendx2nnd {
    return system( "makeindex -o \"$_[0].nnd\" \"$_[0].ndx\"" );
}

add_cus_dep( 'ldx', 'lnd', 0, 'makeldx2lnd' );
sub makeldx2lnd {
    return system( "makeindex -o \"$_[0].lnd\" \"$_[0].ldx\"" );
}

# nomencl package
add_cus_dep( 'nlo', 'nls', 0, 'makenlo2nls' );
sub makenlo2nls {
    return system( "makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"" );
}
