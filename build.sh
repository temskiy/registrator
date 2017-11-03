#!/bin/bash
git config --global http.https://gopkg.in.followRedirects true
go build
./registrator -cleanup -mode services consul://127.0.0.1:8500

