#include "gtest/gtest.h"
#include "Cuiver/IO/FileReadWrite.h"
#include <string>

class DateConverterFixture : public ::testing::Test {

protected:
    void SetUp() override {
        file = new std::string;
        *file = ".";
    }

    void TearDown() override {
        delete file;
    }

public:
    std::string *file = nullptr;
};

TEST_F(DateConverterFixture, test) {
    Cuiver::IO::for_each_line(file->c_str(), [](const std::string &line){
        std::cout << line << std::endl;
    });
    EXPECT_EQ(1, 1);
}