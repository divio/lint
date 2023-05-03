# linter

Docker-packaged linting tools

## Build the docker image
```
   docker build . --tag divio/lint
```

## Using it in bash
```
   alias lint="docker run --rm -it --env-file=.lint -v $(pwd):/app divio/lint /bin/lint"

   lint
   lint --check
   lint --run=js,python

```


## Using it with make
```
lint:
	docker run -it --rm --env-file=.lint -v $(CURDIR):/app divio/lint /bin/lint ${ARGS}
```

```

   make lint
   ARGS=--check make lint
   ARGS="--run=js,scss" make lint
```

Remember, you can specify different  env-files instead of `.lint`

## Running from a pre-commit hook

If the container is invoked with `--staged`, it will only run on files
that are staged for commit. This implies `--check`, because it needs to
operate on temporary copies of the affected files since the working tree
might contain further changes not staged for commit. This is a faster
version suitable for running from a pre-commit hook.

## environment variables we are going to need

Note that these should be relative. The linters will be executed in the
`/app` working directory, but with `--staged`, they operate on files in a
temporary directory instead.

```
LINT_FILE_DOCKER=Dockerfile
LINT_FOLDER_PYTHON=src
LINT_FOLDER_SCSS=private/sass/**/*.scss
LINT_FOLDER_JS=static/js/**/*.js
```

## Python linting: ruff configuration

Linting python files is done with [ruff](https://beta.ruff.rs/docs/).
To use the existing preset, add the following to your `pyproject.toml`:

```toml
[tool.ruff]
    extend = "/presets/ruff.toml"
```

You can modify the rules selected and ignored using the `extend-*` properties (see documentation).

Note that the `isort` presets will be overridden if you provide your own `tool.ruff.isort` section.
Here is an example of a valid isort configuration you could use:

```toml
[tool.ruff]
   # ...

    [tool.ruff.isort]
        # keep thos defaults
        lines-after-imports = 2
        lines-between-types = 0
        # order of imports, you can addd sections are required
        section-order = ["future", "standard-library", "django", "drf", "third-party", "first-party", "project", "local-folder"]

    # define the sections used in the section-order
    [tool.ruff.isort.sections]
        django = ["django"]
        drf=["rest_framework"]
        project=["my_project", "accounts"]
```