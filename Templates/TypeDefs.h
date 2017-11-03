enum Key: String {
#define KEY(NAME, CONTENT) case NAME = CONTENT
#include "ProtocolUIDs.def"
#undef KEY
}

enum Request: String {
#define REQUEST(NAME, CONTENT) case NAME = CONTENT
#include "ProtocolUIDs.def"
#undef REQUEST
}

enum Kind: String {
#define KIND(NAME, CONTENT) case NAME = CONTENT
#include "ProtocolUIDs.def"
#undef KIND
}
