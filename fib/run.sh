#!/bin/bash

sby -f fib_prove.sby

#Does not work with docker image tocisz/verilog-toolbox
sby -f fib_live.sby

sby -f fib_cover.sby
