FROM dustynv/ros:humble-desktop-l4t-r32.7.1

RUN apt-get update && apt-get install -y apt-transport-https

RUN apt-get update && apt-get install -y \
    # ros-humble-teleop-twist-joy \
    build-essential \
    python3-opencv \
    python3-pip \
    cmake \
    git \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=jetson
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN pip3 install --upgrade pip

RUN pip3 install opencv-python-headless==4.5.5.62 cv_bridge

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

