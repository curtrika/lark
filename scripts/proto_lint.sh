#!/bin/sh
echo -e "${ORANGE}Proto lint${NC}"

protolint -config_dir_path ${PROTOLINT_CONFIG_DIR} ${PROTOGEN_SRC}