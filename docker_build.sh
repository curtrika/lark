#!/bin/sh
if docker image inspect protogen:${LARK_VERSION} >/dev/null 2>&1; then
  echo "image already updated"
else
    docker build \
    --build-arg TASK_VERSION=${TASK_VERSION} \
    --build-arg PROTOC_VERSION=${PROTOC_VERSION} \
    --build-arg GO_VERSION=${GO_VERSION_IMAGE} \
    --build-arg ALPINE_VERSION=${ALPINE_VERSION} \
    --build-arg PROTOC_GEN_GO_VERSION=${PROTOC_GEN_GO_VERSION} \
    --build-arg PROTOC_GEN_GO_GRPC_VERSION=${PROTOC_GEN_GO_GRPC_VERSION} \
    --build-arg PROTOC_GEN_DOC_VERSION=${PROTOC_GEN_DOC_VERSION} \
    --build-arg PROTOC_GEN_GRPC_GATEWAY_VERSION=${PROTOC_GEN_GRPC_GATEWAY_VERSION} \
    --build-arg PROTOC_GEN_OPENAPI_VERSION=${PROTOC_GEN_OPENAPI_VERSION} \
    --build-arg PROTOC_GO_INJECT_TAG_VERSION=${PROTOC_GO_INJECT_TAG_VERSION} \
    --build-arg PROTO_LINT_VERSION=${PROTO_LINT_VERSION} \
    -f ./lark/Dockerfile \
    -t protogen:${LARK_VERSION} \
    .
fi
