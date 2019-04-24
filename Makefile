RESPIAN_RELEASE := raspbian_lite-2019-04-09
RESPIAN_FLAVOR := 2019-04-08-raspbian-stretch-lite
DATE_STRING := $(shell date +%Y-%m-%d)
RELEASE_NAME := pup

download:
	mkdir -p ./raspbian
	./scripts/download.sh ${RESPIAN_RELEASE} ${RESPIAN_FLAVOR} ./raspbian

build: download
	mkdir -p ./build
	./scripts/build.sh "./raspbian/${RESPIAN_FLAVOR}.img" "./build/${RELEASE_NAME}-${DATE_STRING}.img"

release: download 
	mkdir -p ./release
	./scripts/release.sh "./build" "./release" "${RELEASE_NAME}-${DATE_STRING}"