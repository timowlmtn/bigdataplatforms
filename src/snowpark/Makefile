requirements:
	pip install -r requirements.txt

install:
	brew install --cask anaconda

environment:
	conda create --name py38_env -c https://repo.anaconda.com/pkgs/snowflake python=3.8 numpy pandas

init:
	conda init zsh