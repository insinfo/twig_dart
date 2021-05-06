#!/usr/bin/env bash
# Fast-fail on errors
set -e

cd twig && pub get && pub run test
cd ../twig_preprocessor/ && pub get && pub run test
cd ../galileo_twig/ && pub get && pub run test
