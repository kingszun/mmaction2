ARG PYTORCH="1.8.1"
ARG CUDA="10.2"
ARG CUDNN="7"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

ENV TZ=Asia/Seoul

# fetch the key refer to https://forums.developer.nvidia.com/t/18-04-cuda-docker-image-is-broken/212892/9
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub 32
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN apt update
RUN apt upgrade -y

RUN apt -y install git
RUN apt -y install curl wget
RUN apt -y install vim openssh-server 

RUN apt -y install sudo
# RUN groupadd --gid $USER_GID $USERNAME
# RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# 이미 생성한 ${USERNAME}에 passwd사용 없이 sudo 권한 사용할 수 있도록 설정
# 이거 안해주면 sudo 사용시 비밀번호 물어봐서 docker build 할때 에러남 
# RUN echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME

# 파일 권한 변경
# RUN chmod 0440 /etc/sudoers.d/$USERNAME

# zsh config
# install zsh
RUN apt -y install zsh


#install oh-my-zsh
RUN sudo sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# install powerline fonts
RUN apt install -y fonts-powerline

RUN sudo chsh -s $(which zsh)

# install oh-my-zsh plugins 
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Perl이란? : https://happygrammer.github.io/guide/perl/
# 펄을 활용하면 vi ~/.zshrc를 해서 직접 수정해야하는 부분이 자동화가 가능하다!! 

RUN perl -pi -w -e 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/g;' ~/.zshrc 
RUN perl -pi -w -e 's/plugins=.*/plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)/g;' ~/.zshrc
RUN perl -pi -w -e 's/## Main prompt/# option for multiline\n prompt_newline() {\n   if [[ -n \$CURRENT_BG ]]; then\n     echo -n "%{%k%F{\$CURRENT_BG}%}\$SEGMENT_SEPARATOR\n %{%k%F{blue}%}\SEGMENT_SEPARATOR"\n   else\n     echo -n "%{%k%}"\n   fi\n \n   echo -n "%{%f%}"\n   CURRENT_BG=""\n }\n## Main prompt\n /g;' ~/.oh-my-zsh/themes/agnoster.zsh-theme
RUN perl -pi -w -e 's/  prompt_end/  prompt_newline\n  prompt_end/g;' ~/.oh-my-zsh/themes/agnoster.zsh-theme

RUN apt install -y git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 ffmpeg

# Install MMCV
RUN pip install openmim
RUN mim install mmengine mmcv

# Install MMAction2
RUN conda clean --all
RUN git clone https://github.com/open-mmlab/mmaction2.git /mmaction2
WORKDIR /mmaction2
RUN mkdir -p /mmaction2/data
ENV FORCE_CUDA="1"
RUN git checkout main
RUN pip install cython --no-cache-dir
RUN pip install --no-cache-dir -e .


# 경우에 따라 시간대가 안맞는 에러가 발생해서, 이 코드는 웬만하면 넣는게 좋습니다. 
RUN sudo apt-get install -y language-pack-en && sudo update-locale
# 설치로 생성된 캐시 파일들을 삭제해서 용량 줄이기!
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/* \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 22 3306


CMD ["zsh"]
