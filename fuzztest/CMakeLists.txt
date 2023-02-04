set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR})

# logging
add_library(logging STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/logging.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/logging.h")

target_include_directories(logging PUBLIC ${PROJECT_ROOT_DIR})
target_link_libraries(logging PRIVATE compilation_flags)
target_link_libraries(logging PUBLIC absl::strings)

# absl_domain
add_library(absl_domain INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/internal/absl_domain.h")
target_link_libraries(absl_domain INTERFACE logging absl::time compilation_flags)

# meta
add_library(meta INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/internal/meta.h")
target_link_libraries(absl_domain INTERFACE absl::int128 compilation_flags)

# any
add_library(any INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/internal/any.h")
target_link_libraries(any INTERFACE logging meta compilation_flags)

# table_of_recent_compares
add_library(table_of_recent_compares INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/internal/table_of_recent_compares.h")
target_link_directories(table_of_recent_compares INTERFACE absl::flat_hash_set absl::bit_gen_ref absl::distributions compilation_flags)

# coverage
add_library(coverage STATIC "${CMAKE_CURRENT_SOURCE_DIR}/internal/coverage.cc" "${CMAKE_CURRENT_SOURCE_DIR}/internal/coverage.h")
target_link_libraries(coverage PUBLIC absl::span table_of_recent_compares)
target_link_libraries(coverage PRIVATE logging absl::core_headers compilation_flags)

# io
add_library(io STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/io.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/io.h")
target_link_libraries(io PRIVATE logging absl::hash absl::str_format compilation_flags)

# regexp
add_library(regexp STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/regexp.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/regexp.h")
target_link_libraries(regexp PUBLIC logging absl::random_bit_gen_ref absl::random_distributions re2::re2 absl::flat_hash_map)
target_link_libraries(regexp PRIVATE compilation_flags)

#seed_seq
add_library(seed_seq STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/seed_seq.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/seed_seq.h")
target_include_directories(seed_seq PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(seed_seq PRIVATE logging absl::random_random compilation_flags)
target_link_libraries(seed_seq PUBLIC absl::strings absl::span)

#serialization
add_library(serialization STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/serialization.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/serialization.h")
target_include_directories(serialization PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(serialization PRIVATE absl::strings compilation_flags)
target_link_libraries(serialization PUBLIC meta absl::span absl::int128)

#subprocess
add_library(subprocess STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/subprocess.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/subprocess.h")
target_include_directories(subprocess PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(subprocess PRIVATE logging absl::flat_hash_map compilation_flags)
target_link_libraries(subprocess PUBLIC absl::strings absl::time)

# type support
add_library(type_support STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/type_support.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/type_support.h")
target_link_libraries(type_support PRIVATE compilation_flags)
target_link_libraries(type_support PUBLIC absl_domain meta absl::strings absl::str_format absl::time absl::symbolize)

#domain
add_library(domain STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/grammar.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/domain.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/domain.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/grammar.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/protobuf_domain.h")
target_include_directories(domain PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(domain PRIVATE logging absl::flat_hash_map compilation_flags)
target_link_libraries(domain PUBLIC
    absl_domain
    any
    coverage
    logging
    meta
    regexp
    serialization
    table_of_recent_compares
    type_support
    absl::time
    absl::flat_hash_map
    absl::random_random
    absl::bits
    absl::int128
    absl::span
    absl::strings
    # probably more will be needed!
)

#registration
add_library(registration INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/internal/registration.h")
target_include_directories(registration INTERFACE
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(registration INTERFACE domain meta type_support absl::strings absl::span compilation_flags)

#fixture_driver
add_library(fixture_driver STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/fixture_driver.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/fixture_driver.h")
target_include_directories(fixture_driver PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(fixture_driver PRIVATE compilation_flags)
target_link_libraries(fixture_driver PUBLIC logging registration type_support )


#compatibility_mode
add_library(compatibility_mode STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/compatibility_mode.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/compatibility_mode.h")
target_include_directories(compatibility_mode PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(compatibility_mode PRIVATE compilation_flags)
target_link_libraries(compatibility_mode PUBLIC logging runtime fixture_driver)


#runtime
add_library(runtime STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/runtime.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/runtime.h")
target_include_directories(runtime PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(runtime PRIVATE compilation_flags)
target_link_libraries(runtime PUBLIC coverage domain fixture_driver io logging meta registration seed_seq serialization type_support)

#registry
add_library(registry STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/registry.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/internal/registry.h")
target_include_directories(registry PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(registry PRIVATE compilation_flags)
target_link_libraries(registry PUBLIC compatibility_mode fixture_driver registration runtime absl::flat_hash_map)

#fuzztest
add_library(fuzztest STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/fuzztest.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/fuzztest.h")
target_include_directories(fuzztest PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(fuzztest PRIVATE compilation_flags)
target_link_libraries(fuzztest PUBLIC domain registry absl::strings)

#googletest_adaptor
add_library(googletest_adaptor INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/googletest_adaptor.h")
target_include_directories(googletest_adaptor INTERFACE
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(googletest_adaptor INTERFACE registry runtime compilation_flags)

#googletest_fixture_adapter
add_library(googletest_fixture_adapter INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/googletest_fixture_adapter.h")
target_include_directories(googletest_fixture_adapter INTERFACE
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(googletest_fixture_adapter INTERFACE fixture_driver compilation_flags)

#fuzztest_gtest_main
add_library(fuzztest_gtest_main STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/fuzztest_gtest_main.cc")
target_include_directories(fuzztest_gtest_main PUBLIC
    $<BUILD_INTERFACE:${PROJECT_ROOT_DIR}>)
target_link_libraries(fuzztest_gtest_main PRIVATE compilation_flags)
target_link_libraries(fuzztest_gtest_main PUBLIC fuzztest googletest_adaptor runtime absl::time)

#UTs
add_executable(any_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/any_test.cc")
target_link_libraries(any_test PRIVATE any absl::strings gtest gtest_main compilation_flags)

add_executable(table_of_recent_compares_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/table_of_recent_compares_test.cc")
target_link_libraries(table_of_recent_compares_test PRIVATE
    domain table_of_recent_compares absl::random_random gtest gtest_main compilation_flags)

add_executable(fixture_driver_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/fixture_driver_test.cc")
target_link_libraries(fixture_driver_test PRIVATE
    domain fixture_driver registration type_support absl::span gtest gtest_main compilation_flags)

add_executable(io_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/io_test.cc")
target_link_libraries(io_test PRIVATE
    # figure out why you need here gmock in the first place
    io fuzztest absl::strings gtest gtest_main gmock compilation_flags)

add_executable(seed_seq_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/seed_seq_test.cc")
target_link_libraries(seed_seq_test PRIVATE
    seed_seq absl::strings absl::span gtest gtest_main compilation_flags)

add_executable(subprocess_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/subprocess_test.cc")
target_link_libraries(subprocess_test PRIVATE
    subprocess gtest gtest_main compilation_flags)

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS "${CMAKE_CURRENT_SOURCE_DIR}/internal/test_protobuf.proto")

add_library(test_protobuf_cc_proto STATIC ${PROTO_SRCS} ${PROTO_HDRS})
#target_link_libraries(test_protobuf_cc_proto PUBLIC )

add_executable(runtime_test "${CMAKE_CURRENT_SOURCE_DIR}/internal/runtime_test.cc")
target_link_libraries(runtime_test PRIVATE
    runtime domain test_protobuf_cc_proto absl::time gtest gtest_main compilation_flags)
