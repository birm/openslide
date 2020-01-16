# working from configurefile at https://github.com/birm/${PROJECT_NAME}/blob/cmake/configure.ac
cmake_minimum_required(VERSION 3.5)
project(openslide VERSION 3.4.1 LANGUAGES C)
add_library(${PROJECT_NAME} "")

target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/src/ ${CMAKE_SOURCE_DIR}/common/)

file(GLOB openslide_SRC "${CMAKE_SOURCE_DIR}/src/*.c" )

target_sources(${PROJECT_NAME} PRIVATE ${openslide_SRC})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMake")

option(USE_VALGRIND "If available, use valgrind for profiling." OFF)

## TODO -- these version requirement numbers may be too strict/wrong depending on project

# get requirements
find_package(ZLIB REQUIRED)
find_package(JPEG REQUIRED)
find_package(OPENJPEG REQUIRED)
find_package(TIFF REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_search_module(GLIB REQUIRED glib-2.0)
find_package(Cairo 1.2.0 REQUIRED)
find_package(PNG REQUIRED)
#find_package(GDKPIXBUF 1.6.0 REQUIRED)
find_package(LIBXML2 REQUIRED)
find_package(SQLITE3 3.6.20 REQUIRED)

#includes
target_include_directories(${PROJECT_NAME}
  PUBLIC
  ${ZLIB_INCLUDE_DIRS}
  ${JPEG_INCLUDE_DIRS}
  ${TIFF_INCLUDE_DIRS}
  ${OPENJPEG_INCLUDE_DIRS}
  ${GLIB_INCLUDE_DIRS}
  ${CAIRO_INCLUDE_DIRS}
  ${PNG_INCLUDE_DIRS}
  ${GDKPIXBUF_INCLUDE_DIRS}
  ${LIBXML2_INCLUDE_DIRS}
  ${SQLITE3_INCLUDE_DIRS}
)

# link requirements
target_link_libraries(${PROJECT_NAME}
  PUBLIC
    ${ZLIB_LIBRARIES}
    ${JPEG_LIBRARIES}
    ${TIFF_LIBRARIES}
    ${OPENJPEG_LIBRARIES}
    ${GLIB_LDFLAGS}
    ${Cairo_LIBRARIES}
    ${PNG_LIBRARIES}
    ${GDKPIXBUF_LIBRARIES}
    ${LIBXML2_LIBRARIES}
    ${SQLITE3_LIBRARIES}
)

# link valgrind only if asked to
if(USE_VALGRIND)
  find_package(VALGRIND REQUIRED)
  target_link_libraries(${PROJECT_NAME} INTERFACE VALGRIND)
endif()

install(TARGETS openslide
    EXPORT openslide-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)


# tools
add_executable(openslide-show-properties "")
target_sources(openslide-show-properties PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/tools/openslide-show-properties.c)
target_link_libraries(openslide-show-properties ${PROJECT_NAME})

add_executable(openslide-write-png "")
target_sources(openslide-write-png PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/tools/openslide-write-png.c)
target_link_libraries(openslide-write-png ${PROJECT_NAME})


add_executable(openslide-quickhash1sum "")
target_sources(openslide-quickhash1sum PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/tools/openslide-quickhash1sum.c)
target_link_libraries(openslide-quickhash1sum ${PROJECT_NAME})

set(TARGETS_EXPORT_NAME openslide-targets)

install(TARGETS openslide
    EXPORT openslide-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
