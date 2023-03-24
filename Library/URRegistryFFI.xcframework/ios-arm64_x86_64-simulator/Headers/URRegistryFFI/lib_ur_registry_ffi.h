#include "stdint.h"

struct ExternError {
    int32_t code;
    char *message; // note: nullable
};

void keystone_sdk_destroy_string(const char* cstring);


// ETH
const char* generate_eth_sign_request(struct ExternError*, const char* request_id, const int data_type, const char* sign_data, const char* path, const char* xfp, const int chain_id, const char* address, const char* origin);
const char* parse_eth_signature(struct ExternError*, const char* cbor_hex);

// SOL
const char* generate_sol_sign_request(struct ExternError*, const char* request_id, const char* sign_data, const char* path, const char* xfp, const char* address, const char* origin, const int sign_type);
const char* parse_sol_signature(struct ExternError*, const char* cbor_hex);