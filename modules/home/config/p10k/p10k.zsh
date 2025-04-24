# Minimal Powerlevel10k config: no user@hostname, keep everything else default
# For full config options see: https://github.com/romkatv/powerlevel10k/blob/master/config/p10k-classic.zsh

# Only show current directory and vcs (git) status in the left prompt
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
# You can add more elements as desired, e.g. (dir vcs time)

# Keep right prompt as default
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)

# You can add more customization here as needed
