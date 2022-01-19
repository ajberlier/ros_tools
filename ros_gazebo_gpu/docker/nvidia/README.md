s
# ROS + NVIDIA

**TL;DR:** Run `./build.sh` in this directory.

---

We cannot simply build an existing ros image as it lacks the OpenGL pieces required to make the visualization applications work. Instead, we're building from `nvidia/cudagl` and installing `ros-noetic-desktop-full` from the package manager.

To build the image, run

```bash docker build -t sunside/ros-gazebo-gpu:noetic-nvidia -f noetic.Dockerfile .```

A `ros` user (password `ros`) will be created with default user and group IDs (`1000:1000`). If you need
different values, specify the `ROS_USER_ID` and `ROS_GROUP_ID` build arguments:

```bash
docker build \
    --build-arg ROS_USER_ID=1000 \
    --build-arg ROS_GROUP_ID=1000 \
    -t sunside/ros-gazebo-gpu:noetic-nvidia \
    -f noetic.Dockerfile .
```

If the directory the script is started in contains a Catkin workspace, it will automatically
source the `devel/source.bash` script.
