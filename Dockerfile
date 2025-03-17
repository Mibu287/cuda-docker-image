FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

# Install Cuda toolkit
apt install cuda-toolkit-12-8 -y

# Install ZSH and other tools
RUN ["bash", "-c", "apt update && apt upgrade -y"]
RUN ["apt", "install", "zsh", "-y"]
RUN ["apt", "install", "-y", "wget", "curl", "git", "binutils", "moreutils", "ninja-build", "gcc", "g++", "ca-certificates", "gpg", "lsb-release", "software-properties-common"]
RUN ["apt", "install", "-y", "liblzma-dev", "libsqlite3-dev", "libreadline-dev", "libssl-dev", "libbz2-dev", "zlib1g-dev"]

# Install CMAKE
RUN ["/bin/sh", "-c", "echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null"]
RUN ["/bin/sh", "-c", "wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null"]
RUN ["apt", "update"]
RUN ["apt", "install", "-y", "kitware-archive-keyring"]
RUN ["apt", "install", "-y", "cmake=3.31.6-0kitware1ubuntu22.04.1", "cmake-curses-gui=3.31.6-0kitware1ubuntu22.04.1"]

# Install LLVM
RUN ["wget", "-O", "/tmp/llvm.sh", "https://apt.llvm.org/llvm.sh"]
RUN ["/bin/bash", "/tmp/llvm.sh", "18", "all"]
RUN echo "export PATH=/usr/lib/llvm-17/bin:\$PATH" >> /root/.zshrc

# Install Pyenv
RUN ["wget", "-O", "/tmp/pyenv.sh", "https://pyenv.run"]
RUN ["/usr/bin/zsh", "/tmp/pyenv.sh"]
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.zshrc
RUN echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.zshrc
RUN echo 'eval "$(pyenv init -)"' >> /root/.zshrc
COPY ./requirements.txt /tmp/requirements.txt
RUN /usr/bin/zsh -c "source /root/.zshrc && pyenv install 3.12 && pyenv global 3.12 && python -m pip install -r /tmp/requirements.txt"

# Install Node
RUN /usr/bin/zsh -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | /usr/bin/zsh"
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'  >> /root/.zshrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'  >> /root/.zshrc
RUN /usr/bin/zsh -c "source ~/.zshrc && nvm install --lts && nvm use --lts"

# Install Rust
RUN ["curl", "https://sh.rustup.rs", "-o", "/tmp/rustup.sh"]
RUN /usr/bin/zsh /tmp/rustup.sh -y
RUN echo 'export PATH=$PATH:$HOME/.cargo/bin' >> /root/.zshrc

# Install Vim & plugins
RUN ["add-apt-repository", "ppa:jonathonf/vim", "-y"]
RUN ["apt", "update"]
RUN ["apt", "install", "vim", "-y"]
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY ./vimrc /root/.vimrc

# Oh-my-zsh
RUN /usr/bin/zsh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN ["mv", "/root/.zshrc.pre-oh-my-zsh", "/root/.zshrc"]
RUN /usr/bin/zsh -c "echo 'plugins=(zsh-autosuggestions zsh-completions zsh-syntax-highlighting)' >> /root/.zshrc"
RUN /usr/bin/zsh -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k"
RUN /usr/bin/zsh -c "echo 'source /root/powerlevel10k/powerlevel10k.zsh-theme' >> /root/.zshrc"

# User
RUN usermod -s /usr/bin/zsh root
USER root:root
WORKDIR /
