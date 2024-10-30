@echo off
IF "%~1"=="" GOTO useage 
IF "%~2"=="" GOTO useage
GOTO run
:useage
@echo "Useage: <top level module> <input file>" 
GOTO end

:run
yosys -p "prep -top %1; write_json output.json" %2 
type output.json | clip
@echo "JSON copied to clipboard"
:end