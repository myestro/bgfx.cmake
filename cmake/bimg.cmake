# bgfx.cmake - bgfx building in cmake
# Written in 2017 by Joshua Brookover <joshua.al.brookover@gmail.com>

# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.

# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# Third party libs
include("${BGFX_ROOT}cmake/3rdparty/edtaa3.cmake")
include("${BGFX_ROOT}cmake/3rdparty/etc1.cmake")
include("${BGFX_ROOT}cmake/3rdparty/etc2.cmake")
include("${BGFX_ROOT}cmake/3rdparty/iqa.cmake")
include("${BGFX_ROOT}cmake/3rdparty/libsquish.cmake")
include("${BGFX_ROOT}cmake/3rdparty/nvtt.cmake")
include("${BGFX_ROOT}cmake/3rdparty/pvrtc.cmake")

# Ensure the directory exists
if( NOT IS_DIRECTORY ${BIMG_DIR} )
	message( SEND_ERROR "Could not load bimg, directory does not exist. ${BIMG_DIR}" )
	return()
endif()

# Grab the bimg source files
file( GLOB BIMG_SOURCES ${BIMG_DIR}/src/*.cpp )

source_group("bgfx/bimg" FILES ${BIMG_SOURCES})

if (NOT BGFX_BUILTIN)
    # Create the bimg target
    add_library( bimg STATIC ${BIMG_SOURCES} )

    # Add include directory of bimg
    target_include_directories( bimg PUBLIC ${BIMG_DIR}/include )

    # bimg dependencies
    target_link_libraries( bimg bx edtaa3 etc1 etc2 iqa squish nvtt pvrtc )

    # Put in a "bgfx" folder in Visual Studio
    set_target_properties( bimg PROPERTIES FOLDER "bgfx" )

	# Export debug build as "bimgd"
	set_target_properties( bimg PROPERTIES OUTPUT_NAME_DEBUG "bimgd" )
else()
    set(BIMG_SOURCES ${BGFX_BUILTIN_SOURCES}
        ${SQUISH_SOURCES}
        ${NVTT_SOURCES}
        ${PVRTC_SOURCES}
        ${EDTAA3_SOURCES}
        ${ETC1_SOURCES}
        ${ETC2_SOURCES}
		${IQA_SOURCES}
        ${BIMG_SOURCES}
    )
    set(BGFX_INCLUDE_DIRS ${BGFX_INCLUDE_DIRS} ${BIMG_DIR}/include ${BIMG_DIR}/3rdparty )
endif()