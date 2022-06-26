{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-utils
  ];

  xdg.desktopEntries = {
    # https://specifications.freedesktop.org/menu-spec/latest/apas02.html
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = rec {
      "text/html" = [ "web-browser.desktop" ];
      "text/xml" = [ "web-browser.desktop" ];
      "x-scheme-handler/http" = [ "web-browser.desktop" ];
      "x-scheme-handler/https" = [ "web-browser.desktop" ];
      "x-scheme-handler/mailto" = [ "email-client.desktop" ];
      "x-scheme-handler/magnet" = [ "torrent-manager.desktop" ];
      "application/x-bittorrent" = [ "torrent-manager.desktop" ];
      "application/pgp-encrypted" = [ "text-editor.desktop" ];
      "application/rss+xml" = [ "rss.desktop" ];
      "application/pdf" = [ "pdf-reader.desktop" ];
      "application/postscript" = [ "pdf-reader.desktop" ];
      "application/json" = [ "text-editor.desktop" ];
      "image/png" = [ "image-viewer.desktop" ];
      "image/jpeg" = [ "image-viewer.desktop" ];
      "image/svg+xml" = [ "vector-image-editor.desktop" ];
      "image/x-ms-bmp" = [ "image-viewer.desktop" ];
      "image/gif" = [ "image-viewer.desktop" ];
      "image/vnd.djvu" = [ "pdf-reader.desktop" ];
      "video/mp4" = [ "video-player.desktop" ];
      "video/x-matroska" = [ "video-player.desktop" ];
      "video/webm" = [ "video-player.desktop" ];
      "video/mpeg" = [ "video-player.desktop" ];
      "video/ogg" = [ "video-player.desktop" ];
      "audio/ogg" = [ "audio-player.desktop" ];
      "audio/x-wav" = [ "audio-player.desktop" ];
      "audio/flac" = [ "audio-player.desktop" ];
      "audio/mpeg" = [ "audio-player.desktop" ];
      "audio/x-hx-aac-adts" = [ "audio-player.desktop" ];
      "text/plain" = [ "text-editor.desktop" ];
      "text/x-python" = [ "text-editor.desktop" ];
      "text/x-shellscript" = [ "text-editor.desktop" ];
      "inode/x-empty" = [ "text-editor.desktop" ];
      "application/octet-stream" = [ "text-editor.desktop" ];
      "application/zip" = [ "text-editor.desktop" ];
      "x-scheme-handler/msteams" = [ "teams.desktop" ];
      "application/x-subrip" = [ "aegisub.desktop" ];
      "application/gzip" = [ "handwritten-editor.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "office-suite.desktop" ];
    };
    associations = {
      added = {
        #{
        #  "mimetype1" = [ "foo1.desktop" "foo2.desktop" "foo3.desktop" ];
        #  "mimetype2" = "foo4.desktop";
        #}
      };
      removed = {
        #"mimetype1" = "foo5.desktop";
      };
    };
  };
}
