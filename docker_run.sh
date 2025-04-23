#!/bin/sh
docker run --rm \
	-u $(id -u):$(id -g) \
	-v $(pwd):/app \
	-w /app \
	protogen:${LARK_VERSION}  \
	task --dir=/app lark:protogen-generate