# handle slice building so the projects that need it can call it
# Types:
# slice2_bin - name_of_slice2_bin (compiled bin)
# slice_path - root/slice
# slice_dir - name of folder (i.e. "Ice")
# slice_target - lib or exe this compile depends on
# output_dir - where compiled files will be output to
function(CompileSlices slice2_bin slice_path ice_file slice_outputs)
   if(CMAKE_BUILD_TYPE EQUAL DEBUG)
      set(output_dir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG})
   elseif(CMAKE_BUILD_TYPE EQUAL RELEASE)
      set(output_dir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE})
   endif()
   add_custom_command(OUTPUT ${slice_outputs}
      COMMAND ${slice2_bin} -I${slice_path} ${ice_file}
      WORKING_DIRECTORY ${output_dir}
      #PRE_BUILD
      DEPENDS ${ice_file} ${slice2_bin}
   )
endfunction()
