//
// FileReadWrite.h
//
// Library: IO
// Package: IO
// Module:  FileReadWrite
//
// Definition of the FileReadWrite class.
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

#ifndef IO_FileReadWrite_INCLUDED
#define IO_FileReadWrite_INCLUDED

#include <string>

namespace Cuiver {
    namespace IO {
        void for_each_line(const char *, void (*)(const std::string &));
    }
}// namespace Cuiver

#endif//IO_FileReadWrite_INCLUDED
