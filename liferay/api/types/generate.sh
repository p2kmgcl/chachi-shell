#!/bin/bash

GENERATED_DIR="$(realpath $(dirname $0))/generated/"
OPENAPI_FILE="${GENERATED_DIR}/openapi.json"

rm -rf "$GENERATED_DIR"
mkdir -p "$GENERATED_DIR"

curl -s -u "test@liferay.com:test" -o "$OPENAPI_FILE" http://localhost:8080/o/headless-delivery/v1.0/openapi.json
npx -y swagger-typescript-api --silent --extract-enums -p $OPENAPI_FILE -o "$GENERATED_DIR"
