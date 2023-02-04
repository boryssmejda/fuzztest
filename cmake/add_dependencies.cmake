include(FetchContent)
FetchContent_Declare(abseil
    GIT_REPOSITORY https://github.com/abseil/abseil-cpp/
    GIT_TAG        6acb60c161f1203e6eca929b87f2041da7714bfe
)

FetchContent_Declare(re2
    GIT_REPOSITORY https://github.com/google/re2/
    GIT_TAG        5723bb8950318135ed9cf4fc76bed988a087f536
)

FetchContent_Declare(googletest
    GIT_REPOSITORY https://github.com/google/googletest/
    GIT_TAG        58d77fa8070e8cec2dc1ed015d66b454c8d78850
)

FetchContent_Declare(protobuf
    GIT_REPOSITORY https://github.com/protocolbuffers/protobuf/
    GIT_TAG        ab840345966d0fa8e7100d771c92a73bfbadd25c
    FIND_PACKAGE_ARGS NAMES protobuf
)

set(protobuf_BUILD_TESTS OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(abseil re2 googletest protobuf)

include(FindProtobuf)
find_package(protobuf CONFIG REQUIRED)
