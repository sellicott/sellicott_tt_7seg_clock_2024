:: Run Yosys to generate an elaborated netlist of a Verilog Module
:: JSON output is copied to clipboard for pasting into netlistsvg
:: Author: Sam Ellicott
:: Date: October 30, 2024
:: Useage: elaborate_json.bat <top level module> <input file>

:: Check parameters and generate useage message
@echo off
IF "%~1"=="" GOTO useage 
IF "%~2"=="" GOTO useage
GOTO run
:useage
@echo "Useage: <top level module> <input file>" 
GOTO end

:run
:: Run yosys and generate the json output file
yosys -p "prep -top %1; write_json output.json" %2 

:: copy JSON output to clipboard
type output.json | clip
@echo "JSON copied to clipboard"
:end