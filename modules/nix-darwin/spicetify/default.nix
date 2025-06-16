{ 
  inputs, 
  pkgs, 
  lib, 
  ... 
}: 
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [ inputs.spicetify-nix.darwinModules.spicetify];


   programs.spicetify = {
     enable = true;
     theme = spicePkgs.themes.text;
     colorScheme = "TokyoNight";
     enabledExtensions = with spicePkgs.extensions; [
        adblockify
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
        popupLyrics
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
