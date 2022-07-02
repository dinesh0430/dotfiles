From ZSH man page:
>Commands  are  first  read  from /etc/zsh/zshenv; this cannot be overridden
Commands  are  then  read from $ZDOTDIR/.zshenv.  If the shell is a login shell, commands are read from /etc/zsh/zprofile and    
then $ZDOTDIR/.zprofile.  Then, if the shell is interactive, commands are read from /etc/zsh/zshrc and then  $ZDOTDIR/.zshrc.    
Finally, if the shell is a login shell, /etc/zsh/zlogin and $ZDOTDIR/.zlogin are read

So we set $ZDOTDIR variable in /etc/zsh/zshenv to keep our $HOME(~) clean and tidy
