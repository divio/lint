# linter

Docker-packaged linting tools

```
   docker build . --tag divio/lint
   alias lint="docker run -it -v $(pwd):/app divio/lint /bin/lint"
   
   lint

