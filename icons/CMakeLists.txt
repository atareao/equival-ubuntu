#
# App icons. These are installed to the system's default theme
#


install(FILES equival.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/pixmaps)
install(FILES equival.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/equival/icons)
install(FILES facebook.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/equival/icons)
install(FILES googleplus.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/equival/icons)
install(FILES twitter.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/equival/icons)
install(FILES web.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/equival/icons)

install(
    CODE
        "execute_process (COMMAND gtk-update-icon-cache -t -f ${CMAKE_INSTALL_PREFIX}/share/equival/icons/)"
    CODE
        "message (STATUS \"Updated icon cache in ${CMAKE_INSTALL_PREFIX}/share/equival/icons/\")"
)
