IF(MSVC)
	ADD_DEFINITIONS(-DUNICODE -D_UNICODE)

	SET(CMAKE_CXX_FLAGS "/DWIN32 /D_WINDOWS /W4 /WX /GR /EHsc /wd4503")
	SET(CMAKE_EXE_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_SHARED_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_MODULE_LINKER_FLAGS "/WX /pdbcompress")

	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "/DEBUG")
	SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "/DEBUG")
	SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "/DEBUG")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "/DEBUG")

	IF(KLAYGE_WITH_WINRT)
		SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")
		SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")
	ELSE()
		SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /INCREMENTAL")
		SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL")
		SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /INCREMENTAL")
		SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL")
	ENDIF()

	SET(KLAYGE_COMPILER_NAME "vc")
	IF(MSVC_VERSION GREATER 1700)
		SET(KLAYGE_COMPILER_VERSION "12")
	ELSEIF(MSVC_VERSION GREATER 1600)
		SET(KLAYGE_COMPILER_VERSION "11")
	ELSEIF(MSVC_VERSION GREATER 1500)
		SET(KLAYGE_COMPILER_VERSION "10")
	ELSEIF(MSVC_VERSION GREATER 1400)
		SET(KLAYGE_COMPILER_VERSION "9")
	ENDIF()

	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /fp:fast")
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /fp:fast")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /fp:fast")
	
	IF(NOT KLAYGE_WITH_WINRT)
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /GS-")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /GS-")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /GS-")
	ENDIF()

	IF(KLAYGE_ARCH_NAME MATCHES "x86")
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /arch:SSE")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /arch:SSE")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /arch:SSE")
		
		IF(MSVC_VERSION GREATER 1500)
			SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /LARGEADDRESSAWARE")
			SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
		ENDIF()
	ENDIF()

	IF(MSVC_VERSION GREATER 1500)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
	ENDIF()
	IF(MSVC_VERSION GREATER 1600)
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Qpar")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /Qpar")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /Qpar")
	ENDIF()
	
	SET(CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS})
		
	# create vcproj.user file for Visual Studio to set debug working directory
	FUNCTION(CREATE_VCPROJ_USERFILE TARGETNAME)
		IF(MSVC)
			SET(SYSTEM_NAME $ENV{USERDOMAIN})
			SET(USER_NAME $ENV{USERNAME})

			IF(MSVC_VERSION GREATER 1500)
				CONFIGURE_FILE(
					${KLAYGE_ROOT_DIR}/cmake/VisualStudio2010UserFile.vcxproj.user.in
					${CMAKE_CURRENT_BINARY_DIR}/${TARGETNAME}.vcxproj.user
					@ONLY
				)
			ELSEIF(MSVC_VERSION GREATER 1400)
				CONFIGURE_FILE(
					${KLAYGE_ROOT_DIR}/cmake/VisualStudio2008UserFile.vcproj.user.in
					${CMAKE_CURRENT_BINARY_DIR}/${TARGETNAME}.vcproj.${SYSTEM_NAME}.${USER_NAME}.user
					@ONLY
				)
			ELSEIF(MSVC_VERSION GREATER 1300)
				CONFIGURE_FILE(
					${KLAYGE_ROOT_DIR}/cmake/VisualStudio2005UserFile.vcproj.user.in
					${CMAKE_CURRENT_BINARY_DIR}/${TARGETNAME}.vcproj.${SYSTEM_NAME}.${USER_NAME}.user
					@ONLY
				)
			ENDIF()
		ENDIF()
	ENDFUNCTION()
ELSE()
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -W -Wall -Wno-unused -march=core2 -std=c11")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W -Wall -Wno-unused -march=core2 -std=c++11")
	SET(CMAKE_CXX_FLAGS_DEBUG "-DDEBUG -g -O0" )
	SET(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG -O2" )
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG -g -O2")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL "-DNDEBUG -Os")
	IF(KLAYGE_ARCH_NAME MATCHES "x86")
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")
		SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m32")
		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
		IF(WIN32)
			SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--large-address-aware")
			SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--large-address-aware")
			SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--large-address-aware")

			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=pe-i386")
		ELSE()
			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=elf32-i386")
		ENDIF()
	ELSEIF(KLAYGE_ARCH_NAME MATCHES "x64")
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m64")
		SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m64")
		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m64")
		IF(WIN32)
			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=pe-x86-64")
		ELSE()
			SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=elf64-x86-64")
		ENDIF()
	ENDIF()
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-s")
	SET(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "-s")
	SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE "-s")
	SET(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL "-s")
	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "-s")
	SET(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "-s")

	IF(MINGW)
		SET(KLAYGE_COMPILER_NAME "mgw")
		ADD_DEFINITIONS(-D_WIN32_WINNT=0x0501)
	ELSE()
		SET(KLAYGE_COMPILER_NAME "gcc")
	ENDIF()
	
	EXECUTE_PROCESS(COMMAND gcc -dumpversion OUTPUT_VARIABLE GCC_VERSION)
	STRING(REPLACE "." "" KLAYGE_COMPILER_VERSION ${GCC_VERSION})
ENDIF()

SET(CMAKE_C_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
SET(CMAKE_C_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
SET(CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
SET(CMAKE_C_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL})

SET(BOOST_ROOT "${KLAYGE_ROOT_DIR}/External/boost")
SET(BOOST_LIBRARYDIR "${BOOST_ROOT}/lib/${KLAYGE_PLATFORM_NAME}/lib")
SET(BOOST_COMPONENTS "")
IF(MSVC)
	IF(NOT KLAYGE_WITH_WINRT)
		IF(KLAYGE_COMPILER_VERSION STREQUAL "12")
			SET(BOOST_COMPONENTS ${BOOST_COMPONENTS} program_options)
		ELSEIF(KLAYGE_COMPILER_VERSION STREQUAL "11")
			SET(BOOST_COMPONENTS ${BOOST_COMPONENTS} program_options)
		ELSEIF(KLAYGE_COMPILER_VERSION STREQUAL "10")
			SET(BOOST_COMPONENTS ${BOOST_COMPONENTS} atomic chrono date_time filesystem program_options system thread)
		ELSEIF(KLAYGE_COMPILER_VERSION STREQUAL "9")
			SET(BOOST_COMPONENTS ${BOOST_COMPONENTS} atomic chrono date_time filesystem program_options regex system thread)
		ENDIF()
	ENDIF()
ELSE()
	SET(BOOST_COMPONENTS ${BOOST_COMPONENTS} chrono filesystem program_options system thread)
ENDIF()
FIND_PACKAGE(Boost COMPONENTS ${BOOST_COMPONENTS})

IF(NOT Boost_LIBRARY_DIR)
	SET(Boost_LIBRARY_DIR ${Boost_LIBRARY_DIRS})
ENDIF()
