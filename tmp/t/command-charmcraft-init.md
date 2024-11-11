(command-charmcraft-init)=
# Command 'charmcraft init'

## Usage:
```text
charmcraft init [options]
```

## Summary:

Initialize a charm operator package tree and files.

This command will modify the directory to create the necessary files for a charm operator package. By default it will work in the current directory.

Available profiles are:     simple:         A basic kubernetes charm with lot of texts helping the developer         to navigate their first charm by following the instructions.

```text
kubernetes:
    A basic Kubernetes charm with example container.
```

```text
machine:
    A basic charm but meant to be deployed in machine-based environments,
    without container requirements.
```

```text
flask-framework:
    A basic Flask application charm for the 12-factor charm project.
```

Depending on the profile choice, Charmcraft will setup the following tree of files and directories:

```text
.
├── charmcraft.yaml        - Charm build configuration
├── CONTRIBUTING.md        - Instructions for how to build and develop
│                             your charm
├── LICENSE                - Your charm license, we recommend Apache 2
├── pyproject.toml         - Configuration for testing, formatting and
│                             linting tools
├── README.md              - Frontpage for your charmhub.io/charm/
├── requirements.txt       - PyPI dependencies for your charm, with `ops`
├── src
│   └── charm.py           - Minimal operator using Python operator framework
├── tests
│   ├── integration
│   │   └── test_charm.py  - Integration tests
│   └── unit
│       └── test_charm.py  - Unit tests
└── tox.ini                - Configuration for tox, the tool to run all tests
```

You will need to edit at least charmcraft.yaml and README.md.

Your minimal operator code is in src/charm.py which uses the Python operator framework from https://github.com/canonical/operator and there are some example unit and integration tests with a harness to run them.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-V, --version` | Show the application version and exit |
| `--name` | The name of the charm; defaults to the directory name |
| `--author` | The charm author; defaults to the current user name per GECOS |
| `-f, --force` | Initialize even if the directory is not empty (will not overwrite files) |
| `--profile` | Use the specified project profile (defaults to 'simple') |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |