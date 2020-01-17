project(openslide-bins)
add_executable(${PROJECT_NAME} openslide-show-properties.c openslide-write-png.c openslide-quickhash1sum.c)

target_link_libraries(${PROJECT_NAME}
    ${ZLIB_LIBRARIES}
    ${OPENJPEG_LIBRARIES}
    ${JPEG_LIBRARIES}
    ${TIFF_LIBRARIES}
    ${GLIB_LDFLAGS}
    ${Cairo_LIBRARIES}
    ${PNG_LIBRARIES}
    ${GDKPIXBUF_LIBRARIES}
    ${LIBXML2_LIBRARIES}
    ${SQLITE3_LIBRARIES}
    openslide
)
