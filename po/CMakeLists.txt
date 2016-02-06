# Translations
include (Translations)
add_translations_directory ("${PACKAGE}")
add_translations_catalog ("${PACKAGE}"
    ../src
)

ADD_CUSTOM_TARGET(
    translations
    COMMAND xgettext -o ../../po/${PACKAGE}.pot --language=C --keyword=_ --escape ../../src/*.vala
    COMMAND intltool-merge --quiet --desktop-style ../../po/ data/${PACKAGE}.desktop.in ../../data/${PACKAGE}.desktop
)
