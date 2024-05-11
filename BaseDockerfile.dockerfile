# Setting the base image of which docker image is being created
FROM jenkins/jenkins:lts

LABEL maintainer="binitkoirala17@gmail.com"
LABEL description="A docker image made from jenkins lts, flutter and android sdk installed"

# Switching to root user to install dependencies and flutter
USER root

# Installing the different dependencies required for Flutter, installing flutter from beta channel from github and giving permissions to jenkins user to the folder
RUN apt-get update && apt-get install -y --force-yes git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 \
    && apt-get clean \
    && git clone -b stable https://github.com/flutter/flutter.git /usr/local/flutter \
    && chown -R jenkins:jenkins /usr/local/flutter


# Running flutter doctor to check if flutter was installed correctly
RUN /usr/local/flutter/bin/flutter doctor -v \
    && rm -rfv /flutter/bin/cache/artifacts/gradle_wrapper

# Setting flutter and dart-sdk to PATH so they are accessible from terminal
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Getting the android sdk using apt with root user
RUN apt update && yes |apt install default-jdk

# Getting the android sdk command line tools 
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip

# Creating a directory to keep the sdk contents
# # This directory will be the path for ANDROID_HOME in environment variables
# # SET the variable name as ANDROID_HOME and /android-sdk/ as value
RUN mkdir android-sdk

# Unzipping the contents of the zip file to the android-sdk directory
RUN unzip commandlinetools-linux-7302050_latest.zip -d android-sdk/

# Creating a directory and adding a sub folder as the sdk manager would not work without it
RUN mkdir /android-sdk/latest && mv /android-sdk/cmdline-tools/* /android-sdk/latest/ && mv /android-sdk/latest /android-sdk/cmdline-tools/

# Accepting the licenses in sdkmanager
RUN yes |./android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses

# Creating an image of the android v
RUN yes |android-sdk/cmdline-tools/latest/bin/sdkmanager 'system-images;android-30;google_apis;x86'
