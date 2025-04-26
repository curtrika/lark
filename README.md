# Lark

A standardized Docker-based build environment for go.pb, grpc.pb, gw.pb и swagger doc.

## Overview

This project provides a standardized Docker environment for generating Protocol Buffers (go.pb, grpc.pb, gw.pb) and Swagger documentation from .proto files. It helps teams maintain consistency in their build process by ensuring all developers use the same versions of build tools and libraries.

## Problem Statement

When working with Protocol Buffers in a team environment, different developers often use different versions of build tools and libraries, which can lead to:
- Inconsistent generated code
- Merge conflicts in generated files
- Version mismatches between team members
- Time wasted on resolving build-related issues

## Solution

This project provides a Docker-based solution that:
- Standardizes the build environment
- Ensures consistent versions of all required tools
- Simplifies the build process
- Reduces merge conflicts in generated files

## Features

- Docker-based build environment
- Standardized tool versions
- Support for Protocol Buffers compilation
- Swagger documentation generation
- Task-based build system

## Prerequisites

- Docker
- Task (task runner)
- Git

## Installation

1. Clone the repository:
```bash
git clone git@github.com:curtrika/lark.git
cd lark
rm -rf .git
```

2. Include Lark Taskfile in your project (one level above this repository):
```yaml
version: '3'
tasks:
  {...}

includes:
  lark:
    taskfile: ./lark/lark.yml
```

## Example of project structure

Here's an example of a project structure:

```
.
├── Taskfile.yml
├── api
│   └── your_service
│       └── v1
│           ├── get_method.proto
│           └── service.proto
├── docs
│   └── your_service.swagger.json
├── lark
├── pkg
└── proto_libs
```

> ⚠️ **Important**: Make sure to properly configure Proto Path in your project to avoid potential import issues.

## Usage

1. Build the Docker image:
```
task lark:build
```

2. Run the image:
```
task lark:run
```

## Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

- [ ] Fix bug with imports
- [x] Implement caching for faster builds
- [ ] Add usage examples
- [ ] Create more comprehensive documentation