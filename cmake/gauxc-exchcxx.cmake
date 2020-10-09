find_package( ExchCXX QUIET )
if( NOT ${ExchCXX_FOUND} )

  set( EXCHCXX_ENABLE_CUDA  ${GAUXC_ENABLE_CUDA} CACHE BOOL "" )
  set( EXCHCXX_ENABLE_TESTS OFF                  CACHE BOOL "" )

  FetchContent_Declare(
    exchcxx
    GIT_REPOSITORY 
      https://github.com/evaleev/ExchCXX.git
    GIT_TAG 
      master
  )

  FetchContent_MakeAvailable( exchcxx )

  # disable unity builds for libxc
  if (CMAKE_UNITY_BUILD)
    set_target_properties(exchcxx PROPERTIES UNITY_BUILD OFF)
    message(STATUS "Will disable unity-build for target exchcxx")
  endif()

else()

  if( ${GAUXC_ENABLE_CUDA} AND NOT ${EXCHCXX_ENABLE_CUDA} )
    message( FATAL_ERROR "GauXC CUDA BINDINGS REQUIRE ExchCXX CUDA Bindings" )
  endif()

endif()


