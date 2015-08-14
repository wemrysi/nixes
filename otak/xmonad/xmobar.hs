-- Setup for a 3200x1800 monitor

Config {
    font = "xft:Source Code Pro:size=10:antialias=true",
    bgColor = "#000000",
    fgColor = "#ffffff",
    position = Static { xpos = 0, ypos = -8, width = 2960, height = 40 },
    lowerOnStart = True,
    commands = [
        Run Weather "KORD" ["-t","<tempF>F <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000,
        Run Cpu ["-t","Cpu:<total>%","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory ["-t","Mem:<usedratio>%","-H","4096","-L","2048","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Wireless "wlp2s0" ["-t","<essid>","-H","80","-L","40","-l","#FFB6B0","-h","#CEFFAC","-n","#FFFFCC"] 50,
        Run Network "wlp2s0" ["-t","<rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run BatteryP ["BAT0"] ["-t","Bat: <timeleft> (<left>%)","-H","80","-L","10","-l","#FFB6B0","-h","#CEFFAC","-n","#FFFFCC"] 600,
        Run Volume "default" "Master" ["--","-C","#CEFFAC","-c","#FFB6B0"] 10,
        Run Brightness ["-t","Lcd:<percent>%","-w","3","--","-D","intel_backlight"] 10,
        Run Date "%a %b %_d %H:%M" "date" 10,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %cpu%   %memory%   %wlp2s0wi%: %wlp2s0%   %battery%   %default:Master%   %bright%   <fc=#FFFFCC>%date%</fc>   %KORD%"
}
