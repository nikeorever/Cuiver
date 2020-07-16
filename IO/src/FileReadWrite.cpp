//
// FileReadWrite.cpp
//
// Library: IO
// Package: IO
// Module:  FileReadWrite
//
//
// Copyright (C) 2020 nikeo
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
#include "Cuiver/IO/FileReadWrite.h"
#include <fstream>

namespace Cuiver {
    namespace IO {
        void for_each_line(const char *file, void (*f)(const std::string &)) {
            std::ifstream ifs(file);
            std::string line;
            while (std::getline(ifs, line)) {
                f(line);
            }
        }
    }// namespace IO
}// namespace Cuiver