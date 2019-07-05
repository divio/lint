# linter

Docker-packaged linting tools

## Build the docker image
```
   docker build . --tag divio/lint
```

## Using it in bash
```
   alias lint="docker run -it --env-file=.lint -v $(pwd):/app divio/lint /bin/lint"

   lint
   lint --check

```


## Using it with make
```
lint:
	docker run -it  --env-file=.lint -v $(CURDIR):/app divio/lint /bin/lint ${ARGS}
```

```

   make lint
   ARGS=--check make lint
```

Remember, you can specify differnt  env-files instead of `.lint`

## environment variales we are going to need
```
LINT_FILE_DOCKER=/app/Dockerfile
LINT_FOLDER_PYTHON=/app/src
LINT_FOLDER_SCSS=/app/private/sass/**/*.scss
LINT_FOLDER_JS=/app/static/js/**/*.js
```
