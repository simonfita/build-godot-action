FROM barichello/godot-ci:mono-latest

LABEL "com.github.actions.name"="Build Godot"
LABEL "com.github.actions.description"="Build a Godot project for multiple platforms"
LABEL "com.github.actions.icon"="loader"
LABEL "com.github.actions.color"="blue"

LABEL repository="https://github.com/josephbmanley/build-godot-action"
LABEL homepage="https://cloudsumu.com/"
LABEL maintainer="Joseph Manley <joseph@cloudsumu.com>"

ENV PATH="$PATH:/opt/dotnet"
ENV DOTNET_ROOT="/opt/dotnet/"

USER root
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0 --install-dir /opt/dotnet/
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
