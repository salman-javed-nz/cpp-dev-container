FROM fedora:40

SHELL ["/bin/bash", "-eux", "-o", "pipefail", "-c"]

# Update and install packages.
RUN dnf upgrade -y \
    && dnf install -y \
        ccache-4.9.1-1.fc40 \
        clang-18.1.6-3.fc40 \
        clang-analyzer-18.1.6-3.fc40 \
        clang-tools-extra-18.1.6-3.fc40 \
        cmake-3.28.2-1.fc40 \
        conan-2.6.0-1.fc40 \
        cppcheck-2.14.2-1.fc40 \
        doxygen-2:1.10.0-3.fc40 \
        gcc-14.1.1-7.fc40 \
        gcc-c++-14.1.1-7.fc40 \
        gdb-14.2-3.fc40 \
        git-2.45.2-2.fc40 \
        git-lfs-3.5.1-1.fc40 \
        iwyu-0.22-1.fc40 \
        lcov-2.0-3.fc40 \
        libasan-14.1.1-7.fc40 \
        liblsan-14.1.1-7.fc40 \
        libtsan-14.1.1-7.fc40 \
        libubsan-14.1.1-7.fc40 \
        lld-18.1.6-1.fc40 \
        lldb-18.1.6-1.fc40 \
        meson-1.4.1-1.fc40 \
        mingw64-gcc-14.1.1-3.fc40 \
        mingw64-gcc-c++-14.1.1-3.fc40 \
        mingw64-libgcc-14.1.1-3.fc40 \
        mingw64-libstdc++-14.1.1-3.fc40 \
        ninja-build-1.12.1-1.fc40 \
        python-unversioned-command-3.12.4-1.fc40 \
        python3-3.12.4-1.fc40 \
        python3-pip-23.3.2-1.fc40 \
        unzip-6.0-63.fc40 \
        valgrind-1:3.23.0-4.fc40 \
        wget2-2.1.0-11.fc40 \
        wine-core-9.5-1.fc40 \
        zip-3.0-40.fc40 \
    && dnf clean all

# Install Python packages.
RUN pip install --no-cache-dir --no-warn-script-location \
        cmake-format==0.6.13 \
        gcovr==7.2 \
        lizard==1.17.10 \
        poxy==0.17.2

# Install vcpkg.
RUN git clone https://github.com/Microsoft/vcpkg.git \
    && git -C vcpkg checkout 2024.07.12 \
    && vcpkg/bootstrap-vcpkg.sh -disableMetrics
ENV VCPKG_ROOT=/vcpkg
ENV PATH=$VCPKG_ROOT:$PATH

# Run Wine for the first time.
ENV WINEARCH=win64
ENV WINEDEBUG=-all
RUN wine wineboot --init && wineserver --wait

# Point Wine to the MinGW libraries.
RUN wine \
        reg add "HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Environment" \
        /f \
        /v PATH \
        /t REG_SZ \
        /d "%SystemRoot%\\system32;%SystemRoot%;%SystemRoot%\\system32\\wbem;%SystemRoot%\\system32\\WindowsPowershell\\v1.0;Z:\\usr\\x86_64-w64-mingw32\\sys-root\\mingw\\bin" \
    && wineserver --wait
