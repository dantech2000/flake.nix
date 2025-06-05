# Minimal Powerlevel10k config: no user@hostname, keep everything else default
# For full config options see: https://github.com/romkatv/powerlevel10k/blob/master/config/p10k-classic.zsh

# Only show current directory and vcs (git) status in the left prompt
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs aws)
# You can add more elements as desired, e.g. (dir vcs time)

# Keep right prompt as default
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

# Directory shortening: show only last 2 directories, max 40 characters
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_DIR_MAX_LENGTH=40

# You can add more customization here as needed
