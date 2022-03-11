cmd /c flutter build web --base-href="/grouploan/"
rmdir /s /q .\docs\
mkdir .\docs
xcopy /E /I /y build\web .\docs