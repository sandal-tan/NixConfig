#!/bin/bash

curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
usrshell=$(basename $SHELL)

if [ "$usrshell" == "bash" ]; then
	localColor="\"[32m\""
	remoteColor="\"[31m\""
elif [ "$usrshell" == "fish" ]; then
	localColor="green"
	remoteColor="red"
fi

rm -rf $HOME/.vimrc $HOME/.vim/ftplugin/* $HOME/.vim/.ycm_extra_conf.py

# Link vimrc
ln -sF $curDir/Config/Vim/vimrc $HOME/.vimrc

# Create vim directories if needed
mkdir -p $HOME/.vim
mkdir -p $HOME/.vim/ftplugin

# Link VIM filetype plugins
ln -sF $curDir/Config/Vim/ftplugin/c.vim $HOME/.vim/ftplugin/c.vim
ln -sF $curDir/Config/Vim/ftplugin/java.vim $HOME/.vim/ftplugin/java.vim
ln -sF $curDir/Config/Vimftplugin/asm.vim $HOME/.vim/ftplugin/asm.vim

# Link YCM_CONF
ln -sF $curDir/Config/Vim/ycm_extra_conf.py $HOME/.vim/.ycm_extra_conf.py

# Link shell profile
mkdir -p $curDir/Compiled
if [ "$usrshell" == "fish" ]; then
	rm -rf $HOME/.config/fish/config.fish
	printf "#!$(which fish)\n
set remoteColor $remoteColor \n
set localColor $localColor \n
set INSTPATH $curDir \n" > $curDir/Compiled/config.fish
	cat $curDir/Config/Fish/fish.config >> $curDir/Compiled/config.fish
	ln -sF $curDir/Compiled/config.fish $HOME/.config/fish/config.fish
elif [ "$usrshell" == "bash" ]; then
	printf "#!/bin/bash\n
homeColor=$localColor\n
remoteColor=$remoteColor\n
NIXCONFIG=$curDir \n" > $curDir/Compiled/bash_profile
	cat $curDir/Config/Bash/bash.config >> $curDir/Compiled/bash_profile
	ncsu=$(uname -a | grep -c ncsu)
	if [ "$ncsu" == "1" ]; then
		rm -rf $HOME/.mybashrc
		ln -sF $curDir/Compiled/bash_profile $HOME/.mybashrc
	else
		rm -rf $HOME/.bash_profile
		ln -sF $curDir/Compiled/bash_profile $HOME/.bash_profile
	fi
fi
