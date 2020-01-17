add_executable(openslide-bins openslide-show-properties.c openslide-quickhash1sum.c openslide-write-png.c)
message(STATUS "${SQLITE3_INCLUDE_DIR}")
target_include_directories(openslide-bins PUBLIC ${OPENSLIDE_INCLUDES})
target_link_libraries(openslide-bins openslide ${OPENSLIDE_DEP_LIBS})
