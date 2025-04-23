#!/bin/sh
echo -e "${ORANGE}Protoc custom tags injecting${NC}"

for file in $(find ${PROTOGEN_TARGET} -name '*.go')
do
  protoc-go-inject-tag -input "$file"
done