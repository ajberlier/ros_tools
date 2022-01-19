# ROS Noetic Desktop Full + NVIDIA in Docker

## Sourced documentation

- [Ubuntu install of ROS Noetic](http://wiki.ros.org/noetic/Installation/Ubuntu)
- [Hardware Acceleration](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration)
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)
- [Install Gazebo using Ubuntu Packages](https://gazebosim.org/tutorials?cat=guided_b&tut=guided_b1)
- [Gazebo Models](https://github.com/osrf/gazebo_models) are available on Git
- [nvidia/cudagl](https://hub.docker.com/r/nvidia/cudagl) Docker image

## Problems to steer around

A core issues that arise when just following the official documentation(s) are these:

- The `nvidia-docker2` runtime is now deprecated and has been replaced with `nvidia-container-toolkit`; as a result, `--runtime="nvidia"` is not a valid option anymore and `--gpus "all"` (or similar) must be used instead.
- `xauth:  error in locking authority` X11 authentication may fail due to a subtle bug when passing arguments along.
    - solution: 


## Build with GPU support

For NVIDIA GPU support, go to the [docker/nvidia](docker/nvidia) directory and follow the instructions [there](docker/nvidia/README.md).

If in a hurry, just run

```bash docker/nvidia/build.sh```

Start the container with

```bash ./run-nvidia.sh```

and you're ready to go. Note that this will create a container named `ros`, so running the command twice won't work. You can, however, `docker exec -it ros bash` into the running container as often as you like.