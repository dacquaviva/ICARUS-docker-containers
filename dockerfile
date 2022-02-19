FROM nvidia/cuda:11.5.1-cudnn8-devel-ubuntu18.04

RUN apt-get update

# Install opencv dependencies
RUN apt-get install build-essential cmake git unzip pkg-config \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libgtk2.0-dev libcanberra-gtk* \
    python3-dev python3-numpy python3 python3-pip \
    libxvidcore-dev libx264-dev libgtk-3-dev \
    libtbb2 libtbb-dev libdc1394-22-dev \
    libv4l-dev v4l-utils \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libavresample-dev libvorbis-dev libxine2-dev \
    libfaac-dev libmp3lame-dev libtheora-dev \
    libopencore-amrnb-dev libopencore-amrwb-dev \
    libopenblas-dev libatlas-base-dev libblas-dev \
    liblapack-dev libeigen3-dev gfortran \
    libhdf5-dev protobuf-compiler \
    libprotobuf-dev libgoogle-glog-dev libgflags-dev -y

# Install opencv
WORKDIR /code/libs/opencv

RUN apt-get install wget -y
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.5.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.5.zip
RUN unzip opencv.zip && unzip opencv_contrib.zip

RUN mv opencv-4.5.5 opencv
RUN mv opencv_contrib-4.5.5 opencv_contrib
RUN rm opencv.zip && rm opencv_contrib.zip

# Install Numpy
WORKDIR /code/python
RUN pip3 install --upgrade pip
RUN pip3 install numpy==1.19.5

# Build opencv
WORKDIR /code/libs/opencv/opencv/build 

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
        -D WITH_OPENCL=OFF \
        -D WITH_CUDA=ON \
        -D CUDA_ARCH_BIN=7.2 \
        -D CUDA_ARCH_PTX="" \
        -D WITH_CUDNN=ON \
        -D WITH_CUBLAS=ON \
        -D ENABLE_FAST_MATH=ON \
        -D CUDA_FAST_MATH=ON \
        -D OPENCV_DNN_CUDA=ON \
        -D ENABLE_NEON=ON \
        -D WITH_QT=OFF \
        -D WITH_OPENMP=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_TIFF=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_TBB=ON \
        -D BUILD_TBB=ON \
        -D BUILD_TESTS=OFF \
        -D WITH_EIGEN=ON \
        -D WITH_V4L=ON \
        -D WITH_LIBV4L=ON \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D BUILD_opencv_python3=TRUE \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D BUILD_EXAMPLES=OFF \
        -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-11.5 ..

RUN make -j$(nproc)
RUN make install
