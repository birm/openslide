cmake_minimum_required(VERSION 3.5)
project(openslide VERSION 3.4.1 LANGUAGES C)
add_compile_definitions(SUFFIXED_VERSION="${PROJECT_VERSION}")


file(GLOB openslide_SRC "${CMAKE_SOURCE_DIR}/src/*.c" )
add_library(${PROJECT_NAME} STATIC ${openslide_SRC})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/src/ ${CMAKE_SOURCE_DIR}/common/)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMake")

option(USE_VALGRIND "If available, use valgrind for profiling." OFF)
option(BUILD_TOOLS, "Build openslide cli tools." OFF)

# TODO tools not building
# tools
if(BUILD_TOOLS)
  add_subdirectory(tools)
endif()

## TODO -- many of these have version requirments, and some were behaving strange (e.g. openjpeg)

# get requirements
find_package(ZLIB REQUIRED)
find_package(JPEG REQUIRED)
find_package(OPENJPEG REQUIRED)
find_package(TIFF REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_search_module(GLIB REQUIRED glib-2.0)
find_package(Cairo 1.2.0 REQUIRED)
find_package(PNG REQUIRED)
find_package(GDKPIXBUF 1.6.0 REQUIRED)
find_package(LIBXML2 REQUIRED)
find_package(SQLITE3 3.6.20 REQUIRED)
#required includes
set(OPENSLIDE_INCLUDES
  ${ZLIB_INCLUDE_DIRS}
  ${OPENJPEG_INCLUDE_DIRS}
  ${JPEG_INCLUDE_DIR}
  ${TIFF_INCLUDE_DIR}
  ${GLIB_INCLUDE_DIRS}
  ${CAIRO_INCLUDE_DIRS}
  ${PNG_INCLUDE_DIR}
  ${GDKPIXBUF_INCLUDE_DIR}
  ${LIBXML2_INCLUDE_DIR}
  ${SQLITE3_INCLUDE_DIR}
)

# required link directories
set(OPENSLIDE_DEP_LIBS
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
)
target_include_directories(${PROJECT_NAME} PUBLIC ${OPENSLIDE_INCLUDES})
target_link_libraries(${PROJECT_NAME} ${OPENSLIDE_DEP_LIBS})

# link valgrind only if asked to
if(USE_VALGRIND)
  find_package(VALGRIND REQUIRED)
  target_link_libraries(${PROJECT_NAME} VALGRIND)
endif()


# TODO check if we need this definition before passing it
# openjpeg flag for >=2.1
add_compile_definitions(HAVE_OPENJPEG2)

# TODO check what os as to set FOPEN_CLOEXEC_FLAG
add_compile_definitions(FOPEN_CLOEXEC_FLAG)


set(TARGETS_EXPORT_NAME "${PROJECT_NAME}-targets")

install(TARGETS openslide
    EXPORT ${TARGETS_EXPORT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
