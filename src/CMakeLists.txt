# Vala
find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.18" MINIMUM)
include(ValaPrecompile)

# Packages

set(TARGET_GLIB 2.32)

pkg_check_modules(DEPS REQUIRED
	gtk+-3.0
	json-glib-1.0
	${EXTRA_PKG_CONFIG}
)

set(CFLAGS
    ${DEPS_CFLAGS}
    ${DEPS_CFLAGS_OTHER}
    -D_VERSION=\"${VERSION}\"
    -D_INSTALL_PREFIX=\"${CMAKE_INSTALL_PREFIX}\"
    -D_SOURCE_ROOT_DIR=\"${CMAKE_SOURCE_DIR}\"
    -D_GSETTINGS_DIR=\"${CMAKE_BINARY_DIR}/gsettings\"
    -DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"
    -DLANGUAGE_SUPPORT_DIRECTORY=\"${LANGUAGE_SUPPORT_DIRECTORY}\"
    -g
)

if (NOT DEBUG)
    set(CFLAGS
        ${CFLAGS}
        -O2
    )
endif ()

set(EQUIVAL_PACKAGES
    gtk+-3.0 json-glib-1.0 ${EXTRA_PACKAGES}
)

set(VALAC_OPTIONS
    --vapidir=${CMAKE_SOURCE_DIR}/vapi
    --target-glib=${TARGET_GLIB}
    --thread
    --enable-checking
    --debug
    --fatal-warnings
    ${EXTRA_VALA_OPTIONS}
)

set(LIB_PATHS ${DEPS_LIBRARY_DIRS})
link_directories(${LIB_PATHS})
add_definitions(${CFLAGS} "-DGETTEXT_PACKAGE=\"${PACKAGE}\"")

vala_precompile(VALA_C    
    comun.vala
    config.vala
    configuration.vala
    elemento.vala
    equival.vala
    holo-selector.vala
    main.vala
    special-entry.vala
PACKAGES
    ${EQUIVAL_PACKAGES}
OPTIONS
    ${VALAC_OPTIONS}
)

#Here we define our executable name.
add_executable(equival
    ${VALA_C} )

add_definitions (${DEPS_CFLAGS} -DWNCK_I_KNOW_THIS_IS_UNSTABLE)

#We need to link the libraries with our Executable.
target_link_libraries(equival ${DEPS_LIBRARIES} -lX11)

install (TARGETS equival RUNTIME DESTINATION bin)
