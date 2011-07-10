FUNCTION(FIND_OPENCL)

SET (OPENCL_VERSION_STRING "0.1.0")
SET (OPENCL_VERSION_MAJOR 0)
SET (OPENCL_VERSION_MINOR 1)
SET (OPENCL_VERSION_PATCH 0)

SET	(OPENCL_FOUND 0)

IF (APPLE)

  FIND_LIBRARY(OPENCL_LIBRARIES OpenCL DOC "OpenCL lib for OSX")
  FIND_PATH(OPENCL_INCLUDE_DIRS OpenCL/cl.h DOC "Include for OpenCL on OSX")
  FIND_PATH(_OPENCL_CPP_INCLUDE_DIRS OpenCL/cl.hpp DOC "Include for OpenCL CPP bindings on OSX")
  SET(OPENCL_FOUND 1)

ELSE (APPLE)

	IF (WIN32)
	
	    FIND_PATH(OPENCL_INCLUDE_DIRS CL/cl.h)
	    FIND_PATH(_OPENCL_CPP_INCLUDE_DIRS CL/cl.hpp)
	    SET(OPENCL_FOUND 1)
	
	    # Finding NVIDIA OCL SDK libs for x86 and x86_64
	    IF( ${CMAKE_SYSTEM_PROCESSOR} STREQUAL "AMD64" )
	    	SET(OPENCL_LIB_DIR "$ENV{CUDA_PATH}/lib/x64")
	    
	    ELSE (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "AMD64")
	    	SET(OPENCL_LIB_DIR "$ENV{CUDA_PATH}/lib/Win32")
	    
	    ENDIF( ${CMAKE_SYSTEM_PROCESSOR} STREQUAL "AMD64" )
	    
	    FIND_LIBRARY(OPENCL_LIBRARIES OpenCL.lib ${OPENCL_LIB_DIR})
	    
	    GET_FILENAME_COMPONENT(_OPENCL_INC_CAND ${OPENCL_LIB_DIR}/../../include ABSOLUTE)
	    
	    FIND_PATH(OPENCL_INCLUDE_DIRS CL/cl.h PATHS "${_OPENCL_INC_CAND}")
	    FIND_PATH(_OPENCL_CPP_INCLUDE_DIRS CL/cl.hpp PATHS "${_OPENCL_INC_CAND}")

	ENDIF (WIN32)

ENDIF (APPLE)

FIND_PACKAGE_HANDLE_STANDARD_ARGS( OpenCL DEFAULT_MSG OPENCL_LIBRARIES OPENCL_INCLUDE_DIRS )

#OpenCL comes with cl.hpp (C++ bindings) and cl.h (C), add cl.hpp to the include dir list
IF( _OPENCL_CPP_INCLUDE_DIRS )
	SET( OPENCL_HAS_CPP_BINDINGS TRUE )
	LIST( APPEND OPENCL_INCLUDE_DIRS ${_OPENCL_CPP_INCLUDE_DIRS} )
	LIST( REMOVE_DUPLICATES OPENCL_INCLUDE_DIRS )
ENDIF( _OPENCL_CPP_INCLUDE_DIRS )

MARK_AS_ADVANCED(
  OPENCL_INCLUDE_DIRS
)

endfunction()

