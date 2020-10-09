# Parallelism
find_package( OpenMP  REQUIRED )
if( GAUXC_ENABLE_MPI )
  find_package( MPI REQUIRED )
endif()

# Required Dependencies
include( gauxc-integratorxx )
include( gauxc-exchcxx      )
include( gauxc-cereal       )
include( gauxc-eigen3       )


add_library( gauxc STATIC 
  grid.cxx 
  grid_impl.cxx 
  molmeta.cxx 
  molgrid.cxx 
  molgrid_impl.cxx 
  molgrid_defaults.cxx 
  atomic_radii.cxx 
  load_balancer_impl.cxx 
  load_balancer.cxx 
  replicated_load_balancer.cxx 
)

target_include_directories( gauxc
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
)

target_compile_options( gauxc
  PRIVATE
    $<$<COMPILE_LANGUAGE:CXX>: -Wall -Wextra -Wpedantic -Wnon-virtual-dtor>
)



configure_file( 
  ${PROJECT_SOURCE_DIR}/include/gauxc/gauxc_config.hpp.in
  ${PROJECT_BINARY_DIR}/include/gauxc/gauxc_config.hpp
)

target_link_libraries( gauxc PUBLIC 
  ExchCXX::exchcxx 
  IntegratorXX::integratorxx 
  OpenMP::OpenMP_CXX
  Eigen3::Eigen 
)

if( GAUXC_ENABLE_MPI )
  target_link_libraries( gauxc PUBLIC MPI::MPI_C )
endif()

if( GAUXC_ENABLE_CEREAL )
  target_link_libraries( gauxc PUBLIC cereal )
endif()

add_subdirectory( integrator )

include( GNUInstallDirs )
set( INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/ExchCXX )

# Targets
install(TARGETS gauxc gauxc_gau2grid
    EXPORT gauxc-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )

set_target_properties( gauxc PROPERTIES EXPORT_NAME ExchCXX )

# Install Headers
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} FILES_MATCHING PATTERN "*.hpp" )
install(DIRECTORY ${PROJECT_BINARY_DIR}/include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} FILES_MATCHING PATTERN "*.hpp" )

# Export target to script
install(EXPORT gauxc-targets
    FILE
    GauXCTargets.cmake
    NAMESPACE
    GauXC::
    DESTINATION
    ${INSTALL_CONFIGDIR}
    )

# Export build-tree targets (to be usable by e.g. FetchContent)
export(EXPORT gauxc-targets
    NAMESPACE GauXC::
    FILE "${PROJECT_BINARY_DIR}/GauXCTargets.cmake")
