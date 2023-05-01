#!/bin/bash

echo "STARTING BUILD.SH"

mv -v "${SRC_DIR}/targets" "${PREFIX}/targets"

[[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ ${target_platform} == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

# Install to conda style directories
for platform in "x86_64-linux" "ppc64le-linux" "sbsa-linux"; do
    pushd "${PREFIX}/targets/${platform}"
    [[ -d lib64 ]] && mv -v lib64 lib
    popd
done

# Set up symlinks for target platform only
pushd "${PREFIX}/${targetsDir}"
for i in `ls`; do
    if [[ $i == "bin" ]] || [[ $i == "lib" ]] || [[ $i == "include" ]] || [[ $i == "nvvm" ]]; then
        if [[ $i == "bin" ]]; then
            mkdir -pv "${PREFIX}/bin"
            # Use a custom nvcc.profile to handle the fact that nvcc is a symlink.
            cp -v "${RECIPE_DIR}/nvcc.profile.for_prefix_bin" "${PREFIX}/bin/nvcc.profile"
            ln -sv "${PREFIX}/${targetsDir}/bin/nvcc" "${PREFIX}/bin/nvcc"
            ln -sv "${PREFIX}/${targetsDir}/bin/crt" "${PREFIX}/bin/crt"
        elif [[ $i == "lib" ]]; then
            mkdir -pv "${PREFIX}/lib"
            for j in "$i"/*.a*; do
                # Static libraries are symlinked in $PREFIX/lib
                ln -sv "${PREFIX}/${targetsDir}/${j}" "${PREFIX}/${j}"
            done
            ln -sv "${PREFIX}/${targetsDir}/${i}" "${PREFIX}/${targetsDir}/lib64"
        elif [[ $i == "nvvm" ]]; then
            mkdir -pv "${PREFIX}/nvvm"
            for j in "$i"/*; do
                ln -sv "${PREFIX}/${targetsDir}/${i}/${j}" "${PREFIX}/${j}"
            done
        fi
    fi
done
popd

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
# Name this script starting with `~` so it is run after all other compiler activation scripts.
# At the point of running this, $CXX must be defined.
for CHANGE in "activate" "deactivate"
do
    mkdir -pv "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/~cuda-nvcc_${CHANGE}.sh"
done

echo "ENDING BUILD.SH"
