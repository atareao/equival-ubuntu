# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.0

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/atareao/Copy/PROGRAMACION/Python/trusty/equival

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build

# Utility rule file for i18n.

# Include the progress variables for this target.
include po/CMakeFiles/i18n.dir/progress.make

po/CMakeFiles/i18n:
	$(CMAKE_COMMAND) -E cmake_progress_report /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold messages.”

i18n: po/CMakeFiles/i18n
i18n: po/CMakeFiles/i18n.dir/build.make
	cd /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po && /usr/bin/msgfmt -o /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po/es.mo /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/po/es.po
	cd /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po && /usr/bin/msgfmt -o /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po/fr.mo /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/po/fr.po
	cd /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po && /usr/bin/msgfmt -o /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po/en.mo /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/po/en.po
.PHONY : i18n

# Rule to build all files generated by this target.
po/CMakeFiles/i18n.dir/build: i18n
.PHONY : po/CMakeFiles/i18n.dir/build

po/CMakeFiles/i18n.dir/clean:
	cd /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po && $(CMAKE_COMMAND) -P CMakeFiles/i18n.dir/cmake_clean.cmake
.PHONY : po/CMakeFiles/i18n.dir/clean

po/CMakeFiles/i18n.dir/depend:
	cd /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/atareao/Copy/PROGRAMACION/Python/trusty/equival /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/po /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po /home/atareao/Copy/PROGRAMACION/Python/trusty/equival/build/po/CMakeFiles/i18n.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : po/CMakeFiles/i18n.dir/depend
