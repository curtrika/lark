ARG GO_VERSION
ARG ALPINE_VERSION
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}

ENV HOME /home/docker
WORKDIR ${HOME}

ENV LOCAL ${HOME}/.local
RUN mkdir -p ${LOCAL}/bin
ENV PATH $PATH:${LOCAL}/bin

ARG TASK_VERSION
RUN go install github.com/go-task/task/v3/cmd/task@v${TASK_VERSION}
ENV PATH $PATH:$(go env GOPATH)/bin

ARG PROTOC_VERSION
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip \
    && unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d ${LOCAL}/protoc \
    && rm protoc-${PROTOC_VERSION}-linux-x86_64.zip
ENV PATH $PATH:${LOCAL}/protoc/bin

ARG PROTOC_GEN_GO_VERSION
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v${PROTOC_GEN_GO_VERSION}

ARG PROTOC_GEN_GO_GRPC_VERSION
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v${PROTOC_GEN_GO_GRPC_VERSION}

ARG PROTOC_GEN_GRPC_GATEWAY_VERSION
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v${PROTOC_GEN_GRPC_GATEWAY_VERSION}

ARG PROTOC_GEN_OPENAPI_VERSION
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v${PROTOC_GEN_OPENAPI_VERSION}

ARG PROTOC_GO_INJECT_TAG_VERSION
RUN go install github.com/favadi/protoc-go-inject-tag@v${PROTOC_GO_INJECT_TAG_VERSION}

ARG PROTOC_GEN_DOC_VERSION
RUN go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v${PROTOC_GEN_DOC_VERSION}

ARG PROTO_LINT_VERSION
RUN go install github.com/yoheimuta/protolint/cmd/protolint@v${PROTO_LINT_VERSION}

# needed binaries installation
RUN apk --no-cache add curl make

# google's protofiles
RUN mkdir -p /proto/
ENV THIRD_PARTY /proto
ENV GOOGLE ${THIRD_PARTY}/google
ENV GEN_OPENAPI_V2 ${THIRD_PARTY}/protoc-gen-openapiv2
ENV PROTOVALIDATE ${THIRD_PARTY}/protovalidate/buf/validate
ENV GOOGLE_APIS_PROTO_URL https://raw.githubusercontent.com/googleapis/googleapis/master/google
ENV GOOGLE_PROTOCOLBUFFERS_URL https://raw.githubusercontent.com/protocolbuffers/protobuf/main/src/google/protobuf
ENV PROTOC_GEN_OPENAPI_V2_URL https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/main/protoc-gen-openapiv2
ENV PROTOVALIDATE_URL https://raw.githubusercontent.com/bufbuild/protovalidate/main/proto/protovalidate/buf/validate

RUN mkdir -p ${GOOGLE}/api && \
		curl ${GOOGLE_APIS_PROTO_URL}/api/annotations.proto -o ${GOOGLE}/api/annotations.proto && \
		curl ${GOOGLE_APIS_PROTO_URL}/api/http.proto -o ${GOOGLE}/api/http.proto && \
		curl ${GOOGLE_APIS_PROTO_URL}/api/httpbody.proto -o ${GOOGLE}/api/httpbody.proto && \
		curl ${GOOGLE_APIS_PROTO_URL}/api/field_behavior.proto -o ${GOOGLE}/api/field_behavior.proto && \
		curl ${GOOGLE_APIS_PROTO_URL}/api/visibility.proto -o ${GOOGLE}/api/visibility.proto && \
	mkdir -p ${GOOGLE}/protobuf && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/descriptor.proto -o ${GOOGLE}/protobuf/descriptor.proto && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/any.proto -o ${GOOGLE}/protobuf/any.proto && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/struct.proto -o ${GOOGLE}/protobuf/struct.proto && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/duration.proto -o ${GOOGLE}/protobuf/duration.proto && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/timestamp.proto -o ${GOOGLE}/protobuf/timestamp.proto && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/empty.proto -o ${GOOGLE}/protobuf/empty.proto && \
		curl ${GOOGLE_PROTOCOLBUFFERS_URL}/wrappers.proto -o ${GOOGLE}/protobuf/wrappers.proto && \
	mkdir -p ${GEN_OPENAPI_V2}/options && \
		curl ${PROTOC_GEN_OPENAPI_V2_URL}/options/annotations.proto -o ${GEN_OPENAPI_V2}/options/annotations.proto && \
		curl ${PROTOC_GEN_OPENAPI_V2_URL}/options/openapiv2.proto -o ${GEN_OPENAPI_V2}/options/openapiv2.proto && \
    mkdir -p ${PROTOVALIDATE} && \
    		curl ${PROTOVALIDATE_URL}/expression.proto -o ${PROTOVALIDATE}/expression.proto && \
    		curl ${PROTOVALIDATE_URL}/validate.proto -o ${PROTOVALIDATE}/validate.proto && \
    mkdir -p ${PROTOVALIDATE}/priv && \
        	curl ${PROTOVALIDATE_URL}/priv/private.proto -o ${PROTOVALIDATE}/priv/private.proto && \
	mkdir -p ${GOOGLE}/rpc && \
		curl ${GOOGLE_APIS_PROTO_URL}/rpc/code.proto -o ${GOOGLE}/rpc/code.proto && \
		curl ${GOOGLE_APIS_PROTO_URL}/rpc/status.proto -o ${GOOGLE}/rpc/status.proto && \
		curl ${GOOGLE_APIS_PROTO_URL}/rpc/error_details.proto -o ${GOOGLE}/rpc/error_details.proto

COPY ./lark/.protolint.yaml ${HOME}