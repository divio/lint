# linter

Docker-packaged linting tools with sensible defaults.

<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

- [Available linters](#available-linters)
- [Usage](#usage)
  * [Using it with bash](#using-it-with-bash)
  * [Using it with make](#using-it-with-make)
  * [Running from a pre-commit hook](#running-from-a-pre-commit-hook)
- [Options](#options)
  * [Environment variables](#environment-variables)
  * [Script options](#script-options)
- [Ruff configuration](#ruff-configuration)
- [Development](#development)
  * [Build the docker image](#build-the-docker-image)

<!-- TOC end -->

## Available linters

The following linters are available:

* `docker`: runs [hadolint](https://github.com/hadolint/hadolint)
* `python`: runs [ruff](https://github.com/astral-sh/ruff)
* `scss`: runs [prettier](https://prettier.io/)
* `js`: runs [prettier](https://prettier.io/)

Each tool is configured with sensible defaults adopted at [Divio](https://divio.com/), except ruff
which requires a manual setup (see [Ruff configuration](#ruff-configuration)).

## Usage

### Using it with bash

Use the following:
```bash
alias lint="docker run --rm -it --env-file=.lint -v $(pwd):/app divio/lint /bin/lint"

# Normal
lint
# Only check, do not fix
lint --check
# Run only js and python linters
lint --run=js,python
```

For an example of `.lint` file, see [Environment variables](#environment-variables).


### Using it with make
```
lint:
	docker run -it --rm --env-file=.lint -v $(PWD):/app divio/lint /bin/lint ${ARGS}
```

```bash
# Normal
make lint
# Only check, do not fix
make lint ARGS=--check
# Lint only js and scss linters
make lint ARGS="--run=js,scss"
```

For an example of `.lint` file, see [Environment variables](#environment-variables).

### Running from a pre-commit hook

If the container is invoked with `--staged`, it will only run on files
that are staged for commit. This implies `--check`, because it needs to
operate on temporary copies of the affected files since the working tree
might contain further changes not staged for commit. This is a faster
version suitable for running from a pre-commit hook.

## Options

### Environment variables

Each language has a matching environment variable, which should be the **relative** path to source
files. Only linters with the corresponding environment variable defined will run.

_Note_: the linters will be executed in the `/app`` working directory, unless `--staged`` is used.
In this case, the files are copied to a temporary directory before linting (this implies `--check`).

Example:
```
LINT_FILE_DOCKER=Dockerfile
LINT_FOLDER_PYTHON=src
LINT_FOLDER_SCSS=private/sass/**/*.scss
LINT_FOLDER_JS=static/js/**/*.js
```

### Script options

The following options are available for the `/bin/lint` script:

* `-c / --check`: only check compliance, do not automatically fix errors
* `--staged`: only run against files staged for commit, useful for pre-commit hooks. Note that it
  implies `--check`.
* `--run`: only run a subset of linters. `--run=all` is equivalent to `--run=python,js,docker,scss`.

## Ruff configuration

Linting Python files is done with [ruff](https://beta.ruff.rs/docs/).
To use the existing Divio preset, add the following to your `pyproject.toml`:

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


## Development

### Build the docker image

This image needs to support both AMD and ARM.

**development**

During development, use (tip - use `make -n` to see the command without running it):
```bash
# Build for amd64
make build
# Build for arm64
make build TARGET=arm64
```

Don't forget to test both platforms (`docker run ...`)!

Once you know it works for both platforms, you can build a multi-arch image using
buildkit.

First, create a builder if you haven't done so already (check with `docker buildx ls`):
```bash
# create a builder. Run this only once!
docker buildx create --name builder

# use the builder
docker buildx use builder
```

Once you have the builder selected, you can run the following:
```bash
# Test the build
make build_multiarch
```

If all seems fine, it is time to release and push to DockerHub.
Create a new tag with the version (e.g. `0.8`) and push (`git push --tags`).
The GitLab pipeline will do the rest (see `.gitlab-ci.yml` for more info).

You can now go back to the "default" builder by running: `docker buildx use default`.


(**NOTE**: you can also manually push to DockerHub, but this is **NOT** recommended:
`make push_multiarch VERSION=0.7`).
