{ config, pkgs }:
with config.colorscheme.colors;

#alternate-normal-background: #${base01};
# man rofi-theme then /Layout to understand elements
builtins.toString (pkgs.writeText "style.css" ''

* {
    /* Theme settings */
    highlight: bold;
    scrollbar: false;

    /* Theme colors */
    foreground:                  #${base05};
    background:                  #${base00};
    background-color:            @background;
    border-color:                #${base05};
    separatorcolor:              #${base01};
    scrollbar-handle:            #${base01};

    normal-background:           @background;
    normal-foreground:           @foreground;
    alternate-normal-background: @background;
    alternate-normal-foreground: @foreground;
    selected-normal-background:  @foreground;
    selected-normal-foreground:  @background;

    active-background:           @foreground;
    active-foreground:           @background;
    alternate-active-background: @active-background;
    alternate-active-foreground: @active-foreground;
    selected-active-background:  @active-foreground;
    selected-active-foreground:  @active-background;

    urgent-background:           #${base08};
    urgent-foreground:           @background;
    alternate-urgent-background: @urgent-background;
    alternate-urgent-foreground: @urgent-foreground;
    selected-urgent-background:  @background;
    selected-urgent-foreground:  @urgent-background;
}

window {
    background-color: @background;
    border:           3;
    padding:          0;
}

mainbox {
    border:  0;
    padding: 0;
}

message {
    border:       2px 0 0;
    border-color: @separatorcolor;
    padding:      0px;
}

textbox {
    highlight:  @highlight;
    text-color: @foreground;
}

listview {
    border:       0px solid 0 0;
    padding:      0px 0 0;
    border-color: @separatorcolor;
    spacing:      0px;
    scrollbar:    @scrollbar;
}

element {
    border:  0;
    padding: 0px;
}

element.normal.normal {
    background-color: @normal-background;
    text-color:       @normal-foreground;
}

element.normal.urgent {
    background-color: @urgent-background;
    text-color:       @urgent-foreground;
}

element.normal.active {
    background-color: @active-background;
    text-color:       @active-foreground;
}

element.selected.normal {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

element.selected.urgent {
    background-color: @selected-urgent-background;
    text-color:       @selected-urgent-foreground;
}

element.selected.active {
    background-color: @selected-active-background;
    text-color:       @selected-active-foreground;
}

element.alternate.normal {
    background-color: @alternate-normal-background;
    text-color:       @alternate-normal-foreground;
}

element.alternate.urgent {
    background-color: @alternate-urgent-background;
    text-color:       @alternate-urgent-foreground;
}

element.alternate.active {
    background-color: @alternate-active-background;
    text-color:       @alternate-active-foreground;
}

scrollbar {
    width:        4px;
    border:       0;
    handle-color: @scrollbar-handle;
    handle-width: 8px;
    padding:      0;
}

mode-switcher {
    border:       2px 0 0;
    border-color: @separatorcolor;
}

inputbar {
    spacing:    0;
    text-color: @normal-foreground;
    padding:    0px;
    children:   [ prompt, textbox-prompt-sep, entry, case-indicator ];
}

case-indicator,
entry,
prompt,
button {
    spacing:    0;
    text-color: @normal-foreground;
}

button.selected {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

textbox-prompt-sep {
    expand:     false;
    str:        ":";
    text-color: @normal-foreground;
    margin:     0 0.3em 0 0;
}
element-text, element-icon {
    background-color: inherit;
    text-color:       inherit;
}
'')
