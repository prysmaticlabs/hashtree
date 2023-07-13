#[=======================================================================[.rst:
FindHashtree
-----------

Find the Hashtree library

IMPORTED targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` target:

``Hashtree::Hashtree``

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables if found:

``Hashtree_INCLUDE_DIRS``
  where to find hashtree.h
``Hashtree_LIBRARIES``
  the libraries to link against to use Hashtree.
``Hashtree_FOUND``
  TRUE if found

#]=======================================================================]

# Look for the necessary header
find_path(Hashtree_INCLUDE_DIR NAMES hashtree.h)
mark_as_advanced(Hashtree_INCLUDE_DIR)

# Look for the necessary library
find_library(Hashtree_LIBRARY NAMES hashtree)
mark_as_advanced(Hashtree_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Hashtree
	REQUIRED_VARS Hashtree_INCLUDE_DIR Hashtree_LIBRARY
)

# Create the imported target
if(Hashtree_FOUND)
    set(Hashtree_INCLUDE_DIRS ${Hashtree_INCLUDE_DIR})
    set(Hashtree_LIBRARIES ${Hashtree_LIBRARY})
    if(NOT TARGET Hashtree::Hashtree)
        add_library(Hashtree::Hashtree UNKNOWN IMPORTED)
        set_target_properties(Hashtree::Hashtree PROPERTIES
            IMPORTED_LOCATION             "${Hashtree_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${Hashtree_INCLUDE_DIR}")
    endif()
endif()
