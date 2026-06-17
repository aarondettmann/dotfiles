" GUI font and font size
if exists(':GuiFont')
    GuiFont! Hack:h10
elseif exists('+guifont')
    set guifont=Hack:h10
endif

if exists('*GuiWindowMaximized')
    call GuiWindowMaximized(1)
endif
