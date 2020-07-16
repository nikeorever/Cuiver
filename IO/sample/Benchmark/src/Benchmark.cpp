#include <Cuiver/IO/FileReadWrite.h>
#include <iostream>
#include <string>

int main() {
    std::string path = "/home/xianxueliang/Desktop/test.cc";

    Cuiver::IO::for_each_line(path.c_str(), [](const std::string &line) {
        std::cout << "[Cuiver]" << line << std::endl;
    });
}