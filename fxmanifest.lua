fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_script '@es_extended/imports.lua'
shared_script 'shared/config.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/utils.lua',
    'server/dbm.lua',
    'server/main.lua'
}
client_scripts{
    'client/main.lua',
    'client/cl_impound.lua'
} 

ui_page 'ui/dashboard.html'

files {
    'ui/img/*.png',
    'ui/img/*.webp',
    'ui/dashboard.html',
    'ui/dmv.html',
    --'ui/bolos.html',
    --'ui/incidents.html',
    --'ui/penalcode.html',
    --'ui/reports.html',
    --'ui/warrants.html',
    'ui/app.js',
    'ui/style.css',
}