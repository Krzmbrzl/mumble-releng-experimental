include(vcpkg_common_functions)

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO zeroc-ice/ice
	REF v3.7.3
	# TODO - update sha512 signature
	SHA512 ef43bb28b4a20dcca5078ca2b0ad81269a435317761fc00b4d4bdf85bcdf4dddbf3b3ee6729477bd0957ea519a3705416883ba404386a05914a2c010cb785e27
	HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/cpp DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

# cpp11 mapping for static win32 builds is currently broken, build as cpp98

# if(WIN32 AND VCPKG_LIBRARY_LINKAGE STREQUAL static)
#     vcpkg_configure_cmake(
#         SOURCE_PATH ${SOURCE_PATH}
#         OPTIONS
#             -DCMAKE_CXX_STANDARD=98
#     )

# else()
#     vcpkg_configure_cmake(
#         SOURCE_PATH ${SOURCE_PATH}
#         OPTIONS
#             -DCMAKE_CXX_STANDARD=11
#     )
# endif()
if(WIN32)
	vcpkg_check_linkage(ONLY_DYNAMIC_CRT)
endif()

vcpkg_configure_cmake(
	SOURCE_PATH ${SOURCE_PATH}
	PREFER_NINJA
	OPTIONS
		-DCMAKE_CXX_STANDARD=98
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/cpp/include DESTINATION ${CURRENT_PACKAGES_DIR})
file(INSTALL ${SOURCE_PATH}/slice DESTINATION ${CURRENT_PACKAGES_DIR})

file(INSTALL ${CURRENT_PACKAGES_DIR}/bin/ DESTINATION ${CURRENT_PACKAGES_DIR}/tools/ice)

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/ice)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
	file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
  
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/zeroc-ice RENAME copyright)
file(INSTALL ${SOURCE_PATH}/ICE_LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/zeroc-ice)