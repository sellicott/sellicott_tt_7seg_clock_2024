@set GIT_PATH="%~dp0\..\PortableGit\cmd"
@set PATH=%GIT_PATH%;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%SystemRoot%\System32\OpenSSH

@cmd /k "%~dp0\..\oss-cad-suite\environment.bat"