// Vietnamese Telex -> Unicode conversion (C++ port of engine/vietnamese.py)
// All identifiers and comments are in English as requested.

#pragma once

#include <string>

// Convert a full Telex string (may contain spaces) to Vietnamese Unicode.
// Example: "tieengs vieetj" -> "tiếng việt"
std::string telex_to_unicode(const std::string& raw);

// Convert an input buffer (used while typing) to Vietnamese Unicode.
// Semantically the same as telex_to_unicode but kept for structural parity.
inline std::string convert_buffer(const std::string& buffer) {
    return telex_to_unicode(buffer);
}

