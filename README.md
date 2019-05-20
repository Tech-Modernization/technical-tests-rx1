# Test 1
## The Challenge
The following test will require you to do the following:
- Convert the current Dockerfile into a multistage build Dockerfile.
- Optimise Dockerfile for caching benefits.

There are many benefits to using multi-stage build techniques when creating Dockerfiles. One such benefit is mitigating security risks, this is accomplished because the attack surface size of the image can be greatly reduced when the image no longer contains unnecessary files, packages, or binaries. It can also enhance caching on layers in previous build steps that no longer need to be clustered in a single RUN statement for optimal layering because the image is discarded and only those artifacts necessary are kept.

The final multi-stage Dockerfile should only have the essential components. You should also consider optimisation for caching, and structure in your final solution.

The below Dockerfile in its current state does not compile - you will also need to debug this issue and consider how this can be resolved.

For all the files that will be required they can be cloned from the following repository - [HERE](https://github.com/xUnholy/technical-tests)

## The Solution

### Troubleshooting
The original golang code created a listener at 127.0.0.1:8000. It works for localhost tests but if built into a container it needs to listen to public network interface so that it can receive requests from outside the container.

### Optimization
System packages and relatively static files should be added as early as possible so changes to code(which is much more frequent) will be built on top of the cached layer, which results a reduced build time.

The original Dockerfile didn't utilise Docker's multistage feature. The final artefact is arund 400MB including all the tools to build the app from golang source.

With multistage build steps, only the compiled executable is carried over to the final stage since golang puts all dependencies inside the executable, resulting a much smaller image less than 14MB. This dramatically reduced the cost to store/run this container in scale, also made it secure because the attack surface is so small.

### Tidying Up
The dockerignore file was missing which means everything in the repository including .git directory was copied as build context. With the added dockerignore file, the .git directory, Dockerfile itself and this README file won't be part of the build anymore. This will speed up the build a tiny little bit but more importantly reduced the size of the container as well as the attack surface, making the final image more secure.

## Commands for Local Development
### Docker Build

```
docker build -t test1 .
```

### Docker Run
Run by default as the webserver
```
docker run --rm -p 8000:8000 test1
```

Run as an interactive shell for troubleshooting
```
docker run --rm -ti test1 /bin/ash
```

### Local Tests

Bash commands to test all 3 endpoints(assuming the container is running already)
```
for i in / /go /opt; do echo "Testing $i:"; curl -i http://localhost:8000$i; echo; done
```
