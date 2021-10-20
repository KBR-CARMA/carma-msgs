# Copyright 2021 Leidos Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

macro(carma_define_ament_executable executable_name_arg deps_arg cpp_files_arg)
  
  add_library(${executable_name_arg}
    ${cpp_files_arg}
  )

  # Define include directories
  target_include_directories(${executable_name_arg}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  )

  # Seperate external packages from internal targets
  set(external_deps ) # Deps outside our package
  set(internal_deps ) # Deps inside our package
  foreach(dep_name ${deps_arg})

    if( "${${dep_name}_FOUND}" ) # If this is a package that was found with find_package(package_name) This flag will be set
      # For packages we want to use ament_target_dependencies
      
      set(external_deps ${external_deps} ${dep_name})
      
    else() # If this dependencie was not found with find_package we will assume it is an internal target

      set(internal_deps ${internal_deps} ${dep_name})

    endif()
  endforeach()

  # Add deps
  target_link_libraries(${library_name_arg} ${internal_deps})
  ament_target_dependencies(${executable_name_arg} ${external_deps})

  # No need to export here as is the case with libraries because executables do not get linked against

  # Install
  install(
    DIRECTORY include/
    DESTINATION include
  )

  install(
    TARGETS ${executable_name_arg}
    EXPORT ${executable_name_arg}
    LIBRARY DESTINATION lib/${PROJECT_NAME} # In Ament, Executables are installed to lib/${PROJECT_NAME} not bin 
    ARCHIVE DESTINATION lib/${PROJECT_NAME}
    RUNTIME DESTINATION lib/${PROJECT_NAME}
    INCLUDES DESTINATION include
  )


endmacro()