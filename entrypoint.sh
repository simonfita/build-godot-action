#!/bin/sh

# Move godot templates already installed from the docker image to home
mkdir -v -p ~/.local/share/godot/export_templates
cp -a /root/.local/share/godot/export_templates/. ~/.local/share/godot/export_templates/



mode="export-release"
if [ "$6" = "true" ]
then
    echo "Exporting in debug mode!"
    mode="export-debug"
fi

# Export for project
echo "Building $1 for $2"
mkdir -p $GITHUB_WORKSPACE/build/
cd "$GITHUB_WORKSPACE/$5"

if [ -d "addons/epic-online-services-godot" ]; then
    mkdir -p .godot
    echo "res://addons/epic-online-services-godot/eosg.gdextension" > .godot/extension_list.cfg
    
    mv "$GITHUB_WORKSPACE/addons/epic-online-services-godot/bin/windows/EOSSDK-Win64-Shipping.dll" "$GITHUB_WORKSPACE/build/"
    mv "$GITHUB_WORKSPACE/addons/epic-online-services-godot/bin/windows/x64/xaudio2_9redist.dll" "$GITHUB_WORKSPACE/build/"
fi


if [ -f "docs/licences.txt" ]; then
    echo "Copying licences.txt"
    mv "$GITHUB_WORKSPACE/docs/licences.txt" "$GITHUB_WORKSPACE/build/"
fi

#import first
godot --headless --import
#second import and export
godot --headless --${mode} "$2" "$GITHUB_WORKSPACE/build/$1"
echo "Build Done"


echo ::set-output name=build::build/${SubDirectoryLocation:-""}


if [ "$4" = "true" ]
then
    echo "Packing Build"
    mkdir -p $GITHUB_WORKSPACE/package
    cd $GITHUB_WORKSPACE/build
    zip $GITHUB_WORKSPACE/package/artifact.zip "." -r
    echo ::set-output name=artifact::package/artifact.zip
    echo "Done"
fi
