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

Remember, you can specify different  env-files instead of `.lint`

## Running from a pre-commit hook

If the container is invoked with `--staged`, it will only run on files
that are staged for commit. This implies `--check`, because it needs to
operate on temporary copies of the affected files, since the working tree
might contain further changes not staged for commit. This is a faster
version suitable for running from a pre-commit hook.

## environment variales we are going to need

Note that these should be relative. The linters will be executed in the
`/app` working directory, but with `--staged`, they operate on files in a
teporary directory instead.

```
LINT_FILE_DOCKER=Dockerfile
LINT_FOLDER_PYTHON=src
LINT_FOLDER_SCSS=private/sass/**/*.scss
LINT_FOLDER_JS=static/js/**/*.js
```
