install(FILES equival.db DESTINATION share/${PACKAGE})
install(FILES equival.desktop DESTINATION share/applications)
install (CODE
"execute_process (COMMAND update-desktop-database)"
)
