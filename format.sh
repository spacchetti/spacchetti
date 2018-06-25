ls src/**/*.dhall | xargs -I{} dhall format --inplace {}
echo formatted dhall files
