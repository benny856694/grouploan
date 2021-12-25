cmd /c flutter build web --base-href="/grouploan/"
mkdir .\docs
xcopy /E /I /y build\web .\docs