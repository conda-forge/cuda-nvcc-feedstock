#!/bin/bash

mv "${SRC_DIR}/targets" "${PREFIX}/targets"

# Work from cross-target directory
pushd "${PREFIX}/targets/${cross_target_name}"
# Install to conda style directories
[[ -d lib64 ]] && mv lib64 lib
for i in `ls`; do
    [[ $i == "build_env_setup.sh" ]] && continue
    [[ $i == "conda_build.sh" ]] && continue
    [[ $i == "metadata_conda_debug.yaml" ]] && continue
    if [[ $i == "bin" ]] || [[ $i == "lib" ]] || [[ $i == "include" ]] || [[ $i == "nvvm" ]]; then
        if [[ $i == "bin" ]]; then
            mkdir -p "${PREFIX}/bin"
            # Use a custom nvcc.profile to handle the fact that nvcc is a symlink.
            cp "${RECIPE_DIR}/nvcc.profile.for_prefix_bin" "${PREFIX}/bin/nvcc.profile"
            ln -sv "`pwd`/${i}/nvcc" "${PREFIX}/bin/nvcc"
            ln -sv "`pwd`/${i}/crt" "${PREFIX}/bin/crt"
        elif [[ $i == "lib" ]]; then
            mkdir -p "${PREFIX}/lib"
            for j in "$i"/*.a*; do
                # Static libraries are symlinked in $PREFIX/lib
                ln -sv "`pwd`/${i}/${j}" "${PREFIX}/${j}"
            done
            ln -sv "`pwd`/${i}" lib64
        elif [[ $i == "nvvm" ]]; then
            mkdir -p "${PREFIX}/nvvm"
            for j in "$i"/*; do
                ln -sv "`pwd`/${i}/${j}" "${PREFIX}/${j}"
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
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/~cuda-nvcc_${CHANGE}.sh"
done
