add_executable(IO-Test src/FileReadWriteTest.cpp)
target_link_libraries(IO-Test Cuiver::IO gtest_main gtest)
