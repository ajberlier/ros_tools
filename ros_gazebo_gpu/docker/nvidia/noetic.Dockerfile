FROM nvidia/cudagl:11.4.2-base-ubuntu20.04

# Set timezone so the package manager does not choke.
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/NewYork
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# RUN apt-get install -y tzdata

# Run a full upgrade and install utilities for development.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    mesa-utils \
    vim \
    build-essential gdb \
    cmake cmake-curses-gui \
    git \
    ssh \
    apt-utils\
 && rm -rf /var/lib/apt/lists/*

# Register the ROS package sources.
ENV UBUNTU_RELEASE=focal
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install ROS.
RUN apt-get update && apt-get install -y \
    ros-noetic-desktop-full python3-rosdep\
 && rm -rf /var/lib/apt/lists/*

# Upgrade Gazebo.
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y \
    gazebo11 \
 && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init

# Only for nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
# ENV PATH /usr/local/nvidia/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime (nvidia-docker2)
ENV NVIDIA_VISIBLE_DEVICES \
   ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
   ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

# Create users and groups.
ARG ROS_USER_ID=1000
ARG ROS_GROUP_ID=1000

RUN addgroup --gid $ROS_GROUP_ID ros \
 && useradd --gid $ROS_GROUP_ID --uid $ROS_USER_ID -ms /bin/bash -p "$(openssl passwd -1 ros)" -G root,sudo ros \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && mkdir -p /workspace \
 && ln -s /workspace /home/workspace \
 && chown -R ros:ros /home/ros /workspace

# Source the ROS configuration.
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/ros/.bashrc

# If the script is started from a Catkin workspace,
# source its configuration as well.
RUN echo "test -f devel/setup.bash && echo \"Found Catkin workspace.\" && source devel/setup.bash" >> /home/ros/.bashrc

USER ros
RUN rosdep update
WORKDIR /workspace
