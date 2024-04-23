FROM ros:humble

RUN apt-get update && apt-get install -y apt-transport-https

RUN apt-get update && apt-get install -y \
    ros-humble-teleop-twist-joy \
    build-essential \
    cmake \
    git \
    python3-pip \
    libhdf5-serial-dev \
    hdf5-tools \
    libhdf5-dev \
    zlib1g-dev \
    zip \
    libjpeg8-dev \
    liblapack-dev \
    libblas-dev \
    gfortran \
    libhdf5-dev \
    libopencv-dev \
    ros-humble-cv-bridge \
    ros-humble-image-transport \
    ros-humble-camera-info-manager \
    build-essential \
    pkg-config \
    libfreetype6-dev \
    python3-setuptools \
    screen \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=jetson
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN pip3 install --upgrade pip

RUN pip3 install opencv-python-headless==4.5.5.62

# Creating a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

RUN usermod -aG dialout ${USERNAME}
# Set-up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*


COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/$USERNAME/.bashrc

COPY /ros2_ws /source
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh"]

CMD ["bash"]

