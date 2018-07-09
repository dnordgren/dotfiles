## How to install oh-my-git on WSL (Windows Subsystem Linux) on Windows
_Ubuntu Bash assumed_

1. Add the following line to `~/.bashrc`:

```bash
source /home/derek/.oh-my-git/prompt.sh
```

2. Clone https://github.com/gabrielelana/awesome-terminal-fonts locally (temp)
3. Following https://github.com/gabrielelana/awesome-terminal-fonts#how-to-install-linux:
  * copy all the fonts from `./build` directory to `~/.fonts` directory
  * copy all the font maps (all `*.sh` files) from `./build` directory to `~/.fonts` directory
  * run `fc-cache -fv ~/.fonts` to let freetype2 know of those fonts
  * source the font maps (`source ~/.fonts/*.sh`) in your shell startup script

4. Change default (first) font in `~/.hyper.js`
To `"SourceCodePro+Powerline+Awesome Regular"`

## Troubleshooting
* Can use `fc-list` to get list of fonts registered with bash
  * It's key-value; use the value string
