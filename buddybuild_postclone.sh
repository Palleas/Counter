#!/usr/bin/env bash

rm Cartfile || true
rm Cartfile.resolved || true 
rm Cartfile.private || true

make deps
