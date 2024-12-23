#!/bin/bash

image_suffix=(base dev prod prod-rs)
archs=(amd64 arm64)
gst_version=$1

for suffix in ${image_suffix[*]}
do
    digests=()
    for arch in ${archs[*]}
    do
        digest=`docker manifest inspect pintoinc/gstreamer:$gst_version-$suffix-$arch | jq ".manifests[] | select(.platform.architecture == \"$arch\").digest"`
        # remove quotes
        digest=${digest:1:$[${#digest}-2]}
        digests+=($digest)
    done

    manifests=""
    for digest in ${digests[*]}
    do
        manifests+=" pintoinc/gstreamer@$digest"
    done

    docker manifest create pintoinc/gstreamer:$gst_version-$suffix$manifests
    docker manifest push pintoinc/gstreamer:$gst_version-$suffix
done
