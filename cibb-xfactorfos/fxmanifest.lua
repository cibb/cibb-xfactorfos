fx_version 'cerulean'
games { 'gta5' }

version '1.0.0'
author 'Cibb <dev@Cibb.dev>'
description 'XFactor Fame Or Shame for FiveM.'

dependency "cibb-xfactorfos-screen"

files {
    "stream/fos_screen_x.gfx",
    'client/html/screen.js',
    'client/html/img/logo.png',
    'client/html/screen.html',
    'client/html/index.html',
    'client/html/sounds/*.mp3'
}

client_script {    
    'config.lua',
    'locales/es.lua',
    'client/*.lua'
}

server_script {
    'config.lua',
    'locales/es.lua',
    'server/main.lua'
}

ui_page "client/html/index.html"