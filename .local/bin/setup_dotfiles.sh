git clone --bare git@github.com:Ceralor/dotfiles.git $HOME/.files.git
homegit() { 
  git --git-dir=$HOME/.files.git --work-tree=$HOME $@ 
}
mkdir -p .config-backup
homegit checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    homegit checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
homegit checkout
homegit config status.showUntrackedFiles no
find ~/.local/bin/ -name "*.sh" -type f -exec chmod +x {} \;
source ~/.bash_profile
echo "Setup additional bash config? "
select yn in y n; do
	case $yn in
  	y ) ~/.local/bin/setup_bashconfigs.sh; break;;
  	n ) exit;;
  esac
done
