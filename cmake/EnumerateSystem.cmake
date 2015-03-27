if(UNIX)
  if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(SPECIFIC_SYSTEM_VERSION_NAME "${CMAKE_SYSTEM_NAME}")
    if(EXISTS "/etc/issue")
      set(LINUX_NAME "")
      file(READ "/etc/issue" LINUX_ISSUE)
      # Fedora case
      if(LINUX_ISSUE MATCHES "Fedora")
        string(REGEX MATCH "release ([0-9]+)" FEDORA "${LINUX_ISSUE}")
        set(LINUX_NAME "Fedora")
        set(LINUX_VER "${CMAKE_MATCH_1}")
        set(RPM_SYSTEM_NAME "fc${CMAKE_MATCH_1}")
      endif(LINUX_ISSUE MATCHES "Fedora")
      # Scientific Linux case
      if(LINUX_ISSUE MATCHES "Scientific Linux")
        string(REGEX MATCH "release ([0-9]+\\.[0-9]+)" CENTOS "${LINUX_ISSUE}")
        set(LINUX_NAME "ScientificLinux")        
        set(LINUX_VER "${CMAKE_MATCH_1}")
        set(RPM_SYSTEM_NAME "rhel${CMAKE_MATCH_1}")
      endif(LINUX_ISSUE MATCHES "Scientific Linux")
      # CentOS case
      if(LINUX_ISSUE MATCHES "CentOS")
        string(REGEX MATCH "release ([0-9]+\\.[0-9]+)" CENTOS "${LINUX_ISSUE}")
        set(LINUX_NAME "CentOS")        
        set(LINUX_VER "${CMAKE_MATCH_1}")
        set(RPM_SYSTEM_NAME "rhel${CMAKE_MATCH_1}")
      endif(LINUX_ISSUE MATCHES "CentOS")
      # Redhat case
      if(LINUX_ISSUE MATCHES "Red Hat")
        string(REGEX MATCH "release ([0-9]+\\.[0-9]+)" REDHAT "${LINUX_ISSUE}")
        set(LINUX_NAME "Redhat")        
        set(LINUX_VER "${CMAKE_MATCH_1}")
        set(RPM_SYSTEM_NAME "rhel${CMAKE_MATCH_1}")
      endif(LINUX_ISSUE MATCHES "Red Hat")
      # Ubuntu case
      if(LINUX_ISSUE MATCHES "Ubuntu")
        string(REGEX MATCH "buntu ([0-9]+\\.[0-9]+)" UBUNTU "${LINUX_ISSUE}")
        set(LINUX_NAME "Ubuntu")        
        set(LINUX_VER "${CMAKE_MATCH_1}")     
      endif(LINUX_ISSUE MATCHES "Ubuntu")   
      # Debian case
      if(LINUX_ISSUE MATCHES "Debian")
        string(REGEX MATCH "Debian .*ux ([0-9]+\\.[0-9]+)" DEBIAN "${LINUX_ISSUE}")
        set(LINUX_NAME "Debian")
        set(LINUX_VER "${CMAKE_MATCH_1}")        
      endif(LINUX_ISSUE MATCHES "Debian")      
      # Open SuSE case
      if(LINUX_ISSUE MATCHES "SUSE")
        string(REGEX MATCH "SUSE  ([0-9]+\\.[0-9]+)" SUSE "${LINUX_ISSUE}")
        set(LINUX_NAME "openSUSE")        
        set(LINUX_VER "${CMAKE_MATCH_1}")
        if (LINUX_VER MATCHES "/")        
          string(REPLACE "/" "_" LINUX_VER ${LINUX_VER})        
        endif()
      endif(LINUX_ISSUE MATCHES "SUSE")
      # Mandriva case
      # TODO      

      #Find CPU Arch
      if (${CMAKE_SYSTEM_PROCESSOR} MATCHES "64")
        set ( BIT_MODE "64")
      else()
        set ( BIT_MODE "32")
      endif ()

      #Find CPU Arch for Debian system 
      if ((LINUX_NAME STREQUAL "Debian") OR (LINUX_NAME STREQUAL "Ubuntu"))

        # There is no such thing as i686 architecture on debian, you should use i386 instead
        # $ dpkg --print-architecture
        FIND_PROGRAM(DPKG_CMD dpkg)
        IF(NOT DPKG_CMD)
          # Cannot find dpkg in your path, default to i386
          # Try best guess
          if (BIT_MODE STREQUAL "32")
            SET(CPACK_DEBIAN_PACKAGE_ARCHITECTURE i386)
          elseif (BIT_MODE STREQUAL "64")
            SET(CPACK_DEBIAN_PACKAGE_ARCHITECTURE amd64)
          endif()
        ENDIF(NOT DPKG_CMD)
        EXECUTE_PROCESS(COMMAND "${DPKG_CMD}" --print-architecture
          OUTPUT_VARIABLE CPACK_DEBIAN_PACKAGE_ARCHITECTURE
          OUTPUT_STRIP_TRAILING_WHITESPACE
          )
      endif ()

      if(LINUX_NAME) 
        set(SPECIFIC_SYSTEM_VERSION_NAME "${CMAKE_SYSTEM_NAME}-${LINUX_NAME}-${LINUX_VER}")
      else()
        set(LINUX_NAME "NOT-FOUND")
      endif(LINUX_NAME)

    endif(EXISTS "/etc/issue")      
  endif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set(SPECIFIC_SYSTEM_VERSION_NAME "${SPECIFIC_SYSTEM_VERSION_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
  set(SPECIFIC_COMPILER_NAME "")
endif(UNIX)
