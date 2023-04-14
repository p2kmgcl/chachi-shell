#!/bin/bash

GENERATED_DIR="$(realpath $(dirname $0))/generated/"

rm -rf "$GENERATED_DIR"
mkdir -p "$GENERATED_DIR"

curl -s -u "test@liferay.com:test" -o "$GENERATED_DIR/headless-delivery-openapi.json" http://localhost:8080/o/headless-delivery/v1.0/openapi.json
npx -y swagger-typescript-api --name headless-delivery-openapi.ts --silent --extract-enums -p "$GENERATED_DIR/headless-delivery-openapi.json" -o "$GENERATED_DIR"

curl -s -u "test@liferay.com:test" -o "$GENERATED_DIR/object-admin-openapi.json" http://localhost:8080/o/object-admin/v1.0/openapi.json
npx -y swagger-typescript-api --name object-admin-openapi.ts --silent --extract-enums -p "$GENERATED_DIR/object-admin-openapi.json" -o "$GENERATED_DIR"
