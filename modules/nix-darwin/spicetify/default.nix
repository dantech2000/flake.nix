{ inputs
, pkgs
, ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ inputs.spicetify-nix.darwinModules.spicetify ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "TokyoNight";
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      autoVolume
      copyToClipboard
      fullAlbumDate
      fullAppDisplay
      goToSong
      groupSession
      hidePodcasts
      history
      keyboardShortcut
      lastfm
      listPlaylistsWithSong
      loopyLoop
      phraseToPlaylist
      playNext
      playlistIcons
      playlistIntersection
      popupLyrics
      savePlaylists
      shuffle # shuffle+
      volumePercentage
    ];
    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      lyricsPlus
      ncsVisualizer
      marketplace
    ];
  };
}
