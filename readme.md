# Docker build guide

## Image: python_oracle

Make sure you already downloaded the [oracle client (both "basic" and "sdk")](https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html), e.g., `instantclient-sdk-linux.x64-11.2.0.4.0.zip` and `instantclient-basic-linux.x64-11.2.0.4.0.zip`,  into this project ROOT folder before executing the following command.

```bash
export PYTHON_VERSION=3.6
export ORACLE_VERSION=11.2
docker build -t python_oracle:${PYTHON_VERSION}-${ORACLE_VERSION} --build-arg="PYTHON_VERSION=${PYTHON_VERSION}" --build-arg="ORACLE_VERSION=${ORACLE_VERSION}" --file python_oracle.Dockerfile .
```

