-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Cibb <dev@Cibb.dev>'
description 'XFactor Fame Or Shame for FiveM.'

client_script {
    'config.lua',
    'locales/es.lua',
    'client/utils.lua',
    'client/shared.lua',
    'client/menu.lua',
    'client/client.lua',
    'client/screen.lua'
}

server_script {
    'config.lua',
    'locales/es.lua',
    'server/main.lua'
}

ui_page "client/html/index.html"

files {
    'client/html/screen.js',
    'client/html/screen.html',
    'client/html/index.html',
    'client/html/sounds/x.mp3',
    'client/html/sounds/x_final.mp3',
    'client/html/sounds/gold.mp3'
}

fx_version 'adamant'
games { 'gta5', 'rdr3' }