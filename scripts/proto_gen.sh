#!/bin/sh
echo -e "${ORANGE}Protoc generate go,grpc,gw and openapiv2 docs${NC}"

# Create cache directory if it doesn't exist
CACHE_DIR="${PROTOGEN_TARGET}/.cache"
mkdir -p ${CACHE_DIR}
mkdir -p ${PROTOGEN_TARGET}
mkdir -p ${PROTOSWAGGER_TARGET}

# Function to get file hash
get_file_hash() {
    sha256sum "$1" | cut -d' ' -f1
}

# Function to check if regeneration is needed
needs_regeneration() {
    local proto_file="$1"
    local cache_file="${CACHE_DIR}/$(basename ${proto_file}).hash"
    
    if [ ! -f "${cache_file}" ]; then
        return 0 # true, regeneration needed
    fi
    
    local current_hash=$(get_file_hash "${proto_file}")
    local cached_hash=$(cat "${cache_file}")
    
    [ "${current_hash}" != "${cached_hash}" ]
}

# Get list of proto files
PROTO_FILES=$(find ${PROTOGEN_SRC} -name '*.proto')
CHANGED_FILES=""

# Check which files have changed
for proto_file in ${PROTO_FILES}; do
    if needs_regeneration "${proto_file}"; then
        CHANGED_FILES="${CHANGED_FILES} ${proto_file}"
    fi
done

# If no files changed, exit
if [ -z "${CHANGED_FILES}" ]; then
    echo -e "${GREEN}No changes detected in proto files${NC}"
    exit 0
fi

echo -e "${ORANGE}Generating protobuf files for changed protos${NC}"

# Clean old generated files
for file in $(find ${PROTOGEN_TARGET} -name '*.pb.*'); do
    rm "$file"
done

for file in $(find ${PROTOSWAGGER_TARGET} -name '*.swagger.yaml'); do
    rm "$file"
done

for file in $(find ${PROTOSWAGGER_TARGET} -name '*.swagger.json'); do
    rm "$file"
done

# Save current hashes to temporary directory
TMP_CACHE_DIR=$(mktemp -d)
for proto_file in ${CHANGED_FILES}; do
    get_file_hash "${proto_file}" > "${TMP_CACHE_DIR}/$(basename ${proto_file}).hash"
done

# Run generation
if protoc \
    --proto_path ${PROTOGEN_SRC} \
    --proto_path "/proto" \
    --go_out=${PROTOGEN_TARGET} \
    --go_opt=paths=source_relative \
    --go-grpc_out=${PROTOGEN_TARGET} \
    --go-grpc_opt=require_unimplemented_servers=false \
    --go-grpc_opt=paths=source_relative \
    --grpc-gateway_out=${PROTOGEN_TARGET} \
    --grpc-gateway_opt=generate_unbound_methods=true \
    --grpc-gateway_opt=paths=source_relative \
    --openapiv2_out=${PROTOSWAGGER_TARGET} \
    --openapiv2_opt=${PROTOSWAGGER_OPTS} \
    -I /proto/protovalidate \
    ${CHANGED_FILES}; then
    
    # If generation successful, update cache
    for hash_file in "${TMP_CACHE_DIR}"/*.hash; do
        mv "${hash_file}" "${CACHE_DIR}/$(basename ${hash_file})"
    done
    echo -e "${GREEN}Generation COMPLETE${NC}"
else
    echo -e "${ORANGE}Generation FAILED, cache not updated${NC}"
    rm -rf "${TMP_CACHE_DIR}"
    exit 1
fi

rm -rf "${TMP_CACHE_DIR}"
