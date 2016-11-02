module.exports = (grunt) ->
    configOptions =
        sshconfig:
            maerua:
                host: '196.216.167.210'
                username: 'emd811s'
                port: 4576
                privateKey: grunt.file.read('/home/icarus/.ssh/id_rsa')
                passphrase: ''
        sshexec:
            deploy:
                command: ['cd /home/emd811s/antrack', 'git pull origin master', 'npm install', 'cd', 'pm2 restart 0'].join(' && ')
                options:
                    config: 'maerua'
    grunt.initConfig configOptions

    grunt.loadNpmTasks 'grunt-ssh'

    grunt.registerTask 'deploy', ['sshexec:deploy']
