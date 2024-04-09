include(CheckCXXCompilerFlag)

macro(check_and_add_flag)
    set(target ${ARGV0})
    set(flag ${ARGV1})

    check_cxx_compiler_flag(${flag} HAS_${flag})
    if (HAS_${flag})
        target_compile_options(${target} INTERFACE $<BUILD_INTERFACE:${flag}>)
    endif()
endmacro()

add_library(KokkosCommFlags INTERFACE)

check_and_add_flag(KokkosCommFlags -Wall)
check_and_add_flag(KokkosCommFlags -Wextra)
check_and_add_flag(KokkosCommFlags -Wshadow)
check_and_add_flag(KokkosCommFlags -Wpedantic)
check_and_add_flag(KokkosCommFlags -pedantic)
check_and_add_flag(KokkosCommFlags -Wcast-align)
check_and_add_flag(KokkosCommFlags -Wformat=2)
check_and_add_flag(KokkosCommFlags -Wmissing-include-dirs)
check_and_add_flag(KokkosCommFlags -Wno-gnu-zero-variadic-macro-arguments)

# mdspan-related definitions
if (KOKKOSCOMM_ENABLE_MDSPAN)
    target_compile_definitions(KokkosCommFlags KOKKOSCOMM_ENABLE_MDSPAN)
    if (KOKKOSCOMM_USE_STD_MDSPAN)
        target_compile_definitions(KokkosCommFlags KOKKOSCOMM_USE_STD_MDSPAN)
    elseif (KOKKOSCOMM_USE_KOKKOS_MDSPAN)
        target_compile_definitions(KokkosCommFlags KOKKOSCOMM_USE_KOKKOS_MDSPAN)
        target_compile_definitions(KokkosCommFlags KOKKOSCOMM_MDSPAN_IN_EXPERIMENTAL)
    endif ()
endif ()

# choose cxx standard
set_target_properties(KokkosCommFlags PROPERTIES CXX_EXTENSIONS OFF)
if (KOKKOSCOMM_ENABLE_MDSPAN AND KOKKOSCOMM_USE_STD_MDSPAN)
    target_compile_features(KokkosCommFlags INTERFACE cxx_std_23)
else ()
    target_compile_features(KokkosCommFlags INTERFACE cxx_std_20)
endif ()

add_library(KokkosComm::KokkosCommFlags ALIAS KokkosCommFlags)
