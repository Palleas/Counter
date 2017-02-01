#!/usr/bin/env bash

make deps

rm Cartfile || true
rm Cartfile.resolved || true 
rm Cartfile.private || true