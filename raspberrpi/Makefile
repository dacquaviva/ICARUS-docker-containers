
DDATE := $(shell date -v $(offset) +%Y%m%d)

build-icarus-arm64v8-opencv-4.4.0:
	sudo docker build -f dockerfile.opencv.base -t prominendt/icarus-arm64v8-opencv-4.4.0:base .

push-icarus-arm64v8-opencv-4.4.0:
	sudo docker push prominendt/icarus-arm64v8-opencv-4.4.0:base
